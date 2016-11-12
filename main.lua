--global variables
local angle
local deltaX
local deltaY
local gravity = 9.8

--load background
local background = display.newImageRect("background.png", 360,580)
background.x = display.contentCenterX
background.y = display.contentCenterY

--tap count
local tapCount = 0
local tapText = display.newText(tapCount, display.contentCenterX, 20, native.systemFont, 40)
tapText:setFillColor(0 ,0, 0)

--load platform
--local platform = display.newImageRect("platform.png", 300, 50)
--platform.x = display.contentCenterX
--platform.y = display.contentHeight - 25

--load balloon
local balloon = display.newImageRect("basketball.png", 112, 112)
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY
balloon.alpha = 0.8

--borders
local border = display.newImageRect("border.png", 1, 1000)
border.x = 0
border.y = display.contentCenterY

local border2 = display.newImageRect("border.png", 1, 1000)
border.x = display.contentWidth
border.y = display.contentCenterY

--load physics
local math, physics = require("math"), require("physics")
--physics.start()
--physics.setGravity(0, gravity)

function startPhysics( start )
	if (start) then
		physics.start()
		physics.addBody(balloon, "dynamic", { radius = 54, bounce = 0.3})
		physics.addBody(border, "static")
		physics.addBody(border2, "static")

		print("ted")
	end
end

--add phydics to objects
--physics.addBody(platform, "static")
--physics.addBody(balloon, "dynamic", { radius = 54, bounce = 0.3})
--physics.addBody(border, "static")
--physics.addBody(border2, "static")

local function pushBalloon( event )
	startPhysics(true)

	if (event.phase == "began") then
		deltaX = event.x - balloon.x
		deltaY = event.y - balloon.y
		normDeltaX = deltaX / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))
		normDeltaY = deltaY / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))

		angle = math.atan2( deltaY, deltaX ) * 180 / math.pi

		balloon:applyLinearImpulse( normDeltaX * -1, normDeltaY * -1, balloon.x, balloon.y )

		tapCount = tapCount +1
		tapText.text = tapCount

		if (gravity <= 25) then
			gravity = gravity + .20
			physics.setGravity(0, gravity)
			print(gravity)
		end
	end
end

balloon:addEventListener("touch", pushBalloon)
