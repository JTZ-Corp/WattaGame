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

--load ball
local ball
local ball2

--borders
local border
local border2

--horizontal
local horizontal

--load physics
local math, physics = require("math"), require("physics")
--physics.start()
--physics.setGravity(0, gravity)

function startPhysics( start )
	if (start) then
		physics.addBody(ball, "dynamic", { radius = 38, bounce = 0.3})
		physics.addBody(border, "static")
		physics.addBody(border2, "static")
		physics.addBody(horizontal, "static")
	end
end

function addBall( )
	ball2 = display.newImageRect(mainGroup, "basketball.png", 75, 75)
	ball2.myName = "ball2"
	ball2.x = display.contentCenterX 
	ball2.y = display.contentCenterY - 200
	ball2.alpha = 0.8

	physics.addBody(ball2, "dynamic", { radius = 35, bounce = 0.3})
	ball2:addEventListener("touch", pushBall2)
end

--add physics to objects
--physics.addBody(platform, "static")
--physics.addBody(balloon, "dynamic", { radius = 54, bounce = 0.3})
--physics.addBody(border, "static")
--physics.addBody(border2, "static")

local function pushBall( event )
	startPhysics(true)

	if (event.phase == "began") then
		deltaX = event.x - ball.x
		deltaY = event.y - ball.y
		normDeltaX = deltaX / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))
		normDeltaY = deltaY / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))

		angle = math.atan2( deltaY, deltaX ) * 180 / math.pi

		ball:applyLinearImpulse( normDeltaX * -0.5, normDeltaY * -0.5, ball.x, ball.y )

		tapCount = tapCount +1
		tapText.text = tapCount

		if (gravity <= 25 and (tapCount % 5 == 0)) then
			gravity = gravity + .20
			physics.setGravity(0, gravity)
			print(gravity)
		end

		if (tapCount == 10) then
			addBall() 
		end
	end
end

function pushBall2( event )
	--startPhysics(true)

	if (event.phase == "began") then
		deltaX = event.x - ball2.x
		deltaY = event.y - ball2.y
		normDeltaX = deltaX / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))
		normDeltaY = deltaY / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))

		angle = math.atan2( deltaY, deltaX ) * 180 / math.pi

		ball2:applyLinearImpulse( normDeltaX * -0.5, normDeltaY * -0.5, ball2.x, ball2.y )

		tapCount = tapCount +1
		tapText.text = tapCount

		if (gravity <= 25 and (tapCount % 5 == 0)) then
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
	--physics.pause()

	backGroup = display.newGroup()
	sceneGroup:insert( backGroup )

	mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )

	uiGroup = display.newGroup()
	sceneGroup:insert( uiGroup )

	background = display.newImageRect(backGroup, "background_2.png", 360,580)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	ball = display.newImageRect(mainGroup, "basketball.png", 75, 75)
	ball.myName = "ball"
	ball.x = display.contentCenterX
	ball.y = display.contentCenterY
	ball.alpha = 0.8

--borders
	border = display.newImageRect(backGroup, "border.png", 1, 1000)
	border.x = 0
	border.y = display.contentCenterY

	border2 = display.newImageRect(backGroup, "border.png", 1, 1000)
	border.x = display.contentWidth
	border.y = display.contentCenterY

	horizontal = display.newImageRect(backGroup, "horizontal.png", 1000, 1)
	horizontal.myName = "horizontal"
	horizontal.x = display.contentWidth
	horizontal.y = display.contentHeight + 100

	tapText = display.newText(uiGroup, tapCount, display.contentCenterX, 20, native.systemFont, 40)
	tapText:setFillColor(0 ,0, 0)
end

local function onCollision( event )
	if ( event.phase == "began" ) then
		local obj1 = event.object1
		local obj2 = event.object2

		--print(obj1.myName .. obj2.myName)

		if ((obj1.myName == "horizontal" and obj2.myName == "ball") or
			(obj1.myName == "horizontal" and obj2.myName == "ball2")) then
			display.remove(obj2)
			endGame()
		end
	end
end


function endGame()
	composer.removeScene( "menu" )
	composer.gotoScene( "menu", {time=800, effect="crossFade"} )
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
		Runtime:addEventListener("collision", onCollision )
		ball:addEventListener("touch", pushBall)
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
		Runtime:removeEventListener("collision", onCollision )
		physics.pause()
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

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
