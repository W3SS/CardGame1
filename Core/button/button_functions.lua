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
			t.y0 = event.y - t.y
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

			--EndTurn(current_card)
			local CheckState = switch { 
				[1] = function()    --NORMAL CARD FINALISATION: SEND CARD DETAILS, PASS TURN
						id = GameInfo.current_card_int
						if(id ~= -1) then
							camera.damping = 10

							local current_card = GameInfo.table_cards[id]

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
			        end,
			    [2] = function()    --FACEOFF FINALISATION

			    		for i=1, table.getn(GameInfo.player_list) do
							if (GameInfo.username == GameInfo.player_list[i].username) then
								if ( GameInfo.player_list[i].faceoff_card ~= "") then
				        			print("this is the end of the finalisation")
										appWarpClient.sendUpdatePeers(
											tostring("pass_faceoff") .. " " ..
											tostring(GameInfo.username) .. " " ..		
											tostring(GameInfo.player_list[i].faceoff_card))
								end
							end
						end		        	
			        end,
			    default = function () print( "ERROR - state not within finalisation states") end,
			    }

			CheckState:case(GameInfo.finalise_state)
		end
	end

	return true
end