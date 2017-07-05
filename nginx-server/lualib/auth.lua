local is_valid = require "nginx-server/lualib/isvalid"
local cookie_name = os.getenv("COOKIE_NAME")
local cookie_domain = os.getenv("COOKIE_DOMAIN")
local user_code, err = ngx.req.get_post_args(1)["code"]

local valid = is_valid(user_code)

if valid == false then
  ngx.log(ngx.INFO, "Token invalid: " .. user_code)
  ngx.status = 401
  ngx.say("Unauthorized")
  ngx.exit(ngx.OK)
  return
end

ngx.log(ngx.INFO, "Token is valid: " .. user_code)
ngx.header['Set-Cookie'] = cookie_name .. "=" .. valid .. "; Domain=" .. cookie_domain
ngx.status = 200
ngx.exit(ngx.OK)
return
