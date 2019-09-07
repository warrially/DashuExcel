--[[--ldoc desc
@module TExcel
@author Warrially

Date   2018-02-24 11:05:31
Last Modified by   Warrially
Last Modified time 2018-02-26 21:19:19
]]
require "StringEx"
require "MathEx"
local xls = require "ExcelLua";
local TSheet = require "TSheet"

for k,v in pairs(xls) do
    print("库内容", k, v);
end


local TExcel = {}

-- 创建Excel
function TExcel:create()
    local tb = {}
    setmetatable(tb, {__index = self})
    tb.super = self;
    tb:init();
    return tb;
end;

-- 初始化
function TExcel:init()
    self.m_sheetList = {}
    self.m_nExcel = xls.open();
end;

function TExcel:this(...)
    return self.m_nExcel, table.unpack{...};
end

-- 手动关闭Excel
function TExcel:free()
    self.m_sheetList = nil;
    xls.close(self:this());
end;

-- 获取单元格(单元格编号:int)
function TExcel:getSheet(nSheet)
    if not self.m_sheetList[nSheet] then
        self.m_sheetList[nSheet] = TSheet:create(self:this(), nSheet)
    end
    return self.m_sheetList[nSheet]
end;

-- 通过单元格的名称获取编号(单元格名称:string)
function TExcel:getSheetByName(strSheet)
    return xls.getSheetByName(self:this(strSheet))
end

-- 获取Sheet的数量
function TExcel:getSheetCount()
    return xls.getSheetCount(self:this())
end

-- 添加一个Sheet
function TExcel:addSheet()
    xls.addSheet(self:this())
end

-- 查找文本是否存在
function TExcel:findText(strFindText)
    return xls.findText(self:this(strFindText))
end

-- 保存到文件(文件名:string)
function TExcel:saveToFile(strFile)
    xls.saveToFile(self:this(strFile));
end;

-- 从文件载入(文件名:string)
function TExcel:loadFromFile(strFile)
    xls.loadFromFile(self:this(strFile));
end

-- 从CSV文件载入(文件名:string)
function TExcel:loadFromCSV(strFile)
    xls.loadFromCSV(self:this(strFile));
end

-- 把 123,456,789.00 转换成数字
function S2F(str)
    return xls.S2F(str);
end;

stringToFloat = S2F

-- 把 日期字符串 2011年1月2日 等 转成 日期浮点
function S2D(str)
    return xls.S2D(str)
end;

stringToDate = S2D

-- 获取文件列表
function GetFiles(strPath, strPattern)
    return {xls.GetFiles(strPath, strPattern)}
end

-- 提取文件名
function GetFileName(strFile)
    return xls.GetFileName(strFile);
end

-- 提取扩展名
function GetExtension(strFile)
    return xls.GetExtension(strFile);
end

-- 提取无扩展名的文件名
function GetFileNameWithoutExtension(strFile)
    return xls.GetFileNameWithoutExtension(strFile);
end

return TExcel