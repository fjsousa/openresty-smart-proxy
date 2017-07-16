local is_valid = require "nginx-server/lualib/isvalid"
local cookie_name = os.getenv("COOKIE_NAME")
local cookie_domain = os.getenv("COOKIE_DOMAIN")
local user_code, err = ngx.req.get_post_args(1)["code"]

ngx.log(ngx.INFO, "Checking validity for auth token: " .. (user_code or "nil"))

local valid = is_valid(user_code)

if valid == false then
  ngx.log(ngx.INFO, "Auth token not valid: " .. user_code)
  ngx.status = 401
  ngx.header["Content-type"] = "text/html"
  ngx.say("Unauthorized. Take me to the <a href=\"/\">main page.</a>")
  return
end

ngx.log(ngx.INFO, "Auth token is valid: " .. user_code)
ngx.log(ngx.INFO, "Setting domain cookie")
ngx.header['Set-Cookie'] = cookie_name .. "=" .. valid .. "; Domain=" .. cookie_domain
ngx.redirect("/")
return
