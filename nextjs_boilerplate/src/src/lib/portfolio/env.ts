// zodを使って値のvalidationを行う

import zod from "zod";

// 単純に.envファイルの変数を渡して、空でないようにvalidation
const envSchema = zod.object({
  DATABASE_URL: zod.string().min(1),
  GOOGLE_CLIENT_ID: zod.string().min(1),
  GOOGLE_CLIENT_SECRET: zod.string().min(1),
  NEXTAUTH_URL: zod.string().min(1),
  NEXTAUTH_SECRET: zod.string().min(1),
});

export const env = envSchema.parse(process.env);
