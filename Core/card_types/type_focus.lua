function Check_FocusCards(filename)

	local card_info = {}
	local return_info = {}
	return_info.found = true

    local CheckState = switch { 
    --//////////////////////////////////////////////////////////////////
    --/////////////////////////////////FOCUS 
    --//////////////////////////////////////////////////////////////////    
        ["f/1.png"] = function()
                card_info.name = "battlecry"
                set_stats(card_info, 4,4,3,1,0,0,0,0,"focus",3,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", "", 10, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", "", 1, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", "", 1, 0)
            end,
        ["f/2.png"] = function()
                card_info.name = "recover"
                set_stats(card_info, 4,4,3,1,0,0,0,0,"focus",3,1)
                --card_info.actions[table.getn(card_info.actions) + 1] = set_action("OR_health", "", 10, 0)
                --card_info.actions[table.getn(card_info.actions) + 1] = set_action("OR_limb", "", 2, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("or_action", "health_limb", 0, 0) 
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", "", 1, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", "", 1, 0)
                end,
        ["f/3.png"] = function()
                card_info.name = "steady"
                set_stats(card_info, 4,4,3,1,0,2,0,0,"focus",3,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", "", 10, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", "", 1, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", "", 1, 0)
            end,
        ["f/4.png"] = function()
                card_info.name = "dislocate"
                set_stats(card_info, 4,4,3,1,1,0,0,0,"focus",3,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("limb", "", -1, 0)
            end,
        ["f/5.png"] = function()
                card_info.name = "surge"
                set_stats(card_info, 4,4,3,1,0,0,0,0,"focus",3,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", "", 2, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("discard", "", 1, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", "", 1, 0)
            end,            
        ["f/6.png"] = function()
                card_info.name = "harden"
                set_stats(card_info, 4,4,3,1,0,0,0,0,"focus",3,1)
                --IMMUNE TO WEAPONS REMOVED
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("arm", "", 2, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("leg", "", 2, 0)  
            end,
        ["f/7.png"] = function()
                card_info.name = "counter"
                set_stats(card_info, 4,4,3,1,0,0,1,0,"focus",3,1.5)
                --EXTRA LIMB NO LONGER USED
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("counter", "", 1, 0)
            end,
        ["f/8.png"] = function()
                card_info.name = "duel"
                set_stats(card_info, 4,3,4,3,0,0,0,5,"focus",3,2)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("faceoff", "", 0, -1)
                --VICTORY ACTIONS
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("health_delay", "", -6, 1)
            end,
        ["f/9.png"] = function()
                card_info.name = "arm-wrestle"
                set_stats(card_info, 4,3,4,3,1,0,0,3,"focus",3,2)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("faceoff", "", 1, -1)
                --VICTORY ACTIONS
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("power_damage", "", 0, 0)
            end,
        ["f/10.png"] = function()
                card_info.name = "grapple"
                set_stats(card_info, 4,3,4,3,2,0,0,3,"focus",3,2)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("faceoff", "", 0, -1) 
                --VICTORY ACTIONS
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("limb", "", -2, 0)
            end,                
        ["f/11.png"] = function()
                card_info.name = "luck"
                set_stats(card_info, 4,3,4,3,0,0,0,13,"focus",3,2.5)
                --IMMUNE TO PHYSICAL REMOVED
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", "", 2, 0)
            end,
        ["f/12.png"] = function()
                card_info.name = "battle-of-wills"
                set_stats(card_info, 4,4,4,4,0,0,0,0,"focus",3,2)
                --IMMUNE TO CHEAT NO LONGER USED
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("faceoff", "", 1, -1)
                --VICTORY ACTIONS
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("discard", "", 2, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", "", 1, 0)
            end,
        ["f/13.png"] = function()
                card_info.name = "energise"
                set_stats(card_info, 4,4,4,4,0,0,0,2,"focus",3,3)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("limb", "", 2, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", "", 2, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", "", 1, 0)
            end,            
        ["f/14.png"] = function()
                card_info.name = "deflect"
                set_stats(card_info, 4,4,4,4,0,0,1,6,"focus",3,3)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("counter", "", 0, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", "", -6, 0) --because its other persons turn
                end,
        ["f/15.png"] = function()
                card_info.name = "surpress"
                set_stats(card_info, 4,4,4,4,2,0,0,0,"focus",3,3)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", "", 10, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("end_round", "", 0, -1)
            end,

        default = function () 
            --print( "ERROR - filename not within physical") 
            return_info.found = false
            end,
	}

	CheckState:case(filename)

	return_info.card_info = card_info
	return return_info

end