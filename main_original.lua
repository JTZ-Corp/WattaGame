local composer = require( "composer" )
local scene = composer.newScene()

local mainGroup
local backGroup
local uiGroup

--global variables
local angle
local deltaX
local deltaY
local gravity = 9.8

--load background
local background
--tap count
local tapCount = 0
local tapText
--load platform
--local platform = display.newImageRect("platform.png", 300, 50)
--platform.x = display.contentCenterX
--platform.y = display.contentHeight - 25

--load balloon
local balloon

--borders
local border
local border2

--load physics
local math, physics = require("math"), require("physics")
physics.start()
--physics.setGravity(0, gravity)

function startPhysics( start )
	if (start) then
		physics.addBody(balloon, "dynamic", { radius = 54, bounce = 0.3})
		physics.addBody(border, "static")
		physics.addBody(border2, "static")
	end
end

--add physics to objects
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

--SCENES
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	physics.pause()

	backGroup = display.newGroup()
	sceneGroup:insert( backGroup )

	mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )

	uiGroup = display.newGroup()
	sceneGroup:insert( uiGroup )

	background = display.newImageRect(backGroup, "background_2.png", 360,580)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	balloon = display.newImageRect(mainGroup, "basketball.png", 112, 112)
	balloon.x = display.contentCenterX
	balloon.y = display.contentCenterY
	balloon.alpha = 0.8

--borders
	border = display.newImageRect(backGroup, "border.png", 1, 1000)
	border.x = 0
	border.y = display.contentCenterY

	border2 = display.newImageRect(backGroup, "border.png", 1, 1000)
	border.x = display.contentWidth
	border.y = display.contentCenterY

	tapText = display.newText(uiGroup, tapCount, display.contentCenterX, 20, native.systemFont, 40)
	tapText:setFillColor(0 ,0, 0)

	balloon:addEventListener("touch", pushBalloon)
end

local function endGame()
	composer.removeScene( "menu" )
	local options = { effect = "crossFade", time = 800, params = { fromScene = "main_original"} }
	composer.gotoScene( "menu", options )
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start();
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		physics.pause()
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end

local function gotoGame( )
	composer.gotoScene("game")
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
