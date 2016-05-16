#!/bin/bash

exec docker run --rm -it \
  --name nginx-dev \
  -v "$(pwd)/nginx-server/conf":/opt/openresty/nginx/conf\
  -v "$(pwd)/nginx-server/logs":/opt/openresty/nginx/logs\
  -v "$(pwd)/nginx-server/lualib":/opt/openresty/nginx/lualib\
  -v "$(pwd)/nginx-server/public":/opt/openresty/nginx/public\
  -p 80:80 \
  ficusio/openresty:latest "$@"