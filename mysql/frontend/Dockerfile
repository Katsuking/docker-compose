FROM node:latest

WORKDIR /frontend

COPY package*.json ./

RUN npm install --no-package-lock

COPY . .

EXPOSE 3000

# CMD ["npm", "start"]