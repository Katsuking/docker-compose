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

### prettier x tailwindcss

[セットアップ](https://tailwindcss.com/blog/automatic-class-sorting-with-prettier)
