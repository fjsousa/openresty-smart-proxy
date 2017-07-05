local is_valid = require "nginx-server/lualib/isvalid"
local cookie_name = os.getenv("COOKIE_NAME")
local token_cookie = ngx.var["cookie_" .. cookie_name]

if not is_valid(token_cookie) then
  return ngx.exec("/form.html")
end

return
