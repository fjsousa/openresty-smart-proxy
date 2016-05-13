local cookie_name = os.getenv("COOKIE_NAME")
local user_code, err = ngx.req.get_post_args(1)["code"]

function is_valid(code) 
  return false
end

local valid = is_valid(user_code)

if valid == false then
  ngx.status = 401
  ngx.say("Unauthorized")
  ngx.exit(ngx.OK)
  return
end

ngx.header['Set-Cookie'] = cookie_name .. "=" .. valid
ngx.status = 200
ngx.say(valid)
ngx.exit(ngx.OK)
return
