----------------------------------------->>
-- GTI: Grand Theft International
-- Date: 11 Apr 2014
-- Resource: GTIdroidApps/camera_gui.lua
-- Type: Client Side
-- Author: LittleDollar (LilDolla)
----------------------------------------->>
local showCamera
local screen
local taken = false
local show = false
local GTIPhone = exports.GTIdroid:getGTIDroid()
local X_OFF,Y_OFF = 17, 88
local r, g, b = 255, 255, 255

-- Camera Picture Saving
----------------->>
addEvent("saveMobilePicture",true)
addEventHandler( "saveMobilePicture", resourceRoot,
    function( data, tag, timestamp)
        if image then
            destroyElement(image)
        end
        image = dxCreateTexture( data)
		--
		local realTime = getRealTime()
		date = string.format("%04d/%02d/%02d", realTime.year + 1900, realTime.month + 1, realTime.monthday )
		time = string.format("%02d:%02d", realTime.hour, realTime.minute )
		--
		local picture = fileCreate( "@:GTIdroidApps/screenshots/"..timestamp..".png")
		if picture then
			fileWrite( picture, data)
			fileClose( picture)
		end
		if fileExists( "@:GTIdroidApps/screenshots/"..timestamp..".png") then
			local saves = xmlLoadFile("@:GTIdroidApps/screenshots.xml")
			if not saves then
				local saves = xmlCreateFile("@:GTIdroidApps/screenshots.xml", "shots")
				local line = xmlCreateChild( saves, "shot")
				xmlNodeSetAttribute( line, "name", date.." "..time)
				xmlNodeSetAttribute( line, "file", timestamp)
				xmlSaveFile( saves)
				xmlUnloadFile( saves)
			else
				local line = xmlCreateChild( saves, "shot")
				xmlNodeSetAttribute( line, "name", date.." "..time)
				xmlNodeSetAttribute( line, "file", timestamp)
				xmlSaveFile( saves)
				xmlUnloadFile( saves)
			end
		end
    end
)

-- Camera DX
----------------->>

addEventHandler("onClientRender", root,
    function()
		if (not showCamera) then return end
		local x,y = guiGetPosition(GTIPhone, false)
		local x,y = x+X_OFF-278, y+Y_OFF-232
		dxUpdateScreenSource( screen)
		if show == false then
			dxDrawImage(278+x, 232+y, 278, 402, screen, 0, 0, 0, tocolor(r, g, b, 255), true)
			dxDrawImage(504+x, 582+y, 48, 48, "images/snap.png", 0, 0, 0, tocolor(r, g, b, 255), true)
		elseif show == true then
			if image then
				if taken == true then return end
				dxDrawImage( 278+x, 232+y, 278, 402, image)
			end
		end
    end
)

function setShow( state)
	if state == true then
		show = true
	else
		show = false
	end
end

local disabledHUD = {"health", "armour", "breath", "clock", "money", "weapon", "ammo", "vehicle_name", "radar"}

function setBlink( state)
	if state == true then
		r, g, b = 0, 0, 0
		taken = true
	else
		r, g, b = 255, 255, 255
		taken = false
		setShow( true)
		setTimer( setShow, 2500, 1, false)
	end
end

addEventHandler( "onClientClick", root,
	function ( _, state, mX, mY )
		if (not showCamera) then return end
		local x,y = guiGetPosition(GTIPhone, false)
		local x,y = x+X_OFF-278, y+Y_OFF-232
        --if ( mX >= 390+x and mX <= (390+x) + 48 and mY >= (584+y) and mY <= 584+y + 48 ) then
		if ( mX >= 490+x and mX <= (490+x) + 48 and mY >= (574+y) and mY <= 574+y + 48 ) then
			if state == "down" then
				if not isTimer( onAntiSnap) then
					setBlink( true)
					triggerServerEvent( "onCameraPictureTaken", localPlayer)
					setTimer( setBlink, 1750, 1, false)
					onAntiSnap = setTimer( function() end, 1750, 1)
				end
			end
        end
    end
)

-- Toggle Camera DX
------------------------>>

function toggleCamera()
	showCamera = nil
	exports.GTIdroid:showMainMenu(true)
	GTICameraApp = exports.GTIdroid:getGTIDroidAppButton("Camera")
	--
	addEventHandler("onClientGUIClick", root,
		function()
			if source == GTICameraApp then
				if (not showCamera) then
					showCamera = true
					exports.GTIdroid:showMainMenu(false)
					screen = dxCreateScreenSource ( 277, 349)
				else
					showCamera = nil
					exports.GTIdroid:showMainMenu(true)
				end
			end
		end
	)
end
addEventHandler("onClientResourceStart", resourceRoot, toggleCamera)
-- Prevent Bugs when GTIdroid is restarted
addEvent("onGTIPhoneCreate", true)
addEventHandler("onGTIPhoneCreate", root, toggleCamera)

function hideCamera()
	showCamera = nil
	exports.GTIdroid:showMainMenu(true)
end
addEvent("onGTIDroidClickBack", true)
addEvent("onGTIDroidClose", true)
addEventHandler("onGTIDroidClickBack", root, hideCamera)
addEventHandler("onGTIDroidClose", root, hideCamera)
addEventHandler("onClientResourceStop", resourceRoot, hideCamera)
