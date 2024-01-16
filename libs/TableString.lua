function TableString(t)
    -- 非table类型直接返回
    if type(t) ~= 'table' then
        return tostring(t)
    end

    -- 剩下table类型
    local str = '{'

    -- 迭代table中的内容
    local keys = 0
    local indices = 0
    for k, v in pairs(t) do
        if type(k) == 'number' then
            -- 键值为index
            if type(v) == 'table' then
                str = str .. TableString(v)
            else
                str = str .. v
            end
            indices = indices + 1
        else
            -- 键值为key
            if type(v) == 'table' then
                str = str .. k .. '=' .. TableString(v)
            else
                str = str .. k .. '=' .. v
            end
            keys = keys + 1
        end

        str = str .. ', '
    end

    if indices + keys > 0 then
        str = string.sub(str, 1, -3)
    end

    str = str .. '}'

    return str
end

-- 示例代码
-- local collection = {'a',{1,2},{'hi', {'Anna', 'Bell', name='AnnaBell'}},{{'x','y','z'},{1,2,3}}}
-- local collection = {a='1',b='2', 'x', 'y', 'z'}
-- local collection = {1,2,3}
-- print(TableString('a'))
-- print(TableString(2))
-- print(TableString({}))

-- print(TableString(collection))