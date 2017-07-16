FROM fjsousa/nginx-openresty:latest

RUN apk update \
 && apk add --virtual build-deps \
    unzip wget curl gcc make musl-dev \
    pcre-dev openssl-dev zlib-dev \
    ncurses-dev readline-dev perl \
 && echo "==> Installing Lua dependencies..." \
 && luarocks install busted \
 && luarocks install lua-resty-http \
 && rm -rf /root/luarocks

RUN mkdir -p /opt/openresty/nginx/nginx-server/logs
COPY nginx-server/conf /opt/openresty/nginx/nginx-server/conf
COPY nginx-server/lualib /opt/openresty/nginx/nginx-server/lualib
COPY public /opt/openresty/nginx/nginx-server/public

RUN echo "==> Replacing nginx *.tmpl files..."
ENV NGINX_CONFIG /opt/openresty/nginx/nginx-server/conf/nginx
ENV SERVER_CONFIG /opt/openresty/nginx/nginx-server/conf/servers/server
ENV COOKIE_NAME Token
ENV URL http://www.theuselessweb.com/
ENV COOKIE_DOMAIN localhost

RUN cp "$NGINX_CONFIG".tmpl "$NGINX_CONFIG".conf \
 && cp "$SERVER_CONFIG".tmpl "$SERVER_CONFIG".conf \
 && sed -i -- "s|{{COOKIE_NAME}}|$COOKIE_NAME|g" $NGINX_CONFIG.conf \
 && sed -i -- "s|{{COOKIE_DOMAIN}}|$COOKIE_DOMAIN|g" $NGINX_CONFIG.conf \
 && sed -i -- "s|{{URL}}|$URL|g" $SERVER_CONFIG.conf

RUN apk del build-deps

CMD ["nginx", "-g", "daemon off; error_log /dev/stderr info;", "-p", "nginx-server/", "-c", "conf/nginx.conf"]
