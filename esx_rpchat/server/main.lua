--[[

  ESX RP Chat

--]]
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.PlayerData = xPlayer

local danePostaci = {}

TriggerEvent('es:addGroupCommand', 'reloadchatnames', 'admin', function(source, args, user)
	TriggerClientEvent('esx_rpchat:reloadNames', -1)
end, function(source, args, user)
end)

RegisterNetEvent('route68_chat:updateName') 
AddEventHandler('route68_chat:updateName', function()
  getIdentityToArray(source)
end)

RegisterNetEvent('route68:dzwonekPolicyjny')
AddEventHandler('route68:dzwonekPolicyjny', function()
	TriggerClientEvent("sendProximityMessagePoliceDzwonek", -1, 'Ktoś oczekuje funkcjonariusza na komendzie!')
end)

RegisterNetEvent('route68:dzwonekEMS')
AddEventHandler('route68:dzwonekEMS', function()
	TriggerClientEvent("sendProximityMessageEMSDzwonek", -1, 'Ktoś oczekuje medyka w szpitalu!')
end)


--[[]]--

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
		}
	else
		return nil
	end
end

function getIdentityToArray(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]
		local znaleziono = false

		for i=1, #danePostaci do
			if tostring(danePostaci[i].identifier) == tostring(identifier) then
				znaleziono = true
				danePostaci[i].phone_number = identity['phone_number']
				break
			end
		end

		if znaleziono == false then
			table.insert(danePostaci, {
				identifier = identifier,
				phone_number = identity['phone_number']
			})
		end

	end
end

 AddEventHandler('chatMessage', function(source, name, message)
      if string.sub(message, 1, string.len("/")) ~= "/" then
          local name = getIdentity(source)
		TriggerClientEvent("sendProximityMessage", -1, source, source, message)
      end
      CancelEvent()
  end)
  
  RegisterNetEvent('menu:phone')
  AddEventHandler('menu:phone', function()
	local name = getIdentity(source)
	TriggerClientEvent("sendProximityMessagePhone", -1, source, source, name.phone_number)
  end)

TriggerEvent('es:addCommand', 'me', function(source, args, user)
    local name = getIdentity(source)
    TriggerClientEvent("sendProximityMessageMe", -1, source, source, table.concat(args, " "))

	local text = ''
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
	color = {r = 204, g = 152, b = 214, alpha = 255}
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, source, color)
end)

TriggerEvent('es:addCommand', 'if', function(source, args, user)
    local name = getIdentity(source)
		local czy = math.random(1, 2)
    TriggerClientEvent("sendProximityMessageCzy", -1, source, source, table.concat(args, " "), czy)

		local text = '' -- edit here if you want to change the language : EN: the person / FR: la personne
	    for i = 1,#args do
	        text = text .. ' ' .. args[i]
	    end
		color = {r = 106, g = 212, b = 176, alpha = 255}
		TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, source, color)
end)

TriggerEvent('es:addCommand', 'do', function(source, args, user)
    local name = getIdentity(source)
    TriggerClientEvent("sendProximityMessageDo", -1, source, source, table.concat(args, " "))

	local text = '' -- edit here if you want to change the language : EN: the person / FR: la personne
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
	color = {r = 83, g = 130, b = 201, alpha = 255}
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, source, color)
end)

--TriggerEvent('es:addCommand', 'me', function(source, args, user)
    --local name = getIdentity(source)
    --table.remove(args, 2)
    --TriggerClientEvent('esx-qalle-chat:me', -1, source, source, table.concat(args, " "))
--end)

RegisterCommand('tweet', function(source, args, rawCommand)
    -- local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(6)
    local name = getIdentity(source)
	local amount = 25
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getInventoryItem('Telefon').count
	if quantity > 0 then
    fal = name.firstname .. " " .. name.lastname
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-messagetwt"><div class="chat-message-header"><i class="fab fa-twitter"> <font color="white">{0}</font></i></div><div class="chat-message-body">{1}</div></div>',
        args = { fal, msg }
    })
	else
		TriggerClientEvent("pNotify:SendNotification", _source, {text = 'Nie masz przy sobie telefonu!'})
	end
end, false)

RegisterCommand('help', function(source, args, rawCommand)
    -- local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(3)
    local name = getIdentity(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    fal = "Podstawowe komendy chatu"
    TriggerClientEvent('chat:addMessage', source, {
        template = '<div class="chat-messagehelp"><div class="chat-message-header"><i class="fas fa-question"> <font color="white">{0}</font>:</i></div><div class="chat-message-body">{1}</div></div>',
        args = { fal,"Zwykła wiadomość - Local OOC, [/me], [/do], [/if] - Komendy narracyjne [/ad], [/news], [/news2] - Zamieszczenie ogłoszenia ($15) [/report] - Wiadomośc do admina" }
    })
end, false)

RegisterCommand('ad', function(source, args, rawCommand)
    -- local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(3)
    local name = getIdentity(source)
	local amount = 15
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getInventoryItem('Telefon').count
	if quantity > 0 then
    fal = "Ogłoszenie nadane przez " .. name.firstname .. ' ' .. name.lastname
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-messagead"><div class="chat-message-header"><i class="fab fa-twitter"> <font color="white">{0}</font></i></div><div class="chat-message-body">{1}</div></div>',
        args = { fal, msg }
    })
	TriggerClientEvent("pNotify:SendNotification", source, {text = "Zapłaciłeś/aś $15 za nadanie Ogłoszenia"})
	xPlayer.removeAccountMoney('bank', amount)
	else
		TriggerClientEvent("pNotify:SendNotification", _source, {text = 'Nie masz przy sobie telefonu!'})
	end
end, false)

RegisterCommand('dark', function(source, args, rawCommand)
    -- local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(5)
    local name = getIdentity(source)
	local amount = 50
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    fal = "DarkChat"
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-messagead"><div class="chat-message-header"><i class="fas fa-book-dead"> <font color="white">{0}</font></i></div><div class="chat-message-body">{1}</div></div>',
        args = { fal, msg }
    })
	TriggerClientEvent("pNotify:SendNotification", source, {text = "Zapłaciłeś/aś $50 za wysłanie Wiadomości"})
	xPlayer.removeAccountMoney('bank', amount)
end, false)

RegisterCommand('ems', function(source, args, rawCommand)
    -- local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(4)
    local name = getIdentity(source)
	fal = "EMS & Fire"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	if xPlayer.job.name == 'fire' then
		--if grade == 'chirurg' or grade == 'special' or grade == 'preboss' or grade == 'boss' then
			TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(239, 83, 69, 0.9); border-radius: 3px;"><i class="fas fa-ambulance"></i>&nbsp; {0}: {1}</div>',
			args = { fal, msg }
			})
		--end
	end
end, false)

RegisterCommand('policenews', function(source, args, rawCommand)
    -- local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(13)
    local name = getIdentity(source)
	fal = "WIADOMOŚĆ OD SŁUŻB - POLICE"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	if xPlayer.job.name == 'police' then
		--if grade == 'lieutenant' or grade == 'chef' or grade == 'boss' then
			TriggerClientEvent('chat:addMessage', -1, {
			template = '<div class="chat-messagepd"><div class="chat-message-header"><i class="fas fa-balance-scale"> <font color="white">{0}</font></i></div><div class="chat-message-body">{1}</div></div>',
			args = { fal, msg }
			})
		--end
	end
end, false)

--[[RegisterCommand('opis', function(source, opis, rawCommand)
	local opis = rawCommand:sub(5)
	TriggerClientEvent("esx_rpchat:opis", source, opis)
end, false)]]

--[[RegisterCommand('bcso', function(source, args, rawCommand)
    -- local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(5)
    local name = getIdentity(source)
	fal = "BCSO"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	if xPlayer.job.name == 'police' then
		--if grade == 'lieutenant' or grade == 'chef' or grade == 'boss' then
			TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(124, 66, 0, 0.9); border-radius: 3px;"><i class="fas fa-balance-scale"></i>&nbsp; {0}: {1}</div>',
			args = { fal, msg }
			})
		--end
	end
end, false)]]

RegisterCommand('mech', function(source, args, rawCommand)
    -- local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(5)
    local name = getIdentity(source)
	fal = "Warsztat"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	if xPlayer.job.name == 'mechanic' then
			TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(232, 87, 9, 0.9); border-radius: 3px;"><i class="fas fa-wrench"></i>&nbsp; {0}: {1}</div>',
			args = { fal, msg }
			})
	end
end, false)

RegisterCommand('admin', function(source, args, rawCommand)
	-- local playerName = GetPlayerName(source)
	if source ~= 0 then
		local msg = rawCommand:sub(6)
		local name = getIdentity(source)
		fal = "ADMIN"
		local xPlayer = ESX.GetPlayerFromId(source)
		local grade = xPlayer.job.grade_name
		local grupos = getIdentity(source)

		MySQL.Async.fetchAll('SELECT * FROM users WHERE @identifier=identifier', {
			['@identifier'] = xPlayer.getIdentifier()
		}, function(result)
			if result[1] then
					--local przebieg = result[1].przebieg
					local rola = result[1].group
					--TriggerClientEvent("sendProximityMessagePrzebieg", -1, source, wynik)
					if rola ~= "mod" then
							TriggerClientEvent('chat:addMessage', -1, {
							template = '<div class="chat-messageadmin"><div class="chat-message-header"><i class="fas fa-shield-alt"> <font color="white">{0}</font></i></div><div class="chat-message-body">{1}</div></div>',
							args = { fal, msg }
							})
					end
			end
		end)
	else
		local msg = rawCommand:sub(6)
		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div class="chat-messageadmin"><div class="chat-message-header"><i class="fas fa-shield-alt"> <font color="white">{0}</font></i></div><div class="chat-message-body">{1}</div></div>',
			args = { "ADMIN", msg }
		})
	end
end, false)

RegisterCommand('sg', function(source, args, rawCommand)
    -- local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(3)
    local name = getIdentity(source)
	fal = "State Government"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	local grupos = getIdentity(source)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE @identifier=identifier', {
		['@identifier'] = xPlayer.getIdentifier()
	}, function(result)
		if result[1] then
				--local przebieg = result[1].przebieg
				local rola = result[1].group
				--TriggerClientEvent("sendProximityMessagePrzebieg", -1, source, wynik)
				if rola == "superadmin" then
					TriggerClientEvent('chat:addMessage', -1, {
						template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(2, 31, 53, 0.8); border-radius: 3px;"><i class="fas fa-crown"></i>&nbsp; {0}: {1}</div>',
						args = { fal, msg }
					})
				end
		end
	end)
end, false)

RegisterCommand('news', function(source, args, rawCommand)
    -- local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(5)
    local name = getIdentity(source)
	fal = "Weazel News"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	if xPlayer.job.name == 'police' then
			TriggerClientEvent('chat:addMessage', -1, {
			template = '<div class="chat-messagenews"><div class="chat-message-header"><i class="fas fa-shield-alt"> <font color="white">{0}</font></i></div><div class="chat-message-body">{1}</div></div>',
			args = { fal, msg }
			})
	end

end, false)

RegisterCommand('news2', function(source, args, rawCommand)
    -- local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(6)
    local name = getIdentity(source)
	fal = "Daily Route"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	if xPlayer.job.name == 'reporter' then
			TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(0, 90, 0, 0.9); border-radius: 3px;"><i class="fas fa-broadcast-tower"></i>&nbsp; {0}: <br>{1}</div>',
			args = { fal, msg }
			})
	end
end, false)

RegisterCommand('sunshine', function(source, args, rawCommand)
    -- local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(9)
    local name = getIdentity(source)
	fal = "Sunshine Autos"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	if xPlayer.job.name == 'cardealer' then
			TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(0, 90, 0, 0.9); border-radius: 3px;"><i class="fas fa-car"></i>&nbsp; {0}: <br>{1}</div>',
			args = { fal, msg }
			})
	end
end, false)
RegisterCommand('kasyno', function(source, args, rawCommand)
    -- local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(7)
    local name = getIdentity(source)
	fal = "Diamond Casino"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	if xPlayer.job.name == 'angels' then
			TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(135, 61, 255, 0.9); border-radius: 3px;"><i class="fas fa-gem"></i>&nbsp; {0}: <br>{1}</div>',
			args = { fal, msg }
			})
	end
end, false)
RegisterCommand('silownia', function(source, args, rawCommand)
    -- local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(9)
    local name = getIdentity(source)
	fal = "Cobra Gym"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	if xPlayer.job.name == 'silownia' then
			TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(91, 201, 60, 0.9); border-radius: 3px;"><i class="fas fa-dumbbell"></i>&nbsp; {0}: <br>{1}</div>',
			args = { fal, msg }
			})
	end
end, false)

AddEventHandler('chatMessage', function(source, color, msg)
	cm = stringsplit(msg, " ")
	if cm[1] == "/reply" then
		local xPlayer = ESX.GetPlayerFromId(source)
		CancelEvent()
		if tablelength(cm) > 1 then
			local tPID = tonumber(cm[2])
			local names2 = GetPlayerName(tPID)
			local names3 = GetPlayerName(source)
			local textmsg = ""
			for i=1, #cm do
				if i ~= 1 and i ~=2 then
					textmsg = (textmsg .. " " .. tostring(cm[i]))
				end
			end
			local grupos = getIdentity(source)
			MySQL.Async.fetchAll('SELECT * FROM users WHERE @identifier=identifier', {
				['@identifier'] = xPlayer.getIdentifier()
			}, function(result)
				if result[1] then
						--local przebieg = result[1].przebieg
						local rola = result[1].group
						--TriggerClientEvent("sendProximityMessagePrzebieg", -1, source, wynik)
						if rola ~= "user" then
							TriggerClientEvent('textmsg', tPID, source, textmsg, names2, names3)
					    	TriggerClientEvent('textsent', source, tPID, names2)
						end
				end
			end)
		end
	end
end)

--[[
        RegisterCommand('ooc', function(source, args, rawCommand)
    -- local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(5)
    local name = getIdentity(source)

    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(41, 41, 41, 0.9); border-radius: 3px;"><i class="fas fa-globe"></i>&nbsp; {0}:<br> {1}</div>',
        args = { playerName, msg }
    })
end, false)
]]--

RegisterServerEvent('esx_rpchat:shareDisplay')
AddEventHandler('esx_rpchat:shareDisplay', function(text, color)
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, source, color)
end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

ESX.RegisterUsableItem('coin', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
		local name = getIdentity(_source)
		local wynik = math.random(1, 100)

    TriggerClientEvent('esx_rpchat:moneta', -1, source, wynik)
end)
