A development flow based on an OpenResty Docker image that will make your life easier when scripting in Nginx. Clone, build, run and try it for yourself:

- `$ git clone git@github.com:fjsousa/openresty-smart-proxy.git`
- `$ cd openresty-smart-proxy/`
- `$ docker build -t nginx-barrier-page:latest .`
- `$ docker run -p 80:80 nginx-barrier-page:latest`
- Hit `localhost` in your browser.

Read the companion blog post at [datajournal](http://datajournal.co.uk/nginx-openresty-lua-docker.html).
