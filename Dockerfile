FROM ryanwclark/nginx:latest
LABEL maintainer="Ryan Clark (ryanwclark@yahoo.com)"

### Set Defaults
ENV N8N_VERSION=0.136.0 \
    ENABLE_SMTP=FALSE \
    ENABLE_CRON=FALSE \
    NGINX_WEBROOT=/app \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    ZABBIX_HOSTNAME=n8n-app

### Install Runtime Dependencies
RUN set -x && \
    apk update && \
    apk upgrade && \
    apk add -t .n8n-build-deps \
               build-base \
               python3 \
               && \
    \
    apk add -t .n8n-run-deps \
               graphicsmagick \
               nodejs \
               npm \
               && \
    \
    mkdir -p /app && \
    npm_config_user=root npm install -g n8n@${N8N_VERSION} && \
    \
### Misc & Cleanup
    apk del .n8n-build-deps && \
    rm -rf /tmp/* /var/cache/apk/*

WORKDIR /app/

### Networking Configuration
EXPOSE 5678

### Add Files
ADD install /
