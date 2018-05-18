--- LUA八字库
local TBazi = {}

-- 新历历法
local ctInvalid     = 1 --非法
local ctJulian      = 2 --儒略
local ctGregorian   = 3 --格利高里

-- 从新历获取八字(年, 月, 日, 时, 分, 秒, 性别男1,女0)
function TBazi:GetBazi(data)
    local nYear = data.nYear or 0;
    local nMonth = data.nMonth or 0;
    local nDay = data.nDay or 0;
    local nHour = data.nHour or 0;
    local nMinute = data.nMinute or 0;
    local nSecond = data.nSecond or 0;
    local nSex = data.nSex or 0;

    if not self:GetDateIsValid(nYear, nMonth, nDay) then
        dump(data, "无效的日期")
        error("无效的日期")
    end;

end;


-- 返回公历日期是否合法
function TBazi:GetDateIsValid(nYear, nMonth, nDay)
    -- 没有公元0年
    if nYear == 0 then
        return false
    end

    -- 1月开始
    if nMonth < 1 then
        return false
    end

    -- 12月结束
    if nMonth > 12 then
        return false
    end

    -- 1号开始
    if nDay < 1 then
        return false
    end

    -- 获取每个月有多少天
    if nDay > self:GetMonthDays(nYear, nMonth) then
        return false
    end

    -- 1582 年的特殊情况
    if nYear ~= 1582 then
        return true
    end
    if nMonth ~= 10 then
        return true
    end
    if nDay < 5 then
        return true
    end
    if nDay > 14 then
        return true
    end
    return false
end

-- 取本月天数，不考虑 1582 年 10 月的特殊情况
function TBazi:GetMonthDays(nYear, nMonth)
    if nMonth == 1 or nMonth == 3 or nMonth == 5 or nMonth == 7 or nMonth  == 8 or nMonth == 10 or nMonth == 12 then
        return 31
    end

    if nMonth == 4 or nMonth == 6 or nMonth == 9 or nMonth == 11 then
        return 30
    end

    if nMonth == 2 then
        if self:GetIsLeapYear(nYear) then
            return 29
        else
            return 28
        end
    end

    return 0
end;

-- 返回某公历是否闰年
function TBazi:GetIsLeapYear(nYear)
    if self:GetCalendarType(nYear, 1, 1) == ctGregorian then
        return (nYear%4 == 0) and ((nYear%100 ~= 0) or (nYear%400 == 0))
    elseif nYear >= 0  then
        return nYear%4 == 0
    else  -- 需要独立判断公元前的原因是没有公元 0 年
        return (nYear-3)%4 == 0
    end;
end;


-- 根据公历日期判断当时历法
function TBazi:GetCalendarType(nYear, nMonth, nDay)
    if not self:GetDateIsValid(nYear, nMonth, nDay) then
        return ctInvalid
    end

    if nYear > 1582 then
        return ctGregorian
    elseif nYear < 1582 then
        return ctJulian
    elseif nMonth < 10 then
        return ctJulian
    elseif (nMonth == 10) and (nDay <= 4) then
        return ctJulian
    elseif (nMonth == 10) and (nDay <= 14) then
        return ctInvalid
    else
        return ctGregorian
    end
    -- 在现在通行的历法记载上，全世界居然有十天没有任何人出生过，也没有任何人死亡过，也没有发生过大大小小值得纪念的人或事。这就是1582年10月5日至10月14日。格里奥，提出了公历历法。这个历法被罗马教皇格里高利十三世采纳了。那么误差的十天怎么办？罗马教皇格里高利十三世下令，把1582年10月4日的后一天改为10月15日，这样误差的十天没有了，历史上也就无影无踪地消失了十天，当然史书上也就没有这十天的记载了。“格里高利公历”一直沿用到今天。
end

TBazi:GetBazi({
    nYear = 1986,
    nMonth = 2,
    nDay = 22,
    nHour = 12
})