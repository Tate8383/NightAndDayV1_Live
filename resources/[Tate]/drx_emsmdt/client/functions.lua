function Open(charname, status, calls)
    SetNuiFocus(true, true)
    SendNUIMessage({
        open = true,
        charname = charname,
        status = status,
        calls = calls
    })
end

function Close()
    SetNuiFocus(false, false)
    SendNUIMessage({
        close = true
    })
end

RegisterCommand('911', function(source, args)
    local coords = GetEntityCoords(PlayerPedId(-1))
    local location = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords[1], coords[2], coords[3]))
    local type = 'Alarm'
    local message = ''
    for i=1, #args, 1 do
        if i > 0 then message = message .. ' '
            message = message .. args[i]
        end
    end
    TriggerServerEvent('drx_emsmdt:newCall', type, message, location, coords)
end)