local is_valid = require "nginx-server/lualib/isvalid"
local cookie_name = os.getenv("COOKIE_NAME")
local token_cookie = ngx.var["cookie_" .. cookie_name]

ngx.log(ngx.INFO, "Checking validity for cookie token: " .. (token_cookie or "nil"))

if not is_valid(token_cookie) then
  ngx.log(ngx.INFO, "Cookie token not valid: " .. (token_cookie or "nil"))
  return ngx.exec("/form.html")
end

ngx.log(ngx.INFO, "Cookie token valid: " .. (token_cookie or "nil"))
return
