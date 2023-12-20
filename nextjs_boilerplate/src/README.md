This is a [Next.js](https://nextjs.org/) project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/basic-features/font-optimization) to automatically optimize and load Inter, a custom Google Font.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js/) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/deployment) for more details.

### vs code setup

tailwind使うなら必須

![tailwindcss](./images/tailwind_vscode.png)

![Alt text](./images/editor_quick.png)

### packages

prettier: formatter
prettier-plugin-tailwindcss: tailwindcss公式
[setup](https://github.com/tailwindlabs/prettier-plugin-tailwindcss)
[one more](https://nextjs.org/docs/pages/building-your-application/configuring/eslint#usage-with-other-tools)
create new file for config

```sh
npm i -D prettier eslint-config-prettier prettier-plugin-tailwindcss
```

next auth

```sh
npm install next-auth
```

ui
[setup](https://daisyui.com/docs/install/)

```sh
npm i -D daisyui@latest
```

prisma: for db

```sh
npm i prisma @prisma/client
npm i @auth/prisma-adapter # for next auth
```

### BD

dockerでmongoDBを用意
GUIはmongo expressを使用

`http://localhost:8081/`
user: admin
password: pass

### prisma

docker composeに合わせた接続情報
`DATABASE_URL="mysql://myuser:password@localhost:3006/mydb"`

```sh
npx prisma init
npx prisma db pull
npx prisma db push # make change
npx prisma genereate # create client
```

connection string
[setup](https://www.prisma.io/docs/concepts/database-connectors/mongodb)
[instance](https://vercel.com/guides/nextjs-prisma-postgres#step-4.-install-and-generate-prisma-client)

paramsがないとうまく行かなかったので注意

```.env
DATABASE_URL="mongodb://root:root_password@127.0.0.1:27017/mydb?retryWrites=true&w=majority&authSource=admin&directConnection=true"
```

### NextAuth

[prisma設定](https://next-auth.js.org/v3/adapters/prisma#setup)

.env等に設定する環境変数

```sh
DATABASE_URL="mysql://myuser:password@localhost:3006/mydb"
GOOGLE_CLIENT_ID="your id"
GOOGLE_CLIENT_SECRET="your secret"
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="whatever"
```

#### Google setup

- external を選択

![external](./images/oauth_consent.png)

- Emailを入れるくらいでほとんでブランクでいい

![add app name](./images/appname.png)

- 追加するScopeは画像にある２つだけ

![scope](./images/scope.png)

- test userには自分を追加

![testuser](./images/testuser.png)

- credential => OAuth client ID

![oauth](./images/oauth.png)

- redirectの設定

NextAuthを使った後のリダイレクト先
`http://localhost:3000/api/auth/callback/google`

![redirect](./images/redirect.png)
