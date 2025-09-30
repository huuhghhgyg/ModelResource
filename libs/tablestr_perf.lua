-- t: table
-- level: 最大显示table层级。不输入时处理为math.huge，即展开所有层级
function tablestr(t, level)
    local function resolve_table(t, queue)
        -- 假设table已经被取出来了
        local q = {}

        for k, v in pairs(t) do
            q[#q + 1] = { key = k, value = v }
        end

        -- 以栈（尾部）方式插入：为了保证弹出顺序与原先一致，这里逆序追加
        for i = #q, 1, -1 do
            queue[#queue + 1] = q[i]
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
    local queue = { { key = 0, value = t } } -- {str：'{','}'；tuple:{key,value}}
    local lv_stack = 0

    while #queue > 0 do
        local item = table.remove(queue) -- 尾部弹出

        if type(item) == 'string' then
            local mark = item
            str = str .. mark

            -- 通过标记类型设置当前stack level
            if mark == '{' then
                lv_stack = lv_stack + 1
            elseif mark == '}' then
                lv_stack = lv_stack - 1
            end
        elseif type(item) == 'table' then
            -- tuple table
            local tup = item
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
                -- 使用栈（尾部）顺序压入：先压 '}' ，然后压入子项（resolve_table 已逆序），最后压入 '{'，保证下一个弹出是 '{'
                queue[#queue + 1] = '}'
                if lv_stack >= level then
                    queue[#queue + 1] = '...'
                else
                    resolve_table(value, queue)
                end
                queue[#queue + 1] = '{'
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
            print('unexpected type:', type(item))
        end

        -- 下一个将要处理的项是栈顶：使用 #queue 和 queue[#queue] 检查
        if #queue > 0 and queue[#queue] ~= '{' and queue[#queue] ~= '}' and string.sub(str, -1) ~= '{' then
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
