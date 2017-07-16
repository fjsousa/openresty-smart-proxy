io.input("nginx-server/lualib/valid")
local list = {}

for token in io.lines() do
  table.insert(list, token)
end

function is_valid (req_token)

  for idx, token in ipairs(list) do
    if token == req_token then
      return req_token
    end
  end

  return false

end

return is_valid
