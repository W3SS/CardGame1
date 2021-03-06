

local decks; -- The deck of Cards
local suits = {"w","p","f","s","a","c"}; -- weapon, physical, focus, speed, armour, cheat
local suit_names = {"WEAPON","PHYSICAL","FOCUS","SPEED","ARMOUR","CHEAT"};
local dealBtn; -- the deal buttons

function GetDeck()
    return decks;
end

function Get_SuitNames()
    return suit_names;
end

function TempReset()
    --for i=1, 6 do
    --    decks[i] = {}
    --end

    decks[4] = {}
end

--CREATE 4 DECKS CONTAINING 30 CARDS EACH. EACH DECK CONTAINS 2 OF THE EACH CARD (15 SETS)
function createDeck()
	decks = {};
	for i=1, 6 do
		--cardtext = ""
		decks[i] = {}
     	for j=1, 30 do
    	    local tempCard = j;
    	    table.insert(decks[i],tempCard);
    	    --cardtext = cardtext .. tempCard .. ",";
     	end
     	--print(cardtext)
    end  
end

function DrawCharacterCards()
    --print("check draw")
    for i=1, table.getn(GameInfo.player_list) do
        if (GameInfo.player_list[i].username == GameInfo.username) then
            --print("player found")
            local user_info = GameInfo.player_list[i]

            for stat=1, table.getn(user_info.character_info) do
                --print("stat: " .. stat)
                local card_num = user_info.character_info[stat]
                --print("card num: " .. card_num)
                if (card_num > 0) then
                    for card_itt=1, card_num do
                        DrawCard(stat, true)      
                    end 
                end
            end          

        end
    end

                local group = display.newGroup() --BRING SCREEN ELEMENTS TO THE FRONT OF SCREEN
                group:insert(GameInfo.screen_elements2.image)
                TitleText:toFront()
                group:insert(MsgBox)
                MsgText:toFront()    
end

--DRAW A CARD BY AMENDING THE DECK CHOSEN AND LOADING THE CARD AS AN OBJECT
function DrawCard(deck_index, remove_item)
	tempCard = CheckDeck(deck_index, remove_item)

    if (tempCard ~= -1) then
        LoadCard2( suits[deck_index] .. "/" .. tempCard .. ".png", suits[deck_index], tempCard,0,150);
    else
        print("COULDN'T DRAW CARD, DECK NOT LARGE ENOUGH")
    end
end

function CheckDeck(deck_index, remove_item)

	--RANDOMLY GENERATE A NUMBER FROM THE SIZE OF THE DECK
	local randIndex = math.random(#decks[deck_index])
	--local randIndex = 8 --4 ,5
    print("indexnum: ", randIndex)

	--GET THE CARD NAME SAVED AT THAT LIST INDEX POSITION

    local tempCard = -1

    --print("current size: " .. table.getn(decks[deck_index]))
    if (randIndex <= table.getn(decks[deck_index])) then

    	tempCard = decks[deck_index][randIndex]
    	--print("card: ", tempCard)

    	--REMOVE THE VALUE FROM THE LIST
        if (remove_item == true) then
            RemoveDeckCard(deck_index, randIndex)

            QueueMessage(
            --appWarpClient.sendUpdatePeers(
                --tostring("MSG_CODE") .. " " ..
                tostring("remove_card") .. " " ..
                tostring(GameInfo.username) .. " " .. 
                tostring(deck_index).." ".. 
                tostring(randIndex))        
        end

        if ( tempCard > 15) then
            tempCard = tempCard - 15
        end
    end
	return tempCard
end

function RemoveDeckCard(deck_index, remove_pos)
    --print("deck index" .. deck_index .. " remove_pos " .. remove_pos .. " deck " .. table.getn(decks))
    table.remove(decks[deck_index],remove_pos)
    --print("Deck_listSize: ", table.maxn(decks[deck_index]))   
end

function LoadCard(filename,x,y)
	local group = display.newGroup()
    --local group = GameInfo.card_group[1]
    -- width, height, x, y
    local icon = display.newImage(group, "Images/" .. filename, 
        x, y)

    icon:addEventListener( "touch", onTouch )
    id = table.getn(GameInfo.cards)+1

    GameInfo.cards[id] = icon
    GameInfo.cards[id].touched = false
    GameInfo.cards[id].id = id
    GameInfo.cards[id].unique_id = GameInfo.username .. "_" .. filename .. "_" .. id
    GameInfo.cards[id].filename = filename
    GameInfo.cards[id].drawn = false
    GameInfo.cards[id].finalised = false
end

function LoadCard2(filename,sheet,sprite,x,y)
    local group = display.newGroup()

    -- first, create the image sheet object
    local options =
    {
        -- The params below are required
        width = 350,
        height = 350,
        numFrames = 15,

        -- The params below are optional; used for dynamic resolution support
        sheetContentWidth = 1050,  -- width of original 1x size of entire sheet
        sheetContentHeight = 1750  -- height of original 1x size of entire sheet
    }
    --print("sheet: " .. sheet .. ", sprite: " .. sprite)
    local imageSheet = graphics.newImageSheet( "Images/" .. sheet .. ".png", options )
    local icon = display.newImage( imageSheet, sprite, x, y )


    icon:addEventListener( "touch", onTouch )
    id = table.getn(GameInfo.cards)+1

    GameInfo.cards[id] = icon
    GameInfo.cards[id].touched = false
    GameInfo.cards[id].id = id
    GameInfo.cards[id].unique_id = GameInfo.username .. "_" .. filename .. "_" .. id
    GameInfo.cards[id].filename = filename
    GameInfo.cards[id].sheet = sheet
    GameInfo.cards[id].sprite = sprite
    GameInfo.cards[id].drawn = false
    GameInfo.cards[id].finalised = false
end



function AddCard(unique_id,filename,x,y,scale)
	local group = display.newGroup()
    -- width, height, x, y
    --it's this that's causing the misalignment of cards being laid down over the network
    local icon;

    if (scale == true) then
	    icon = display.newImage(group, "Images/" .. filename, 
	        (x / camera.xScale) - camera.scrollX, (y / camera.yScale) - camera.scrollY)
	else
	    icon = display.newImage(group, "Images/" .. filename, 
	        x, y)
	end
    icon:addEventListener( "tap" , tapRotateLeftButton )
    icon:addEventListener( "touch", onTouch )

    if ( GameInfo.current_card_int ~= -1) then

        if (GameInfo.table_cards[GameInfo.current_card_int].finalised == false) then
            Restore_HandCard()
            Remove_CurrentCard()
            tab.hide_once = true
        end 
    end

    if ( GameInfo.current_card_int ~= -1) then
        GameInfo.previous_card_int = GameInfo.current_card_int
    end
    --print("card added")

    id = table.getn(GameInfo.table_cards)+1
    GameInfo.table_cards[id] = icon
    GameInfo.table_cards[id].touched = false
    GameInfo.table_cards[id].id = id 
    GameInfo.table_cards[id].unique_id = unique_id
    GameInfo.table_cards[id].filename = filename
    GameInfo.table_cards[id].drawn = true
    GameInfo.table_cards[id].rotation = 0
    GameInfo.table_cards[id].finalised = false

    
    GameInfo.current_card_int = id
    --print("current card: " .. GameInfo.current_card_int)
    --print("previous card: " .. GameInfo.previous_card_int)
end


function AddCard2(unique_id,filename,sheet,sprite,x,y,scale)
    local group = display.newGroup()


    -- first, create the image sheet object
    local options =
    {
        -- The params below are required
        width = 350,
        height = 350,
        numFrames = 15,

        -- The params below are optional; used for dynamic resolution support
        sheetContentWidth = 1050,  -- width of original 1x size of entire sheet
        sheetContentHeight = 1750  -- height of original 1x size of entire sheet
    }

    local imageSheet = graphics.newImageSheet( "Images/" .. sheet .. ".png", options )
    --local icon = display.newImage( imageSheet, sprite, x, y )    
    -- width, height, x, y
    --it's this that's causing the misalignment of cards being laid down over the network
    local icon;

    if (scale == true) then
        icon = display.newImage( imageSheet, sprite, 
            (x / camera.xScale) - camera.scrollX, (y / camera.yScale) - camera.scrollY)
    else
        icon = display.newImage( imageSheet, sprite, 
            x, y)
    end



    icon:addEventListener( "tap" , tapRotateLeftButton )
    icon:addEventListener( "touch", onTouch )

    if ( GameInfo.current_card_int ~= -1) then

        if (GameInfo.table_cards[GameInfo.current_card_int].finalised == false) then
            Restore_HandCard()
            Remove_CurrentCard()
            tab.hide_once = true
        end 
    end

    if ( GameInfo.current_card_int ~= -1) then
        GameInfo.previous_card_int = GameInfo.current_card_int
    end
    --print("card added")

    id = table.getn(GameInfo.table_cards)+1
    GameInfo.table_cards[id] = icon
    GameInfo.table_cards[id].touched = false
    GameInfo.table_cards[id].id = id 
    GameInfo.table_cards[id].unique_id = unique_id
    GameInfo.table_cards[id].filename = filename
    GameInfo.table_cards[id].sheet = sheet
    GameInfo.table_cards[id].sprite = sprite

    GameInfo.table_cards[id].drawn = true
    GameInfo.table_cards[id].rotation = 0
    GameInfo.table_cards[id].finalised = false

    
    GameInfo.current_card_int = id
    --print("current card: " .. GameInfo.current_card_int)
    --print("previous card: " .. GameInfo.previous_card_int)
end


local SetCards_state = 0

function Reset_SetCards_state()
    SetCards_state = 0
end

function SetPlayerCards_Networked()

    local setup_complete = false

    CheckState = switch { 
        [0] = function()    --SEND CARD DATA
                DrawCharacterCards()

                SetGame()
                --print("SENDING FINISH" .. GameInfo.username)

                QueueMessage(
                --appWarpClient.sendUpdatePeers(
                    --tostring("MSG_CODE") .. " " ..
                    tostring("finish_draw") .. " " ..
                    tostring(GameInfo.username))  

                SetCards_state = SetCards_state + 1
            end,
        [1] = function()    --WAIT TO RECEIVE THE COMPLETE STATUS

                if (GameInfo.switch1 == true) then

                    GameInfo.switch1 = false
                    SetCards_state = SetCards_state + 1
                    --print("switch triggered")
                end
            end,
        [2] = function()    --WAIT FOR THE OPPONENT TO FINISH DRAWING
                --GameInfo.gamestate = GameInfo.gamestate + 1
                setup_complete = true
            end,

        default = function () print( "ERROR - SetCards_state not within switch") end,
    }

    CheckState:case(SetCards_state)

    return setup_complete;

end