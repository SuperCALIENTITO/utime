--[[------------------------------------
            New Time Shared
------------------------------------]]--

--[[----------------------------
        Metatable player
----------------------------]]--

local metaPlayer = FindMetaTable("Player")
if not metaPlayer then return end

function metaPlayer:GetPlayerSessionTimePlayed()
    return self:GetNWInt("NewTime.TimePlayed")
end

function metaPlayer:SetPlayerSessionTimePlayed(time)
    self:SetNWInt("NewTime.TimePlayed", time)
end

function metaPlayer:UpdatePlayerSessionTimePlayed()
    local time = self:GetPlayerSessionTimePlayed()
    self:SetPlayerSessionTimePlayed(time + 1)
end

function metaPlayer:GetPlayerTotalTimePlayed()
    return self:GetNWInt("NewTime.TotalTimePlayed")
end

function metaPlayer:SetPlayerTotalTimePlayed(time)
    self:SetNWInt("NewTime.TotalTimePlayed", time)
end


--[[----------------------------
           Time Format
----------------------------]]--

function NewTime.FormatTime(time)
    local tmp = time
    local s = tmp % 60

    tmp = math.floor( tmp / 60 )
    local m = tmp % 60

    tmp = math.floor( tmp / 60 )
    local h = tmp % 24

    tmp = math.floor( tmp / 24 )
    local d = tmp % 7
    local w = math.floor( tmp / 7 )

    return string.format( "%02iw %id %02ih %02im %02is", w, d, h, m, s )
end


--[[----------------------------
           Utime Replace
----------------------------]]--

hook.Add("PostGamemodeLoaded", "NewTime.Replacement", function()
    function metaPlayer:GetUTime()
        return self:GetPlayerSessionTimePlayed()
    end

    function metaPlayer:GetUTimeTotalTime()
        return self:GetPlayerTotalTimePlayed()
    end

    if (Utime) then
        function Utime.timeToStr(time)
            return NewTime.FormatTime(time)
        end 
    end
end)