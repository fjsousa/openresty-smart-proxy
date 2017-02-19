io.input("nginx-server/conf/valid")

function is_valid (req_token) 

  local list = {}

  for token in io.lines() do
    table.insert(list, token)
  end

  for idx, token in ipairs(list) do
    if token == req_token then
      return true
    end
  end

  return false

end

return is_valid