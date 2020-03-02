--[[

  ESX RP Chat

--]]
ESX = nil

local praca = ''

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local zasieg = 0.5

RegisterNetEvent('route68:zasiegVoice')
AddEventHandler('route68:zasiegVoice', function(prox)
    zasieg = tonumber(prox) + 0.0
    print(tostring(zasieg))
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = ESX.GetPlayerData()
	praca = PlayerData.job.name
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	praca = job.name
end)

RegisterNetEvent('esx_rpchat:reloadNames')
AddEventHandler('esx_rpchat:reloadNames', function()
	TriggerServerEvent('route68_chat:updateName')
end)

RegisterNetEvent("textsent")
AddEventHandler('textsent', function(tPID, names2, textmsg)
	--TriggerEvent('chatMessage', "", {205, 205, 0}, " Reply sent to:^0 " .. names2 .."  ".."^0  - " .. tPID)
		TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(232, 27, 9, 0.9); border-radius: 3px;"><i class="fas fa-shield-alt"></i>&nbsp;[{0}] {1}</div>',
			args = { 'Wiadomość wysłana do [ID '..tPID..'] ', names2}
        })
end)

RegisterNetEvent("textmsg")
AddEventHandler('textmsg', function(source, textmsg, names2, names3 )
	--TriggerEvent('chatMessage', "", {205, 205, 0}, "  ADMIN " .. names3 .."  ".."^0: " .. textmsg)
		TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(232, 27, 9, 0.9); border-radius: 3px;"><i class="fas fa-shield-alt"></i>&nbsp;[{0}] {1}</div>',
			args = { 'Wiadomość od Admina ['..names3..'] ', textmsg}
        })
end)

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, name, message)
    local pid = GetPlayerFromServerId(id)
    local myId = PlayerId()
    
    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(70, 70, 70, 0.9); border-radius: 3px;"><i class="far fa-comment"></i>&nbsp;[{0}]: {1}</div>',
			args = { name, message }
        })
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) <= zasieg then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(70, 70, 70, 0.9); border-radius: 3px;"><i class="far fa-comment"></i>&nbsp;[{0}]: {1}</div>',
			args = { name, message }
        })
    end
end)

RegisterNetEvent('sendClientMessageStateGovm')
AddEventHandler('sendClientMessageStateGovm', function(id)
    local pid = GetPlayerFromServerId(id)
    local myId = PlayerId()

        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(2, 31, 53, 0.8); border-radius: 3px;"><i class="fas fa-flag-usa"></i>&nbsp; [{0}] {1}</div>',
			args = { "State Government", "Chcesz zagwarantować sobie pewny pobyt na wyspie? Podanie o stałą wizę można złożyć na stronie [Prime-Project.pl] - zapraszamy!" }
        })

end)

local font = 4 -- Font of the text
local time = 6000 -- Duration of the display of the text : 1000ms = 1sec
local nbrDisplaying = 1

RegisterNetEvent('esx_rpchat:triggerDisplay')
AddEventHandler('esx_rpchat:triggerDisplay', function(text, source, color)
    local offset = 0 + (nbrDisplaying*0.14)
    Display(GetPlayerFromServerId(source), text, offset, color)
end)

function Display(mePlayer, text, offset, color)
    local displaying = true
    Citizen.CreateThread(function()
        Wait(time)
        displaying = false
    end)
    Citizen.CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        print(nbrDisplaying)
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = GetDistanceBetweenCoords(coordsMe['x'], coordsMe['y'], coordsMe['z'], coords['x'], coords['y'], coords['z'], true)
            if dist < 50 then
                DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset, text, color)
            end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

function DrawText3D(x,y,z, text, color)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*1.7
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextCentre(true)


        --[[("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)]]

        -- Calculate width and height
        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55*scale, font)
        local width = EndTextCommandGetWidth(font)

        -- Diplay the text
        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)

        --DrawRect(_x, _y+scale/45, width*1.1, height*1.15, color.r, color.g, color.b, 200)
        if color.r == 204 and color.g == 152 and color.b == 214 then -- me
            color.r = 96
            color.g = 0
            color.b = 129
        elseif color.r == 83 and color.g == 130 and color.b == 201 then -- do
            color.r = 0
            color.g = 68
            color.b = 176
        elseif color.r == 106 and color.g == 212 and color.b == 176 then -- if
            color.r = 0
            color.g = 219
            color.b = 135
        end
        --[[if color == {r = 204, g = 152, b = 214, alpha = 255} then
            color = {r = 96, g = 0, b = 129, alpha = 170}
        end]]
        DrawRect(_x, _y+scale/45, width*1.1, height*1.2, color.r, color.g, color.b, 200)
    end
end

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    
    
    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(164, 30, 191, 0.9); border-radius: 3px;"><i class="fas fa-user-circle"></i>&nbsp;[{0}]: {1}</div>',
            args = { name, message }
        })
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) <= zasieg then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(164, 30, 191, 0.9); border-radius: 3px;"><i class="fas fa-user-circle"></i>&nbsp;[{0}]: {1}</div>',
            args = { name, message }
        })
    end
end)

RegisterNetEvent('sendProximityMessageTweet')
AddEventHandler('sendProximityMessageTweet', function(id, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
		local name = ""
    if pid == myId then
        TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(28, 160, 242, 0.9); border-radius: 3px;"><i class="fab fa-twitter"></i>&nbsp;{0} {1}</div>',
					args = { name, message }
        })
    end
end)

RegisterNetEvent('sendProximityMessageRSE')
AddEventHandler('sendProximityMessageRSE', function(id)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
	local name = " Route 68 Rockstar Editor"
	local nagraj = '[/nagrajklip] - Rozpoczyna nagrywanie'
	local anuluj = '[/anulujklip] - Anuluje nagrywanie'
	local zapisz = '[/zapiszklip] - Zapisuje nagranie - klip musi mieć conajmniej 3 sekundy'
	local editor = '[/rseditor] - Rozłącza z serwerem i przenosi do Rockstar Editora'
    if pid == myId then
        TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(80, 124, 58, 0.9); border-radius: 3px;"><i class="fas fa-video"></i>{0}<br>{1}<br>{2}<br>{3}<br>{4}</div>',
					args = { name, nagraj, anuluj, zapisz, editor }
        })
    end
end)

RegisterNetEvent('sendProximityMessagePrzebieg')
AddEventHandler('sendProximityMessagePrzebieg', function(id, przebieg, opissilnika, opisturbo, opishamulce, opisskrzynia, opiszawieszenie)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
		local name = ""
    if pid == myId then
        TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(232, 87, 9, 0.9); border-radius: 3px;"><i class="fas fa-car"></i>{0} {1}<br>{2}<br>{3}<br>{4}<br>{5}<br>{6}</div>',
					args = { name, przebieg, opissilnika, opisturbo, opishamulce, opisskrzynia, opiszawieszenie }
        })
    end
end)

RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, name, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    

    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-messagetwt"><div class="chat-message-header"><i class="fab fa-twitter"> <font color="white">{0}</font></i></div><div class="chat-message-body">{1}</div></div>',
            args = { name, message }
        })
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) <= zasieg then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-messagetwt"><div class="chat-message-header"><i class="fab fa-twitter"> <font color="white">{0}</font></i></div><div class="chat-message-body">{1}</div></div>',
            args = { name, message }
        })
    end
end)

RegisterNetEvent('sendProximityMessageCzy')
AddEventHandler('sendProximityMessageCzy', function(id, name, message, czy)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
	local color = {r = 164, g = 30, b = 191, alpha = 255}
    

	if czy == 1 then
      if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-messagetwt"><div class="chat-message-header"><i class="far fa-check-circle"> <font color="white">Obywatel [{0}] z powodzeniem</font></i></div><div class="chat-message-body">{1}</div></div>',
            args = { name,message }
        })
      elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) <= zasieg then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-messagetwt"><div class="chat-message-header"><i class="far fa-check-circle"> <font color="white">Obywatel [{0}] z powodzeniem</font></i></div><div class="chat-message-body">{1}</div></div>',
            args = { name,message }
        })
      end
	elseif czy == 2 then
	  if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-messagetwt"><div class="chat-message-header"><i class="far fa-times-circle"> <font color="white">Obywatel [{0}] z niepowodzeniem</font></i></div><div class="chat-message-body">{1}</div></div>',
            args = { name,message }
        })
      elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) <= zasieg then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-messagetwt"><div class="chat-message-header"><i class="far fa-times-circle"> <font color="white">Obywatel [{0}] z niepowodzeniem</font></i></div><div class="chat-message-body">{1}</div></div>',
            args = { name,message }
        })
      end
	end
end)

RegisterNetEvent('sendProximityMessagePhone')
AddEventHandler('sendProximityMessagePhone', function(id, name, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    

    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(101, 67, 153, 0.9); border-radius: 3px;"><i class="fas fa-sim-card"></i>&nbsp;[{0}] {1}</div>',
            args = { name, message }
        })
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) <= zasieg then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(101, 67, 153, 0.9); border-radius: 3px;"><i class="fas fa-sim-card"></i>&nbsp;[{0}] {1}</div>',
            args = { name, message }
        })
    end
end)

RegisterNetEvent('sendProximityMessagePoliceDzwonek')
AddEventHandler('sendProximityMessagePoliceDzwonek', function(message)
    if praca == 'police' then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(173, 48, 42, 0.9); border-radius: 3px;"><i class="fas fa-concierge-bell"></i>&nbsp;[{0}] {1}</div>',
            args = { 'KOMISARIAT', message }
        })
    end
end)

RegisterNetEvent('sendProximityMessageEMSDzwonek')
AddEventHandler('sendProximityMessageEMSDzwonek', function(message)
    if praca == 'fire' then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(173, 48, 42, 0.9); border-radius: 3px;"><i class="fas fa-concierge-bell"></i>&nbsp;[{0}] {1}</div>',
            args = { 'SZPITAL', message }
        })
    end
end)

RegisterNetEvent('esx_rpchat:25usd')
AddEventHandler('esx_rpchat:25usd', function()
	TriggerEvent("pNotify:SendNotification", {text "Zapłaciłeś/aś $25 za wysłanie Tweeta"})
end)

RegisterNetEvent('esx_rpchat:moneta')
AddEventHandler('esx_rpchat:moneta', function(name, wynik)
		local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
		local dane = name
        

	if wynik < 50 then
	  if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(30, 94, 191, 0.9); border-radius: 3px;"><i class="fab fa-bitcoin"></i> {0} {1}</div>',
            args = { 'MONETA: ['..dane..']', 'Wyrzucił/a Orła!' }
        })
      elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) <= zasieg then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(30, 94, 191, 0.9); border-radius: 3px;"><i class="fab fa-bitcoin"></i> {0} {1}</div>',
            args = { 'MONETA: ['..dane..']', 'Wyrzucił/a Orła!' }
        })
	  end
	elseif wynik > 50 then
		if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(30, 94, 191, 0.9); border-radius: 3px;"><i class="fab fa-bitcoin"></i> {0} {1}</div>',
            args = { 'MONETA: ['..dane..']', 'Wyrzucił/a Reszkę!' }
        })
      elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) <= zasieg then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(30, 94, 191, 0.9); border-radius: 3px;"><i class="fab fa-bitcoin"></i> {0} {1}</div>',
            args = { 'MONETA: ['..dane..']', 'Wyrzucił/a Reszkę!' }
        })
	  end
	elseif wynik == 50 then
		if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(30, 94, 191, 0.9); border-radius: 3px;"><i class="fab fa-bitcoin"></i> {0} {1}</div>',
            args = { 'MONETA: ['..dane..']', 'Moneta stanęła na kant!' }
        })
      elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) <= zasieg then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(30, 94, 191, 0.9); border-radius: 3px;"><i class="fab fa-bitcoin"></i> {0} {1}</div>',
            args = { 'MONETA: ['..dane..']', 'Moneta stanęła na kant!' }
        })
	  end
	end

end)

local zawiadamia = false
local zawiadamia2 = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local Gracz = GetPlayerPed(-1)
        local PozycjaGracza = GetEntityCoords(Gracz)
        local Dystans = GetDistanceBetweenCoords(PozycjaGracza, 439.43, -981.04, 30.68, true)
        if Dystans <= 6 then
            local PozycjaTekstu= {
                ["x"] = 439.43,
                ["y"] = -981.04,
                ["z"] = 30.68
            }
            ESX.Game.Utils.DrawText3D(PozycjaTekstu, "NACIŚNIJ [~g~G~s~] ABY WEZWAĆ FUNKCJONARIUSZA", 0.55, 1.0, "~b~DZWONEK", 0.7)
            if IsControlJustPressed(0, 47) and Dystans <= 6 and zawiadamia == false then
                TriggerEvent('pNotify:SendNotification', {text = 'Wysłano zawiadomienie!'})
                TriggerEvent('pNotify:SendNotification', {text = 'Następny raz będziesz mógł/mogła użyć dzwonka za dwie minuty.'})
                zawiadamia = true
                TriggerServerEvent('route68:dzwonekPolicyjny')
                Citizen.Wait(120 * 1000)
                zawiadamia = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local Gracz = GetPlayerPed(-1)
        local PozycjaGracza = GetEntityCoords(Gracz)
        local Dystans = GetDistanceBetweenCoords(PozycjaGracza, 339.86, -586.27, 28.79, true) -- x = 339.86, y = -586.27, z = 28.79
        if Dystans <= 6 then
            local PozycjaTekstu= {
                ["x"] = 339.86,
                ["y"] = -586.27,
                ["z"] = 28.79
            }
            ESX.Game.Utils.DrawText3D(PozycjaTekstu, "NACIŚNIJ [~g~G~s~] ABY WEZWAĆ MEDYKA", 0.55, 1.0, "~b~DZWONEK", 0.7)
            if IsControlJustPressed(0, 47) and Dystans <= 6 and zawiadamia2 == false then
                TriggerEvent('pNotify:SendNotification', {text = 'Wysłano zawiadomienie!'})
                TriggerEvent('pNotify:SendNotification', {text = 'Następny raz będziesz mógł/mogła użyć dzwonka za dwie minuty.'})
                zawiadamia2 = true
                TriggerServerEvent('route68:dzwonekEMS')
                Citizen.Wait(120 * 1000)
                zawiadamia2 = false
            end
        end
    end
end)