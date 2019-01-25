FROM node:8.15.0-alpine as builder

RUN apk update && apk upgrade && \
    apk add --no-cache git python && \
    apk add --update alpine-sdk

COPY . /capricoin-mobile-wallet

WORKDIR /capricoin-mobile-wallet

RUN sed -i 's/.*bower install.*/    \"preinstall\"\: \"bower install --allow-root\"\,/' package.json

RUN npm config set unsafe-perm true && npm install bower && npm install && npm run build && npm config set unsafe-perm false

######################

FROM nginx
COPY --from=builder /capricoin-mobile-wallet/public/ /usr/share/nginx/html/
EXPOSE 80
