local dbF, dbT, bTable, bhTable = "GTIhousesData.db", "sqlite", "businesses", "buildableZones"
busData = {}
buildData = {}
object = {}

function createBusiness( add, id, name, owned, owner, x, y, z, cost, type, level, build, pay, desc, show)
	if add then
		table.insert( busData, { id, name, owned, owner, x, y, z, cost, type, level, build, pay, desc})
		dbQuery( db, "INSERT INTO `"..bTable.."`( id, name, x, y, z, owned, account, cost, type, level, buildable, payout, description) VALUES( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", id, name, x, y, z, owned, owner, cost, type, level, "false", pay, desc)
	end
	if not show then
		triggerClientEvent( root, "GTIbusiness.addBusiness", root, id, name, owned, owner, x, y, z, cost, type, level, false)
	else
		triggerClientEvent( show, "GTIbusiness.addBusiness", show, id, name, owned, owner, x, y, z, cost, type, level, getPlayerName( show))
	end
end
addEvent( "GTIbusiness.createBusiness", true)
addEventHandler( "GTIbusiness.createBusiness", root, createBusiness)

function createBuilding( id, oid, x, y, z, rot)
	if isElement( object[id]) ~= true then
		object[id] = createObject( oid, x, y, z, 0, 0, rot)
		dbQuery( db, "INSERT INTO `"..bhTable.."`( id, objectID, x, y, z, rot) VALUES( ?, ?, ?, ?, ?, ?)", id, oid, x, y, z, rot)
	elseif isElement( object[id]) then
		destroyElement( object[id])
		object[id] = createObject( oid, x, y, z, 0, 0, rot)
		dbExec( db, "UPDATE `"..bhTable.."` SET `newID`=?,`x`=?,`y`=?,`z`=?,`rot`=? WHERE `id`=?", oid, x, y, z, rot, id)
	end
end
addEvent( "GTIbusiness.createBuilding", true)
addEventHandler( "GTIbusiness.createBuilding", root, createBuilding)

addEventHandler( 'onResourceStart', resourceRoot,
	function()
		db = dbConnect( dbT, dbF)
		--db = dbConnect( "mysql", "dbname=gtishared;host=127.0.0.1", "LilDolla", "haUNWUd!52Bf")
		--Business Database
		--dbExec ( db, "CREATE TABLE IF NOT EXISTS `??`(id INT, name TEXT, x INT, y INT, z INT, owned TEXT, account TEXT, cost INT, type TEXT, level INT, buildable TEXT, payout INT, description TEXT, PRIMARY KEY(id))", bTable)
		dbExec ( db, "CREATE TABLE IF NOT EXISTS `??`(id INT, name TEXT, newName TEXT, x INT, y INT, z INT, owned TEXT, account TEXT, cost INT, newCost INT, type TEXT, level INT, buildable TEXT, payout INT, description TEXT, PRIMARY KEY(id))", bTable)
		--Building Database
		--dbExec ( db, "CREATE TABLE IF NOT EXISTS `??`(id INT, objectID INT, newID INT, x INT, y INT, z INT, rot INT, PRIMARY KEY(id))", bhTable)
		dbExec ( db, "CREATE TABLE IF NOT EXISTS `??`(id INT, objectID INT, newID INT, x INT, y INT, z INT, rot INT, PRIMARY KEY(id))", bhTable)
		--
		local bd = dbQuery( loadBusinesses, db, "SELECT * FROM `"..bTable.."`")
		local bhd = dbQuery( loadBuildings, db, "SELECT * FROM `"..bhTable.."`")
	end
)

function getIDName( id)
	if not id then return end
	for index, bData in ipairs ( busData) do
		if string.find(index, id) then
			local x, y, z = bData[5], bData[6], bData[7]
			local zone = getZoneName( x, y, z)
			local name = bData[2]
			return zone.." "..name
		end
	end
end

function loadBuildings( bhd)
	local bhData = dbPoll( bhd, 0)
	for id, bhData in ipairs(bhData) do
		local id, oid, cid = bhData['id'], bhData['objectID'], bhData['newID']
		local x, y, z, rot = bhData['x'], bhData['y'], bhData['z'], bhData['rot']
		--
		if id then
			if cid == "" then
				table.insert(buildData, {id, oid, x, y, z, rot})
				createBuilding( id, oid, x, y, z, rot)
			else
				if tonumber( cid) then
					table.insert(buildData, {id, cid, x, y, z, rot})
					createBuilding( id, cid, x, y, z, rot)
				else
					table.insert(buildData, {id, oid, x, y, z, rot})
					createBuilding( id, oid, x, y, z, rot)
				end
			end
		end
	end
end

function loadBusinesses( bd)
	local bData = dbPoll( bd, 0)
	for id, bData in ipairs(bData) do
		local x, y, z = bData['x'], bData['y'], bData['z']
		local owned, owner, cost, name = bData['owned'], bData['account'], bData['cost'], bData['name']
		local busType, busLevel, buildable, payout, desc = bData['type'], bData['level'], bData['buildable'], bData['payout'], bData['description']
		--
		local newName, newCost = bData['newName'], bData['newCost']
		--
		if tonumber( newCost) then
			if newName ~= "" and newName ~= " " and newName ~= nil then
				table.insert(busData, {id, newName, owned, owner, x, y, z, newCost, busType, busLevel, buildable, payout, desc})
				createBusiness( false, id, newName, owned, owner, x, y, z, newCost, busType, busLevel, buildable, payout, desc)
			else
				table.insert(busData, {id, name, owned, owner, x, y, z, newCost, busType, busLevel, buildable, payout, desc})
				createBusiness( false, id, name, owned, owner, x, y, z, newCost, busType, busLevel, buildable, payout, desc)
			end
		else
			if newName ~= "" and newName ~= " " and newName ~= nil then
				table.insert(busData, {id, newName, owned, owner, x, y, z, cost, busType, busLevel, buildable, payout, desc})
				createBusiness( false, id, newName, owned, owner, x, y, z, cost, busType, busLevel, buildable, payout, desc)
			else
				table.insert(busData, {id, name, owned, owner, x, y, z, cost, busType, busLevel, buildable, payout, desc})
				createBusiness( false, id, name, owned, owner, x, y, z, cost, busType, busLevel, buildable, payout, desc)
			end
		end
	end
end

function verifyBusinessOwnership( theID, viewGUI)
	if not theID then return end
	for index, bData in ipairs ( busData) do
		if string.find(index, theID) then
			local owner = bData[4]
			local possibility = bData[11]
			local requester = getAccountName( getPlayerAccount( source))
			if string.find( owner, requester, 1) then
				--outputChatBox( "Owner of B"..theID.." is account "..owner.." (Your Acc: "..requester..")", source)
				if viewGUI == true then
					if possibility == true or possibility == "true" then
						if isElement( object[tonumber(theID)]) then
							local x, y, z = getElementPosition( object[tonumber(theID)])
							local pX, pY, pZ = getElementPosition( source)
							local distance = math.floor(getDistanceBetweenPoints3D( pX, pY, pZ, x, y, z))
							if distance <= 150 then
								if isPedOnGround( source) then
									triggerClientEvent( source, "GTIbb.viewEditor", source, bData[2], getZoneName( bData[5], bData[6], bData[7]), theID, bData[8])
									outputChatBox( "Fetching '"..getIDName( theID).."' details", source, 92, 179, 255)
								else
									outputChatBox( "You need to be on the ground before editing '"..getIDName( theID).."'", source, 145, 92, 96)
								end
							else
								outputChatBox( "You need to be closer to '"..getIDName( theID).."' before you can edit the building ("..(distance-150).."m)", source, 145, 92, 96)
							end
						else
							triggerClientEvent( source, "GTIbb.viewEditor", source, bData[2], getZoneName( bData[5], bData[6], bData[7]), theID, bData[8])
							outputChatBox( "Fetching '"..getIDName( theID).."' details", source, 92, 179, 255)
						end
					else
						outputChatBox( "'"..getIDName( theID).."' is not a buildable lot", source, 145, 92, 96)
					end
				elseif viewGUI == "getObject" then
					if possibility == true or possibility == "true" then
						outputChatBox( "Fetching '"..getIDName( theID).."' object data", source, 92, 179, 255)
						triggerClientEvent( source, "GTIbb.pushData", source, theID, getZoneName( bData[5], bData[6], bData[7]), theID, bData[8])
					else
						outputChatBox( "'"..getIDName( theID).."' is not a buildable lot", source, 145, 92, 96)
					end
				else
					if not isTimer( antiOwn) then
						outputChatBox( "You currently own "..getIDName( theID), source, 92, 179, 255)
						antiOwn = setTimer( function() end, 1000, 1)
					end
				end
			end
		end
	end
end
addEvent( "GTIbusiness.verifyBusinessOwnership", true)
addEventHandler( "GTIbusiness.verifyBusinessOwnership", root, verifyBusinessOwnership)

function editBusiness( id, newName, newCost, newDesc)
	local requester = getAccountName( getPlayerAccount( source))
	for index, bData in ipairs ( busData) do
		if string.find(index, id) then
			local owned = bData[3]
			local owner = bData[4]
			local cost = bData[8]
			local name = bData[2]
			local x, y, z = bData[5], bData[6], bData[7]
			local busType, busLevel, buildable, pay, desc = bData[9], bData[10], bData[11], bData[12], bData[13]
			if string.find( owner, requester) then
				bData[2] = newName
				bData[8] = newCost
				bData[13] = newDesc
				dbExec( db, "UPDATE `"..bTable.."` SET `newName`=?,`newCost`=?,`description`=? WHERE `id`=?", newName, newCost, newDesc, id)
				triggerClientEvent( root, "GTIbusiness.updateClientData", root, "edited", id, newName, x, y, z, newCost, requester)
			end
		end
	end
end
addEvent( "GTIbusiness.editBusiness", true)
addEventHandler( "GTIbusiness.editBusiness", root, editBusiness)

function executeBusinessOption( theOption, id)
	if not theOption and id then return end
	local playerMoney = getPlayerMoney( source)
	local requester = getAccountName( getPlayerAccount( source))
	if theOption == "buy" then
		for index, bData in ipairs ( busData) do
			if string.find( index, id) then
				local owner = bData[4]
				local cost = bData[8]
				local name = bData[2]
				local x, y, z = bData[5], bData[6], bData[7]
				local busType, busLevel, buildable, location, pay, desc, accName = bData[9], bData[10], bData[11], bData[12], bData[13]
				--if owner == "false" or owner == false then
				if string.find( owner, "false") then
					if not isTimer( antiSpam) then
						if playerMoney >= cost then
							takePlayerMoney( source, cost)
							outputChatBox( "You have bought '"..getIDName( id).."' for $"..formatNumber(cost), source, 92, 145, 96)
							triggerClientEvent( root, "GTIbusiness.updateClientData", root, "bought", id, name, x, y, z, cost, requester)
							dbExec( db, "UPDATE `"..bTable.."` SET `owned`=?,`account`=? WHERE `id`=?", "true", requester, id)
							bData[3] = "true"
							bData[4] = requester
						else
							outputChatBox( "You don't have enough money to buy '"..getIDName( id).."' ($"..formatNumber(cost)..")", source, 145, 92, 96)
						end
						antiSpam = setTimer( function() end, 5000, 1)
					end
				end
			end
		end
	elseif theOption == "sell" then
		for index, bData in ipairs ( busData) do
			if string.find(index, id) then
				local owned = bData[3]
				local owner = bData[4]
				local cost = bData[8]
				local name = bData[2]
				local x, y, z = bData[5], bData[6], bData[7]
				local busType, busLevel, buildable, location, pay, desc, accName = bData[9], bData[10], bData[11], bData[12], bData[13]
				if string.find( owner, requester) then
					givePlayerMoney( source, cost)
					outputChatBox( "You have sold '"..getIDName( id).."' for $"..formatNumber(cost), source, 92, 179, 255)
					if isElement( object[tonumber(id)]) then
						destroyElement( object[tonumber(id)])
						dbExec( db, "DELETE FROM `"..bhTable.."` WHERE `id`=?", id)
					end
					bData[3] = "false"
					bData[4] = "false"
					dbExec( db, "UPDATE `"..bTable.."` SET `owned`=?,`account`=?,`newName`=?,`newCost`=? WHERE `id`=?", "false", "false", name, cost, id)
					triggerClientEvent( root, "GTIbusiness.updateClientData", root, "sold", id, name, x, y, z, cost, "false")
				end
			end
		end
	end
end
addEvent( "GTIbusiness.executeBusinessOption", true)
addEventHandler( "GTIbusiness.executeBusinessOption", root, executeBusinessOption)

function getBusinessDetails( theID, input)
	if not theID then return end
	for index, bData in ipairs( busData) do
		--if index == theID then
		if string.find( theID, index, 1) then
			local x, y, z = bData[5], bData[6], bData[7]
			local owned, owner, cost, name = bData[3], bData[4], bData[8], bData[2]
			local busType, busLevel, buildable = bData[9], bData[10], bData[11]
			local pay, desc = bData[12], bData[13]
			local location = getZoneName( x, y, z)
			if input then
				if input == true then
					triggerClientEvent( source, "GTIbusiness.inputInformation", source, theID, owned, owner, cost, name, busType, busLevel, buildable, location, pay, desc)
				elseif input == "e" then
					triggerClientEvent( source, "GTIbusiness.getOldInformation", source, theID, owned, owner, cost, name, busType, busLevel, buildable, location, pay, desc)
				end
			else
				local account = getAccount( owner)
				local accountName = getAccountName( getPlayerAccount( source))
				if account then
					if string.find( owner, accountName) then
						triggerClientEvent( source, "GTIbb.showAdvanced", source, true)
					else
						triggerClientEvent( source, "GTIbb.showAdvanced", source, false)
					end
					triggerClientEvent( source, "GTIbusiness.inputInformation", source, theID, owned, owner, cost, name, busType, busLevel, buildable, location, pay, desc, accountName)
				else
					triggerClientEvent( source, "GTIbusiness.inputInformation", source, theID, owned, owner, cost, name, busType, busLevel, buildable, location, pay, desc, accountName)
					triggerClientEvent( source, "GTIbb.showAdvanced", source, false)
				end
			end
		end
	end
end
addEvent( "GTIbusiness.getBusinessDetails", true)
addEventHandler( "GTIbusiness.getBusinessDetails", root, getBusinessDetails)

function loadCachedBusinesses()
	if isElement( source) then
		for id, bData in ipairs(busData) do
			local x, y, z = bData[5], bData[6], bData[7]
			local owned, owner, cost, name = bData[3], bData[4], bData[8], bData[2]
			local busType, busLevel, buildable = bData[9], bData[10], bData[11]
			--
			createBusiness( false, id, name, owned, owner, x, y, z, cost, busType, busLevel, buildable, source)
		end
	end
end
addEventHandler( "onPlayerLogin", root, loadCachedBusinesses)

function formatNumber(v)
	v = tonumber(v)
	if v then
		local s = string.format("%d", math.floor(v))
		local pos = string.len(s) % 3
		if pos == 0 then pos = 3 end
		return string.sub(s, 1, pos)
			.. string.gsub(string.sub(s, pos+1), "(...)", ",%1")
	else
		return false
	end
end
