--[[------------------------------------
            New Time Server
------------------------------------]]--

--[[----------------------------
        Custom Functions
----------------------------]]--

local sql = sql
function sql.QueryRowF(query, ...)
    local args = {...}
    local query = string.format(query, unpack(args))

    return sql.QueryRow(query)
end

function sql.QueryValueF(query, ...)
    local args = {...}
    local query = string.format(query, unpack(args))

    return sql.QueryValue(query)
end

function sql.QueryF(query, ...)
    local args = {...}
    local query = string.format(query, unpack(args))

    return sql.Query(query)
end

--[[----------------------------
        Database Creation
----------------------------]]--

if not sql.TableExists("newtime") then
    sql.Query("CREATE TABLE IF NOT EXISTS newtime ( steamid TEXT NOT NULL PRIMARY KEY, time INTEGER NOT NULL, lastjoin INTEGER NOT NULL, firstjoin INTEGER NOT NULL )")
    sql.Query("CREATE INDEX NEWTIME_IDX ON newtime ( steamid DESC )")
end

--[[----------------------------
          Main Functions
----------------------------]]--

function NewTime.OnJoin(ply)
    local Steamid = ply:SteamID()
    local Time = sql.QueryRowF([[SELECT time, lastjoin FROM newtime WHERE steamid = "%s"]], Steamid)
    local AltTime = nil

    if sql.TableExists("utime") then
        AltTime = sql.QueryRowF([[SELECT totaltime, lastvisit FROM utime WHERE player = %s]], ply:UniqueID())
    end

    if ( AltTime ) and ( not Time ) then
        sql.QueryF([[INSERT INTO newtime (steamid, time, lastjoin, firstjoin) VALUES ("%s", %s, %s, %s)]], Steamid, AltTime.totaltime, AltTime.lastvisit, os.time())

        ply:SetPlayerSessionTimePlayed(0)
        ply:SetPlayerTotalTimePlayed(AltTime.totaltime)
    elseif ( Time ) then
        sql.QueryF([[UPDATE newtime SET lastjoin = %s WHERE steamid = "%s"]], Time.lastjoin, Steamid)

        ply:SetPlayerSessionTimePlayed(0)
        ply:SetPlayerTotalTimePlayed(Time.time)
    else
        sql.QueryF([[INSERT INTO newtime (steamid, time, lastjoin, firstjoin) VALUES ("%s", %s, %s, %s)]], Steamid, 0, os.time(), os.time())

        ply:SetPlayerSessionTimePlayed(0)
        ply:SetPlayerTotalTimePlayed(0)
    end
end

function NewTime.OnDisconnect(ply)
    local Steamid = ply:SteamID()
    local Time = ply:GetPlayerSessionTimePlayed()
    local TotalTime = ply:GetPlayerTotalTimePlayed()

    local NewTime = sql.QueryRowF([[SELECT time, lastjoin FROM newtime WHERE steamid = "%s"]], Steamid)
    local HasMoreTimeThanBefore = ( TotalTime + Time ) >= ( tonumber( NewTime.time ) )

    if HasMoreTimeThanBefore then
        sql.QueryF([[UPDATE newtime SET time = %s WHERE steamid = "%s"]], TotalTime + Time, Steamid)
    end
end

hook.Add("PlayerInitialSpawn", "NewTime.OnJoin", NewTime.OnJoin)
hook.Add("PlayerDisconnected", "NewTime.OnDisconnect", NewTime.OnDisconnect)

--[[----------------------------
                Timer
----------------------------]]--

timer.Create("NewTime.UpdatePlayers", 1, 0, function()
    for _, ply in ipairs(player.GetAll()) do
        ply:UpdatePlayerSessionTimePlayed()
    end
end)