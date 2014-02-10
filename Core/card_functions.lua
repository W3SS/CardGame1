
function onTouch( event )
		--print("touch")
		local t = event.target
		local phase = event.phase

		if (t.finalised == false) then
			if "began" == phase then
				-- Make target the top-most object
				local parent = t.parent
				parent:insert( t )
				display.getCurrentStage():setFocus( t )
				t.isFocus = true
				-- Store initial position

				if (t.drawn == false) then
					t.x0 = event.x - t.x
					t.y0 = event.y - t.y
				else
					t.x0 = (event.x / camera.xScale) - t.x
					t.y0 = (event.y / camera.xScale) - t.y
				end
				t.moved = true
				print("moved: " , t.moved)
				t.touched = true
				--GameInfo.hand.hide = true

				--print("touched")
			elseif t.isFocus then
				if "moved" == phase then
					-- Make object move (we subtract t.x0,t.y0 so that moves are
					-- relative to initial grab point, rather than object "snapping").
					t.x = (event.x / camera.xScale) - t.x0
					t.y = (event.y / camera.xScale) - t.y0

					if (t.drawn == false) then
						t.x = event.x - t.x0
						t.y = event.y - t.y0
					else
						t.x = (event.x / camera.xScale) - t.x0
						t.y = (event.y / camera.xScale) - t.y0
					end

				elseif "ended" == phase or "cancelled" == phase then
					display.getCurrentStage():setFocus( nil )
					t.isFocus = false
		      		--print("moved button id ".. t.unique_id)
		      		if (GameInfo.hand.hide == true) then
						Update_Pos2(t.unique_id, t.filename, t.x, t.y)
					end
					if (t.drawn == false) then
						t.isVisible = false
					end
					t.moved = false

					CheckBoard_Pos(t)
					GameInfo.hand.hide = false
				end
			end
		end
		--GameInfo.touches[ table.getn(GameInfo.touches)+1 ] = event
		return true
end

function CheckBoard_Pos(card)
	local used_x = card.x
	local used_y = card.y
	local x_space = 125
	local y_space = 125

	x_itts = used_x / x_space
	y_itts = used_y / y_space

	x_itts = math.round(x_itts)
	y_itts = math.round(y_itts)

	--CAN'T CAPTURE ROTATION HERE PROPERLY
	print("grid_x:" .. x_itts .."  grid_y:" .. y_itts .. " rotation:" .. card.rotation)

	--verticle card, y must be ODD, x must be EVEN
	--horizontal card, y must be EVEN, x must be ODD

	--divide end position values by 2 to get the table grid reference
end

--ALLOW THE CARDS PLACED ON THE TABLE TO BE ROTATED IF CLICKED ON
function tapRotateLeftButton( e )
	print("rotate")
    local t = e.target

    if (t.finalised == false) then
	    if ( t.rotation == 0 or t.rotation == -90 or 
	    	t.rotation == -180 or t.rotation == -270) then
	    	transition.to(t, {time=250,
	    	--rotation= t.rotation -90.0, onComplete=UpdateRotation(t)})
			--t.rotation = t.rotation - 90

			rotation= t.rotation -90.0, onComplete=function()
    		timer.performWithDelay(250, UpdateRotation(t),1)end })
		end
	end
end

function UpdateRotation(t)
	--print("updating rotation")

	if ( t.rotation <= -360 ) then
		t.rotation = 0
	end

	CheckBoard_Pos(t)
	--SEND AN UPDATE TO THE OTHER PLAYERS THAT THE CARD'S ROTATING AND BY WHAT ANGLE
	appWarpClient.sendUpdatePeers(
		tostring("rotation") .. " " ..
		tostring(t.unique_id) .. " " .. 
		tostring(GameInfo.username) .. " " ..		
		--tostring(t.rotation - 90))
		tostring(t.rotation))
end