
function SetupButtons()
	PlayerHand()
	ScrollBar()
	Player_Stats()
	Tab()
	Enemy_Stats()
	Finalise_button()
	Turn_button()
	--Portrait()			
end

function HideButtons()

end


function PlayerHand()
	--print("height: ", display.contentHeight)

	boxwidth = 3000
	boxheight = 360

	GameInfo.hand = display.newRoundedRect(
		GameInfo.portrait_start + boxwidth / 2,
		GameInfo.height - boxheight / 2,
		boxwidth,boxheight, 0 )

	GameInfo.hand:setFillColor( 255, 0, 128 )
	GameInfo.hand.strokeWidth = 6
	GameInfo.hand:setStrokeColor( 200,200,200,255 )
	GameInfo.hand.width = boxwidth
	GameInfo.hand.height = boxheight
	GameInfo.hand.hide = false
	GameInfo.hand.show = false
end

function ScrollBar()
	--print("height: ", display.contentHeight)
	local group = display.newGroup()

	boxwidth = GameInfo.hand.width
	boxheight = 100

	bar = {}
	local icon = display.newImage(group, "Images/" .. "scrollbar.png", 
        boxwidth / 2, 
        GameInfo.height - GameInfo.hand.height - boxheight / 2)

	--bar = display.newRoundedRect(
	--	boxwidth / 2,
	--	GameInfo.height - GameInfo.hand.height - boxheight / 2,
	--	boxwidth,boxheight, 0 )
	--bar:setFillColor( 255, 128, 0 )
	--bar.strokeWidth = 6
	--bar:setStrokeColor( 200,200,200,255 )
		-- Make the button instance respond to touch events

	icon:addEventListener( "touch", onStrafe )
	
	bar.x = boxwidth / 2
	bar.y = GameInfo.height - GameInfo.hand.height - boxheight / 2
	bar.icon = icon
	bar.width = boxwidth
	bar.height = boxheight	
	
end

function Enemy_Stats()
	--print("height: ", display.contentHeight)

	boxwidth = GameInfo.width
	boxheight = 100

	bar2 = display.newRoundedRect(
		boxwidth / 2,
		boxheight / 2,
		boxwidth,boxheight, 0 )
	bar2:setFillColor( colorsRGB.RGB("white") )
	bar2.strokeWidth = 6
	bar2:setStrokeColor( 200,200,200,255 )

	bar2.width = boxwidth
	bar2.height = boxheight	
	
end

function Player_Stats()
	--print("height: ", display.contentHeight)

	boxwidth = GameInfo.width
	boxheight = 100

	bar3 = display.newRoundedRect(
		boxwidth / 2,
		GameInfo.height - GameInfo.hand.height - bar.height - boxheight / 2,
		boxwidth,boxheight, 0 )
	bar3:setFillColor( colorsRGB.RGB("white") )
	bar3.strokeWidth = 6
	bar3:setStrokeColor( 200,200,200,255 )

	bar3.width = boxwidth
	bar3.height = boxheight	
	
end

function Tab()
	local group = display.newGroup()

	boxwidth = 100
	boxheight = 100

	tab = {}
	local icon = display.newImage(group, "Images/" .. "uparrow.png", 
        GameInfo.width - boxwidth / 2, 
        GameInfo.height - GameInfo.hand.height - bar.height - boxheight / 2)

	--tab = display.newRoundedRect(
	--	GameInfo.width - boxwidth / 2,
	--	GameInfo.height - GameInfo.hand.height - bar.height - boxheight / 2,
	--	boxwidth,boxheight, 0 )
	--tab:setFillColor( 0, 128, 128 )
	--tab.strokeWidth = 6
	--tab:setStrokeColor( 200,200,200,225 )
		-- Make the button instance respond to touch events
	icon:addEventListener( "touch", onStrafe_vert )
	
	tab.icon = icon
	tab.width = boxwidth
	tab.height = boxheight	
	tab.hide_once = true
end

function Finalise_button()
	boxwidth = 200
	boxheight = 75

	finalise_button = display.newRoundedRect(
		--GameInfo.portrait_start + boxwidth / 2,
		--GameInfo.height - GameInfo.hand.height - bar.height - boxheight / 2,
		GameInfo.width - boxwidth / 2,
		bar2.y + (bar2.height / 2) + boxheight / 2 ,
		boxwidth,boxheight, 0 )
	finalise_button:setFillColor( 1, 1, 1 )
	finalise_button.strokeWidth = 6
	finalise_button:setStrokeColor( 200,200,200,225 )
		-- Make the button instance respond to touch events
	finalise_button.width = boxwidth
	finalise_button.height = boxheight	
	finalise_button:addEventListener( "touch", finishCard )

	finalise_button.default_text = "end turn"
	finalise_button.print_text = finalise_button.default_text
	finalise_button.text = display.newText( finalise_button.print_text, finalise_button.x, finalise_button.y, native.systemFontBold, 32 )
	finalise_button.text:setFillColor( 0, 0, 0 )
end

function Turn_button()
	boxwidth = 200
	boxheight = 75

	turn_button = display.newRoundedRect(
		boxwidth / 2,
		bar2.height + boxheight / 2,
		boxwidth,boxheight, 0 )
	turn_button:setFillColor( 1, 1, 1 )
	turn_button.strokeWidth = 6
	turn_button:setStrokeColor( 200,200,200,225 )
		-- Make the button instance respond to touch events
	turn_button.width = boxwidth
	turn_button.height = boxheight	
	--turn_button:addEventListener( "touch", finishCard )

	turn_button.default_text = "YOUR TURN"
	turn_button.print_text = turn_button.default_text
	turn_button.text = display.newText( turn_button.print_text, turn_button.x, turn_button.y, native.systemFontBold, 32 )
	turn_button.text:setFillColor( 0, 0, 0 )
end


function Portrait()
	--print("height: ", display.contentHeight)

	portrait = display.newRoundedRect( GameInfo.portrait_start / 2,GameInfo.height - GameInfo.hand.height / 2 ,
		GameInfo.portrait_start,GameInfo.hand.height, 0 )
	portrait:setFillColor( 0, 128, 128 )
	portrait.strokeWidth = 6
	portrait:setStrokeColor( 200,200,200,255 )

end


