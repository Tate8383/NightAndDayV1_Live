Config = {}

Config.Debug = false
Config.JobBusy = false

Config.MarkerData = {
    ["type"] = 6,
    ["size"] = 1.0, 1.0, 1.0,
    ["color"] = 0, 255, 150
}

Config.FishingRestaurant = {
    ["name"] = "La Spada Fish Restaurant",
    ["blip"] = {
        ["sprite"] = 628,
        ["color"] = 3
    },
    ["ped"] = {
        ["model"] = 0xED0CE4C6,
        ["position"] = vector3(-1038.4545898438, -1397.0551757813, 5.553192615509),
        ["heading"] = 75.0
    }
}

Config.FishingItems = {
    ["rod"] = {
        ["name"] = "fishingrod",
        ["label"] = "Fishing Rod"
    },
    ["bait"] = {
        ["name"] = "fishingbait",
        ["label"] = "Fishing Bait"
    },
    ["goldfish"] = {
        ["price"] = 25
    },
    ["fish"] = {
        ["price"] = 50 
    },
    ["bluefish"] = {
        ["price"] = 100
    },
    ["redfish"] = {
        ["price"] = 150
    },
    ["stripedbass"] = {
        ["price"] = 300
    },
    ["pacifichalibut"] = {
        ["price"] = 350
    },
    ["largemouthbass"] = {
        ["price"] = 400
    },
    ["salmon"] = {
        ["price"] = 450
    },
    ["catfish"] = {
        ["price"] = 500
    },
    ["tigersharkmeat"] = {
        ["price"] = 600
    },
    ["stingraymeat"] = {
        ["price"] = 700
    },
    ["killerwhalemeat"] = {
        ["price"] = 800
    },
}

Config.FishingZones = {
    {
        ["name"] = "Beach Fishing",
        ["coords"] = vector3(-1948.1279296875, -749.79125976563, 2.5400819778442),
        ["radius"] = 999999999999999999999999.0,
    },
    {
        ["name"] = "special0",
        ["coords"] = vector3(7040.34, 8172.63, 204.435),
        ["radius"] = 9999999999999999999900.0,
        ["secret"] = true,
    },
}
