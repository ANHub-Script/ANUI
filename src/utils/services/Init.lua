local Services = {
    platoboost = {
        Name = "Platoboost",
        Icon = "rbxassetid://75920162824531",
        Args = {"ServiceId", "Secret"},
        
        
        New = require("./Platoboost").New
    },
    pandadevelopment = {
        Name = "Panda Development",
        Icon = "panda",
        Args = {"ServiceId"},
        
        
        New = require("./PandaDevelopment").New
    },
    luarmor = {
        Name = "Luarmor",
        Icon = "rbxassetid://130918283130165",
        Args = {"ScriptId", "Discord"},


        New = require("./Luarmor").New
    },
    github = {
        Name = "GitHub",
        Icon = "github",
        Args = {"Owner", "Repo", "Branch", "DBPath", "URL", "Secret", "Folder"},

        -- Per-device keys with a 24h TTL, database committed to a GitHub repo.
        -- `Folder` is filled in from the window config, not by the user.
        New = require("./GitHubKey").New
    },
    -- other Services...
}

--[[
    Instantiates a provider from one `KeySystem.API` entry.

    `context` supplies values the window knows but the user does not pass — at
    the moment just `Folder`, which the GitHub provider needs for its cache file.

    Arguments are placed by index instead of appended, so an optional field left
    as nil does not shift every later argument into the wrong slot.
]]
function Services.Build(entry, context)
    local definition = Services[entry.Type]
    if not definition then
        return nil, nil
    end

    local total = #definition.Args
    local args = {}

    for index = 1, total do
        local name = definition.Args[index]
        local value = entry[name]

        if value == nil and context then
            value = context[name]
        end

        args[index] = value
    end

    local instance = definition.New(table.unpack(args, 1, total))

    if type(instance) == "table" then
        instance.Type = entry.Type
    end

    return instance, definition
end

return Services