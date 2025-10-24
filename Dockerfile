FROM node:20-alpine

RUN apk add --no-cache curl
WORKDIR /app

COPY app/package*.json ./
RUN npm install

COPY app/ ./
EXPOSE 8080

CMD ["node", "index.js"]