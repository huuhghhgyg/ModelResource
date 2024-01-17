-- setpoint(x, y, z, [{color=, size=, text=}])
function setpoint(x, y, z, config)
    -- 处理参数
    if type(config) ~= "table" then
        config = {}
    end
    local color = config.color or 'blue'
    local size = config.size or 5
    local text = config.text or ''

    local obj = {
        point = scene.addobj('points', {
            vertices = {x, y, z},
            color = color,
            size = size
        }),
        label = scene.addobj('label', {
            text = text .. '(' .. x .. ',' .. y .. ',' .. z .. ')'
        })
    }
    obj.label:setpos(x, y, z)

    return obj
end