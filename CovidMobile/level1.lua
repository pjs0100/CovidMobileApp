-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
local state = require("state")
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local stateGroup = {}
local playBtn
local optBtn

local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	composer.gotoScene( "menu", "fade", 500 )
	
	return true	-- indicates successful touch
end

local function onOptBtnRelease()
	
	-- go to level1.lua scene
	composer.gotoScene( "options", "fade", 500 )
	
	return true	-- indicates successful touch
end

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view
	physics.start()
	physics.pause()
	

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

	optBtn = widget.newButton{
		label="Options",
		defaultColor = {0,0,0,255},
		labelColor = { default={0,0,0,255}, over={0,0,0,128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onOptBtnRelease	-- event listener function
	}
	optBtn.x = display.contentCenterX + 80
	optBtn.y = display.contentHeight - 470

	sceneGroup:insert(optBtn)

	local stateText = display.newText("", display.contentCenterX, display.contentHeight *(29/30))
	stateText:setFillColor(0,0,0, 1)
	stateText:scale(0.5, 1)
	sceneGroup:insert(stateText)

	local tIndex = 0
	local lIndex = 2
	local csv = require("csv")
	local f = csv.open(system.pathForFile( "states.csv", system.ResourceDirectory))
	for fields in f:lines() do
  		local group = display.newGroup()
  		group.id = 2
  		--group.statevisibilitySlide = 1
  		--group.statevisibilityText = 1
  		for i, v in ipairs(fields) do
  			if (v == "Province_State") or (v == "American Samoa") or (v == "Diamond Princess") or (v == "District of Columbia") or (v == "Grand Princess") or (v == "Guam") or (v == "Northern Mariana Islands") or (v == "Puerto Rico") or (v == "Recovered") or (v == "Virgin Islands") then
		  		group.id = 1
		  		break	
		  	end
		  	if i == 1 then
		  		tIndex = tIndex + 1
		  		group.tIndex = tIndex
		  		if ((tIndex%5)==0) then
		  			lIndex =lIndex + 1
		  		end
		  		if (tIndex == 50) then
		  			tIndex = 5
		  			lIndex = 2
		  		end
		  		group.name = v
		  		--print(group.name)
		  		--print(tIndex)
		  		--print(lIndex)
		  	end
		  	if i == 6 then
		  		group.confirmed = tonumber(v)
		  	end
		  	if i == 7 then
		  		group.deaths = tonumber(v)
		  	end
		  	if i == 11 then
		  		group.inc = tonumber(v)
		  	end
		  	if i == 14 then
		  		group.mort = tonumber(v)
		  	end
		  	--print(i, v)
		  	
		  end
		  
		  
		  if group.id ~= 1 then
		  	local newState = state:new({id = tIndex, name = group.name, xPos = screenW *((tIndex%5)+1)/6, yPos = screenH*(lIndex)/14, confirmed = group.confirmed, deaths = group.deaths, mortrate = group.mort, incidentrate = group.inc})
		  	function newState:touch( event )
		  		stateText.text = self.name.." ".."Confirmed cases: "..self.confirmed.." ".."Deaths: "..self.deaths.." ".."Mortality Rate: "..self.mortrate
		  		--print(stateText)
		  		--print("here")
		  	end
		  	table.insert(group, newState)
		  	group.newState = newState
		  	local heart = newState:spawn()
		  	heart:addEventListener("touch", newState)
		  	--physics.addBody(heart, "dynamic")
		  	
		  	group.heart = heart
		  	group:insert(heart)
		  	table.insert(stateGroup, group);
		  end
		 

		end

		for _, group in ipairs(stateGroup) do
		  	
		  	sceneGroup:insert(group.heart)
		end



	
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		composer.removeScene( "options" )
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
		for _, group in ipairs(stateGroup) do
		  	
		  	group.heart:play()
		  	if (group.newState.mortrate>6) then
		  		--print(newState.mortrate)
				Runtime:dispatchEvent({name = "onMort5", group.newState})
			end
			--print(event.params.textCap)
			--print(group.newState.name)
			if event.params.textCap~=nil then

				local a = event.params.textCap

			local b = string.lower(group.newState.name)
			local i, j = string.find(b, a)
			if i == nil then
				group.newState.shape.alpha = 0
			else
				group.newState.shape.alpha = 1
			end
		end
		end
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
		physics.stop()
		for _, group in ipairs(stateGroup) do
		  	
		  	group.heart:pause()
		end
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene