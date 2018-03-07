--[[--ldoc 乘法口诀表DEMO
@module main
@author warrially

Date   2018-03-03 11:19:35
Last Modified by   warrially
Last Modified time 2018-03-03 11:20:59
]]

local TExcel = require "TExcel"

-- 表格1
local xls1 = TExcel:create()

-- sheet1
local sheet1 = xls1:getSheet(1)
-- 循环乘法口诀
for i = 1, 9 do
    for j = i , 9 do
        sheet1:setCellsAsStr(i, j,  i .. " * " .. j .. " = " .. i * j )
    end;
end;
xls1:saveToFile("乘法口诀表.xlsx")
xls1:free()
