local discard_max = 0
local sub_action = ""

function Hide_DiscardTable()
    GameInfo.screen_elements.image.isVisible  = false
    GameInfo.discard_screen.card1.icon.isVisible  = false
    TitleText.text = ""
    GameInfo.pause_add = false
    CheckActionPos(false)
end

function Show_DiscardTable(temp_sub_action)
    GameInfo.screen_elements.image.isVisible  = true
    GameInfo.discard_screen.card1.icon.isVisible  = true
    TitleText.text = "Discard Card"
    GameInfo.pause_add = true
    sub_action = temp_sub_action
    --print(sub_action)
end

function CheckDiscard(current_card)

    local card_info = retrieve_card(current_card.filename)

    local CheckState = switch { 
        ["damage"] = function()    --DAMAGE ENEMY USING CARDS MAIN VALUE
            appWarpClient.sendUpdatePeers(
                tostring("health_mod") .. " " .. 
                tostring(-card_info.damage)) 
            end,
        ["armour"] = function()    --ADD ARMOUR USING CARDS MAIN VALUE
            appWarpClient.sendUpdatePeers(
                tostring("armour_mod") .. " " .. 
                tostring(card_info.damage)) 
            end,

        default = function () print( "ERROR - sub_type not within discard subtypes") end,
    }

    CheckState:case(sub_action)

    if (discard_max <= 1) then
    --    Hide_DiscardTable(false)
        appWarpClient.sendUpdatePeers(
            tostring("hide_discard") .. " " .. 
            tostring(GameInfo.username)) 
    end

    discard_max = discard_max - 1
end

function SetDiscardMax(discard_value)
    discard_max = discard_value
    --print("draw value" .. draw_max)
end

function LoadDiscardCard()
    local group = display.newGroup()
    -- width, height, x, y
    local draw_item = {}
    draw_item.card1 = {}

    AddDiscardZone(draw_item.card1,GameInfo.width / 2,GameInfo.height / 2 - 150,"red","discard",1);


    GameInfo.discard_screen = draw_item
    Hide_DiscardTable()
    --Show_DiscardTable()
end

function AddDiscardZone(draw_card,x,y,colour,type, type_int)

    local icon = display.newRoundedRect( 
        x, y, 400, 400, 1 )
            icon:setFillColor( colorsRGB.RGB(colour) )
            icon.strokeWidth = 6
            icon:setStrokeColor( 200,200,200,255 )
            
    --icon:addEventListener( "touch", DrawTempCard )
    icon.item_loaded = false
    icon.card_type = type
    icon.type_int = type_int
    icon.bbox_min_x = x - (400 / 2)
    icon.bbox_max_x = x + (400 / 2)
    icon.bbox_min_y = y - (400 / 2)
    icon.bbox_max_y = y + (400 / 2)
    draw_card.icon = icon
end