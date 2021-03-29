FROM node:10.23.1-alpine3.9

COPY . /app/portal
WORKDIR /app/portal
RUN npm install -g cnpm --registry=https://registry.npm.taobao.org \
  && cnpm i gitbook-cli -g \
  && gitbook install
CMD ["gitbook", "serve ."]

EXPOSE 4000