--[[--ldoc desc
@module TSheet
@author Warrially

Date   2018-02-24 12:19:15
Last Modified by   Warrially
Last Modified time 2018-02-26 21:33:48
]]

local xls = require "ExcelLua";
local TSheet = {}

function TSheet:create(...)
    local tb = {}
    setmetatable(tb, {__index = self})
    tb.super = self;
    tb:init(...);
    return tb;
end;

-- 初始化
function TSheet:init(nExcel, nSheet)
    self.m_nExcel = nExcel;
    self.m_nSheet = nSheet;
end;

function TSheet:this(...)
    return self.m_nExcel, self.m_nSheet, table.unpack{...};
end;

-- 设置(列编号:int, 行编号:int, 内容:string)
function TSheet:setCellsAsStr(nCol, nRow, str)
    xls.setCellsAsStr(self:this(nCol, nRow, str))
end;


-- 设置(列编号:int, 行编号:int, 内容:date)
function TSheet:setCellsAsDate(nCol, nRow, dt)
    xls.setCellsAsDate(self:this(nCol, nRow, dt))
end;


-- 设置(列编号:int, 行编号:int, 内容:float)
function TSheet:setCellsAsFloat(nCol, nRow, f)
    xls.setCellsAsFloat(self:this(nCol, nRow, f))
end;

-- 设置(列编号:int, 行编号:int, 公式:string)
function TSheet:setCellsAsFormula(nCol, nRow, strFormula)
    xls.setCellsAsFormula(self:this(nCol, nRow, strFormula))
end;

-- 设置
function TSheet:setCells(nCol, nRow, value)
    if type(value) == "number" then
        self:setCellsAsFloat(nCol, nRow, value);
    elseif type(value) == "string" then
        self:setCellsAsStr(nCol, nRow, value);
    end;
end;



-- 读取(列编号:int, 行编号:int)
function TSheet:getCellsAsStr(nCol, nRow)
    return xls.getCellsAsStr(self:this(nCol, nRow))
end;

-- 读取(列编号:int, 行编号:int)
function TSheet:getCellsAsDate(nCol, nRow)
    return xls.getCellsAsDate(self:this(nCol, nRow))
end;

-- 读取(列编号:int, 行编号:int)
function TSheet:getCellsAsFloat(nCol, nRow)
    return xls.getCellsAsFloat(self:this(nCol, nRow))
end;

-- 最后一行
function TSheet:lastRow()
    return xls.lastRow(self:this())
end;

-- 自动列宽
function TSheet:autoWidthCol(nCol)
    return xls.autoWidthCol(self:this(), nCol)
end;

-- 自动列宽范围
function TSheet:autoWidthCols(nCol1, nCol2)
    return xls.autoWidthCols(self:this(), nCol1, nCol2)
end;

return TSheet;