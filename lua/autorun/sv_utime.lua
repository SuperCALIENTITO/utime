-- Written by Team Ulysses, http://ulyssesmod.net/

utime = utime or {}
-- module( "Utime", package.seeall )
if not SERVER then return end

local q = sql.Query
local qR = sql.QueryRow
local qV = sql.QueryValue
utime.welcome = CreateConVar( "utime_welcome", "1", FCVAR_ARCHIVE )



--[[------------------------------------------------
		Database Creation and Update
------------------------------------------------]]--

if not sql.TableExists( "utime" ) then
	q( "CREATE TABLE IF NOT EXISTS utime ( id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, player INTEGER NOT NULL, totaltime INTEGER NOT NULL, lastvisit INTEGER NOT NULL );" )
	q( "CREATE INDEX IDX_UTIME_PLAYER ON utime ( player DESC );" )
end

if q("SELECT * FROM utime.steamid") == false then
	print( "SQL RESULT: ", q( "ALTER TABLE utime ADD steamid VARCHAR(64)" ) )
end



local welcome = utime.welcome:GetBool()
function utime.onJoin( ply )
	local uid, steamid = ply:UniqueID(), ply:SteamID()
	local row = qR( "SELECT totaltime, lastvisit FROM utime WHERE player = " .. uid )
	local steamrow = qR( "SELECT totaltime, lastvisit FROM utime WHERE steamid = " .. steamid )
	local time = 0


	if steamrow then

		if welcome then
			ULib.tsay( ply, "[UTime] Bienvenido devuelta " .. ply:Nick() .. ", jugaste aqui la ultima vez el " .. os.date( "%c", steamrow.lastvisit ) )
		end

		q( "UPDATE utime SET lastvisit = " .. os.time() .. " WHERE steamid = \"" .. steamid .. "\"" )
		time = steamrow.totaltime

	elseif row then

		if welcome then
			ULib.tsay( ply, "[UTime] Bienvenido devuelta " .. ply:Nick() .. ", jugaste aqui la ultima vez el " .. os.date( "%c", row.lastvisit ) )
		end

		q( "UPDATE utime SET lastvisit = " .. os.time() .. " WHERE player = " .. uid )
		q( "UPDATE utime SET steamid = \"" .. steamid .. "\" WHERE player = " .. uid )
		time = row.totaltime

	else

		if welcome then
			ULib.tsay( ply, "[UTime] Bienvenido a Mapping Latam " .. ply:Nick() .. "!" )
		end

		q( "INSERT into utime ( player, totaltime, lastvisit, steamid ) VALUES ( " .. uid .. ", 0, " .. os.time() .. ", \"" .. steamid .. "\" )" )

	end

	ply:SetUTime( time )
	ply:SetUTimeStart( CurTime() )
end



function utime.updatePlayer( ply )
	q( "UPDATE utime SET totaltime = " .. math.floor( ply:GetUTimeTotalTime() ) .. " WHERE steamid = " .. ply:SteamID() .. ";" )
end



function utime.updateAll()
	local players = player.GetAll()

	for _, ply in ipairs( players ) do
		if ply and ply:IsConnected() then
			utime.updatePlayer( ply )
		end
	end
end


hook.Add( "PlayerInitialSpawn", "UTimeInitialSpawn", utime.onJoin )
hook.Add( "PlayerDisconnected", "UTimeDisconnect", utime.updatePlayer )
timer.Create( "UTimeTimer", 67, 0, utime.updateAll )
