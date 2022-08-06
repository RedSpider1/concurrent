FROM node:10.23.1-alpine3.9

COPY . /app/portal
WORKDIR /app/portal
RUN  alias cnpm="npm --registry=https://registry.npmmirror.com \
--cache=$HOME/.npm/.cache/cnpm \
--disturl=https://npmmirror.com/mirrors/node \
--userconfig=$HOME/.cnpmrc" \
  && cnpm i gitbook-cli -g \
  && gitbook install \
  && sed -i 's/confirm: true/confirm: false/g' ~/.gitbook/versions/3.2.3/lib/output/website/copyPluginAssets.js
CMD ["gitbook", "serve", "."]

EXPOSE 4000