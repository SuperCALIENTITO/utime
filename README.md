# Newtime

This addon is a complete replacement for the "utime" addon which is no longer supported and uses obsolete functions.



## Meta Actions

You can find all actons [here](https://github.com/vicentefelipechile/newtime/blob/master/lua/newtime/sh_newtime.lua)

```lua
local ply = Player( 1 ) -- Player Object Example

--[[----------------
       Getters
----------------]]--

-- Return: Integer
-- Also ply:GetUTime() works
local TimeSession = ply:GetPlayerSessionTimePlayed()

-- Return: Integer
-- Also ply:GetUTimeTotalTime() works
local TimeTotal = ply:GetPlayerTotalTimePlayed()


--[[----------------
       Setters
----------------]]--

-- Arguments: Integer
ply:SetPlayerSessionTimePlayed( TimeSession )

-- Arguments: Integer
ply:SetPlayerTotalTimePlayed( TimeTotal )


--[[----------------
       Updater
----------------]]--

-- Updates the session time played by 1 second
ply:UpdatePlayerSessionTimePlayed()
```