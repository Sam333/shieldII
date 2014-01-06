core = {}

--core.host = "127.0.0.1"
--core.port = 15002
core.host = "127.0.0.1"
core.port = 15003

core.sendtimeout = 20
core.gettimeout = 1

local nixio = require "nixio"
local os    = require "os"

local proto = {
    -- A 获取状态
    ['getStatus'] = 'C',
    ['loginout']  = 'B',
    ['loginin']   = 'A'  
}

function core.content(item,data,data1)
    local content = ""
    local len = nil

    if proto[item] == 'C' then
        len = 6
        content = string.format("%3s||%s",len,proto[item])
    elseif proto[item] == 'B' then
        len = 8 + string.len(data)
        content = string.format("%3s||%s||%s",len,proto[item],data)
        core.gettimeout = 3
    elseif proto[item] == 'A' then
        len = 10 + string.len(data) + string.len(data1)
        content = string.format("%3s||%s||%s::%s",len,proto[item],data,data1)
        core.gettimeout = 6
    end

    return content
end

function core.send(item,data,data1)
    local socket = nixio.socket("inet","stream")
    local tmp
    local t = {}

    if not socket then return "创建socket失败" end
    
    if not socket:connect(core.host,core.port) then
        socket:close()
        return "连接不上"
    end
    
    --socket:setopt("socket","sndtimeo",core.sendtimeout)

    local content = core.content(item,data,data1)

    socket:setopt("socket","rcvtimeo",core.gettimeout)

    socket:send(content)
--[[
    while true do
        tmp = socket:recv(10)

        if tmp == false then
            break;
        end

        tmp = tostring(tmp)
        t[#t + 1] = tmp
    end
]]
    tmp = socket:recv(1024)

    socket:close()
    --local result = table.concat(t)
    local result = tmp

    return result
end

return core