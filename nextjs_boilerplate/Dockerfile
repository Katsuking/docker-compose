FROM node:lts-bookworm as base
WORKDIR /app
COPY package*.json ./app/src
EXPOSE 3000

FROM base as builder
WORKDIR /app
COPY ./src .
RUN cd ./src && npm run build

FROM base as production
WORKDIR /app

ENV NODE_ENV=production
RUN cd ./src && npm ci

RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001
USER nextjs

COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/public ./public

CMD npm start

FROM base as dev
ENV NODE_ENV=development
WORKDIR /app
COPY ./src .
RUN cd ./src && npm install
CMD npm run dev