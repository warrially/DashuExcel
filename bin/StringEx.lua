--[[--ldoc 字符串扩展函数
@module StringEx
@author Warrially

Date   2018-03-07 21:06:47
Last Modified by   Warrially
Last Modified time 2018-03-07 21:09:30
]]

--允许使用方括号符号将字符串索引的能力
--@usage
--      s = "hello"
--      s[1] = "h"
getmetatable('').__index = function(str, i)
    if (type(i) == 'number') then
        return string.sub(str, i, i)
    end

    return string[i]
end



-- Allows the ability to index into a string like above, but using normal brackes to
-- return the substring
-- For example:
--      s = "hello"
--      s(2,5) = "ello"
--
-- However, it also allows indexing into the string to return the byte (unicode) value
-- of the character found at the index. This only occurs if the second value is omitted
-- For example:
--      s = "hello"
--      s(2) = 101 (e)
--
-- Furthermore, it also allows for the ability to replace a character at the given index
-- with the given characters, iff the second value is a string
-- For example:
--      s = "hello"
--      s(2,'p') = "hpllo"
getmetatable('').__call = function(str, i, j)
    if (type(i) == 'number' and type(j) == 'number') then
        return string.sub(str, i, j)
    elseif (type(i) == 'number' and type(j) == 'string') then
        return table.concat{string.sub(str, 1, i - 1), j, string.sub(str, i + 1)}
    elseif (type(i) == 'number' and type(j) == 'nil') then
        return string.byte(str, i)
    end

    return string[i]
end



---检查字符串是否从给定字符开始
--@usage str = "abc"
-- if string.startsWith(str,"a") then
--     print("true")
-- end
function string.startsWith(str, chars)
    return chars == '' or string.sub(str, 1, string.len(chars)) == chars
end



---检查字符串是否以给定字符结尾
--@usage if string.endsWith("abc","c") then
--     print("true")
-- end
function string.endsWith(str, chars)
    return chars == '' or string.sub(str, -string.len(chars)) == chars
end



---从字符串的开始移除长度，返回结果
--@string str 字符串
--@int length 长度可以是数字或字符串
--@usage str = "abc"
-- string.removeFromStart(str,1)
-- print(str)
function string.removeFromStart(str, length)
    if (type(length) == 'number') then
        return string.sub(str, length + 1, string.len(str))
    elseif (type(length) == 'string') then
        return string.sub(str, string.len(length) + 1, string.len(str))
    else
        return str
    end
end



---从字符串的结尾移除长度，返回结果
--@string str 字符串
--@int length 长度可以是数字或字符串
--@usage local str = "abc"
-- str = string.removeFromEnd(str,1)
-- print(str)=>ab
function string.removeFromEnd(str, length)
    if (type(length) == 'number') then
        return string.sub(str, 1, string.len(str) - length)
    elseif (type(length) == 'string') then
        return string.sub(str, 1, string.len(str) - string.len(length))
    else
        return str
    end
end


---从字符串中移除模式的一些发生
--@string str       字符串
--@string pattern   字符串
--@param limit 如果限制为空白，则移除所有事件
--@usage string.remove("asdfdsa","a",1)
function string.remove(str, pattern, limit)
    if (pattern == '' or pattern == nil) then
        return str
    end

    if (limit == '' or limit == nil) then
        str = string.gsub(str, pattern, '')
    else
        str = string.gsub(str, pattern, '', limit)
    end
    return str
end

---从字符串中移除所有模式的出现
--@string str       字符串
--@string pattern   字符串
--@usage string.removeAll("asdfdsa","a")
function string.removeAll(str, pattern)
    if (pattern == '' or pattern == nil) then
        return str
    end

    str = string.gsub(str, pattern, '')
    return str
end

---从字符串中移除模式的第一次发生
--@string str       字符串
--@string pattern   字符串
--@usage string.removeFirst("asdfdsa","a")
function string.removeFirst(str, pattern)
    if (pattern == '' or pattern == nil) then
        return str
    end

    str = string.gsub(str, pattern, '', 1)
    return str
end



---返回字符串是否包含模式
--@string str       字符串
--@string pattern   字符串
--@usage string.contains("abcabm","bc")
function string.contains(str, pattern)
    if (pattern == '' or string.find(str, pattern, 1)) then
        return true
    end

    return false
end



---不区分大小写的string.find，返回的字符串开始和结束位置
--@string str       字符串
--@string pattern   字符串
--@usage string.findi("abcabm","C")
function string.findi(str, pattern)
    return string.find(string.lower(str), string.lower(pattern), 1)
end



---返回匹配从起始索引字符串模式的第一个子串
function string.findPattern(str, pattern, start)
    if (pattern == '' or pattern == nil) then
        return ''
    end

    if (start == '' or start == nil) then
        start = 1
    end

    return string.sub(str, string.find(str, pattern, start))
end



-- ----Split the string by the given pattern, returning an array of the result
-- ----If pattern is omitted or nil, then default is to split on spaces
-- ----Array index starts at 1
-- -function string.split(str, pattern)
-- - local split = {}
-- - local index = 1

-- - if (pattern == '' or pattern == nil) then
-- -     pattern = '%s'
-- - end

-- - local previousstart = 1
-- - local startpos, endpos = string.find(str, pattern, 1)

-- - while (startpos ~= nil) do
-- -     split[index] = string.sub(str, previousstart, startpos - 1)
-- -     previousstart = endpos + 1
-- -     index = index + 1
-- -     startpos, endpos = string.find(str, pattern, endpos + 1)
-- - end

-- - split[index] = string.sub(str, previousstart, string.len(str))

-- - return split
-- -end

---分割字字符串
--@usage split[index] = string.sub(str, previousstart, string.len(str))
--@string str 原字符串
--@string delimiter 拆分字符串
--@usage local tb = string.split("3,3,3,7,8,5", ",");
-- print(tb[1]) -- 3;
-- print(tb[2]) -- 3;
-- print(tb[3]) -- 3;
-- print(tb[4]) -- 7;
-- print(tb[7]) -- nil;
function string.split(str, delimiter)
    if str == nil or delimiter == nil then return; end

    if (delimiter == '') then return false end
    local pos, arr = 0, {}
    -- for each divider found
    for st, sp in function() return string.find(str, delimiter, pos, true) end do
        table.insert(arr, string.sub(str, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(str, pos))
    return arr
end



---取出字符串里的内容放进table里，以逗号或空格作为分隔单位
--@string str       字符串
--@usage string.toWordArray("a,bc,def") => {1 = a, 2 = bc, 3 = def}
function string.toWordArray(str)
    local words = {}
    local index = 1

    for word in string.gmatch(str, '%w+') do
        words[index] = word
        index = index + 1
    end

    return words
end



---统计字符串里的字符数
--@string   str   字符串
--@usage string.letterCount("zxc")
function string.letterCount(str)
    local _, count = string.gsub(str, '%a', '')
    return count
end



---统计字符串里的空格数
--@string   str   字符串
--@usage x = string.spaceCount("z x c")
--x = 2
function string.spaceCount(str)
    local _, count = string.gsub(str, '%s', '')
    return count
end



---统计字符串中指定模式的数量
--@string   str   字符串
--@usage x = string.patternCount("ssse","se")
--x = 1
function string.patternCount(str, pattern)
    if (pattern == '' or pattern == nil) then
        return nil
    end

    local _, count = string.gsub(str, pattern, '')
    return count
end



---Returns a table of how many of each character appears in the string
---Table in the format: ["char"] = 2
function string.charTotals(str)
    local totals = {}
    local temp = ''

    for i = 1, string.len(str), 1 do
        temp = str[i]
        if (totals[temp]) then
            totals[temp] = totals[temp] + 1
        else
            totals[temp] = 1
        end
    end

    return totals
end



---计算字符串的数量
--@string   str   字符串
--@usage x = string.wordCount("i zb as")
--x = 3
function string.wordCount(str)
    local _, count = string.gsub(str, '%w+', '')
    return count
end


---计算字符串的长度
--@string   str   字符串
--@usage x = string.wordLengths("AB12")
--x = 4
function string.wordLengths(str)
    local lengths = string.gsub(str, '%w+', function(w) return string.len(w) end)
    return lengths
end



---Returns a table of how many of each word appears in the string
---Table in the format: ["word"] = 2
function string.wordTotals(str)
    local totals = {}

    for word in string.gmatch(str, '%w+') do
        if (totals[word]) then
            totals[word] = totals[word] + 1
        else
            totals[word] = 1
        end
    end

    return totals
end



---Returns byte (unicode) representation of each character within the string as an array
---Array index starts at 1
function string.toByteArray(str)
    local bytes = {}

    for i = 1, string.len(str), 1 do
        bytes[i] = string.byte(str, i)
    end

    return bytes
end



---Returns character representation of each character within the string as an array
---Array index starts at 1
function string.toCharArray(str)
    local chars = {}

    for i = 1, string.len(str), 1 do
        chars[i] = str[i]
    end

    return chars
end



---将指定模块转换成大写
--@usage x = string.patternToUpper("abc","b")
--x = "aBc"
function string.patternToUpper(str, pattern)
    if (pattern == '' or pattern == nil) then
        return str
    end

    local upper = string.gsub(str, pattern, string.upper)
    return upper
end


---将指定模块转换成小写
--@usage x = string.patternToLower("aBc","B")
--x = "abc"
function string.patternToLower(str, pattern)
    if (pattern == '' or pattern == nil) then
        return str
    end

    local lower = string.gsub(str, pattern, string.lower)
    return lower
end



---对字符串的内容进行修改替换
--@string    str       字符串
--@string    pattern   字符串
--@param     limit     如果限制为空白，则替换所有事件
--@usage x = string.replace("aBcB","B","das",1)
--x = "adasB"
function string.replace(str, pattern, chars, limit)
    if (pattern == '' or pattern == nil) then
        return str
    end

    if (limit == '' or limit == nil) then
        str = string.gsub(str, pattern, chars)
    else
        str = string.gsub(str, pattern, chars, limit)
    end
    return str
end



---替换给定索引值的字符串
--@string     str       字符串
--@num        index     索引值
--@param      char      要去替换的字符
--@usage x = string.replaceAt("abc",2,1)
--x = "a1c"
function string.replaceAt(str, index, chars)
    return table.concat{string.sub(str, 1, index - 1), chars, string.sub(str, index + 1)}
end



---替换指定模块的字符串
--@string     str       字符串
--@string     pattern   字符串
--@param      char      要去替换的字符
--@usage x = string.replaceAll("abca","a",1)
--x = "1bc1"
function string.replaceAll(str, pattern, chars)
    if (pattern == '' or pattern == nil) then
        return str
    end

    str = string.gsub(str, pattern, chars)
    return str
end



---替换指定模块的第一个字符串
--@string    str       字符串
--@string    pattern   字符串
--@param     char      要去替换的字符
--@usage string.replaceFirst("abca","a",1)
--x = "1bca"
function string.replaceFirst(str, pattern, chars)
    if (pattern == '' or pattern == nil) then
        return str
    end

    str = string.gsub(str, pattern, chars, 1)
    return str
end



---检索从特定位置开始指定字符串的顺位
--@string    str        字符串
--@string    pattern    字符串
--@num       start      从第几位开始检索
--@usage string.indexOf("abca","a",3)
--x = 1
function string.indexOf(str, pattern, start)
    if (pattern == '' or pattern == nil) then
        return nil
    end

    if (start == '' or start == nil) then
        start = 1
    end

    local position = string.find(str, pattern, start)
    return position
end



---检索指定字符串第一次出现的顺位
--@string    str        字符串
--@string    pattern    字符串
--@usage string.firstIndexOf("abcabc","ca")
--x = 3
function string.firstIndexOf(str, pattern)
    if (pattern == '' or pattern == nil) then
        return nil
    end

    local position = string.find(str, pattern, 1)
    return position
end



---检索指定字符串最后一次出现的顺位
--@string    str        字符串
--@string    pattern    字符串
--@usage string.firstIndexOf("abcabc","a")
--x = 4
function string.lastIndexOf(str, pattern)
    if (pattern == '' or pattern == nil) then
        return nil
    end

    local position = string.find(str, pattern, 1)
    local previous = nil

    while (position ~= nil) do
        previous = position
        position = string.find(str, pattern, previous + 1)
    end

    return previous
end



---返回数组特定下标的数据
--@string    str        字符串
--@num       index      下标
--@usage x = string.charAt({1,2,3},2)
--x = 2
function string.charAt(str, index)
    return str[index]
end



---将指定下标的字符转换成数字
--@string    str        字符串
--@num       index      下标
--@usage x = string.byteAt("ba",2)
--x = 97
function string.byteAt(str, index)
    return string.byte(str, index)
end



---将单个字符转换成数字
--@string    str        字符串
--@usage x = string.byteValue("a")
--x = 97
function string.byteValue(char)
    if (string.len(char) == 1) then
        return string.byte(char, 1)
    end

    return nil
end


---比较两个字符串的大小
---str1>str2 -->1  str1 = str2 -->0  str1<str2 -->-1
--@string    str        字符串
--@usage x = string.compare("a","A"))
--x = 0
function string.compare(str1, str2)
    local len1 = string.len(str1)
    local len2 = string.len(str2)
    local smallestLen = 0;

    if (len1 <= len2) then
        smallestLen = len1
    else
        smallestLen = len2
    end

    for i = 1, smallestLen, 1 do
        if (str1(i) > str2(i)) then
            return 1
        elseif (str1(i) < str2(i)) then
            return -1
        end
    end

    local lengthDiff = len1 - len2
    if (lengthDiff < 0) then
        return -1
    elseif (lengthDiff > 0) then
        return 1
    else
        return 0
    end
end



---比较两个字符串的大小
---str1>str2 -->1  str1 = str2 -->0  str1<str2 -->-1
--@string    str        字符串
--@usage x = string.compare("a","A"))
--x = 0
function string.comparei(str1, str2)
    return string.compare(string.lower(str1), string.lower(str2))
end



---返回值来判断两个字符串是否相等
--@string    str        字符串
--@usage x = string.equal("12","zx")
--x = false
function string.equal(str1, str2)
    local len1 = string.len(str1)
    local len2 = string.len(str2)

    if (len1 ~= len2) then
        return false
    end

    for i = 1, len1, 1 do
        if (str1[i] ~= str2[i]) then
            return false
        end
    end

    return true
end



---返回值来判断两个字符串是否相等（不区分大小写）
--@string    str        字符串
--@usage x = string.equal("12","zx")
--x = false
function string.equali(str1, str2)
    return string.equal(string.lower(str1), string.lower(str1))
end


---打印数组内容和下标
--@string    array       数组
--@num       showindex   若为空，数组不显示下标
--@usage print(printArray({1,2},1))
--1  1
--2  2
function printArray(array, showindex)
    for k,v in ipairs(array) do
        if (showindex) then
            print(k, v)
        else
            print(v)
        end
    end
end



---打印table的内容
--@string    _table       数组
--@usage print(printTable({1,2}))
--1  1
--2  2
function printTable(_table)
    for k,v in pairs(_table) do
        print(k, v)
    end
end



---打印字符串，数字，table，或bool值、
--@string   params.value  内容
--@usage print(string.valueOf({"d","1"}))
--[1]=d
--[2]=1
function string.valueOf(value)
    local t = type(value)

    if (t == 'string') then
        return value
    elseif (t == 'number') then
        return '' .. value .. ''
    elseif (t == 'boolean') then
        if (value) then
            return "true"
        else
            return "false"
        end
    elseif (t == 'table') then
        local str = ""
        for k,v in pairs(value) do
            str = str .. "[" .. k .. "] = " .. v .. "\n"
        end
        str = string.sub(str, 1, string.len(str) - string.len("\n"))
        return str
    else
        return "nil"
    end
end



---通过指定下标，在字符串里插入字符
--@string   str     字符串
--@string   chars   字符串
--@num      index   下标
--@usage  print(string.insert("abcd","2",2))
--ab2cd

function string.insert(str, chars, index)
    if (index == 0) then
        return chars .. str
    elseif (index == string.len(str)) then
        return str .. chars
    else
        return string.sub(str, 1, index) .. chars .. string.sub(str, index + 1, string.len(str))
    end
end



---在字符串中重复插入字符
--@string   str     字符串
--@string   chars   字符串
--@num      rep     重复插入的次数
--@num      index   下标
--@usage  string.insertRep("ello", "h", 4, 0) = "hhhhello"
function string.insertRep(str, chars, rep, index)
    local rep = string.rep(chars, rep)
    return string.insert(str, rep, index)
end



---移除当前下标和之后的所有字符
--@string   str     字符串
--@num      index   下标
--@usage  string.removeToEnd("hello", 3) = "he"
function string.removeToEnd(str, index)
    if (index == 1) then
        return ""
    else
        return string.sub(str, 1, index - 1)
    end
end



---移除当前下标和之前的所有字符
--@string   str     字符串
--@num      index   下标
--@usage  string.removeToStart("hello", 3) = "lo"
function string.removeToStart(str, index)
    if (index == string.len(str)) then
        return ""
    else
        return string.sub(str, index + 1, string.len(str))
    end
end

---用于去除字符串中前后的空格或符号
--@string   str     字符串
--@num      char    字符串
--@usage
--string.trim("[[[word[[[", "%[") => "word"
--string.trim("   word   ") => "word"
function string.trimStartEnd(str, char)
    if (char == '' or char == nil) then
        char = '%s'
    end

    local trimmed = string.gsub(str, '^' .. char .. '*(.-)' .. char .. '*$', '%1')
    error(1)
    return trimmed
end


---用于去除字符串前的空格或符号
--@string   str     字符串
--@num      char    字符串
--@usage
--string.trimStart("[[[word[[[", "%[") => "word[[["
--string.trimStart("   word   ") => "word   "
function string.trimStart(str, char)
    if (char == '' or char == nil) then
        char = '%s'
    end

    local trimmed = string.gsub(str, '^' .. char .. '*', '')
    return trimmed
end



---用于去除字符串后的空格或符号
--@string   str     字符串
--@num      char    字符串
--@usage
--string.trimStart("[[[word[[[", "%[") => "[[[word"
--string.trimStart("   word   ") => "   word"
function string.trimEnd(str, char)
    if (char == '' or char == nil) then
        char = '%s'
    end

    local length = string.len(str)

    while (length > 0 and string.find(str, '^' .. char .. '', length)) do
        length = length - 1
    end

    return string.sub(str, 1, length)
end



---Returns a string where the given string has had variables substituted into it
--@usage
--string.subvar("x=$(x), y=$(y)", {x=200, y=300}) => "x=200, y=300"
--string.subvar("x=$(x), y=$(y)", {['x']=200, ['y']=300}) => "x=200, y=300"
function string.subvar(str, _table)
    str = string.gsub(str, "%$%(([%w_]+)%)", function(key)
        local value = _table[key]
        return value ~= nil and tostring(value)
    end)

    return str
end



---将指定下标之前的字符移动到结尾处
--@string   str     字符串
--@num      char    字符串
--@usage
--string.rotate("hello", 3) => "lohel"
function string.rotate(str, index)
    local str1 = string.sub(str, 1, index)
    local str2 = string.sub(str, index + 1, string.len(str))
    return str2 .. str1
end



---求两个数平均值
--@string   str     字符串
--@usage
--string.average(1, 3) => 4
function string.average(str1, str2)
    local len1 = string.len(str1)
    local len2 = string.len(str2)
    local smallestLen = 0
    local newstr = ''

    if (len1 <= len2) then
        smallestLen = len1
    else
        smallestLen = len2
    end

    for i = 1, smallestLen, 1 do
        newstr = newstr .. string.char( (str1(i) + str2(i)) / 2 )
    end

    if (len1 <= len2) then
        newstr = newstr .. string.sub(str2, smallestLen + 1, string.len(str2))
    else
        newstr = newstr .. string.sub(str1, smallestLen + 1, string.len(str1))
    end

    return newstr
end



---将字符串中指定下标的两个字符进行交换
--@string   str     字符串
--@num      index   下标
--@usage
--string.swap("ABC",1,3) => CBA
function string.swap(str, index1, index2)
    local temp = str[index1]
    str = str(index1, str[index2])
    return str(index2, temp)
end



---对字符串进行升序排序
--@string   str     字符串
--@usage
--string.sortAscending("CBA") => ABC
function string.sortAscending(str)
    local chars = str:toCharArray()
    table.sort(chars, function(a,b) return a(1) < b(1) end)
    return table.concat(chars)
end



---对字符串进行降序排序
--@string   str     字符串
--@usage
--string.sortAscending("ABC") => CBA
function string.sortDescending(str)
    local chars = str:toCharArray()
    table.sort(chars, function(a,b) return a(1) > b(1) end)
    return table.concat(chars)
end



---去除字符串中最大的字符
--@string   str     字符串
--@usage
--string.highest("ABC") => C
function string.highest(str)
    local s = string.sortDescending(str)
    return s[1]
end



---去除字符串中最小的字符
--@string   str     字符串
--@usage
--string.lowest("ABC") => A
function string.lowest(str)
    local s = string.sortAscending(str)
    return s[1]
end



---判断字符串是否为空
--@string   str     字符串
--@usage
--string.isEmpty("") => true
function string.isEmpty(str)
    if (str == '' or str == nil) then
        return true
    end

    return false
end



---获取字符串的长度
--@string   str     字符串
--@usage
--string.wordPercents("hello, world!") = {"hello" = 38.46, "world" = 38.46}
function string.wordPercents(str)
    local t = string.wordTotals(str)
    local count = string.len(str)

    for k,v in pairs(t) do
        t[k] = ((string.len(k) * v) / count) * 100.0
    end

    return t
end



---获取字符串中指定子串的长度
--@string   str     字符串
--@usage
--string.wordPercent("hello, world!", "hello") = 38.46
function string.wordPercent(str, word)
    local t = string.wordPercents(str)

    if (t[word]) then
        return t[word]
    end

    return 0
end



---获取字符串中每个字符占字符串比例的百分比（省略百分号）
--@string   str     字符串
--@usage
--string.charPercents("hello") = {"h" = 20, "e" = 20, "l" = 40, "o" = 20}
function string.charPercents(str)
    local t = string.charTotals(str)
    local count = string.len(str)

    for k,v in pairs(t) do
        t[k] = (v/count) * 100.0
    end

    return t
end



---获取字符串中指定字符占字符串比例的百分比（省略百分号）
--@string   str     字符串
--@usage
--string.charPercent("hello", "h") = 20
function string.charPercent(str, char)
    local t = string.charPercents(str)

    if (t[char]) then
        return t[char]
    end

    return 0
end



---获取字符串中空格占字符串比例的百分比（省略百分号）
--@string   str     字符串
--@usage
--string.spacePercent("he ll") = 20
function string.spacePercent(str)
    local count = string.spaceCount(str)
    return (count / string.len(str)) * 100.0
end



---获取字符串中大写字母的数量
--@string   str     字符串
--@usage
--string.upperCount("Hello") = 1
function string.upperCount(str)
    local _, count = string.gsub(str, '%u', '')
    return count
end



---获取字符串中大写字母占字符串比例的百分比（省略百分号）
--@string   str     字符串
--@usage
--string.upperPercent("Hello") = 20
function string.upperPercent(str)
    local count = string.upperCount(str)
    return (count / string.len(str)) * 100.0
end



---获取字符串中小写字母的数量
--@string   str     字符串
--@usage
--string.lowerCount("Hello") = 4
function string.lowerCount(str)
    local _, count = string.gsub(str, '%l', '')
    return count
end



---获取字符串中小写字母占字符串比例的百分比（省略百分号）
--@string   str     字符串
--@usage
--string.lowerPercent("Hello") = 80
function string.lowerPercent(str)
    local count = string.lowerCount(str)
    return (count / string.len(str)) * 100.0
end



---获取字符串中数字的数量
--@string   str     字符串
--@usage
--string.digitCount("Hello123") = 3
function string.digitCount(str)
    local _, count = string.gsub(str, '%d', '')
    return count
end



---获取字符串中不同数字的数量各有多少
--@string   str     字符串
--@usage
--string.digitTotals("Hello1123") = {1=2,2=1,3=1}
function string.digitTotals(str)
    local totals = {}

    for digit in string.gmatch(str, '%d') do
        if (totals[digit]) then
            totals[digit] = totals[digit] + 1
        else
            totals[digit] = 1
        end
    end

    return totals
end



---获取字符串中不同数字各占字符串比例的百分比（省略百分号）
--@string   str     字符串
--@usage
--string.digitPercents("hello, 2world!") = {"2" = 7.14}
function string.digitPercents(str)
    local t = string.digitTotals(str)
    local count = string.len(str)

    for k,v in pairs(t) do
        t[k] = ((string.len(k) * v) / count) * 100.0
    end

    return t
end



---获取字符串中指定数字占字符串比例的百分比（省略百分号）
--@string   str     字符串
--@usage
--string.digitPercent("hello2", "2") = 16.67
function string.digitPercent(str, digit)
    local t = string.digitPercents(str)

    if (t[digit]) then
        return t[digit]
    end

    return 0
end



---获取字符串中符号的数量
--@string   str     字符串
--@usage
--string.puncCount("hello, world!") = 2
function string.puncCount(str)
    local _, count = string.gsub(str, '%p', '')
    return count
end



---获取字符串中不同符号的数量各有多少
--@string   str     字符串
--@usage
--string.puncCount("hello, world!") = {","=1,"!"=1}
function string.puncTotals(str)
    local totals = {}

    for punc in string.gmatch(str, '%p') do
        if (totals[punc]) then
            totals[punc] = totals[punc] + 1
        else
            totals[punc] = 1
        end
    end

    return totals
end



---获取字符串中不同符号各占字符串比例的百分比（省略百分号）
--@string   str     字符串
--@usage
--string.puncPercents("hello, world!") = {"," = 7.69, "!" = 7.69}
function string.puncPercents(str)
    local t = string.puncTotals(str)
    local count = string.len(str)

    for k,v in pairs(t) do
        t[k] = ((string.len(k) * v) / count) * 100.0
    end

    return t
end



---获取字符串中指定符号占字符串比例的百分比（省略百分号）
--@string   str     字符串
--@usage
--string.puncPercent("hello, world!", ",") = 7.69
function string.puncPercent(str, punc)
    local t = string.puncPercents(str)

    if (t[punc]) then
        return t[punc]
    end

    return 0
end



---在表中的每一项后面添加字符(除了最后一项)
--@table   array     表
--@sep
--string.join("a,b,c", " ") => a b c
function string.join(array, sep)
    return table.concat(array, sep)
end



---Returns the Levenshtein distance between the two given strings
function string.levenshtein(str1, str2)
    local len1 = string.len(str1)
    local len2 = string.len(str2)
    local matrix = {}
    local cost = 0

    if (len1 == 0) then
        return len2
    elseif (len2 == 0) then
        return len1
    elseif (str1 == str2) then
        return 0
    end

    for i = 0, len1, 1 do
        matrix[i] = {}
        matrix[i][0] = i
    end
    for j = 0, len2, 1 do
        matrix[0][j] = j
    end

    for i = 1, len1, 1 do
        for j = 1, len2, 1 do
            if (str1[i] == str2[j]) then
                cost = 0
            else
                cost = 1
            end

            matrix[i][j] = math.min(matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost)
        end
    end

    return matrix[len1][len2]
end



---把字符串的第一个字符转换成小写
--@string   str     字符串
--@usage
--string.lowerFirst("ABC") => aBC
function string.lowerFirst(str)
    return str(1, string.lower(str[1]))
end



---把字符串的第一个字符转换成大写
--@string   str     字符串
--@usage
--string.upperFirst("abc") => Abc
function string.upperFirst(str)
    return str(1, string.upper(str[1]))
end



---把字符串的字符随机打乱
--@string   str     字符串
--@usage
--string.shuffle("abc") => cab
function string.shuffle(str)
    local temp = ''
    local length = string.len(str)
    local ran1, ran2 = 0, 0
    math.randomseed(os.time())

    for i = 1, length , 1 do
        ran1 = math.random(length)
        ran2 = math.random(length)
        temp = str[ran1]
        str = str(ran1, str[ran2])
        str = str(ran2, temp)
    end

    return str
end



---Converts the given integer value into a binary string of length limit
---If limit is omitted, then a binary string of length 8 is returned
function dectobin(dec, limit)
    if (limit == '' or limit == nil) then
        limit = 8
    end

    local bin = ''
    local rem = 0

    for i = 1, dec, 1 do
        rem = dec % 2
        dec = dec - rem
        bin = rem .. bin
        dec = dec / 2
        if (dec <= 0) then break end
    end

    local padding = limit - (string.len(bin) % limit)
    if (padding ~= limit) then
        bin = string.insertRep(bin, '0', padding, 0)
    end

    return bin
end



---Returns the uuencoded representation of the given string
function string.uuencode(str)
    local padding = 3 - (string.len(str) % 3)
    if (padding ~= 3) then
        str = string.insertRep(str, string.char(1), padding, string.len(str))
    end

    local uuenc = ''
    local bin1, bin2, bin3, binall = '', '', '', ''

    for i = 1, string.len(str) - 2, 3 do
        bin1 = dectobin(string.byte(str[i]), 8)
        bin2 = dectobin(string.byte(str[i+1]), 8)
        bin3 = dectobin(string.byte(str[i+2]), 8)

        binall = bin1 .. bin2 .. bin3

        uuenc = uuenc .. string.char(tonumber(binall(1,6), 2) + 32)
        uuenc = uuenc .. string.char(tonumber(binall(7,12), 2) + 32)
        uuenc = uuenc .. string.char(tonumber(binall(13,18), 2) + 32)
        uuenc = uuenc .. string.char(tonumber(binall(19,24), 2) + 32)
    end

    return uuenc
end



---Returns the actual string from a uuencoded string
function string.uudecode(str)
    local padding = 4 - (string.len(str) % 4)
    if (padding ~= 4) then
        str = string.insertRep(str, string.char(1), padding, string.len(str))
    end

    local uudec = ''
    local bin1, bin2, bin3, bin4, binall = '', '', '', '', ''

    for i = 1, string.len(str) - 3, 4 do
        bin1 = dectobin(string.byte(str[i]) - 32, 6)
        bin2 = dectobin(string.byte(str[i+1]) - 32, 6)
        bin3 = dectobin(string.byte(str[i+2]) - 32, 6)
        bin4 = dectobin(string.byte(str[i+3]) - 32, 6)

        binall = bin1 .. bin2 .. bin3 .. bin4

        uudec = uudec .. string.char(tonumber(binall(1,8), 2))
        uudec = uudec .. string.char(tonumber(binall(9,16), 2))
        uudec = uudec .. string.char(tonumber(binall(17,24), 2))
    end

    return string.trim(uudec, string.char(1))
end



---Returns a simple hash key for a string. If the check value is ommited
---then the string is hashed by the prime value of 17
---Best results occur when the check value is prime
function string.hash(str, check)
    local sum = 0
    local checksum = 17
    local length = string.len(str)

    if (check ~= '' and check ~= nil) then checksum = check end

    sum = str(1) + 1
    sum = sum + str(length) + length
    sum = sum + str(length/2) + math.ceil(length/2)

    return sum % checksum
end

---url字符转换
function string.urlencodeChar(char)
    return "%" .. string.format("%02X", string.byte(char))
end

---url字符转换
function string.urlencode(str)
    --convert line endings
    str = string.gsub(tostring(str), "\n", "\r\n")
    --escape all characters but alphanumeric, '.' and '-'
    str = string.gsub(str, "([^%w%.%- ])", string.urlencodeChar)
    --convert spaces to "+" symbols
    return string.gsub(str, " ", "+")
end

function string.ltrim(str)
    return string.gsub(str, "^[ \t\n\r]+", "")
end

function string.rtrim(str)
    return string.gsub(str, "[ \t\n\r]+$", "")
end

function string.trim(str)
    str = string.gsub(str, "^[ \t\n\r]+", "")
    return string.gsub(str, "[ \t\n\r]+$", "")
end

---检测手机号码是否正确
function string.isPoneNum( PhoneNumText )
    local phoneNum = string.trim(PhoneNumText);
    local start, length = string.find(phoneNum, "^1[3|4|5|8|7][0-9]%d+$"); --判断手机号码是否正确
    if start ~= nil and length == 11 then
        return true ;
    end
    return false;
end

---计算文字utf8的长度
function string.utf8len(str)
    local len = #str
    local left = len
    local cnt = 0
    local arr = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc }
    while left > 0 do
        local tmp = string.byte(str, -left)
        local i = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

---按照utf8格式取子串
function string.utf8SubStr(str,subLen)
    local len = #str
    local left = len
    local cnt = 0
    local arr = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc }
    while left > 0 do
        local tmp = string.byte(str, -left)
        local i = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
        if cnt >= subLen then
            break;
        end
    end
    local temp = string.sub(str,0,len - left);
    return temp
end

--- 拆分出单个字符
function string.cutTextToTable(str)
    local list = {}
    local len = string.len(str)
    local i = 1
    while i <= len do
        local c = string.byte(str, i)
        local shift = 1
        if c > 0 and c <= 127 then
            shift = 1
        elseif (c >= 192 and c <= 223) then
            shift = 2
        elseif (c >= 224 and c <= 239) then
            shift = 3
        elseif (c >= 240 and c <= 247) then
            shift = 4
        end
        local char = string.sub(str, i, i+shift-1)
        i = i + shift
        table.insert(list, char)
    end
    return list, len
end


--- 按字母或者汉字拆分(例如，12个字母 6个汉字)
function string.subStrByTypes (str, chineseLen, characterLen)
    if not characterLen then
        characterLen = chineseLen * 2;
    end

    --计算一个汉字相对于英文字符是几个
    local exchange = characterLen /chineseLen;

    local list,len = string.cutTextToTable(str);
    local str = "";
    for i,v in ipairs(list) do
        local _, nvow = string.gsub(v, "[%a%d%p]", "")
        --是字母
        if nvow == 1 then
            characterLen = characterLen - 1;
        else
            characterLen = characterLen - exchange;
        end
        str = str ..  v;
        if  characterLen < 0 then
            return str;
        end
    end

    return str;
end


