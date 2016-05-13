#!/bin/bash
NGINX_PID="null"
PID_FILE=nginx-server/logs/nginx.pid

if [ -f $PID_FILE ]; then
  NGINX_PID=`cat $PID_FILE` 
fi

# helper functions 

log() {
    echo " >>> $@"
}

#start, stop, reload
nginx_server(){

  log $1"ing nginx server"

  if [ $1 = "start" ]; then
    cmd=""
  elif [ $1 = "stop" ]; then
    cmd="-s stop"
  elif [ $1 = "reload" ]; then
    cmd="-s reload"
  fi

  nginx -p `pwd`/nginx-server/ -c `pwd`/nginx-server/conf/nginx.conf $cmd
}

nginx_watch(){
  log "Live reloading *.conf and *.lua"
  export -f nginx_server
  export -f log
  fswatch -o `pwd`/nginx-server/conf/* `pwd`/nginx-server/*.lua | xargs -n1 -I{} bash -c 'nginx_server reload'
}

helper(){
  echo "$(basename $0) <nginx-start|nginx-stop>" && exit 1
}

[[ $# -lt 1 ]] && helper

if [ $1 = "nginx-start" ]; then

  if [ $NGINX_PID = "null" ]; then
    nginx_server start
  else
    nginx_server reload
  fi

  nginx_watch
  exit 0

fi

if [ $1 = "nginx-stop" ]; then
  nginx_server stop
  exit 0
fi

helper