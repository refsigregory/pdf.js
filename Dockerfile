FROM node:22-alpine

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

EXPOSE 8888

CMD ["npx", "gulp", "server", "--host", "0"]
