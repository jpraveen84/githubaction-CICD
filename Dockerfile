FROM node:19.7.0-alpine

COPY ./ ./

WORKDIR examples/hello-world 

RUN npm install express && npm install
RUN chmod +x ./index.js

CMD [ "node","index.js" ]
