io.input("nginx-server/lualib/valid")

function is_valid (req_token)

   -- ngx.log(ngx.INFO, "Checking validity for token: " .. req_token)

   ngx.log(ngx.INFO, "Checking validity for token: ")

  local list = {}

  for token in io.lines() do
    table.insert(list, token)
  end

  for idx, token in ipairs(list) do
    if token == req_token then
      return req_token
    end
  end

  return false

end

return is_valid
