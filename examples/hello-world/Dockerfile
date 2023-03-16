FROM node:19.7.0-alpine

RUN mkdir -p /app

WORKDIR /app

COPY ./ ./

RUN ls
CMD ["node"]

ENTRYPOINT ["index.js"]

