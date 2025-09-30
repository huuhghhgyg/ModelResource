-- t: table
-- level: 最大显示table层级。不输入时处理为math.huge，即展开所有层级
function tablestr(t, level)
    function resolve_table(t, queue)
        -- 假设table已经被取出来了
        local q = {}

        for k, v in pairs(t) do
            table.insert(q, { key = k, value = v })
        end

        for i = 1, #q do
            table.insert(queue, i, q[i])
        end
    end

    -- 非table类型直接返回
    if type(t) ~= 'table' then
        return tostring(t)
    end

    -- 检查level类型
    if level == nil then
        level = math.huge
    elseif type(level) ~= "number" then
        print(debug.traceback('TableString: level must be a number'))
        os.exit()
    elseif level < 0 then
        print(debug.traceback('TableString: level must be a positive number'))
        os.exit()
    end

    -- 剩下table类型
    local str = ''

    -- 解析队列
    -- 把根表用大括号包起来，确保根级别也有正确的 '{' / '}' 标记
    local queue = { { key = 0, value = t } } -- {str：'{','}'；tuple:{key,value}}
    local lv_stack = 0

    while #queue > 0 do
        -- queue中只有括号string和tuple table
        if type(queue[1]) == 'string' then
            local mark = table.remove(queue, 1) -- 标记
            str = str .. mark

            -- 通过标记类型设置当前stack level
            if mark == '{' then
                lv_stack = lv_stack + 1
            elseif mark == '}' then
                lv_stack = lv_stack - 1
            end
        elseif type(queue[1]) == 'table' then
            -- tuple table
            local tup = table.remove(queue, 1)
            local key = tup.key
            local value = tup.value

            -- 处理key
            if type(key) == 'number' then
                key = ''
            else
                key = key .. '='
            end

            -- 处理value
            if type(value) == 'table' then
                -- 解析table
                table.insert(queue, 1, '}')
                if lv_stack >= level then
                    table.insert(queue, 1, '...')
                else
                    resolve_table(value, queue)
                end
                table.insert(queue, 1, '{')
                str = str .. key
            else
                -- 解析其他容易解析的数据类型
                if type(value) == 'function' then
                    value = 'function()'
                elseif type(value) == 'string' then
                    value = "'" .. value .. "'"
                end

                -- 其他可以被直接转化的值
                str = str .. key .. value
            end
        else
            print('unexpected type:', type(key))
        end

        if #queue > 1 and queue[1] ~= '{' and queue[1] ~= '}' and string.sub(str, -1) ~= '{' then
            str = str .. ', '
        end
    end

    return str
end

-- 示例代码
-- print()
-- local collection = { 'a', { 1, 2 }, { 'hi', { 'Anna', 'Bell', name = 'AnnaBell' } }, { { 'x', 'y', 'z' }, { 1, 2, 3 } } }
-- local collection = {a='1',b='2', 'x', 'y', 'z', f=function() print('hi') end}
-- local collection = {1,2,3}
-- local collection = { a = { x = 1 } }
-- local collection = { a = { x = 1 }, b = { y = 2 } }
-- local collection = {
--     { desc = "plain brace string", t = { "}" } },
--     { desc = "brace as value and keyed", t = { "}", a = "}" } },
--     { desc = "ellipsis string", t = { "...", nested = { "..." } } },
--     { desc = "mixed", t = { "{", "}", "...", a = "{", b = "}" } },
-- }
-- print(tablestr(collection))

-- print(tablestr('a'))
-- print(tablestr(2))
-- print(tablestr({}))
