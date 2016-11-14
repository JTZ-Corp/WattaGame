local composer = require( "composer" )

display.setStatusBar( display.HiddenStatusBar )

math.randomseed( os.time() )

--goto menu scene
composer.gotoScene( "menu" )