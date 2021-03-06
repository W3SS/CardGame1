
local main_loop_state = 1
local end_round_state = 1
local end_timer = 0

function set_MainState(state_value)
	main_loop_state = state_value
	--print("MAIN STATE: "  .. main_loop_state)
end


function run_main_loop()
	
	GameInfo.print_string = ""

	GameInfo.frame_num= GameInfo.frame_num + 1;
    if (GameInfo.frame_num > 60) then
    	GameInfo.frame_num = 0
    end

    Run_PlayerText()

    --GameInfo.end_game = false
    --print(main_loop_state)
    if (GameInfo.end_game == false) then

	    local CheckState = switch { 
	        [1] = function()
					--print("Round Initiation!!!!")
					--Show_FOTable("", true)
					--main_loop_state = main_loop_state + 1
					main_loop_state = 5
	            end,
	        [2] = function() --START-GAME FACEOFF, DETERMINES ROUND'S STARTING PLAYER
					--TempReset() --RESET A DECK TO CHECK THE DECKDEATH CHECK, A TEMPORARY CHECK
					Hide_EndTable()
		            statusText.isVisible = true
		            statusText2.isVisible = true
		            finalise_button.isVisible = true
		            finalise_button.text.isVisible = true
					Show_FOTable("", true)
					main_loop_state = main_loop_state + 1
	            end,

	        [3] = function() --NORMAL GAME LOOP
					GameLoop()
	            end,


	        [4] = function() --SECOND GAME LOOP FOR PRE-GAME ACTIONS, RESETS TO NORMAL WHEN COMPLETE
					--local action_state = Get_ActionState()
					--print("ACTION STATE: " .. action_state .. " LIST SIZE: " .. table.getn(GameInfo.actions))
					GameLoop()

					local action_state = Get_ActionState()
					--
					--print(action_state)
					if (table.getn(GameInfo.actions) < action_state) then
		            	print("ACTION STATE: " .. action_state .. " LIST SIZE: " .. table.getn(GameInfo.actions))
		            	GameInfo.actions = {}
		            	ResetActionState()
		              	ResetActionInternalState()
		              	main_loop_state = 2
		              	--print("THE STATE HAS NOW RESET   " .. action_state)			
					end
	            end,
	        [5] = function() --PRE-GAME ACTIONS
	        --CONTAINS ANYTHING THAT NEEDS TO BE RUN BEFORE A GAME BEGINS,
	        --DRAW/DISCARD CARDS ETC. ALL I NEED TO DO IS CUE THE ACTIONS

	        		--GameInfo.saved_actions[1] = "discard"
	        		--print("THIS SHITE IS BEING SET")
	        		local arr_pos = 0

	        		if (GameInfo.saved_actions ~= nil) then
		        		for i=1, table.getn(GameInfo.saved_actions) do

							arr_pos = table.getn(GameInfo.actions) + 1

			                local CheckState = switch {
			                    ["add_card"] = function()    --
			                    	local card = GameInfo.selected_card
			                    	LoadCard2(card.filename,card.sheet,card.sprite,0,0)
			                    	GameInfo.selected_card = {}
			                        end,		                	
			                    ["draw"] = function()    --
						            GameInfo.actions[arr_pos] = set_action("draw", "", 1, 0)
						            GameInfo.actions[arr_pos].type = "draw"
			                        end,
			                    ["discard"] = function()    --
				            		GameInfo.actions[arr_pos] = set_action("discard", "", 1, 1)
				            		GameInfo.actions[arr_pos].type = "discard"
			                        end,
			                    default = function () print("ERROR - state not within pre game actions") end,
			                }

			                CheckState:case(GameInfo.saved_actions[i])   		
				        end
		            end

	        		--CHECK TO SEE IF THE PLAYER HAS ANY CRIPPLED LIMBS
	        		--GIVE HIM THE ABILITY TO DISCARD A CARD TO ADD A LIMB ACTION

				    for i=1, table.getn(GameInfo.player_list) do

				    	local player = GameInfo.player_list[i]

				    	--if (i == 2) then
				    	--	player.legs = 1
				    	--	player.arms = 1
				    	--end
				    	--player.legs = 0

				    	if (player.arms < 2 or player.legs < 2)  then

					    	local against = 1 --DONATES THE OTHER PLAYER
					    	local action = "heal_limb1"

							if (player.username == GameInfo.player_list[GameInfo.current_player].username) then
								against = 0 --DIRECT AT THE CURRENT PLAYER
								action = "heal_limb0"
							end
							
				        	arr_pos = table.getn(GameInfo.actions) + 1
				            GameInfo.actions[arr_pos] = set_action("limb_discard", action, 1, against)
				            GameInfo.actions[arr_pos].type = "limb_discard"

				        	--arr_pos = table.getn(GameInfo.actions) + 1
				            --GameInfo.actions[arr_pos] = set_action("limb", action, 2, against)
				            --GameInfo.actions[arr_pos].type = "limb"
				            --print("LIMB AGAINST: " .. against .. " Action Pos: " .. arr_pos)
				    	end
					end

					local action_state = Get_ActionState()
					--print("STATE: " .. action_state)
		            main_loop_state = 4 --SECONDARY LOOP

					GameInfo.saved_actions = {}
	            end,

	        default = function () print( "ERROR - sub_type not within main_loop_state") end,
	    }

	    CheckState:case(main_loop_state)

	else
		--end_game == true SECTION
		--print("END GAME")
		ResetGame()

	end --end_game == false function end 



	if (GameInfo.end_round == true) then

	    local CheckState2 = switch { 
	        [1] = function()
                 	local count = 0
                    for i=1, table.getn(GameInfo.player_list) do
                        if (GameInfo.player_list[i].temp_trigger == true) then  
                            count = count + 1
                        end
                    end
                    if(count >= 2) then
                        end_round_state = end_round_state + 1
                        for i=1, table.getn(GameInfo.player_list) do
                            GameInfo.player_list[i].temp_trigger = false  
                        end 
                    end
	            end,
	        [2] = function()
					--GameInfo.round_damage = 0
	        		end_timer = 60 * 3
	        		end_round_state = end_round_state + 1
	            end,
	        [3] = function()
	        		end_timer = end_timer - 1
	        		if (end_timer <= 0) then
	        			end_round_state = end_round_state + 1
	        		end
	            end,
	        [4] = function() --START-GAME FACEOFF, DETERMINES ROUND'S STARTING PLAYER
					local Round_Ended = EndRound()
					if (Round_Ended == true) then
						--print("CARD AFTER END ROUND: " .. table.getn(GameInfo.cards))
						GameInfo.end_round = false
					end
	            end,

	        default = function () print( "ERROR - sub_type not within main_loop_state") end,
	    }

	    CheckState2:case(end_round_state)

	end

    --CHECK THE NETWORK CONNECTION
    appWarpClient.Loop()

end



function GameLoop()
    --BOUNDS NEEDED TO KEEP THE SYNCING OF SCREEN AND GAME SPACES TOGETHER
    --USED TO KEEP CARDS WITHIN THE TABLE BOUNDS
	boundX1 = -camera.scrollX
	boundX2 = -camera.scrollX + (display.contentWidth / camera.xScale)
	boundY1 = -camera.scrollY
	boundY2 = -camera.scrollY + (display.contentHeight / camera.yScale)


    --INPUTS AND MAIN FUNCTIONS FOR THE GAME
 	run_button_loop()
 	run_card_loop()
 	CheckZoom()

    --RUN THE ACTION LIST LOOP, A SET OF ADVANCING NAMES AND INTERNAL STATES
 	CheckActionState()
 	action_CounterLoop()

 	--SOME TEMPORARY DRAWN BUTTONS I'M USING TO TEST THE CAMERA AND IT'S SPACING
	button1.x = -camera.scrollX
	button1.y = -camera.scrollY
	button2.x = -camera.scrollX + (display.contentWidth / camera.xScale)
	button2.y = -camera.scrollY
	button3.x = -camera.scrollX 
	button3.y = -camera.scrollY + (display.contentHeight / camera.yScale)
	button4.x = -camera.scrollX + (display.contentWidth / camera.xScale)
	button4.y = -camera.scrollY + (display.contentHeight / camera.yScale)

	if ( table.getn(GameInfo.touches) >= 1) then
		button1.x = (GameInfo.touches[1].x  / camera.xScale) - camera.scrollX
		button1.y = (GameInfo.touches[1].y  / camera.yScale) - camera.scrollY
		
	end 
	if ( table.getn(GameInfo.touches) >= 2) then	
		button2.x = (GameInfo.touches[2].x  / camera.xScale) - camera.scrollX
		button2.y = (GameInfo.touches[2].y  / camera.yScale) - camera.scrollY
	end 

	local pos_String = ""
	for i = 1, table.getn(GameInfo.touches) do
		pos_String = pos_String .. "x: " .. GameInfo.touches[i].x .. "y: " .. GameInfo.touches[i].y .. "\n"
	end

	GameInfo.touches = {}	


	statusText.text = GameInfo.print_string
	statusText.x = statusText.width / 2
	statusText.y = bar3.y + (bar3.height / 2) - statusText.height / 2

	statusText2.text = GameInfo.print_string2
	statusText2.x = statusText2.width / 2
	statusText2.y = bar2.y + (bar2.height / 2) - statusText2.height / 2
end

