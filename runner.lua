local facebook = require("plugin.facebook.v4")
local sceneName = "runner"
local composer = require( "composer" )

local scene = composer.newScene( sceneName )

local facebook = require("plugin.facebook.v4")
local widget = require("widget")
local EventID = 0

local attachment = {
    caption = "Livro do Desassossego",
    source = { baseDir=system.DocumentsDirectory, filename="screengrab.jpg", type="image" }
}

local json = require( "json" )


local function networkListener( event )
 
    if ( event.isError ) then
        print( "Network error: ", event.response )
    else
        print ( "RESPONSE: " .. event.response )
    end
end

local headers = {}
  
headers["Content-Type"] = "application/x-www-form-urlencoded"
headers["Accept-Language"] = "en-US"
  
local event

local body
 
local params = {}

 
local function facebookListener( event )
 
    print( "event.name:" .. event.name )  -- "fbconnect"
    print( "isError: " .. tostring( event.isError ) )
    print( "didComplete: " .. tostring( event.didComplete ) )
    print( "event.type:" .. event.type )  -- "session", "request", or "dialog"
 
    -- event.type of "session" covers various login/logout events
    if ( "session" == event.type ) then
        -- event.phase may be "login", "loginFailed", "loginCancelled", or "logout"
        if ( "login" == event.phase ) then
            local access_token = event.token
            -- Code for tasks following a successful login
        end
 
    -- event.type of "request" handles calls to various Graph API functionalities
    elseif ( "request" == event.type ) then
        if not event.isError then
            local response = json.decode( event.response )
            -- Process response data here
        end
 
    -- event.type of "dialog" indicates standard popup boxes that can be displayed
    elseif ( "dialog" == event.type ) then
        print( "dialog", event.response )
        -- Handle dialog results here
    end
end




local storedDeviceID = ""
 
local function hasPhonePermission()
 
    -- Check to see if the user has previouslly granted permissions
    local grantedPermissions = system.getInfo( "grantedAppPermissions" )
    local hasPhonePermission = false
 
    -- Check for the "Phone" group permission
    for i = 1,#grantedPermissions do
        if ( "Phone" == grantedPermissions[i] ) then
            hasPhonePermission = true
            break
        end
    end
    return hasPhonePermission
end

local function appPermissionsListener( event )
 
    local phonePermissionGranted = hasPhonePermission()
    if not phonePermissionGranted then
        -- We can't continue, exit the app
        native.requestExit()
    else
        -- Safe to get the device ID
        storedDeviceID = system.getInfo( "deviceID" )
    end
end

if ( system.getInfo( "platform" ) == "android" and system.getInfo( "androidApiLevel" ) >= 23 ) then
 
    local phonePermissionGranted = hasPhonePermission()
 
    if not phonePermissionGranted then
        -- If phone permission is not yet granted, prompt for it
        local permissionOptions =
        {
            appPermission = "Phone",
            urgency = "Critical",
            listener = appPermissionsListener,
            rationaleTitle = "Read phone state required",
            rationaleDescription = "This app needs this state to retrieve previously saved data. Re-request now?",
            settingsRedirectTitle = "Alert",
            settingsRedirectDescription = "Without the ability to access your device's unique ID, it can't function properly. Please grant phone access within Settings."
        }
        native.showPopup( "requestAppPermission", permissionOptions )
    else
        -- We already have the needed permission
        storedDeviceID = system.getInfo( "deviceID" )
    end
end



local texto = {[[E eu offereço-te este livro porque sei que elle é bello e inutil.]],
[[Senti-me agora respirar como se houvesse practicado uma cousa nova, ou atrazada.]],
[[Em mim foi sempre menor a intensidade das sensações que a intensidade da sesação dellas.]],
[[O silencio que sahe do som da chuva espalha-se, num crescendo de monotonia cinzenta, pela rua estreita que fito.]],
[[A grande terra, que serve os mortos, serviria, menos maternalmente, esses papeis.]],
[[Em cada pingo de chuva a minha vida falhada chora na natureza.]],
[[Como nos nas horas em que a trovoada se prepara e os ruidos da rua fallam alto com uma voz separada.]],
[[Ninguem estava quem era, e o patrão Vasques appareceu á porta do gabinete para pensar em dizer qualquer coisa.]],
[[Vem ahi uma grande trovoada; disse o Moreira, e voltou a pagina do Razão.]],
[[E então, em plena vida, é que o sonho tem grandes cinemas.]],
[[Lêr é sonhar pela mão de outrem.]],
[[Devo ao ser guarda-livros grande parte do que posso sentir e pensar como a negação e a fuga do cargo.]],
[[Durmo sobre os cotovelos onde o corrimão me doe, e sei de nada como um grande prometimento.]],
[[Sentado á janella, contemplo com os sentidos todos esta coisa nenhuma da vida universal que está lá fóra.]],
[[Já me cansa a rua, mas não, não me cansa — tudo é rua na vida.]],
[[Mergulhou na sombra como quem entra na porta onde chega.]],
[[Para mim os pormenores são coisas, vozes, frases.]],
[[Entre mim e a vida há um vidro tenue.]],
[[Não toquemos na vida nem com as pontas dos dedos.]],
[[Não era isto, porém, que eu queria dizer.]],
[[Minha alma está hoje triste até ao corpo.]],
[[Eu não sei quem tu és, mas sei ao certo o que sou?]],
[[Pasmo sempre quando acabo qualquer coisa.]],
[[É uma oleographia sem remedio.]],
[[Toda a vida é um somno.]],
[[Não consegui nunca ver-me de fóra.]],
[[Jogar ás escondidas com a nossa consciencia de viver.]],
[[A arte livra-nos illusoriamente da sordidez de sermos.]]}



-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local physics = require( "physics" )
local EventID = 0

local headers = {}
  
headers["Content-Type"] = "application/x-www-form-urlencoded"
headers["Accept-Language"] = "en-US"
  
local event

local body
 
local params = {}

local player = display.newRect(50,50,50,50)
player.score = 0
player.jumps = 4

local function networkListener( event )
 
    if ( event.isError ) then
        print( "Network error: ", event.response )
    else
        print ( "RESPONSE: " .. event.response )
    end
end

local onSystem = function( event )
    if event.type == "applicationSuspend" then
        if (event.type == "applicationExit") then 
    		EventID = EventID + 1
        	print(system.getTimer(), "," , EventID, ", END ,", system.getInfo("deviceID"))

            event = "App: Runner"..",    "..EventID..","..system.getTimer()..",".." END "..","..system.getInfo("deviceID")

            body = "log="..event;
             
            params = {}
            params.headers = headers
            params.body = body
              
            network.request( "http://luislucaspereira.net/mofd/data/", "POST", networkListener, params )
        
    	elseif ( event.type == "applicationSuspend" ) then
        	EventID = EventID + 1
        	print(system.getTimer(), "," , EventID, ", SUSPEND ,", system.getInfo("deviceID"))

            event = "App: Runner"..", "..EventID..",".." Score: "..player.score..","..system.getTimer()..",".." SUSPEND "..","..system.getInfo("deviceID")

            body = "log="..event;
             
            params = {}
            params.headers = headers
            params.body = body
              
            network.request( "http://luislucaspereira.net/mofd/data/", "POST", networkListener, params )    
        end
    end
end



local textScore = display.newText(player.score, 20,20,native.systemFont)
textScore:setFillColor(0,0,0)

local writing = display.newGroup()
local words = display.newGroup()
local currentWordIndex = 1

player.speed = 6

local createword

word_list = {}

local counter = 0

local wordspeed = 20

local function update()
	local wordspeed 
	player.score = player.score + 1
	player.y = player.y + player.speed
	if (player.speed < 6) then
		player.speed = player.speed + 1
	end
	textScore.text = player.score
	words[1].x = words[1].x - 20 - player.speed/10
	if player.y > 360 then 

		event = "App: Runner"..", "..EventID..","..system.getTimer()..",".." DEATH "..",".." Score: "..player.score..","..system.getInfo("deviceID")

		player.score = 0 
		player.y = 0

		body = "log="..event;
		 
		params = {}
		params.headers = headers
		params.body = body
		  
		network.request( "http://luislucaspereira.net/mofd/data/", "POST", networkListener, params )
	end

	if player.y < 10 then 
		player.y = 10
	end
	if player.x < 20 then 
		player.x = 20
	end
	if (words[1].x < 0- (words[1].width / 2)-player.score) then
		
		local texto_escolhido = math.random(1, 28)
		createword(texto[texto_escolhido],880)
		words:remove(1)
	end

end

function createword(word, desiredX)
	local new_word = display.newText( word, desiredX, math.random(40, 280),"Times New Roman", 30  )
    new_word.text = word
    new_word:setFillColor(0,0,0)
    writing:insert(new_word)
    physics.start()
    physics.addBody( new_word,  "static",  {density=0.5, friction=6, bounce=0.3 } )
    words:insert(new_word)
end

local motionx = 0

local function movePlayer (event)
	player.y = player.y + motionx;
end
 

local function touchListener(event)
	

	if event.phase == "began" and counter == 0 and player.jumps > 0 then
		player.speed = -8
		player.jumps = player.jumps - 1
	end
end

--[[local function moveUp(action)
	if (action == true) then
		
	else

	end
end]]

--[[local function upListener(event)
	motionx = -10

	if event.phase == "ended" then
		motionx = 0
	end
end


local function downListener(event)
	motionx = 10

	if event.phase == "ended" then
		motionx = 0
	end
end
]]--

local background = display.newRect( 240, 160, 480, 320 )
background:setFillColor(1,1,1)
writing:insert(background)
writing:insert(textScore)
writing:insert(player)

player:setFillColor(0,0,0)

player.x = display.contentWidth/6 
player.y = display.contentHeight/2

local texto_escolhido = math.random(1, 28)



createword(texto[texto_escolhido],440)

--createword(word_list[1], 440)
--createword(word_list[2], 240)

times = timer.performWithDelay(1, update, -1)

--[[local up = display.newImage("up.png")
 
local down = display.newImage("down.png")

up.x = 440
up.y = 280

down.x = 40
down.y = 280

down:addEventListener("touch", downListener)
up:addEventListener("touch", upListener)]]



Runtime:addEventListener("enterFrame", movePlayer)


local function onLocalCollision( self, event )
	if (event.target.y < event.other.y) then
		player.jumps = 4
	end
end

physics.start()
physics.addBody( player, "dynamic" )
physics.setGravity(0,0)
player.collision = onLocalCollision
player:addEventListener( "collision")

writing:addEventListener("touch", touchListener)

Runtime:addEventListener( "system", onSystem )


event = "App: Runner"..", "..EventID..","..system.getTimer()..",".." START "..","..system.getInfo("deviceID")

body = "log="..event;
 
params = {}
params.headers = headers
params.body = body
  
network.request( "http://luislucaspereira.net/mofd/data/", "POST", networkListener, params )




local function handleButton2Event( event )
 
    if ( "ended" == event.phase ) then
        local screenshotDirectory = system.DocumentsDirectory
        display.save(writing, "screengrab.jpg", screenshotDirectory)

    	facebook.login( facebookListener )
        facebook.request( "me/photos", "POST", attachment )
    end
end

local button2 = widget.newButton(
    {
        left = 280,
        top = 10,
        id = "button2",
        defaultFile = "facebook.png",
        onEvent = handleButton2Event
    }
)

if system.getInfo("model") == "iPad" then
	button2.x = 290
	button2.y = 10
end

if system.getInfo("model") == "iPhone" then
	button2.x = 270
	button2.y = 10
end

local function handleButtonEvent( event )
 
    if ( "ended" == event.phase ) then
    	button2:removeSelf()
    	timer.cancel(times)
    	words:remove(1)
    	Runtime:removeEventListener("enterFrame", movePlayer)
    	player:removeSelf()
        composer.removeScene("menu")
        composer.gotoScene( "menu" )
    end
end

local button = widget.newButton(
    {
        left = 340,
        top = 0,
        id = "button",
        label = "Menu",
        onEvent = handleButtonEvent
    }
)

return scene