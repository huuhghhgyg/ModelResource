-- Subplot.lua 子图

scene.setenv({camtype = "ortho"}) --设置场景

function Subplot(row, col, ...)
    local subplot = {
        span = 10,
        diag = {-80, -70, 80, 70},
        originpt = {}, --存放各行列点坐标
        psize = {} --子图大小
    }
    subplot.row, subplot.col = row, col

    -- 导入参数和fallback
    if ... ~= nil then
        for k, v in pairs(...) do
            subplot[k] = v
        end
    end
    
    function subplot:refresh()
        -- 计算参数
        subplot.psize = {
            (subplot.diag[3]-subplot.diag[1] - (subplot.col-1)*subplot.span)/subplot.col,
            (subplot.diag[4]-subplot.diag[2] - (subplot.row-1)*subplot.span)/subplot.row
        }
        local gwidth, gheight = subplot.psize[1]+subplot.span, subplot.psize[2]+subplot.span
    
        -- 重新计算originpt
        subplot.originpt = {}
        for i = 1, subplot.row do
            subplot.originpt[i]={}
            for j = 1, subplot.col do
                subplot.originpt[i][j] = {subplot.diag[1]+(j-1)*gwidth, subplot.diag[2]+(i-1)*gheight}
            end
        end
    end
    
    subplot:refresh()
    return subplot
end