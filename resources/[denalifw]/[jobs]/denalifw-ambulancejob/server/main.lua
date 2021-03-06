local PlayerInjuries = {}
local PlayerWeaponWounds = {}
local DenaliFW = exports['denalifw-core']:GetCoreObject()
-- Events

-- Compatibility with txAdmin Menu's heal options.
-- This is an admin only server side event that will pass the target player id or -1.
AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
	if GetInvokingResource() ~= "monitor" or type(eventData) ~= "table" or type(eventData.id) ~= "number" then
		return
	end

	TriggerClientEvent('hospital:client:Revive', eventData.id)
	TriggerClientEvent("hospital:client:HealInjuries", eventData.id, "full")
end)

RegisterNetEvent('hospital:server:SendToBed', function(bedId, isRevive)
	local src = source
	local Player = DenaliFW.Functions.GetPlayer(src)
	TriggerClientEvent('hospital:client:SendToBed', src, bedId, Config.Locations["beds"][bedId], isRevive)
	TriggerClientEvent('hospital:client:SetBed', -1, bedId, true)
	Player.Functions.RemoveMoney("bank", Config.BillCost , "respawned-at-hospital")
	TriggerEvent('denalifw-bossmenu:server:addAccountMoney', "ambulance", Config.BillCost)
	TriggerClientEvent('hospital:client:SendBillEmail', src, Config.BillCost)
end)

RegisterNetEvent('hospital:server:RespawnAtHospital', function()
	local src = source
	local Player = DenaliFW.Functions.GetPlayer(src)
	for k, v in pairs(Config.Locations["beds"]) do
		if not v.taken then
			TriggerClientEvent('hospital:client:SendToBed', src, k, v, true)
			TriggerClientEvent('hospital:client:SetBed', -1, k, true)
			if Config.WipeInventoryOnRespawn then
				Player.Functions.ClearInventory()
				MySQL.Async.execute('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode({}), Player.PlayerData.citizenid })
				TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.possessions_taken'), 'error')
			end
			Player.Functions.RemoveMoney("bank", Config.BillCost, "respawned-at-hospital")
			TriggerEvent('denalifw-bossmenu:server:addAccountMoney', "ambulance", Config.BillCost)
			TriggerClientEvent('hospital:client:SendBillEmail', src, Config.BillCost)
			return
		end
	end
	--print("All beds were full, placing in first bed as fallback")

	TriggerClientEvent('hospital:client:SendToBed', src, 1, Config.Locations["beds"][1], true)
	TriggerClientEvent('hospital:client:SetBed', -1, 1, true)
	if Config.WipeInventoryOnRespawn then
		Player.Functions.ClearInventory()
		MySQL.Async.execute('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode({}), Player.PlayerData.citizenid })
		TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.possessions_taken'), 'error')
	end
	Player.Functions.RemoveMoney("bank", Config.BillCost, "respawned-at-hospital")
	TriggerEvent('denalifw-bossmenu:server:addAccountMoney', "ambulance", Config.BillCost)
	TriggerClientEvent('hospital:client:SendBillEmail', src, Config.BillCost)
end)

RegisterNetEvent('hospital:server:ambulanceAlert', function(text)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local players = DenaliFW.Functions.GetQBPlayers()
    for k,v in pairs(players) do
        if v.PlayerData.job.name == 'ambulance' and v.PlayerData.job.onduty then
            TriggerClientEvent('hospital:client:ambulanceAlert', v.PlayerData.source, coords, text)
        end
    end
end)

RegisterNetEvent('hospital:server:LeaveBed', function(id)
    TriggerClientEvent('hospital:client:SetBed', -1, id, false)
end)

RegisterNetEvent('hospital:server:SyncInjuries', function(data)
    local src = source
    PlayerInjuries[src] = data
end)

RegisterNetEvent('hospital:server:SetWeaponDamage', function(data)
	local src = source
	local Player = DenaliFW.Functions.GetPlayer(src)
	if Player then
		PlayerWeaponWounds[Player.PlayerData.source] = data
	end
end)

RegisterNetEvent('hospital:server:RestoreWeaponDamage', function()
	local src = source
	local Player = DenaliFW.Functions.GetPlayer(src)
	PlayerWeaponWounds[Player.PlayerData.source] = nil
end)

RegisterNetEvent('hospital:server:SetDeathStatus', function(isDead)
	local src = source
	local Player = DenaliFW.Functions.GetPlayer(src)
	if Player then
		Player.Functions.SetMetaData("isdead", isDead)
	end
end)

RegisterNetEvent('hospital:server:SetLaststandStatus', function(bool)
	local src = source
	local Player = DenaliFW.Functions.GetPlayer(src)
	if Player then
		Player.Functions.SetMetaData("inlaststand", bool)
	end
end)

RegisterNetEvent('hospital:server:SetArmor', function(amount)
	local src = source
	local Player = DenaliFW.Functions.GetPlayer(src)
	if Player then
		Player.Functions.SetMetaData("armor", amount)
	end
end)

RegisterNetEvent('hospital:server:TreatWounds', function(playerId)
	local src = source
	local Player = DenaliFW.Functions.GetPlayer(src)
	local Patient = DenaliFW.Functions.GetPlayer(playerId)
	if Patient then
		if Player.PlayerData.job.name =="ambulance" then
			Player.Functions.RemoveItem('bandage', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, DenaliFW.Shared.Items['bandage'], "remove")
			TriggerClientEvent("hospital:client:HealInjuries", Patient.PlayerData.source, "full")
		end
	end
end)

RegisterNetEvent('hospital:server:SetDoctor', function()
	local amount = 0
    local players = DenaliFW.Functions.GetQBPlayers()
    for k,v in pairs(players) do
        if v.PlayerData.job.name == 'ambulance' and v.PlayerData.job.onduty then
            amount = amount + 1
        end
	end
	TriggerClientEvent("hospital:client:SetDoctorCount", -1, amount)
end)

RegisterNetEvent('hospital:server:RevivePlayer', function(playerId, isOldMan)
	local src = source
	local Player = DenaliFW.Functions.GetPlayer(src)
	local Patient = DenaliFW.Functions.GetPlayer(playerId)
	local oldMan = isOldMan or false
	if Patient then
		if oldMan then
			if Player.Functions.RemoveMoney("cash", 5000, "revived-player") then
				Player.Functions.RemoveItem('firstaid', 1)
				TriggerClientEvent('inventory:client:ItemBox', src, DenaliFW.Shared.Items['firstaid'], "remove")
				TriggerClientEvent('hospital:client:Revive', Patient.PlayerData.source)
			else
				TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.not_enough_money'), "error")
			end
		else
			Player.Functions.RemoveItem('firstaid', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, DenaliFW.Shared.Items['firstaid'], "remove")
			TriggerClientEvent('hospital:client:Revive', Patient.PlayerData.source)
		end
	end
end)

RegisterNetEvent('hospital:server:SendDoctorAlert', function()
    local players = DenaliFW.Functions.GetQBPlayers()
    for k,v in pairs(players) do
        if v.PlayerData.job.name == 'ambulance' and v.PlayerData.job.onduty then
			TriggerClientEvent('DenaliFW:Notify', v.PlayerData.source, Lang:t('info.dr_needed'), 'ambulance')
		end
	end
end)

RegisterNetEvent('hospital:server:UseFirstAid', function(targetId)
	local src = source
	local Target = DenaliFW.Functions.GetPlayer(targetId)
	if Target then
		TriggerClientEvent('hospital:client:CanHelp', targetId, src)
	end
end)

RegisterNetEvent('hospital:server:CanHelp', function(helperId, canHelp)
	local src = source
	if canHelp then
		TriggerClientEvent('hospital:client:HelpPerson', helperId, src)
	else
		TriggerClientEvent('DenaliFW:Notify', helperId, Lang:t('error.cant_help'), "error")
	end
end)

-- Callbacks

DenaliFW.Functions.CreateCallback('hospital:GetDoctors', function(source, cb)
	local amount = 0
    local players = DenaliFW.Functions.GetQBPlayers()
    for k,v in pairs(players) do
        if v.PlayerData.job.name == 'ambulance' and v.PlayerData.job.onduty then
			amount = amount + 1
		end
	end
	cb(amount)
end)

DenaliFW.Functions.CreateCallback('hospital:GetPlayerStatus', function(source, cb, playerId)
	local Player = DenaliFW.Functions.GetPlayer(playerId)
	local injuries = {}
	injuries["WEAPONWOUNDS"] = {}
	if Player then
		if PlayerInjuries[Player.PlayerData.source] then
			if (PlayerInjuries[Player.PlayerData.source].isBleeding > 0) then
				injuries["BLEED"] = PlayerInjuries[Player.PlayerData.source].isBleeding
			end
			for k, v in pairs(PlayerInjuries[Player.PlayerData.source].limbs) do
				if PlayerInjuries[Player.PlayerData.source].limbs[k].isDamaged then
					injuries[k] = PlayerInjuries[Player.PlayerData.source].limbs[k]
				end
			end
		end
		if PlayerWeaponWounds[Player.PlayerData.source] then
			for k, v in pairs(PlayerWeaponWounds[Player.PlayerData.source]) do
				injuries["WEAPONWOUNDS"][k] = v
			end
		end
	end
    cb(injuries)
end)

DenaliFW.Functions.CreateCallback('hospital:GetPlayerBleeding', function(source, cb)
	local src = source
	if PlayerInjuries[src] and PlayerInjuries[src].isBleeding then
		cb(PlayerInjuries[src].isBleeding)
	else
		cb(nil)
	end
end)

-- Commands

DenaliFW.Commands.Add('911e', Lang:t('info.ems_report'), {{name = 'message', help = Lang:t('info.message_sent')}}, false, function(source, args)
	local src = source
	if args[1] then message = table.concat(args, " ") else message = Lang:t('info.civ_call') end
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local players = DenaliFW.Functions.GetQBPlayers()
    for k,v in pairs(players) do
        if v.PlayerData.job.name == 'ambulance' and v.PlayerData.job.onduty then
            TriggerClientEvent('hospital:client:ambulanceAlert', v.PlayerData.source, coords, message)
        end
    end
end)

DenaliFW.Commands.Add("status", Lang:t('info.check_health'), {}, false, function(source, args)
	local src = source
	local Player = DenaliFW.Functions.GetPlayer(src)
	if Player.PlayerData.job.name == "ambulance" then
		TriggerClientEvent("hospital:client:CheckStatus", src)
	else
		TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.not_ems'), "error")
	end
end)

DenaliFW.Commands.Add("heal", Lang:t('info.heal_player'), {}, false, function(source, args)
	local src = source
	local Player = DenaliFW.Functions.GetPlayer(src)
	if Player.PlayerData.job.name == "ambulance" then
		TriggerClientEvent("hospital:client:TreatWounds", src)
	else
		TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.not_ems'), "error")
	end
end)

DenaliFW.Commands.Add("revivep", Lang:t('info.revive_player'), {}, false, function(source, args)
	local src = source
	local Player = DenaliFW.Functions.GetPlayer(src)
	if Player.PlayerData.job.name == "ambulance" then
		TriggerClientEvent("hospital:client:RevivePlayer", src)
	else
		TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.not_ems'), "error")
	end
end)

DenaliFW.Commands.Add("revive", Lang:t('info.revive_player_a'), {{name = "id", help = Lang:t('info.player_id')}}, false, function(source, args)
	local src = source
	if args[1] then
		local Player = DenaliFW.Functions.GetPlayer(tonumber(args[1]))
		if Player then
			TriggerClientEvent('hospital:client:Revive', Player.PlayerData.source)
		else
			TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.not_online'), "error")
		end
	else
		TriggerClientEvent('hospital:client:Revive', src)
	end
end, "admin")

DenaliFW.Commands.Add("setpain", Lang:t('info.pain_level'), {{name = "id", help = Lang:t('info.player_id')}}, false, function(source, args)
	local src = source
	if args[1] then
		local Player = DenaliFW.Functions.GetPlayer(tonumber(args[1]))
		if Player then
			TriggerClientEvent('hospital:client:SetPain', Player.PlayerData.source)
		else
			TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.not_online'), "error")
		end
	else
		TriggerClientEvent('hospital:client:SetPain', src)
	end
end, "admin")

DenaliFW.Commands.Add("kill", Lang:t('info.kill'), {{name = "id", help = Lang:t('info.player_id')}}, false, function(source, args)
	local src = source
	if args[1] then
		local Player = DenaliFW.Functions.GetPlayer(tonumber(args[1]))
		if Player then
			TriggerClientEvent('hospital:client:KillPlayer', Player.PlayerData.source)
		else
			TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.not_online'), "error")
		end
	else
		TriggerClientEvent('hospital:client:KillPlayer', src)
	end
end, "admin")

DenaliFW.Commands.Add('aheal', Lang:t('info.heal_player_a'), {{name = 'id', help = Lang:t('info.player_id')}}, false, function(source, args)
	local src = source
	if args[1] then
		local Player = DenaliFW.Functions.GetPlayer(tonumber(args[1]))
		if Player then
			TriggerClientEvent('hospital:client:adminHeal', Player.PlayerData.source)
		else
			TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.not_online'), "error")
		end
	else
		TriggerClientEvent('hospital:client:adminHeal', src)
	end
end, 'admin')

-- Items

DenaliFW.Functions.CreateUseableItem("ifaks", function(source, item)
	local src = source
	local Player = DenaliFW.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("hospital:client:UseIfaks", src)
	end
end)

DenaliFW.Functions.CreateUseableItem("bandage", function(source, item)
	local src = source
	local Player = DenaliFW.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("hospital:client:UseBandage", src)
	end
end)

DenaliFW.Functions.CreateUseableItem("painkillers", function(source, item)
	local src = source
	local Player = DenaliFW.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("hospital:client:UsePainkillers", src)
	end
end)

DenaliFW.Functions.CreateUseableItem("firstaid", function(source, item)
	local src = source
	local Player = DenaliFW.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("hospital:client:UseFirstAid", src)
	end
end)