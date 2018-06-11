--[[--遍历读取
@module main
@author warrially

Date   2018-03-03 11:19:35
Last Modified by   warrially
Last Modified time 2018-03-03 11:20:59
]]

local TExcel = require "TExcel"

-- 表格1
local xls1 = TExcel:create()

-- 获取数据源下的所有文件
local strFileList = GetFiles("./数据源/", "*.xlsx")

-- 所有文件进行统计
for i,v in ipairs(strFileList) do
    -- 打开这些Excel文件
    local xls2 = TExcel:create()
    xls2:loadFromFile(v);

    -- 用来累加的总数数额
    local fTotal = 0

    -- 从Excel 文件的E列统计综合
    local sheet = xls2:getSheet(1);
    -- 从第二行开始, 因为第一行是标题, 到最后一行的 E列数据 统计
    for j = 2, sheet:lastRow() do
        local ff = sheet:getCellsAsFloat(5, j); -- E列刚好是第五
        fTotal = fTotal + ff -- 数据加
    end;

    print(fTotal)
    xls1:getSheet(1):setCellsAsStr(1,i,GetFileNameWithoutExtension(v))
    xls1:getSheet(1):setCellsAsFloat(2,i,fTotal)
    xls2:free();
end;

xls1:saveToFile("导出内容.xlsx")

