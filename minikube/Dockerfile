FROM node:16.15.1-alpine3.16 

WORKDIR /app
COPY package.json /app
RUN yarn install && \
    yarn global add pm2

COPY . /app

EXPOSE 3000 
CMD [ "pm2-runtime", "start", "/app/server.js" ]