import { authOptions } from "@/app/api/auth/[...nextauth]/route";
import prisma from "@/lib/db/prisma";
import { Cart, CartItem, Prisma } from "@prisma/client";
import { getServerSession } from "next-auth";
import { cookies } from "next/dist/client/components/headers";

// prismaを使って、productの型情報も定義する
export type CartWithProduct = Prisma.CartGetPayload<{
  include: { CartItem: { include: { product: true } } };
}>;

// カートの商品情報の型も定義
export type CartItemWithProduct = Prisma.CartItemGetPayload<{
  include: { product: true };
}>;

export type ShoppingCart = CartWithProduct & {
  size: number;
  subtotal: number;
};

// async funcなので、Promiseを返す cookieが存在しない場合はnull
export const getCart = async (): Promise<ShoppingCart | null> => {
  const session = await getServerSession(authOptions);

  let cart: CartWithProduct | null = null;
  if (session) {
    cart = await prisma.cart.findFirst({
      where: { userId: session.user.id },
      include: { CartItem: { include: { product: true } } }, // product 情報も取得
    });
  } else {
    // anonymous cart
    // 下のcreateCartで定義したCookieを使う
    const localCartId = cookies().get("localCartId")?.value;
    cart = localCartId
      ? await prisma.cart.findUnique({
          where: { id: localCartId },
          include: { CartItem: { include: { product: true } } }, // product 情報も取得
        })
      : null;
  }

  if (!cart) return null;

  // ただcartを返すだけじゃない
  return {
    ...cart,
    size: cart.CartItem.reduce((acc, item) => acc + item.quantity, 0), // cartの中のトータル
    subtotal: cart.CartItem.reduce(
      (acc, item) => acc + item.quantity * item.product.price,
      0,
    ),
  };
};

export const createcart = async (): Promise<ShoppingCart> => {
  const session = await getServerSession(authOptions);

  let newcart: Cart;
  if (session) {
    newcart = await prisma.cart.create({
      data: { userId: session.user.id }, // route.ts
    });
  } else {
    // anonymous cart
    newcart = await prisma.cart.create({
      data: {},
    });

    // ユーザーがどのカートに属してるかどうかの判定は、クッキーを使って行う。
    // 本番環境等では、encryptが必要
    cookies().set("localCartId", newcart.id);
  }

  return {
    ...newcart,
    size: 0,
    subtotal: 0,
    CartItem: [], // これがないとTSに怒られる
  };
};

export async function mergeAnonymousCartIntoUserCart(userId: string) {
  const localCartId = cookies().get("localCartId")?.value;
  const localcart = localCartId
    ? await prisma.cart.findUnique({
        where: { id: localCartId },
        include: { CartItem: true }, // 商品情報はいらない
      })
    : null;
  if (!localcart) return; // localにcart情報がなければ終了

  const userCart = await prisma.cart.findFirst({
    where: { id: userId },
    include: { CartItem: true },
  });

  // $transactionはすべてのDB操作が成功した場合のみコミット
  // 失敗した場合は、rollbackを行う
  await prisma.$transaction(async (tx) => {
    if (userCart) {
      const mergedCartItems = mergeCartItems(
        localcart.CartItem,
        userCart.CartItem,
      );
      // 既存のカートの削除
      await tx.cartItem.deleteMany({
        where: { cartId: userCart.id },
      });

      // mergedCartItemが保有している既存のidは無視
      // map(item => ({}) JS objectを返す)
      await tx.cartItem.createMany({
        data: mergedCartItems.map((item) => ({
          // idは無視
          cartId: userCart.id,
          productId: item.productId,
          quantity: item.quantity,
        })),
      });
    } else {
      await tx.cart.create({
        data: {
          userId,
          CartItem: {
            createMany: {
              // 既存のcartIdは使わずに
              // cartIdは自動で作成されるようにする
              data: localcart.CartItem.map((item) => ({
                productId: item.productId,
                quantity: item.quantity,
              })),
            },
          },
        },
      });
    }

    // merge後は、localcartとcoockieを削除
    await tx.cart.delete({
      where: { id: localCartId },
    });
    cookies().set("localCartId", "");
  });
}

// transactionで使うロジックの部分
// ...cart いくらでもcartを引数にもてる可変長
// array of array of cartitems
const mergeCartItems = (...cartitems: CartItem[][]) => {
  return cartitems.reduce((acc, items) => {
    items.forEach((item) => {
      const existingItem = acc.find((i) => i.productId === item.productId);
      if (existingItem) {
        existingItem.quantity += item.quantity;
      } else {
        acc.push(item);
      }
    });
    return acc;
  }, [] as CartItem[]);
};
