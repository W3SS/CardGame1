
local perspective=require("Core.functions.perspective")
camera=perspective.createView()

camera:setBounds(-5000,5000, -5000,5000)


camera.xScale = GameInfo.zoom
camera.yScale = GameInfo.zoom


--camera:add(icon, 4, false) --Add an onject to the camera: object, layer, isfocus
--camera:setFocus(icon) --Seperately set focus on an item
--camera:track() --Track the focal point

local zoom_used = false

function CheckZoom()

	local zoom_off = true
	if (table.getn(GameInfo.touches) >= 2 and zoom_off == false) then
		local x = GameInfo.touches[1].x - GameInfo.touches[2].x
		local y = GameInfo.touches[1].y - GameInfo.touches[2].y		
		local zoom =  math.sqrt((x * x) + (y * y))

		if ( zoom > 50) then
			GameInfo.zoom_dis = zoom			
		end

		if(GameInfo.zoom_saved ~= 0) then
			GameInfo.zoom =  GameInfo.zoom - ((GameInfo.zoom_saved - GameInfo.zoom_dis) / 1000)
			if (GameInfo.zoom < 0.25) then
				GameInfo.zoom = 0.25
			end
			if (GameInfo.zoom > 1.0) then
				GameInfo.zoom = 1.0
			end			
			camera.xScale = GameInfo.zoom
			camera.yScale = GameInfo.zoom
			Update_Per_Scaling()
			camera.damping = 0
		end

		GameInfo.zoom_saved = GameInfo.zoom_dis
		zoom_used = true
	end

	if (table.getn(GameInfo.touches) == 0) then
		zoom_used = false
	end


	if  (zoom_used == false and table.getn(GameInfo.touches) == 1) then
		GameInfo.zoom_saved = 0
		GameInfo.zoom_dis = 0

    	if (GameInfo.new_camera_pos.y ~= nil) then
    		camera:setFocus(GameInfo.new_camera_pos)
	    	camera.damping = 0
	    	camera:track() 
	    	Update_Per_Scaling()
    	end
	end

end