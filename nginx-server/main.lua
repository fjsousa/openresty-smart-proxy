local cookie_name = os.getenv("COOKIE_NAME")
local token_cookie = ngx.var["cookie_" .. cookie_name]

function is_valid()
  return false;
end

if not is_valid(token_cookie) then
  return ngx.exec("/form.html")
end

-- 