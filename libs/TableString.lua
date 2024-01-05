function TableString(t)
    -- 非table类型直接返回
    if type(t) ~= 'table' then
        return tostring(t)
    end

    -- 剩下table类型
    local str = '{'
    for k, v in ipairs(t) do
        -- print('detecting table'..k,'str='..str)
        if type(v) == 'table' then
            str = str .. TableString(v)
        else
            str = str .. v
        end

        if k < #t then
            str = str .. ', '
        end
    end
    str = str .. '}'

    return str
end

-- 示例代码
-- local collection = {'a',{1,2},{'hi', {'Anna', 'Bell'}},{{'x','y','z'},{1,2,3}}}
-- print(TableString(collection))
-- print(TableString('a'))
-- print(TableString(2))
-- print(TableString({}))