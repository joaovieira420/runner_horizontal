---------------------------------------------------------------------------------
--
-- main.lua
--
---------------------------------------------------------------------------------

-- hide the status bar
--display.setStatusBar( display.HiddenStatusBar )

-- require the composer library
local composer = require "composer"
local widget = require("widget")

local sceneName = "menu"

local scene = composer.newScene( sceneName )

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc)


-- Add any system wide event handlers, location, key events, system resume/suspend, memory, etc.

-- load scene1
--composer.gotoScene( "scene1" )


local button4
local button3

local function removeButtons()
    button3:removeSelf()
    button4:removeSelf()
end

local background = display.newRect( 240, 160, 480, 320 )
background:setFillColor(1,1,1)


local function handleButton3Event( event )
 
    if ( "ended" == event.phase ) then
        composer.removeScene("runner")
        composer.gotoScene( "runner" )
        removeButtons()
    end
end

local function handleButton4Event( event )
 
    if ( "ended" == event.phase ) then
        composer.removeScene("runner_static")
        composer.gotoScene("runner_static")
        removeButtons()
    end
end



button4 = widget.newButton(
    {
        left = 150,
        top = 100,
        id = "button4",
        label = "Mesmas Palavras",
        onEvent = handleButton4Event
    }
)

button3 = widget.newButton(
    {
        left = 150,
        top = 180,
        id = "button3",
        label = "Palavras Aleatórias",
        onEvent = handleButton3Event
    }
)


return scene