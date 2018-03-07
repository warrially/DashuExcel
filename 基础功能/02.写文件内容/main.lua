--[[--ldoc 写文件内容
@module main
@author warrially

Date   2018-03-07 11:19:35
Last Modified by   Warrially
Last Modified time 2018-03-07 20:35:25
]]

local TExcel = require "TExcel"

-- 表格1
local xls1 = TExcel:create()

-- 按照字符串保存
xls1:getSheet(1):setCellsAsStr(1, 1, "写入的内容文本格式")
xls1:getSheet(1):setCellsAsStr(1, 2, "字符串" .. "拼接")
xls1:getSheet(1):setCellsAsStr(1, 3, "数字" .. 1 .. "拼接")
xls1:getSheet(1):setCellsAsStr(1, 4, tostring(1+2+3+4+7))

-- 按照日期保存
xls1:getSheet(1):setCellsAsDate(2, 1, S2D("2018.3.7"))
xls1:getSheet(1):setCellsAsDate(2, 2, S2D("2018-3-8"))
xls1:getSheet(1):setCellsAsDate(2, 3, S2D("2018/03/09"))
xls1:getSheet(1):setCellsAsDate(2, 4, S2D("2018-03-10") + 7)

xls1:saveToFile("写文件内容.xlsx")
xls1:free()
