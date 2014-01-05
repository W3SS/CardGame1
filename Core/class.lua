--===========================
--THE SETCLASS FUNCTION IS IN THE INC_CLASS FILE. WHICH IS A METHOD IS INITIALISING CLASSES

cGameInfo=setclass("GameInfo")

function cGameInfo.methods:init(gamestate) 
	self.gamestate = gamestate
	self.frame_num = 0
	self.myButtons = {}
	self.images = {}
end

--{ x=50, y=10, w=100, h=100, r=10, red=255, green=0, blue=128, id = 1 },

cButtonClass=setclass("ButtonClass")

function cButtonClass.methods:init(x,y,w,h,r,red,green,blue,id) 
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.r = r
	self.red = red
	self.green = green
	self.blue = blue
	self.id = id
end