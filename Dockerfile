FROM node:10.23.1-alpine3.9

COPY . /app/portal
WORKDIR /app/portal
RUN npm i gitbook-cli -g \
  && gitbook install \
  && sed -i 's/confirm: true/confirm: false/g' ~/.gitbook/versions/3.2.3/lib/output/website/copyPluginAssets.js
CMD ["gitbook", "serve", "."]

EXPOSE 4000

