local is_valid = require "nginx-server/lib/isvalid"
local cookie_name = os.getenv("COOKIE_NAME")
local cookie_domain = os.getenv("COOKIE_DOMAIN")
local user_code, err = ngx.req.get_post_args(1)["code"]

local valid = is_valid(user_code)

if valid == false then
  ngx.status = 401
  ngx.say("Unauthorized")
  ngx.exit(ngx.OK)
  return
end

ngx.header['Set-Cookie'] = cookie_name .. "=" .. valid .. "; Domain=" .. cookie_domain
ngx.status = 200
ngx.say(valid)
ngx.exit(ngx.OK)
return
