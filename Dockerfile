FROM node:14.17.0
LABEL MAINTAINER paulappz

WORKDIR /app

COPY package-lock.json package.json ./

RUN npm i --only=prod

COPY index.js .

CMD npm start