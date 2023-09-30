--[[------------------------------------
            New Time Client
------------------------------------]]--

NewTime.StuffLabel = NewTime.StuffLabel or {
    "NewTime.Label.TotalTime",
    "NewTime.Label.SessionTime",
    "NewTime.Label.Nick",
    "NewTime.TotalTime",
    "NewTime.SessionTime",
    "NewTime.Nick"
}

NewTime.AnotherStuffLabel = NewTime.AnotherStuffLabel or {
    "NewTime.Label.TotalTime",
    "NewTime.Label.SessionTime",
    "NewTime.TotalTime",
    "NewTime.SessionTime"
}

local NewTimePanel = nil

local TextAll = language.GetPhrase("all"):sub(1, 1):upper() .. language.GetPhrase("all"):sub(2):lower()
local TextTime = language.GetPhrase("playerlist_time"):sub(1, 1):upper() .. language.GetPhrase("playerlist_time"):sub(2):lower()
local TextName = language.GetPhrase("playerlist_name"):sub(1, 1):upper() .. language.GetPhrase("playerlist_name"):sub(2):lower()

--[[----------------------------
       Convars Declaration
----------------------------]]--

NewTime.Enable = CreateClientConVar( "newtime_enable", 1, true, true )
NewTime.OutsideColor_R = CreateClientConVar( "newtime_outsidecolor_r", 256, true, true )
NewTime.OutsideColor_G = CreateClientConVar( "newtime_outsidecolor_g", 256, true, true )
NewTime.OutsideColor_B = CreateClientConVar( "newtime_outsidecolor_b", 256, true, true )
NewTime.OutsideText_R = CreateClientConVar( "newtime_outsidetext_r", 0, true, true )
NewTime.OutsideText_G = CreateClientConVar( "newtime_outsidetext_g", 0, true, true )
NewTime.OutsideText_B = CreateClientConVar( "newtime_outsidetext_b", 0, true, true )

NewTime.InsideColor_R = CreateClientConVar( "newtime_insidecolor_r", 256, true, true )
NewTime.InsideColor_G = CreateClientConVar( "newtime_insidecolor_g", 256, true, true )
NewTime.InsideColor_B = CreateClientConVar( "newtime_insidecolor_b", 256, true, true )
NewTime.InsideText_R = CreateClientConVar( "newtime_insidetext_r", 0, true, true )
NewTime.InsideText_G = CreateClientConVar( "newtime_insidetext_g", 0, true, true )
NewTime.InsideText_B = CreateClientConVar( "newtime_insidetext_b", 0, true, true )

NewTime.PosX = CreateClientConVar( "newtime_pos_x", 98, true, true )
NewTime.PosY = CreateClientConVar( "newtime_pos_y", 8, true, true )

--[[----------------------------
       Panel Declaration
----------------------------]]--

local PANEL = {}
PANEL.Small = 40
PANEL.TargetSize = PANEL.Small
PANEL.Large = 100
PANEL.Wide = 160

function NewTime.Initialize()
    NewTimePanel = vgui.Create( "NewTime.Main" )
    NewTimePanel:SetSize( NewTimePanel.Wide, NewTimePanel.Small )
end
hook.Add( "InitPostEntity", "NewTime.Initialize", NewTime.Initialize )


--[[----------------------------
            Functions
----------------------------]]--

local OutsideTextNumber = 255 + 255 + 255
local InsideTextNumber = 255 + 255 + 255
local OutsideTextColor = color_white
local InsideTextColor = color_white

function NewTime.Think()
    if not LocalPlayer():IsValid() or NewTimePanel == nil then return end

    if
        not ( NewTime.Enable:GetBool() ) or
        not ( IsValid( LocalPlayer() ) ) or
        ( IsValid( LocalPlayer():GetActiveWeapon() ) and LocalPlayer():GetActiveWeapon():GetClass() == "gmod_camera" )
    then
        NewTimePanel:SetVisible( false )
    else
        NewTimePanel:SetVisible( true )
    end

    NewTimePanel:SetPos( (ScrW() - NewTimePanel:GetWide()) * NewTime.PosX:GetFloat() / 100, (ScrH() - NewTimePanel.Large) * (NewTime.PosY:GetFloat()) / 100 )

    --[[----------------------------
                Colors
    ----------------------------]]--
    if not ( OutsideTextNumber == ( NewTime.OutsideText_R:GetInt() + NewTime.OutsideText_G:GetInt() + NewTime.OutsideText_B:GetInt() ) ) then
        OutsideTextColor = Color( NewTime.OutsideText_R:GetInt(), NewTime.OutsideText_G:GetInt(), NewTime.OutsideText_B:GetInt(), 200 )
        OutsideTextNumber = NewTime.OutsideText_R:GetInt() + NewTime.OutsideText_G:GetInt() + NewTime.OutsideText_B:GetInt()
    end

    if not ( InsideTextNumber == ( NewTime.InsideText_R:GetInt() + NewTime.InsideText_G:GetInt() + NewTime.InsideText_B:GetInt() ) ) then
        InsideTextColor = Color( NewTime.InsideText_R:GetInt(), NewTime.InsideText_G:GetInt(), NewTime.InsideText_B:GetInt() )
        InsideTextNumber = NewTime.InsideText_R:GetInt() + NewTime.InsideText_G:GetInt() + NewTime.InsideText_B:GetInt()
    end

    --[[----------------------------
                 Labels
    ----------------------------]]--
    for _, name in ipairs( NewTime.AnotherStuffLabel ) do
        NewTimePanel[name]:SetTextColor( OutsideTextColor )
    end

    for _, name in ipairs( NewTime.StuffLabel ) do
        NewTimePanel["NewTime.PlayerInfo"][name]:SetTextColor( InsideTextColor )
    end
end
timer.Create( "NewTime.Think", 0.1, 0, NewTime.Think )


--[[------------------------------------
           Main Panel Functions
------------------------------------]]--

--[[----------------------------
    PANEL:Paint
----------------------------]]--

local TextGradient = surface.GetTextureID( "gui/gradient" )

local OutsideNumber = 255 + 255 + 255
local InsideNumber = 255 + 255 + 255
local OutsideColor = color_white
local InsideColor = color_white

function PANEL:Paint(w, h)
    local Wide = self:GetWide()
    local Tall = self:GetTall()

    if not ( OutsideNumber == ( NewTime.OutsideColor_R:GetInt() + NewTime.OutsideColor_G:GetInt() + NewTime.OutsideColor_B:GetInt() ) ) then
        OutsideColor = Color( NewTime.OutsideColor_R:GetInt(), NewTime.OutsideColor_G:GetInt(), NewTime.OutsideColor_B:GetInt(), 200 )
        OutsideNumber = NewTime.OutsideColor_R:GetInt() + NewTime.OutsideColor_G:GetInt() + NewTime.OutsideColor_B:GetInt()
    end

    draw.RoundedBox( 4, 0, 0, Wide, Tall, OutsideColor )

    surface.SetTexture( TextGradient )
    surface.SetDrawColor( 255, 255, 255, 50 )
    surface.SetDrawColor( OutsideColor )
    surface.DrawTexturedRect( 0, 0, Wide, Tall )

    if self:GetTall() > self.Small + 4 then

        if not ( InsideNumber == NewTime.InsideColor_R:GetInt() + NewTime.InsideColor_G:GetInt() + NewTime.InsideColor_B:GetInt() ) then
            InsideColor = Color( NewTime.InsideColor_R:GetInt(), NewTime.InsideColor_G:GetInt(), NewTime.InsideColor_B:GetInt(), 255 )
            InsideNumber = NewTime.InsideColor_R:GetInt() + NewTime.InsideColor_G:GetInt() + NewTime.InsideColor_B:GetInt()
        end

        draw.RoundedBox( 4, 2, self.Small, Wide - 4, Tall - self.Small - 2, InsideColor )

        surface.SetTexture( TextGradient )
        surface.SetDrawColor( color_white )
        surface.SetDrawColor( InsideColor )
        surface.DrawTexturedRect( 2, self.Small, Wide - 4, Tall - self.Small - 2 )
    end

    return true
end


--[[----------------------------
    PANEL:Init
----------------------------]]--

function PANEL:Init()
    self.Size = self.Small
    self["NewTime.PlayerInfo"] = vgui.Create( "NewTime.PlayerInfo", self )

    for _, name in ipairs( NewTime.AnotherStuffLabel ) do
        self[name] = vgui.Create( "DLabel", self )
    end
end


--[[----------------------------
    PANEL:ApplySchemeSettings
----------------------------]]--

function PANEL:ApplySchemeSettings()
    for _, name in ipairs( NewTime.AnotherStuffLabel ) do
        self[name]:SetFont( "DermaDefault" )
        self[name]:SetTextColor( color_black )
    end
end


--[[----------------------------
    PANEL:ShouldRevealPlayer
----------------------------]]--

function PANEL:ShouldRevealPlayer( ply )
    if ply:GetNWBool("disguised", false) then -- TTT disguiser
        return false
    end

    if engine.ActiveGamemode() == "murder" and ( not LocalPlayer():IsAdmin() ) then
        return false
    end
    
    if engine.ActiveGamemode() == "zombiesurvival" then
        local wraith = GAMEMODE.ZombieClasses[ "Wraith" ].Index
        if ply:Team() == TEAM_UNDEAD and ply:GetZombieClass() == wraith then 
            return false
        end
    end

    local Response = hook.Run("NewTime.ShouldRevealPlayer", ply)
    if Response == false then
        return false
    end

    return true
end


--[[----------------------------
    PANEL:Think
----------------------------]]--
local LockTime = 0

function PANEL:Think()
    if self.Size == self.Small then
        self["NewTime.PlayerInfo"]:SetVisible( false )
    else
        self["NewTime.PlayerInfo"]:SetVisible( true )
    end

    if not IsValid( LocalPlayer() ) then return end

    local tr = util.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetAimVector() )
    local trace = util.TraceLine( tr )
    local ply = trace.Entity
    if ply and ply:IsValid() and ply:IsPlayer() and self:ShouldRevealPlayer(ply) then
        self.TargetSize = self.Large
        self["NewTime.PlayerInfo"]:SetPlayer( trace.Entity )
        LockTime = CurTime()
    end

    if LockTime + 2 < CurTime() then
        self.TargetSize = self.Small
    end

    if self.Size ~= self.TargetSize then
        self.Size = math.Approach( self.Size, self.TargetSize, (math.abs( self.Size - self.TargetSize ) + 1) * 8 * FrameTime() )
        self:PerformLayout()
    end

    self["NewTime.TotalTime"]:SetText( NewTime.FormatTime( LocalPlayer():GetPlayerTotalTimePlayed() ) )
    self["NewTime.SessionTime"]:SetText( NewTime.FormatTime( LocalPlayer():GetPlayerSessionTimePlayed() ) )
end


--[[----------------------------
    PANEL:PerformLayout
----------------------------]]--

function PANEL:PerformLayout()
    -- New Format
    self:SetSize( self:GetWide(), self.Size )

    self["NewTime.Label.TotalTime"]:SetSize( 52, 18 )
    self["NewTime.Label.TotalTime"]:SetPos( 8, 2 )
    self["NewTime.Label.TotalTime"]:SetText( TextAll )

    self["NewTime.Label.SessionTime"]:SetSize( 52, 18 )
    self["NewTime.Label.SessionTime"]:SetPos( 8, 20 )
    self["NewTime.Label.SessionTime"]:SetText( TextTime )

    self["NewTime.TotalTime"]:SetSize( self:GetWide() - 52, 18 )
    self["NewTime.TotalTime"]:SetPos( 52, 2 )

    self["NewTime.SessionTime"]:SetSize( self:GetWide() - 52, 18 )
    self["NewTime.SessionTime"]:SetPos( 52, 20 )

    self["NewTime.PlayerInfo"]:SetPos( 0, 42 )
    self["NewTime.PlayerInfo"]:SetSize( self:GetWide() - 8, self:GetTall() - 42 )
end

vgui.Register( "NewTime.Main", PANEL, "Panel" )



--[[------------------------------------
           Info Panel Functions
------------------------------------]]--

local INFOPANEL = {}

--[[----------------------------
    INFOPANEL:Init
----------------------------]]--

function INFOPANEL:Init()
    for _, name in ipairs( NewTime.StuffLabel ) do
        self[name] = vgui.Create( "DLabel", self )
    end
end


--[[----------------------------
    INFOPANEL:SetPlayer
----------------------------]]--

function INFOPANEL:SetPlayer( ply )
    self.Player = ply
end


--[[----------------------------
    INFOPANEL:ApplySchemeSettings
----------------------------]]--

function INFOPANEL:ApplySchemeSettings()
    for _, name in ipairs( NewTime.StuffLabel ) do
        self[name]:SetFont( "DermaDefault" )
        self[name]:SetTextColor( color_black )
    end
end


--[[----------------------------
    INFOPANEL:Think
----------------------------]]--

function INFOPANEL:Think()
    local ply = self.Player
    if not ply or not ply:IsValid() or not ply:IsPlayer() then -- Disconnected
        self:GetParent().TargetSize = self:GetParent().Small
        return
    end

    -- New format
    self["NewTime.TotalTime"]:SetText( NewTime.FormatTime( ply:GetPlayerSessionTimePlayed() ) )
    self["NewTime.SessionTime"]:SetText( NewTime.FormatTime( ply:GetPlayerTotalTimePlayed() ) )
    self["NewTime.Nick"]:SetText( ply:Nick() )
end


--[[----------------------------
    INFOPANEL:PerformLayout
----------------------------]]--

function INFOPANEL:PerformLayout()
    -- New Format
    self["NewTime.Label.Nick"]:SetSize( 52, 18 )
    self["NewTime.Label.Nick"]:SetPos( 8, 0 )
    self["NewTime.Label.Nick"]:SetText( "#playerlist_name" )

    self["NewTime.Label.TotalTime"]:SetSize( 52, 18 )
    self["NewTime.Label.TotalTime"]:SetPos( 8, 18 )
    self["NewTime.Label.TotalTime"]:SetText( TextAll )

    self["NewTime.Label.SessionTime"]:SetSize( 52, 18 )
    self["NewTime.Label.SessionTime"]:SetPos( 8, 36 )
    self["NewTime.Label.SessionTime"]:SetText( TextTime )

    self["NewTime.Nick"]:SetSize( self:GetWide() - 52, 18 )
    self["NewTime.Nick"]:SetPos( 52, 0 )

    self["NewTime.TotalTime"]:SetSize( self:GetWide() - 52, 18 )
    self["NewTime.TotalTime"]:SetPos( 52, 18 )

    self["NewTime.SessionTime"]:SetSize( self:GetWide() - 52, 18 )
    self["NewTime.SessionTime"]:SetPos( 52, 36 )
end


--[[----------------------------
    INFOPANEL:Paint
----------------------------]]--

function INFOPANEL:Paint()
    return true
end

vgui.Register( "NewTime.PlayerInfo", INFOPANEL, "Panel" )


--[[------------------------------------
           SpawnMenu Functions
------------------------------------]]--


function NewTime.BuildCP( cpanel )
    if not cpanel then return end

    cpanel:ClearControls()
    cpanel:AddControl( "Header", {
        Text = "UTime by Megiddo (Team Ulysses)\nNewTime by vicentefelipechile"
    })

    cpanel:AddControl( "Checkbox", {
        Label = "Enable",
        Command = "newtime_enable"
    })

    cpanel:AddControl( "Slider", {
        Label = "Position X",
        Command = "newtime_pos_x",
        Type = "Float",
        Min = "0",
        Max = "100"
    })

    cpanel:AddControl( "Slider", {
        Label = "Position Y",
        Command = "newtime_pos_y",
        Type = "Float",
        Min = "0",
        Max = "100"
    })

    cpanel:AddControl( "Color", {
        Label = "Outside Color",
        Red = "newtime_outsidecolor_r",
        Green = "newtime_outsidecolor_g",
        Blue = "newtime_outsidecolor_b",
        ShowAlpha = "0",
        ShowHSV = "1",
        ShowRGB = "1",
        Multiplier = "255"
    })

    cpanel:AddControl( "Color", {
        Label = "Outside Text Color",
        Red = "newtime_outsidetext_r",
        Green = "newtime_outsidetext_g",
        Blue = "newtime_outsidetext_b",
        ShowAlpha = "0",
        ShowHSV = "1",
        ShowRGB = "1",
        Multiplier = "255"
    })

    cpanel:AddControl( "Color", {
        Label = "Inside Color",
        Red = "newtime_insidecolor_r",
        Green = "newtime_insidecolor_g",
        Blue = "newtime_insidecolor_b",
        ShowAlpha = "0",
        ShowHSV = "1",
        ShowRGB = "1",
        Multiplier = "255"
    })

    cpanel:AddControl( "Color", {
        Label = "Inside Text Color",
        Red = "newtime_insidetext_r",
        Green = "newtime_insidetext_g",
        Blue = "newtime_insidetext_b",
        ShowAlpha = "0",
        ShowHSV = "1",
        ShowRGB = "1",
        Multiplier = "255"
    })

    cpanel:AddControl( "Button", {
        Text = "Reset",
        Label = "Reset colors and position",
        Command = "newtime_reset"
    })
end


function NewTime.ResetCvars()
        RunConsoleCommand( "newtime_outsidecolor_r", "0" )
        RunConsoleCommand( "newtime_outsidecolor_g", "150" )
        RunConsoleCommand( "newtime_outsidecolor_b", "245" )

        RunConsoleCommand( "newtime_outsidetext_r", "255" )
        RunConsoleCommand( "newtime_outsidetext_g", "255" )
        RunConsoleCommand( "newtime_outsidetext_b", "255" )

        RunConsoleCommand( "newtime_insidecolor_r", "250" )
        RunConsoleCommand( "newtime_insidecolor_g", "250" )
        RunConsoleCommand( "newtime_insidecolor_b", "245" )

        RunConsoleCommand( "newtime_insidetext_r", "0" )
        RunConsoleCommand( "newtime_insidetext_g", "0" )
        RunConsoleCommand( "newtime_insidetext_b", "0" )

        RunConsoleCommand( "newtime_pos_x", "98" )
        RunConsoleCommand( "newtime_pos_y", "8" )
        NewTime.BuildCP( controlpanel.Get( "NewTime" ) )
end
concommand.Add( "newtime_reset", NewTime.ResetCvars )


hook.Add( "SpawnMenuOpen", "NewTime.SpawnMenuOpen", function()
    NewTime.BuildCP( controlpanel.Get( "NewTime" ) ) 
end)

hook.Add( "PopulateToolMenu", "NewTime.Populate", function()
    spawnmenu.AddToolMenuOption( "Utilities", "User", "NewTime", "NewTime", "", "", NewTime.BuildCP )
end)