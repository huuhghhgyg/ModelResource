-- Histogram.lua 直方图
-- data: 数据集合
-- range: {lb, ub} 值范围
-- bins: 分箱数
-- plotorigin: {x, y} 绘图原点(左下角)
-- plotsize: {width, height} 绘图区域大小
-- plotscale: {xscale, yscale} 分度值大小
-- axes: 坐标轴点对象。1为x轴, 2为y轴
-- coord: 坐标轴

-- 初始场景设置
scene.setenv({
    camtype = "ortho"
})

-- 返回一个直方图对象
function Histogram(data, ...)
    local plot = {
        -- 默认值设置
        origin = {-50, -50}, -- 坐标原点坐标
        size = {100, 100}, -- 坐标轴长度
        scale = {3, 2}, -- 坐标轴刻度分度值
        range = {0, 10, 0, 20}, -- xy轴范围
        axislabel = {"x", "y"},
        filled = true, -- 是否填充
        fdisp = function(v) -- 数据标签显示
            return v
        end
    }
    -- 导入参数和fallback
    if ... ~= nil then
        for k, v in pairs(...) do
            plot[k] = v
        end
    end

    local barShape = "polygon"
    if plot.filled == false then
        barShape = "polyline"
    end

    -- 初始化
    plot.axes = {} -- 坐标轴
    plot.originlabel = {} -- 零点可能存在双坐标
    plot.bars = {} -- 数据条
    plot.xvalue = {} -- x轴刻度值(不包括最小值)
    plot.data = data

    function plot:deldata() -- 删除数据(private)
        if #plot.bars == 0 then
            return
        end

        for i = #plot.bars, 1, -1 do
            -- print("plot.bar:",i)
            plot.bars[i][2]:delete()
            plot.bars[i][1]:delete()
        end

        plot.zero:delete()
        for i = #plot.originlabel, 1, -1 do
            plot.originlabel[i]:delete()
        end

        for i = #plot.axes, 1, -1 do
            for j = #plot.axes[i], 1, -1 do
                plot.axes[i][j][2]:delete()
                plot.axes[i][j][1]:delete()
            end
        end
    end

    function plot:refresh() -- 反复绘图时调用(public)
        plot:deldata()

        -- 计算坐标刻度参数
        local xmax = math.max(math.max(table.unpack(plot.data)), plot.range[2])
        local xmin = math.min(math.min(table.unpack(plot.data)), plot.range[1])
        local valueRange = xmax - xmin
        plot.range[1], plot.range[2] = xmin, xmax

        -- 绘图值统计
        local barData = {}
        for i = 1, #data do -- 深拷贝
            table.insert(barData, data[i])
        end
        plot.barValue = {}

        -- 绘制零点
        plot.zero = scene.addobj("points", {
            vertices = {plot.origin[1], plot.origin[2], 0},
            size = 10
        })
        if plot.range[1] == plot.range[3] then -- 都是0
            plot.originlabel[1] = scene.addobj("label", {
                text = plot.range[1],
                size = 4
            })
            plot.originlabel[1]:setpos(plot.origin[1] - 4, plot.origin[2] - 4, 0)
        else
            plot.originlabel[1] = scene.addobj("label", {
                text = plot.range[1],
                size = 4
            })
            plot.originlabel[1]:setpos(plot.origin[1], plot.origin[2] - 4, 0)
            plot.originlabel[2] = scene.addobj("label", {
                text = plot.range[3],
                size = 4
            })
            plot.originlabel[2]:setpos(plot.origin[1] - 4, plot.origin[2], 0)
        end

        -- X坐标刻度
        local xaxis = {} -- x坐标轴对象，其中元素为{point，label}
        for j = 1, (plot.range[2] - plot.range[1]) / plot.scale[1] do -- 第几个刻度
            local xpt = plot.origin[1] + j * plot.size[1] / (plot.range[2] - plot.range[1]) * plot.scale[1] -- X刻度位置
            local pt = scene.addobj("points", {
                vertices = {xpt, plot.origin[2], 0},
                size = 5
            }) -- 刻度点
            local label = scene.addobj("label", {
                text = string.format("%.1f", plot.range[1] + j * plot.scale[1]),
                size = 4
            }) -- 刻度标签
            table.insert(plot.xvalue, plot.range[1] + j * plot.scale[1]) -- 当前x刻度值
            label:setpos(xpt, plot.origin[2] - 4, 0)
            xaxis[j] = {pt, label} -- 对象加入x轴集合
        end
        plot.axes[1] = xaxis

        for i = 1, #plot.axes[1] do -- 根据x轴分值
            local ub = plot.xvalue[i] -- 本次循环最大值
            -- print("循环", i, "ub=", ub) -- for debug

            local value = 0
            for j = #barData, 1, -1 do
                if barData[j] <= ub then
                    value = value + 1
                    table.remove(barData, j)
                end
            end
            plot.barValue[i] = value -- 录入值
        end
        local ymax = math.max(table.unpack(plot.barValue))
        plot.range[4] = math.max(ymax, plot.range[4])

        -- Y坐标刻度
        local yaxis = {} -- y坐标轴对象，其中元素为{point，label}
        for i = 1, (plot.range[4] - plot.range[3]) / plot.scale[2] do -- 第几个刻度
            local ypt = plot.origin[2] + i * plot.size[2] / (plot.range[4] - plot.range[3]) * plot.scale[2] -- Y刻度位置
            local pt = scene.addobj("points", {
                vertices = {plot.origin[1], ypt, 0},
                size = 5
            }) -- 刻度点
            local label = scene.addobj("label", {
                text = plot.fdisp(plot.range[3] + i * plot.scale[2]),
                size = 4
            }) -- 刻度标签
            label:setpos(plot.origin[1] - 4, ypt, 0)
            yaxis[i] = {pt, label}
        end
        plot.axes[2] = yaxis

        -- 绘制数据
        local xunit = plot.size[1] / (plot.range[2] - plot.range[1]) * #plot.axes[1] -- x轴分度值
        local yunit = plot.size[2] / (plot.range[4] - plot.range[3]) -- y轴分度值

        -- 根据数值绘制直方图
        for i = 1, #plot.axes[1] do
            -- 绘图
            local xl = plot.origin[1] + (i - 1) * plot.size[1] / (plot.range[2] - plot.range[1]) * plot.scale[1]
            local xr = plot.origin[1] + i * plot.size[1] / (plot.range[2] - plot.range[1]) * plot.scale[1]
            local yb, yt = plot.origin[2], plot.origin[2] + plot.barValue[i] * yunit
            local bar = scene.addobj(barShape, {
                vertices = {xl, yb, 0, xr, yb, 0, xr, yt, 0, xl, yt, 0, xl, yb, 0}
            })
            local label = scene.addobj("label", {
                text = plot.fdisp(plot.barValue[i]),
                size = 4
            })
            label:setpos((xl + xr) / 2, yt + 2, 0)
            plot.bars[i] = {bar, label}
        end
    end

    function plot:draw() -- 初始化绘制
        -- 坐标轴对象
        plot.coord = scene.addobj("polyline", {
            vertices = {plot.origin[1] + plot.size[1], plot.origin[2], 0, plot.origin[1], plot.origin[2], 0,
                        plot.origin[1], plot.origin[2] + plot.size[2], 0}
        })
        -- 坐标轴标题
        if plot.axislabel ~= nil then
            plot.axislabel[1] = scene.addobj("label", {
                text = plot.axislabel[1],
                size = 4
            })
            plot.axislabel[1]:setpos(plot.origin[1] + plot.size[1], plot.origin[2] - 8, 0)
            plot.axislabel[2] = scene.addobj("label", {
                text = plot.axislabel[2],
                size = 4
            })
            plot.axislabel[2]:setpos(plot.origin[1] - 4, plot.origin[2] + plot.size[2] + 6, 0)
            plot.axislabel[2]:setrot(0, 0, 1)
        end
    end

    plot:draw()
    plot:refresh()
    scene.render()
    return plot
end
