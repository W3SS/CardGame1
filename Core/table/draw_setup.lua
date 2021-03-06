local draw_max = 0

function Hide_DrawTable()
    GameInfo.screen_elements.image.isVisible  = false
    GameInfo.draw_screen.card1.icon.isVisible  = false
    GameInfo.draw_screen.card2.icon.isVisible  = false
    GameInfo.draw_screen.card3.icon.isVisible  = false
    GameInfo.draw_screen.card4.icon.isVisible  = false
    GameInfo.draw_screen.card5.icon.isVisible  = false
    GameInfo.draw_screen.card6.icon.isVisible  = false

    GameInfo.draw_screen.card1.icon.text.isVisible = false
    GameInfo.draw_screen.card2.icon.text.isVisible = false
    GameInfo.draw_screen.card3.icon.text.isVisible = false
    GameInfo.draw_screen.card4.icon.text.isVisible = false
    GameInfo.draw_screen.card5.icon.text.isVisible = false
    GameInfo.draw_screen.card6.icon.text.isVisible = false

    TitleText.text = ""
    GameInfo.pause_main = false
    CheckActionPos(false)

    if (finalise_button ~= nil) then
        finalise_button.text.text = finalise_button.default_text
        check_FinalisationButton(GameInfo.current_player)
    end
end

function Show_DrawTable()
    GameInfo.screen_elements.image.isVisible  = true

    local deck_info = GetDeck(); 

    if (table.getn(deck_info[1]) > 0) then
        GameInfo.draw_screen.card1.icon.isVisible  = true
        GameInfo.draw_screen.card1.icon.text.isVisible = true
    end
    if (table.getn(deck_info[2]) > 0) then
        GameInfo.draw_screen.card2.icon.isVisible  = true
        GameInfo.draw_screen.card2.icon.text.isVisible = true
    end
    if (table.getn(deck_info[3]) > 0) then
        GameInfo.draw_screen.card3.icon.isVisible  = true
        GameInfo.draw_screen.card3.icon.text.isVisible = true
    end
    if (table.getn(deck_info[4]) > 0) then   
        GameInfo.draw_screen.card4.icon.isVisible  = true
        GameInfo.draw_screen.card4.icon.text.isVisible = true
    end
    if (table.getn(deck_info[5]) > 0) then
        GameInfo.draw_screen.card5.icon.isVisible  = true
        GameInfo.draw_screen.card5.icon.text.isVisible = true
    end
    if (table.getn(deck_info[6]) > 0) then
        GameInfo.draw_screen.card6.icon.isVisible  = true
        GameInfo.draw_screen.card6.icon.text.isVisible = true
    end
    TitleText.text = "Draw Card"
    GameInfo.pause_main = true
    if (draw_max ~= 0) then
        run_popup("Draw: " .. draw_max)
    end

    if (finalise_button ~= nil) then
        finalise_button.isVisible = false
        finalise_button.text.isVisible = false   
    end
end


function DrawTempCard( event )
    local t = event.target
    local phase = event.phase

    if "began" == phase then
        
        local parent = t.parent
        parent:insert( t )
        display.getCurrentStage():setFocus( t ) 
        print(t.text.text)
        t.isFocus = true
        t.text:toFront();

        if (t.item_loaded == false) then
            --print("loading")

            local icon = display.newRoundedRect( 
                t.x, t.y, 350, 350, 1 )
                    icon:setFillColor( colorsRGB.RGB("white") )
                    icon.strokeWidth = 6
                    icon:setStrokeColor( 200,200,200,255 )

            GameInfo.temp_card.icon = icon

            local text = display.newText( t.card_type, 
                GameInfo.temp_card.icon.x, GameInfo.temp_card.icon.y, 
                native.systemFontBold, 48 )
                text:setFillColor( colorsRGB.RGB("red") )

            GameInfo.temp_card.icon.text = text
            t.item_loaded = true           
        end
        --print("draw start")
    elseif t.isFocus then
        if "moved" == phase then
            GameInfo.temp_card.icon.x = event.x
            GameInfo.temp_card.icon.y = event.y 
            GameInfo.temp_card.icon.text.x = event.x
            GameInfo.temp_card.icon.text.y = event.y
        elseif "ended" == phase then
            display.getCurrentStage():setFocus( nil )
            --print("off button")
            if (t.item_loaded == true) then
                local max_hight = display.contentHeight - (300 * GameInfo.zoom)
                if (GameInfo.temp_card.icon.y > max_hight) then
                    --print("card drawn" .. t.type_int)
                    DrawCard(t.type_int, true)
                    --portrait:toFront()
                    --statusText:toFront()
                    SetGame()

                    if (draw_max <= 1) then
                        Hide_DrawTable()
                    end
                    --else
                        draw_max = draw_max - 1
                    --end
                    if (draw_max ~= 0) then
                        run_popup("Draw: " .. draw_max)
                    end
                end
                GameInfo.temp_card.icon:removeSelf()
                GameInfo.temp_card.icon.text:removeSelf()
                t.item_loaded = false

                local stage = display.getCurrentStage()
                stage:setFocus( nil )
            end
        end
    end

    return true
end


function SetDrawMax(draw_value)
    draw_max = draw_value
    --print("draw value" .. draw_max)
end


function LoadDrawCard()
    local group = display.newGroup()
    -- width, height, x, y
    local draw_item = {}

    draw_item.card1 = {}
    draw_item.card2 = {}
    draw_item.card3 = {}
    draw_item.card4 = {}
    draw_item.card5 = {}
    draw_item.card6 = {}

    AddCardZone(draw_item.card1,130,500,"red","weapon",1);
    AddCardZone(draw_item.card2,400,500,"blue","physical",2);
    AddCardZone(draw_item.card3,670,500,"green","focus",3);
    AddCardZone(draw_item.card4,130,770,"yellow","speed",4);
    AddCardZone(draw_item.card5,400,770,"purple","armour",5);
    AddCardZone(draw_item.card6,670,770,"aqua","cheat",6);

    GameInfo.draw_screen = draw_item
    Hide_DrawTable()
end

function AddCardZone(draw_card,x,y,colour,type, type_int)

    local icon = display.newRoundedRect( 
        x, y, 250, 250, 1 )
            icon:setFillColor( colorsRGB.RGB(colour) )
            icon.strokeWidth = 6
            icon:setStrokeColor( colorsRGB.RGB("black") )

    icon:addEventListener( "touch", DrawTempCard )
    icon.item_loaded = false
    icon.card_type = type
    icon.type_int = type_int
    draw_card.icon = icon

    draw_card.print_text = type
    --draw_card.text = display.newText( draw_card.print_text, x, y, native.systemFontBold, 32 )
    draw_card.icon.text = display.newText( draw_card.print_text, x, y, native.systemFontBold, 32 )  
    draw_card.icon.text:setFillColor( colorsRGB.RGB("black"), 1)
end