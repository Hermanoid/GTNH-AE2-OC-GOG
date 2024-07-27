-- credit https://github.com/DylanTaylor1/GTNH-Stocking

local shell = require('shell')
local args = {...}
local branch
local repo
local scripts = {
    'oc/main/Run.lua',
    'oc/main/env.example.lua',
    'oc/main/src/Scan.lua',
    'oc/main/src/AE2.lua',
    'oc/main/src/Utility.lua',
    'oc/main/src/Network.lua',
    'oc/main/src/Queue.lua',
    'oc/main/src/Machines.lua',
    'oc/main/src/TPS.lua',
    'oc/main/lib/json.lua',
}

-- BRANCH
if #args >= 1 then
    branch = args[1]
else
    branch = 'main'
end

-- REPO
if #args >= 2 then
    repo = args[2]
else
    repo = 'https://raw.githubusercontent.com/nzbasic/GTNH-AE2-OC-GOG/'
end

local folder = "oc"

-- INSTALL
for i=1, #scripts do
    shell.execute(string.format('wget -f %s%s/%s/%s', repo, branch, folder, scripts[i]))
end
