FROM nginx
COPY nginx.conf.template /
ENTRYPOINT ["/bin/bash", "-c", "envsubst '$NGINX_ASSET_CACHE_TIME$NUCORE_HOST$NUCORE_PORT' < /nginx.conf.template > /etc/nginx/conf.d/default.conf && exec nginx -g 'daemon off;'"]
