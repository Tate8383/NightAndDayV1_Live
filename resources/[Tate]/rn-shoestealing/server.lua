local DenaliFW = exports['denalifw-core']:GetCoreObject()


RegisterServerEvent('rn-shoestealing:serverShoesSteal')
AddEventHandler('rn-shoestealing:serverShoesSteal', function(TargetSource)
    local Player = DenaliFW.Functions.GetPlayer(source)
    Player.Functions.AddItem("weapon_shoe", 1, false, false, true)
    TriggerClientEvent('rn-shoestealing:ShoesRemove', TargetSource)
end)