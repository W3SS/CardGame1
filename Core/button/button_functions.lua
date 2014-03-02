function onStrafe( event )
		local t = event.target
		local phase = event.phase
		if "began" == phase then
			-- Make target the top-most object
			local parent = t.parent
			--parent:insert( t )
			display.getCurrentStage():setFocus( t )
			t.isFocus = true
			-- Store initial position
			t.x0 = event.x - t.x
			--t.y0 = event.y - t.y
		elseif t.isFocus then
			if "moved" == phase then
				-- Make object move (we subtract t.x0,t.y0 so that moves are
				-- relative to initial grab point, rather than object "snapping").
				t.x = event.x - t.x0
				--t.y = event.y - t.y0
			elseif "ended" == phase or "cancelled" == phase then
				display.getCurrentStage():setFocus( nil )
				t.isFocus = false
			end
		end
		return true
end

function onStrafe_vert( event )
		local t = event.target
		local phase = event.phase
		if "began" == phase then
			-- Make target the top-most object
			local parent = t.parent
			--parent:insert( t )
			display.getCurrentStage():setFocus( t )
			t.isFocus = true
			-- Store initial position
			--t.x0 = event.x - t.x
			t.y0 = event.y - t.y
			tab.hide_once = true
		elseif t.isFocus then
			if "moved" == phase then
				-- Make object move (we subtract t.x0,t.y0 so that moves are
				-- relative to initial grab point, rather than object "snapping").
				--t.x = event.x - t.x0
				t.y = event.y - t.y0
			elseif "ended" == phase or "cancelled" == phase then
				display.getCurrentStage():setFocus( nil )
				t.isFocus = false
			end
		end
		return true
end

function finishCard( event )
	local t = event.target
	local phase = event.phase

	if "began" == phase then
		
		local parent = t.parent
		parent:insert( t )
		display.getCurrentStage():setFocus( t )	
		t.isFocus = true

	elseif t.isFocus then
		if "ended" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
			id = GameInfo.current_card_int
			if(id ~= -1) then
				--current_card = GameInfo.table_cards[id]

				--current_card.finalised = true
				--camera:add(current_card, 1, true)
				--camera:setFocus(current_card)
				--camera:track()
				camera.damping = 10

				local current_card = GameInfo.table_cards[GameInfo.current_card_int]

				local Pos_Info = CheckBoard_Pos(current_card)
				--width + width * current_height
				section_num = Pos_Info[3]--Pos_Info[1] + (Pos_Info[2] * GameInfo.world_width)
				local quad_info = {}
				quad_info.section_num = section_num
				quad_info.filename = current_card.filename
				quad_info.rotation = current_card.rotation
				local list_pos = Quad_Add(GameInfo.quads, quad_info)

				--print( "list pos:" .. list_pos)
				--GameInfo.quads[list_pos].subquads[1] = "test"
			    for i = 1, table.getn(GameInfo.quads) do
			    --	print("quad name#" .. i .. " " .. GameInfo.quads[i].section_num 
			    --		.. " file name:" .. GameInfo.quads[i].filename
			    --		.. " rotation:" .. GameInfo.quads[i].rotation)
			    end


				appWarpClient.sendUpdatePeers(
					tostring("position") .. " " ..
					tostring(current_card.unique_id) .. " " ..
					tostring(current_card.filename) .. " " .. 
					tostring(current_card.x).." ".. 
					tostring(current_card.y))

				appWarpClient.sendUpdatePeers(
					tostring("rotation") .. " " ..
					tostring(current_card.unique_id) .. " " .. 
					tostring(GameInfo.username) .. " " ..		
					tostring(current_card.rotation))
												
			end
		end
	end

	return true
end