local luau = require("@lune/luau")
local fs = require("@lune/fs")
local process = require("@lune/process")
local path = process.args[1]
local src = fs.readFile(path)
local ok, err = pcall(function() return luau.compile(src) end)
if ok then print("SYNTAX OK: " .. path) else print("SYNTAX ERROR in " .. path .. "\n" .. tostring(err)); process.exit(1) end
