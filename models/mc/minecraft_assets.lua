scene.setenv({grid='plane'})

-- Agents
local steve = scene.addobj('steve.glb')
local villager = scene.addobj('villager.glb')
local witch = scene.addobj('witch.glb')
local snowman = scene.addobj('snow_golem.glb')
villager:setpos(2, 0, 0)
witch:setpos(4, 0, 0)
snowman:setpos(6, 0, 0)

-- Stations
local chest = scene.addobj('chest.glb')
local chest_large = scene.addobj('chest_large.glb')
local table = scene.addobj('table.glb')
local table_large = scene.addobj('table_large.glb')
chest:setpos(0, 0, 2)
chest_large:setpos(2, 0, 2)
table:setpos(4, 0, 2)
table_large:setpos(6, 0, 2)

-- Items
local apple = scene.addobj('apple.glb')
local gold = scene.addobj('gold_ingot.glb')
apple:setpos(0, 0, 3)
gold:setpos(0.5, 0, 3)

-- Set environment
local cam = scene.getobj('camera')
cam:setpos(8, 4, 8)

scene.render()