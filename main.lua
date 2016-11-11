--load background
local background = display.newImageRect("background.png", 360,580)
background.x = display.contentCenterX
background.y = display.contentCenterY

--tap count
local tapCount = 0
local tapText = display.newText(tapCount, display.contentCenterX, 20, native.systemFont, 40)
tapText:setFillColor(0 ,0, 0)

--load platform
local platform = display.newImageRect("platform.png", 300, 50)
platform.x = display.contentCenterX
platform.y = display.contentHeight - 25

--load balloon
local balloon = display.newImageRect("balloon.png", 112, 112)
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY
balloon.alpha = 0.8

--load physics
local physics = require("physics")
physics.start()
physics.setGravity(0, 9.8)

--add phydics to objects
physics.addBody(platform, "static")
physics.addBody(balloon, "dynamic", { radius = 49, bounce = 0.3})

local function pushBalloon()
	balloon:applyLinearImpulse(0, -0.5, balloon.x, balloon.y)
	tapCount = tapCount + 1
	tapText.text = tapCount
end

background:addEventListener("tap", pushBalloon)
