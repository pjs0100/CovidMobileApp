-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library

local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local stateGroup = {}
local playBtn
local textCap = ""
local confirmCap
local deathCap
local defaultField



local function onPlayBtnRelease()
	local options = { 
      effect = "fade",
      time = 500,
      params = {
      	textCap = textCap,
      	confirmCap = confirmCap,
      	deathCap = deathCap,
      }
  }
	-- go to level1.lua scene
	composer.gotoScene( "level1", options )
	
	return true	-- indicates successful touch
end


function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	

	local background = display.newImageRect( "background2.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY
	sceneGroup:insert( background )

	playBtn = widget.newButton{
		label="Back",
		defaultColor = {0,0,0,255},
		labelColor = { default={0,0,0,255}, over={0,0,0,128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn.x = display.contentCenterX-80
	playBtn.y = display.contentHeight - 470

	sceneGroup:insert(playBtn)

	local optionsTitle = display.newText("Options", display.contentCenterX, display.contentCenterY-150)
	optionsTitle:setFillColor(0,0,0)
	
	local textTitle = display.newText("State Name", display.contentCenterX, display.contentCenterY-30)

	
	local function textListener( event )
	
	if( event.phase== "editing" ) then
		
			textCap = string.lower(event.text)
		end
			
	
		end
		--Create text field
	defaultField= native.newTextField( display.contentCenterX, display.contentCenterY-10, 100, 15 )
	defaultField:addEventListener( "userInput", textListener)

	sceneGroup:insert(defaultField)
	sceneGroup:insert(textTitle)
	sceneGroup:insert(optionsTitle)


	
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		--defaultField.alpha = 1
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	
	
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	
		
	elseif phase == "did" then
		-- Called when the scene is now off screen
		--defaultField.alpha = 0
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
	if defaultField then
		defaultField:removeSelf()	-- widgets must be manually removed
		defaultField = nil
	end
	local sceneGroup = self.view
	
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene