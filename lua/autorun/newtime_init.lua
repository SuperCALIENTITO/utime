--[[------------------------------------
            New Time Loader
------------------------------------]]--

NewTime = NewTime or {
    FolderPrefix = "newtime/"
}

if SERVER then
    AddCSLuaFile(NewTime.FolderPrefix .. "sh_newtime.lua")
    AddCSLuaFile(NewTime.FolderPrefix .. "cl_newtime.lua")

    include(NewTime.FolderPrefix .. "sh_newtime.lua")
    include(NewTime.FolderPrefix .. "sv_newtime.lua")
else
    include(NewTime.FolderPrefix .. "sh_newtime.lua")
    include(NewTime.FolderPrefix .. "cl_newtime.lua")
end