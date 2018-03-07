--[[--ldoc 保存文件
@module main
@author warrially

Date   2018-03-07 11:19:35
Last Modified by   Warrially
Last Modified time 2018-03-07 20:27:33
]]

local TExcel = require "TExcel"

-- 表格1
local xls1 = TExcel:create()
xls1:saveToFile("保存文件演示.xlsx")
xls1:free()
