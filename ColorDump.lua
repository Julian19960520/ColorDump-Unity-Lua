
function Tab(depth)
    return ColorText(string.sub(string.rep("   |", depth), 1, -2),"4b692f")
end
function ColorText(text, color)
    return "<color=#"..color..">"..text.."</color>"
end
--将任意类型的数据转换为字符串，用于debug输出
function GetString(data, depth)
    if type(data) == "table" then
        local temp = {}
        for k,v in pairs(data) do
            table.insert( temp, {k = k, v = v} )
        end
        table.sort( temp, function(a, b) 
            if type(a.k) == "number" and type(b.k) ~= "number" then
                return true
            elseif type(a.k) ~= "number" and type(b.k) == "number" then
                return false
            else
                return a.k < b.k
            end
        end)
        local colors = {"fbf236","c838ff","23d9ff"}     
        local color = colors[(depth-1) % #colors +1]    --本层括号颜色
        local color2 = colors[(depth) % #colors +1]     --更深一层颜色，如果value是table的话，则key与table的括号颜色相同
        local str = ColorText(" {",color).."\n"         --注意：\n放在color标签里会有问题
        for k,t in ipairs(temp) do
            local keyStr
            if type(t.k) == "number" then
                keyStr = "["..t.k.."]"
            else
                keyStr = t.k
            end
            if type(t.v) == "table" then
                keyStr = ColorText(keyStr, color2)
            end
            str = str..Tab(depth)..keyStr.." = "..GetString(t.v,depth+1)..",\n"
        end
        return str..Tab(depth - 1)..ColorText("}",color)
    elseif type(data) == "string" then 
        return "\""..data.."\""
    elseif type(data) == "number" then
        return data
    elseif type(data) == "nil" then
        return "nil"
    elseif type(data) == "boolean" then 
        return data and "true" or "false"
    elseif type(data) == "userdata" then
        return tostring(data)
    elseif type(data) == "function" then 
        return tostring(data)
    else
        return "未知类型"
    end
end

Log = function(data)
    CS.UnityEngine.Debug.Log(GetString(data,1))
end
Warning = function(data)
    CS.UnityEngine.Debug.LogWarning(GetString(data,1))
end
Error = function(data)
    CS.UnityEngine.Debug.LogError(GetString(data,1))
end
