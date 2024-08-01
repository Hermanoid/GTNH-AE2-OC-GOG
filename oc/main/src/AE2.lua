local component = require("component")
local ME = component.me_interface

require("src.Network")
require("src.Utility")
require("src.Scan")

function pprint(table)
    for key, value in pairs(table) do
        print(key, value)
    end
end

function getNetworkStats()
    local CpuDataToServer = {}
    local CpuTable = ME.getCpus()
    for i=1,#CpuTable do
        CpuDataToServer[i] = {
          name = CpuTable[i].name,
          storage = CpuTable[i].storage,
          busy = CpuTable[i].busy,
          activeItems = "",
          storedItems = "",
          pendingItems = "",
          finalOutput = ""
        }

        if CpuTable[i].busy == true then
            local cpu = CpuTable[i].cpu
            for _, v in ipairs({
                {items = cpu.activeItems(), name = "activeItems"},
                {items = cpu.storedItems(), name = "storedItems"},
                {items = cpu.pendingItems(), name = "pendingItems"}
            }) do
                if v.items ~= nil then
                    for __, v2 in ipairs(v.items) do
                        CpuDataToServer[i][v.name] = CpuDataToServer[i][v.name] .. v2.label .. "~" .. v2.size .. ";"
                    end
                end
            end
            local finalOutput = cpu.finalOutput()
            if finalOutput ~= nil then
               CpuDataToServer[i]["finalOutput"] = finalOutput.label .. "~" .. finalOutput.size .. ";"
            end
        end
    end

    return {
        -- cpus = ME.getCpus()
        cpus = CpuDataToServer,
        --avgPowerInjection = ME.getAvgPowerInjection(),
        --avgPowerUsage = ME.getAvgPowerUsage(),
        --storedPower = ME.getStoredPower()
    }
end

function getItemsInNetwork()
    local filter = getFilter()
    local items = {}

    print("Filter: " .. table.concat(filter, ", "))

    local filterDict = {}
    for _, v in ipairs(filter) do
        filterDict[v] = true
    end

    for item in ME.allItems() do
        if filterDict[item.label] then
            items[item.label] = item.size
        end
    end

    return items
end
