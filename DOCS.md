Imagine the scenario where you have a website in a private network that you need to protect with a barrier page, but you need something more than what nginx can give you by default. Basically a way to protect the assets, and make sure that the user-agent can only load the assets, provided that the has credentials to do so.

*image of default nginx login*

You need a nice form with stylings and some javascript to do aninamtions. What we need is a way of accessing a uri, load the barrier page, ask the user to introduce the credentials, validate the credentials, and store a cookie with a token. Everytime that the user refreshes the page, the cookie is sent to the server and validated. If it's not valid, say for instance, the cookie was invalidated, then the user won't be redirected to the website and will load the form instead.

This is what our server logic looks like when we hit our domain `mywebsite.com` and the server checks for a valid cookie

*cookie logic*

The solution I'm proposing in this blog post is extending nginx with lua code by using an nginx distribution called openresty.

We'll go through all the steps from setting up nginx, to setting up a dev environment in lua, with tests included

## Setting up nginx with open resty

I won't go through with details and refer you to http://openresty.org/#Installation
Please keep in mind that if you're building it from source you''l have to specify openssl and pcre location when running `./configure`. Then, you'll need `luarocks` as well, lua's package manager, to install some dependencies that we will be using in our code. 

Installing open resty is also recomended and would save you the trouble of doing the setup twice, in your local and in your live environments.

Finally, make sure that you have, nginx, luarocks and lua in your path.

Also, keep in mind this resources

- Lua documentation http://www.lua.org/manual/5.1/
- openresty lua module: https://github.com/openresty/lua-nginx-module

## Setting up a local dev environment

```
├── fronted
│   └── public
└── nginx-server
    ├── auth.lua
    ├── conf
    │   ├── nginx.conf
    │   └── servers
    │       └── server.conf
    ├── logs
    └── main.lua
```

Wel'll start with a basic version of the server to get everything goingi. First some automation. We can create a script o have live reload on any *.conf and *.lua files. For that we'll create a script that starts the nginx server, if it isn't running already or reloads it otherwise. I'll call it turk, after the mechanical turk:

```bash
NGINX_PID="null"
PID_FILE=nginx-server/logs/nginx.pid

if [ -f $PID_FILE ]; then
  NGINX_PID=`cat $PID_FILE`
fi

if [ $1 = "nginx-start" ]; then

  if [ $NGINX_PID = "null" ]; then
    nginx-server start
  else
    nginx-server reload
    fswatch -o `pwd`/nginx-server/conf `pwd`/nginx-server/*.lua | xargs -n1 -I{} nginx-server reload
  fi

fi

nginx-server(){

  if [ $1 = "start" ]; then
    cmd=""
  elif [ $1 = "stop" ]; then
    cmd="-s stop"
  elif [ $1 = "reload" ]; then
    cmd="-s reload"
  fi

  cmd="nginx -p `pwd`/nginx-server/ -c `pwd`/nginx-server/conf/nginx.conf $cmd"
  log $cmd

}
```
