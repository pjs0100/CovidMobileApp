
local state = {id = 0, name = "", xPos=0, yPos=0, confirmed = 0, deaths = 0, mortrate = 0, incidentrate = 0, shape = nil, options = nil, sheet = nil, sequenceData = nil, timeInt = nil, scale = 0};



--[[local timeInt

local options = 
{
	width = 64,
	height = 64,
	numFrames = 6,
	sheetContentWidth = 384,
	sheetContentHeight = 64,
}

local sheet = graphics.newImageSheet("hearty_strip6.png", options)

local sequenceData =
{
	name="beat", start = 1, count = 6, time = timeInt, loopCount = 0
}
]]--

function state:new (o)    --constructor
  o = o or {}; 
  setmetatable(o, self);
  self.__index = self;
  return o;
end

function state:calcTime()
	self.timeInt = (1000 - (850 *((self.deaths-0)/23437)))
end

function state:createSprite()
	self.options = 
		{
			width = 64,
			height = 64,
			numFrames = 6,
			sheetContentWidth = 384,
			sheetContentHeight = 64,
		}

	self.sheet = graphics.newImageSheet("hearty_strip6.png", self.options)

	self.sequenceData =
	{
		name="beat", start = 1, count = 6, time = self.timeInt, loopCount = 0
	}
end

function state:spawn()
	self:calcTime();
	self:createSprite();
	 self.shape=display.newSprite(self.sheet, self.sequenceData);
	 self.shape.x = self.xPos
	 self.shape.y = self.yPos
	 self.shape.pp = self;  -- parent object
	 self:calcScale();
	 Runtime:addEventListener("onMort5", self)
	 --self.shape:setFillColor (math.random(0,255)/255,math.random(0,255)/255,math.random(0,255)/255);
	 return self.shape
end

function state:calcScale()
	self.scale = (0.25 + (1 *((self.confirmed-0)/299691)))
	self.shape:scale(self.scale, self.scale)
end

function state:onMort5(event)
	if(self.mortrate>6) then
		physics.setGravity(0,0)
		physics.addBody(self.shape, "dynamic", {radius = 10})
		self.shape:applyTorque(0.005)
		--print("here")
	end
end

return state