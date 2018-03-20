-- 对数值进行四舍五入，如果不是数值则返回 0
-- @function [parent=#math] round
-- @param number value 输入值
-- @return number#number 

function math.round(value)
    value = tonumber(value) or 0
    return math.floor(value + 0.5)
end