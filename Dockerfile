FROM golang:1.25-alpine AS builder

RUN apk add --no-cache \
    --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    hugo git

WORKDIR /site

COPY . .

RUN hugo mod get -u
RUN hugo --minify


FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /site/public /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
