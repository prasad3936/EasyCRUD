FROM node:24-alpine

COPY . /opt/

WORKDIR /opt

RUN npm install && npm run build

RUN apk update && apk add apache2 -y

EXPOSE 80

ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]