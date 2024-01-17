# 函数库

MicroCity Web 中在线导入使用方法

```lua
-- 1.下载函数库到虚拟磁盘
print('正在下载依赖库到虚拟磁盘...')
os.upload('https://www.zhhuu.top/ModelResource/libs/文件名.lua')
print('下载完成')
-- 2.引用库
require('文件名')
```

绘图函数的详细介绍请参考 [MicroCity笔记 - 通用绘图代码](https://www.zhhuu.top/MicroCityNotes/notes/plots.html)
- `Histogram.lua`
- `Subplot.lua`