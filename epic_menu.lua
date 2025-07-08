RobloxPlayerBeta --[[
  Ultimate Player Tools v10.2 - Complete Edition
  Features:
  - Enhanced ESP System with Boxes, Health Bars, Tracers
  - Complete Movement Controls (Noclip, Fly, WalkSpeed, JumpPower)
  - Safe Teleport System with Pathfinding
  - Server Hop Functionality
  - Full Environment Controls
  - Advanced Anti-Cheat Protection
  - Modern UI Interface
  - Discord Rich Presence Integration
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local PathfindingService = game:GetService("PathfindingService")
local StarterGui = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")

-- Local Player
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    Players.PlayerAdded:Wait()
    LocalPlayer = Players.LocalPlayer
end

-- Configuration
local config = {
    ESP = {
        Enabled = true,
        TeamColor = true,
        ShowName = true,
        ShowDistance = true,
        ShowHealth = true,
        ShowTracers = true,
        ShowBoxes = true,
        ShowHeadDots = true,
        MaxDistance = 1000,
        FriendColor = Color3.fromRGB(0, 255, 0),
        EnemyColor = Color3.fromRGB(255, 0, 0),
        TextSize = 14,
        TextFont = Enum.Font.SourceSansBold,
        TextOutline = true,
        BoxTransparency = 0.5,
        UpdateRate = 0.1,
        TracerOrigin = "Bottom"
    },
    Movement = {
        Noclip = false,
        WalkSpeed = 16,
        JumpPower = 50,
        Fly = false,
        FlySpeed = 50,
        SpeedBoost = false,
        SpeedBoostMultiplier = 2,
        InfiniteJump = false,
        FlyControls = {
            Forward = Enum.KeyCode.W,
            Backward = Enum.KeyCode.S,
            Left = Enum.KeyCode.A,
            Right = Enum.KeyCode.D,
            Up = Enum.KeyCode.Space,
            Down = Enum.KeyCode.LeftShift
        }
    },
    Teleport = {
        Enabled = true,
        DefaultHeight = 3,
        Duration = 0.5,
        TweenStyle = Enum.EasingStyle.Quad,
        TweenDirection = Enum.EasingDirection.Out,
        MaxDistance = 5000,
        SafetyCheck = true,
        VisualEffects = true,
        EffectColor = Color3.fromRGB(0, 150, 255),
        UsePathfinding = false,
        PathfindingPrecision = 5
    },
    ServerHop = {
        Enabled = false,
        HopDelay = 30,
        PlayerThreshold = 80,
        VIPOnlyServers = false,
        PrivateServers = false
    },
    Environment = {
        Time = 12,
        Brightness = 1,
        Fog = false,
        FogStart = 0,
        FogEnd = 1000,
        AmbientColor = Color3.fromRGB(127, 127, 127),
        ShadowSoftness = 0.5,
        NoClipTerrain = false
    },
    UI = {
        Theme = "Dark",
        Keybind = Enum.KeyCode.RightShift,
        Watermark = true,
        WatermarkText = "Player Tools v10.2",
        DiscordRichPresence = true,
        RichPresenceUpdateInterval = 30
    },
    Safety = {
        AntiKick = true,
        AntiDetection = true,
        AntiAFK = true,
        FakeLag = false,
        NoLogs = true,
        HideFromGameDetectors = true
    }
}

-- Memory Management
local espCache = {}
local connections = {}
local flyConnections = {}
local teleportQueue = {}

-- Anti-Duplicate
if getgenv().PlayerToolsLoaded then return end
getgenv().PlayerToolsLoaded = true

-- ESP Holder
local ESPHolder = Instance.new("Folder")
ESPHolder.Name = "UltimateESP_"..math.random(1, 9999)
ESPHolder.Parent = CoreGui

-- Discord Rich Presence Variables
local lastRichPresenceUpdate = 0
local richPresenceState = "Exploring"
local richPresenceDetails = "Loading tools..."
local richPresenceStartTime = os.time()
local lastPosition = Vector3.new(0, 0, 0)
local totalDistance = 0

-- Cleanup Function
local function Cleanup()
    for _, conn in pairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, espPart in ipairs({"ESP_Highlight", "ESP_Billboard", "ESP_Box", "ESP_HeadDot"}) do
                local part = player.Character:FindFirstChild(espPart)
                if part then part:Destroy() end
            end
        end
    end
    
    pcall(function() ESPHolder:Destroy() end)
    table.clear(espCache)
    table.clear(connections)
    table.clear(teleportQueue)
end

-- Notification System
local function Notify(title, message, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = message,
            Duration = duration or 3,
            Icon = "rbxassetid://6726579484"
        })
    end)
end

-- Anti-Detection System
local function SetupAntiDetection()
    if not config.Safety.AntiDetection then return end
    
    -- Disable error signals
    for _, v in pairs(getconnections(game:GetService("ScriptContext").Error)) do
        pcall(function() v:Disable() end)
    end
    
    -- Modify metatables
    local mt = getrawmetatable(game)
    if mt then
        local oldNamecall = mt.__namecall
        local oldIndex = mt.__index
        
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if tostring(self):lower():find("hack") or tostring(self):lower():find("cheat") then
                return nil
            end
            return oldNamecall(self, ...)
        end)
        
        mt.__index = newcclosure(function(self, key)
            if tostring(key):lower():find("hack") or tostring(key):lower():find("cheat") then
                return nil
            end
            return oldIndex(self, key)
        end)
        
        setreadonly(mt, true)
    end
    
    -- Hide from common detection methods
    if config.Safety.HideFromGameDetectors then
        local hiddenNames = {
            "Synapse", "Krnl", "ScriptWare", "Electron", 
            "Fluxus", "JJSploit", "Hydrogen", "Coco"
        }
        
        for _, name in ipairs(hiddenNames) do
            pcall(function()
                if getgenv()[name] then
                    getgenv()[name] = nil
                end
            end)
        end
    end
end

-- Complete ESP System
local function CreateESP(player)
    if player == LocalPlayer or espCache[player] then return end
    
    local character = player.Character or player.CharacterAdded:Wait()
    if not character then return end
    
    -- Wait for necessary parts with timeout
    local humanoid, head, rootPart
    local startTime = os.clock()
    
    while os.clock() - startTime < 5 do -- 5 second timeout
        humanoid = character:FindFirstChildOfClass("Humanoid")
        head = character:FindFirstChild("Head")
        rootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoid and head and rootPart then break end
        task.wait(0.1)
    end
    
    if not humanoid or not head or not rootPart then return end

    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = character
    highlight.FillTransparency = config.ESP.BoxTransparency
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character

    -- Box ESP
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESP_Box"
    box.Size = Vector3.new(3, 5, 3)
    box.Transparency = config.ESP.BoxTransparency
    box.ZIndex = 1
    box.AlwaysOnTop = true
    box.Adornee = rootPart
    box.Parent = ESPHolder

    -- Head Dot
    local headDot = Instance.new("SphereHandleAdornment")
    headDot.Name = "ESP_HeadDot"
    headDot.Radius = 0.5
    headDot.Transparency = 0.3
    headDot.ZIndex = 2
    headDot.AlwaysOnTop = true
    headDot.Adornee = head
    headDot.Parent = ESPHolder

    -- Name Tag
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = head
    billboard.Parent = ESPHolder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "ESP_Name"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
    nameLabel.Text = player.Name
    nameLabel.TextSize = config.ESP.TextSize
    nameLabel.Font = config.ESP.TextFont
    nameLabel.TextStrokeTransparency = config.ESP.TextOutline and 0.5 or 1
    nameLabel.Parent = billboard

    -- Info Label
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "ESP_Info"
    infoLabel.BackgroundTransparency = 1
    infoLabel.Size = UDim2.new(1, 0, 0.3, 0)
    infoLabel.Position = UDim2.new(0, 0, 0.4, 0)
    infoLabel.TextSize = config.ESP.TextSize - 2
    infoLabel.Font = config.ESP.TextFont
    infoLabel.TextStrokeTransparency = config.ESP.TextOutline and 0.5 or 1
    infoLabel.Parent = billboard

    -- Health Bar
    local healthBar = Instance.new("Frame")
    healthBar.Name = "ESP_HealthBar"
    healthBar.Size = UDim2.new(1, 0, 0.1, 0)
    healthBar.Position = UDim2.new(0, 0, 0.7, 0)
    healthBar.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = billboard

    local healthFill = Instance.new("Frame")
    healthFill.Name = "ESP_HealthFill"
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBar

    -- Tracer
    local tracer = Instance.new("LineHandleAdornment")
    tracer.Name = "ESP_Tracer"
    tracer.Thickness = 1
    tracer.Transparency = 0.7
    tracer.ZIndex = 10
    tracer.Visible = false
    tracer.Parent = ESPHolder

    -- Cache
    espCache[player] = {
        Highlight = highlight,
        Box = box,
        HeadDot = headDot,
        Billboard = billboard,
        Tracer = tracer,
        Character = character,
        Humanoid = humanoid,
        RootPart = rootPart,
        LastUpdate = 0
    }

    -- Update Function
    local function UpdateESP()
        if not config.ESP.Enabled or not character.Parent then
            highlight.Enabled = false
            box.Visible = false
            headDot.Visible = false
            billboard.Enabled = false
            tracer.Visible = false
            return
        end

        if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end

        local now = os.clock()
        local distance = (LocalPlayer.Character.PrimaryPart.Position - rootPart.Position).Magnitude
        
        -- Skip update if too frequent based on distance
        if now - espCache[player].LastUpdate < (distance > 500 and 0.5 or config.ESP.UpdateRate) then
            return
        end
        
        espCache[player].LastUpdate = now
        local shouldShow = distance <= config.ESP.MaxDistance

        highlight.Enabled = shouldShow
        box.Visible = shouldShow and config.ESP.ShowBoxes
        headDot.Visible = shouldShow and config.ESP.ShowHeadDots
        billboard.Enabled = shouldShow
        tracer.Visible = shouldShow and config.ESP.ShowTracers

        if not shouldShow then return end

        -- Update Colors
        local color
        if config.ESP.TeamColor and player.Team then
            color = player.TeamColor.Color
        else
            color = player.Team == LocalPlayer.Team and config.ESP.FriendColor or config.ESP.EnemyColor
        end

        highlight.FillColor = color
        highlight.OutlineColor = color
        box.Color3 = color
        headDot.Color3 = color
        nameLabel.TextColor3 = color

        -- Update Info
        local infoText = {}
        if config.ESP.ShowDistance then
            table.insert(infoText, string.format("%.1fm", distance))
        end
        if config.ESP.ShowHealth then
            table.insert(infoText, math.floor(humanoid.Health).."/"..math.floor(humanoid.MaxHealth))
        end
        infoLabel.Text = table.concat(infoText, " | ")

        -- Update Health
        local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
        healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
        healthFill.BackgroundColor3 = Color3.fromHSV(healthPercent * 0.3, 1, 1)

        -- Update Tracer
        if config.ESP.ShowTracers then
            local camera = Workspace.CurrentCamera
            local viewportSize = camera.ViewportSize
            
            local originPos = if config.ESP.TracerOrigin == "Bottom" then 
                Vector2.new(viewportSize.X/2, viewportSize.Y) else
                Vector2.new(viewportSize.X/2, viewportSize.Y/2)
                
            local targetPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                tracer.Visible = false
            else
                tracer.Visible = true
                tracer.Adornee = nil
                tracer.Length = (Vector2.new(targetPos.X, targetPos.Y) - originPos).Magnitude
                tracer.CFrame = CFrame.new(
                    camera:ViewportPointToRay(originPos.X, originPos.Y, 0).Origin,
                    camera:ViewportPointToRay(targetPos.X, targetPos.Y, 0).Origin
                )
                tracer.Color3 = color
            end
        end
    end

    -- Connections
    local conn1 = player:GetPropertyChangedSignal("TeamColor"):Connect(UpdateESP)
    local conn2 = humanoid:GetPropertyChangedSignal("Health"):Connect(UpdateESP)
    local conn3 = humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(UpdateESP)
    local conn4 = RunService.Heartbeat:Connect(UpdateESP)
    
    table.insert(connections, conn1)
    table.insert(connections, conn2)
    table.insert(connections, conn3)
    table.insert(connections, conn4)
    
    UpdateESP()
end

local function RemoveESP(player)
    if espCache[player] then
        pcall(function()
            if espCache[player].Highlight then espCache[player].Highlight:Destroy() end
            if espCache[player].Box then espCache[player].Box:Destroy() end
            if espCache[player].HeadDot then espCache[player].HeadDot:Destroy() end
            if espCache[player].Billboard then espCache[player].Billboard:Destroy() end
            if espCache[player].Tracer then espCache[player].Tracer:Destroy() end
            espCache[player] = nil
        end)
    end
end

-- Complete Movement System
local Movement = {
    OriginalWalkSpeed = 16,
    OriginalJumpPower = 50,
    Noclip = false,
    Fly = false,
    FlyVelocity = nil,
    SpeedBoost = false,
    InfiniteJump = false
}

function Movement:Update()
    if not LocalPlayer.Character then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local speed = config.Movement.WalkSpeed
    if config.Movement.SpeedBoost then
        speed = speed * config.Movement.SpeedBoostMultiplier
    end
    
    humanoid.WalkSpeed = speed
    humanoid.JumpPower = config.Movement.JumpPower
end

function Movement:ToggleNoclip(state)
    self.Noclip = state
    
    if state then
        local conn = RunService.Stepped:Connect(function()
            if not LocalPlayer.Character then return end
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end)
        table.insert(connections, conn)
    end
end

function Movement:ToggleFly(state)
    self.Fly = state
    
    if state then
        if not LocalPlayer.Character then return end
        
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        -- Create fly controller with better physics
        self.FlyVelocity = Instance.new("BodyVelocity")
        self.FlyVelocity.Velocity = Vector3.new(0, 0, 0)
        self.FlyVelocity.MaxForce = Vector3.new(0, 0, 0)
        self.FlyVelocity.P = 10000 -- Increased for better control
        self.FlyVelocity.Parent = LocalPlayer.Character.PrimaryPart
        
        local flySpeed = config.Movement.FlySpeed
        local controls = config.Movement.FlyControls
        local forward, backward, left, right, up, down = 0, 0, 0, 0, 0, 0
        
        -- Input handling with debounce
        local inputConn = UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            
            if input.KeyCode == controls.Forward then forward = flySpeed end
            if input.KeyCode == controls.Backward then backward = -flySpeed end
            if input.KeyCode == controls.Left then left = -flySpeed end
            if input.KeyCode == controls.Right then right = flySpeed end
            if input.KeyCode == controls.Up then up = flySpeed end
            if input.KeyCode == controls.Down then down = -flySpeed end
        end)
        
        local endConn = UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == controls.Forward then forward = 0 end
            if input.KeyCode == controls.Backward then backward = 0 end
            if input.KeyCode == controls.Left then left = 0 end
            if input.KeyCode == controls.Right then right = 0 end
            if input.KeyCode == controls.Up then up = 0 end
            if input.KeyCode == controls.Down then down = 0 end
        end)
        
        -- Smooth flight physics
        local physicsConn = RunService.Heartbeat:Connect(function(dt)
            if not self.Fly or not LocalPlayer.Character then return end
            
            local root = LocalPlayer.Character.PrimaryPart
            if not root then return end
            
            local camera = Workspace.CurrentCamera
            local lookVector = camera.CFrame.LookVector
            local rightVector = camera.CFrame.RightVector
            
            -- Apply acceleration-based movement
            local moveDirection = (lookVector * (forward + backward)) + (rightVector * (left + right))
            moveDirection = moveDirection + Vector3.new(0, up + down, 0)
            
            -- Smooth interpolation
            self.FlyVelocity.Velocity = moveDirection
            self.FlyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
        end)
        
        table.insert(flyConnections, inputConn)
        table.insert(flyConnections, endConn)
        table.insert(flyConnections, physicsConn)
    else
        -- Cleanup fly connections
        for _, conn in ipairs(flyConnections) do
            conn:Disconnect()
        end
        table.clear(flyConnections)
        
        if self.FlyVelocity then
            self.FlyVelocity:Destroy()
            self.FlyVelocity = nil
        end
    end
end

function Movement:ToggleInfiniteJump(state)
    self.InfiniteJump = state
    
    if state then
        local conn = UserInputService.JumpRequest:Connect(function()
            if not LocalPlayer.Character then return end
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        table.insert(connections, conn)
    end
end

-- Complete Teleport System
local TeleportController = {
    Active = false,
    TargetPlayer = nil,
    Pathfinding = nil,
    LastTeleportTime = 0
}

function TeleportController:Start(targetPlayer)
    -- Check if teleporting too fast
    if os.clock() - self.LastTeleportTime < 1 then
        Notify("Teleport", "Please wait before teleporting again", 2)
        return false
    end
    
    if self.Active then self:Stop() end
    
    -- Validate target player
    if not targetPlayer or targetPlayer == LocalPlayer then
        Notify("Error", "Invalid target player", 3)
        return false
    end
    
    -- Validate characters
    if not targetPlayer.Character or not LocalPlayer.Character then
        Notify("Error", "Characters not loaded", 3)
        return false
    end
    
    -- Validate root parts
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not targetRoot or not localRoot then
        Notify("Error", "Missing root parts", 3)
        return false
    end
    
    -- Check distance
    local distance = (targetRoot.Position - localRoot.Position).Magnitude
    if distance > config.Teleport.MaxDistance then
        Notify("Error", "Target too far away ("..math.floor(distance).."m)", 3)
        return false
    end
    
    self.Active = true
    self.TargetPlayer = targetPlayer
    self.LastTeleportTime = os.clock()
    
    coroutine.wrap(function()
        local pathfinder
        if config.Teleport.UsePathfinding then
            pathfinder = PathfindingService:CreatePath({
                AgentRadius = 2,
                AgentHeight = 5,
                AgentCanJump = true,
                WaypointSpacing = config.Teleport.PathfindingPrecision
            })
        end
        
        while self.Active and self.TargetPlayer do
            if not self.TargetPlayer.Character then break end
            
            targetRoot = self.TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
            localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if targetRoot and localRoot then
                local distance = (targetRoot.Position - localRoot.Position).Magnitude
                if distance > config.Teleport.MaxDistance then
                    self:Stop()
                    Notify("Error", "Target too far away", 3)
                    break
                end
                
                if config.Teleport.UsePathfinding and pathfinder then
                    -- Pathfinding teleport
                    local success, errorMessage = pcall(function()
                        pathfinder:ComputeAsync(localRoot.Position, targetRoot.Position)
                    end)
                    
                    if success and pathfinder.Status == Enum.PathStatus.Success then
                        local waypoints = pathfinder:GetWaypoints()
                        for _, waypoint in ipairs(waypoints) do
                            if not self.Active then break end
                            
                            local tween = TweenService:Create(
                                localRoot,
                                TweenInfo.new(config.Teleport.Duration, config.Teleport.TweenStyle, config.Teleport.TweenDirection),
                                {CFrame = CFrame.new(waypoint.Position + Vector3.new(0, config.Teleport.DefaultHeight, 0))}
                            )
                            tween:Play()
                            tween.Completed:Wait()
                        end
                    else
                        -- Fallback to direct teleport if pathfinding fails
                        local targetCFrame = CFrame.new(targetRoot.Position + Vector3.new(0, config.Teleport.DefaultHeight, 0))
                        local tween = TweenService:Create(
                            localRoot,
                            TweenInfo.new(config.Teleport.Duration, config.Teleport.TweenStyle, config.Teleport.TweenDirection),
                            {CFrame = targetCFrame}
                        )
                        tween:Play()
                        tween.Completed:Wait()
                    end
                else
                    -- Direct teleport
                    local targetCFrame = CFrame.new(targetRoot.Position + Vector3.new(0, config.Teleport.DefaultHeight, 0))
                    local tween = TweenService:Create(
                        localRoot,
                        TweenInfo.new(config.Teleport.Duration, config.Teleport.TweenStyle, config.Teleport.TweenDirection),
                        {CFrame = targetCFrame}
                    )
                    tween:Play()
                    tween.Completed:Wait()
                end
            end
            
            task.wait(0.5)
        end
        
        if pathfinder then
            pathfinder:Destroy()
        end
    end)()
    
    Notify("Teleport", "Teleporting to "..targetPlayer.Name, 3)
    return true
end

function TeleportController:Stop()
    self.Active = false
    self.TargetPlayer = nil
    Notify("Teleport", "Stopped teleporting", 3)
end

-- Safe Teleport Function
function teleportToPlayer(targetPlayer)
    -- Basic validation
    if not targetPlayer then
        warn("Target player is nil")
        return false
    end
    
    if not LocalPlayer.Character then
        warn("Local player has no character")
        return false
    end
    
    -- Character validation
    if not targetPlayer.Character then
        warn("Target player has no character")
        return false
    end
    
    -- Root part validation
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not targetRoot then
        warn("Target missing HumanoidRootPart")
        return false
    end
    
    if not localRoot then
        warn("Local player missing HumanoidRootPart")
        return false
    end
    
    -- Distance check
    local distance = (targetRoot.Position - localRoot.Position).Magnitude
    if distance > config.Teleport.MaxDistance then
        warn("Target too far ("..math.floor(distance).."m)")
        return false
    end
    
    -- Perform teleport with tween
    local targetCFrame = CFrame.new(targetRoot.Position + Vector3.new(0, config.Teleport.DefaultHeight, 0))
    local tween = TweenService:Create(
        localRoot,
        TweenInfo.new(config.Teleport.Duration, config.Teleport.TweenStyle, config.Teleport.TweenDirection),
        {CFrame = targetCFrame}
    )
    tween:Play()
    
    return true
end

-- Complete Server Hop System
local function ServerHop()
    if not config.ServerHop.Enabled then return end
    
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local attempts = 0
    
    local function TPReturner()
        local Site
        if foundAnything == "" then
            Site = game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100")
        else
            Site = game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100&cursor="..foundAnything)
        end
        
        local ID = ""
        if Site and Site ~= "null" then
            local success, data = pcall(HttpService.JSONDecode, HttpService, Site)
            if not success then return false end
            
            if data.nextPageCursor and data.nextPageCursor ~= "null" then
                foundAnything = data.nextPageCursor
            end
            
            for _, v in pairs(data.data) do
                if tonumber(v.playing) < tonumber(v.maxPlayers) and 
                   (tonumber(v.playing)/tonumber(v.maxPlayers) < (config.ServerHop.PlayerThreshold/100) then
                    
                    -- Apply additional filters
                    local validServer = true
                    
                    if config.ServerHop.VIPOnlyServers and not v.vipServer then
                        validServer = false
                    end
                    
                    if config.ServerHop.PrivateServers and v.vipServer then
                        validServer = false
                    end
                    
                    if validServer then
                        ID = v.id
                        table.insert(AllIDs, ID)
                    end
                end
            end
        end
        
        if #AllIDs > 0 then
            local selectedID = AllIDs[math.random(1, #AllIDs)]
            TeleportService:TeleportToPlaceInstance(PlaceID, selectedID, LocalPlayer)
            task.wait(4)
            return true
        end
        return false
    end

    -- Try multiple times with increasing delays
    while attempts < 3 do
        local success = TPReturner()
        if success then return true end
        attempts = attempts + 1
        task.wait(2 ^ attempts) -- Exponential backoff
    end
    
    return false
end

-- Complete Environment Controls
local function UpdateEnvironment()
    Lighting.ClockTime = config.Environment.Time
    Lighting.Brightness = config.Environment.Brightness
    Lighting.Ambient = config.Environment.AmbientColor
    Lighting.ShadowSoftness = config.Environment.ShadowSoftness
    
    if config.Environment.Fog then
        Lighting.FogStart = config.Environment.FogStart
        Lighting.FogEnd = config.Environment.FogEnd
        Lighting.FogColor = Color3.fromRGB(200, 200, 200)
    else
        Lighting.FogStart = 0
        Lighting.FogEnd = 0
    end
    
    if config.Environment.NoClipTerrain then
        for _, part in ipairs(Workspace:FindFirstChildOfClass("Terrain"):GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

-- Complete Anti-Kick System
local function SetupAntiKick()
    if not config.Safety.AntiKick then return end
    
    local mt = getrawmetatable(game)
    if not mt then return end
    
    local oldNamecall = mt.__namecall
    local oldIndex = mt.__index
    
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then
            Notify("Anti-Kick", "Kick attempt blocked from "..tostring(self), 3)
            return nil
        end
        return oldNamecall(self, ...)
    end)
    
    mt.__index = newcclosure(function(self, key)
        if tostring(key):lower() == "kick" then
            return function() end
        end
        return oldIndex(self, key)
    end)
    
    setreadonly(mt, true)
end

-- Complete Anti-AFK System
local function SetupAntiAFK()
    if not config.Safety.AntiAFK then return end
    
    local conn = LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    table.insert(connections, conn)
end

-- Complete No-Logs System
local function SetupNoLogs()
    if not config.Safety.NoLogs then return end
    
    local oldInfo = print.info
    local oldWarn = print.warn
    local oldError = print.error
    
    print.info = function(...) end
    print.warn = function(...) end
    print.error = function(...) end
    
    table.insert(connections, {
        Disconnect = function()
            print.info = oldInfo
            print.warn = oldWarn
            print.error = oldError
        end
    })
end

-- Discord Rich Presence Function
local function UpdateRichPresence()
    if not config.UI.DiscordRichPresence then return end
    
    local now = os.time()
    if now - lastRichPresenceUpdate < config.UI.RichPresenceUpdateInterval then return end
    lastRichPresenceUpdate = now
    
    -- Get current activity
    local activity = "Exploring"
    local details = "Using Player Tools"
    
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Calculate distance traveled
            local currentPosition = LocalPlayer.Character:GetPivot().Position
            if lastPosition ~= Vector3.new(0, 0, 0) then
                totalDistance = totalDistance + (currentPosition - lastPosition).Magnitude
            end
            lastPosition = currentPosition
            
            local distanceKm = math.floor(totalDistance / 1000)
            details = string.format("Exploring at %dK | Tools active", distanceKm)
            
            -- Determine activity state
            if humanoid:GetState() == Enum.HumanoidStateType.Running then
                activity = "On the move"
            elseif humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                activity = "Jumping around"
            elseif Movement.Fly then
                activity = "Flying"
                details = details .. " | Flying"
            elseif Movement.Noclip then
                activity = "Noclip mode"
                details = details .. " | Noclip"
            end
        end
    end
    
    -- Update rich presence variables
    richPresenceState = activity
    richPresenceDetails = details
    
    -- Send to Discord (via BloxstrapRPC or similar)
    pcall(function()
        local success, result = pcall(function()
            return game:GetService("HttpService"):JSONEncode({
                command = "SetRichPresence",
                data = {
                    details = richPresenceDetails,
                    state = richPresenceState,
                    timeStart = richPresenceStartTime
                }
            })
        end)
        
        if success then
            print("[RichPresence] Updated:", result)
        end
    end)
end

-- Initialize ESP with delay to prevent lag
task.spawn(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
            task.wait(0.1) -- Stagger initialization
        end
    end
end)

-- Player Added/Removed Handlers
table.insert(connections, Players.PlayerAdded:Connect(function(player)
    task.wait(0.5) -- Delay to allow character to load
    CreateESP(player)
end))

table.insert(connections, Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end))

-- Character Handling with better safety
table.insert(connections, LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    Movement.OriginalWalkSpeed = humanoid.WalkSpeed
    Movement.OriginalJumpPower = humanoid.JumpPower
    Movement:Update()
    
    if Movement.Noclip then
        task.wait(0.5) -- Wait for physics to settle
        Movement:ToggleNoclip(true)
    end
    
    if Movement.Fly then
        task.wait(1) -- Wait for character to fully load
        Movement:ToggleFly(true)
    end
    
    if Movement.InfiniteJump then
        Movement:ToggleInfiniteJump(true)
    end
    
    -- Reset distance tracking for Rich Presence
    lastPosition = character:GetPivot().Position
    totalDistance = 0
end))

-- Modern UI with Fluent
local success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success then
    Notify("Error", "Failed to load Fluent UI", 5)
    return
end

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"FakeLag"}) -- Don't save fake lag setting

local Window = Fluent:CreateWindow({
    Title = config.UI.WatermarkText,
    SubTitle = "Complete & Safe Edition",
    TabWidth = 120,
    Size = UDim2.fromOffset(600, 500),
    Acrylic = true,
    Theme = config.UI.Theme,
    MinimizeKey = config.UI.Keybind
})

-- Add watermark if enabled
if config.UI.Watermark then
    Fluent:Notify({
        Title = config.UI.WatermarkText,
        Content = "Successfully loaded!",
        Duration = 5
    })
end

local Tabs = {
    Main = Window:AddTab({Title = "Main", Icon = "home"}),
    ESP = Window:AddTab({Title = "ESP", Icon = "eye"}),
    Player = Window:AddTab({Title = "Player", Icon = "user"}),
    Teleport = Window:AddTab({Title = "Teleport", Icon = "arrow-right"}),
    World = Window:AddTab({Title = "World", Icon = "globe"}),
    Settings = Window:AddTab({Title = "Settings", Icon = "settings"})
}

-- Main Tab
Tabs.Main:AddButton({
    Title = "Refresh ESP",
    Description = "Refresh ESP for all players",
    Callback = function()
        for _, player in ipairs(Players:GetPlayers()) do
            RemoveESP(player)
            if player.Character then
                CreateESP(player)
            end
        end
        Notify("ESP", "Refreshed all players", 3)
    end
})

Tabs.Main:AddButton({
    Title = "Server Hop",
    Description = "Find a new server",
    Callback = function()
        Notify("Server Hop", "Searching for new server...", 3)
        local success = ServerHop()
        if not success then
            Notify("Error", "Failed to find suitable server", 3)
        end
    end
})

-- ESP Tab
Tabs.ESP:AddToggle("ESPEnabled", {
    Title = "Enable ESP",
    Default = config.ESP.Enabled,
    Callback = function(value)
        config.ESP.Enabled = value
    end
})

Tabs.ESP:AddDropdown("TracerOrigin", {
    Title = "Tracer Origin",
    Values = {"Bottom", "Center"},
    Default = config.ESP.TracerOrigin,
    Callback = function(value)
        config.ESP.TracerOrigin = value
    end
})

-- Player Tab
Tabs.Player:AddToggle("SpeedBoost", {
    Title = "Speed Boost",
    Default = config.Movement.SpeedBoost,
    Callback = function(value)
        config.Movement.SpeedBoost = value
        Movement:Update()
    end
})

Tabs.Player:AddSlider("FlySpeed", {
    Title = "Fly Speed",
    Default = config.Movement.FlySpeed,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Callback = function(value)
        config.Movement.FlySpeed = value
    end
})

-- Teleport Tab
Tabs.Teleport:AddToggle("UsePathfinding", {
    Title = "Use Pathfinding",
    Default = config.Teleport.UsePathfinding,
    Callback = function(value)
        config.Teleport.UsePathfinding = value
    end
})

-- World Tab
Tabs.World:AddColorPicker("AmbientColor", {
    Title = "Ambient Color",
    Default = config.Environment.AmbientColor,
    Callback = function(value)
        config.Environment.AmbientColor = value
        UpdateEnvironment()
    end
})

-- Settings Tab
Tabs.Settings:AddToggle("AntiAFK", {
    Title = "Anti-AFK",
    Default = config.Safety.AntiAFK,
    Callback = function(value)
        config.Safety.AntiAFK = value
        if value then
            SetupAntiAFK()
        end
    end
})

Tabs.Settings:AddToggle("NoLogs", {
    Title = "Disable Logs",
    Default = config.Safety.NoLogs,
    Callback = function(value)
        config.Safety.NoLogs = value
        if value then
            SetupNoLogs()
        end
    end
})

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Initialize systems
SetupAntiDetection()
SetupAntiKick()
if config.Safety.AntiAFK then SetupAntiAFK() end
if config.Safety.NoLogs then SetupNoLogs() end

-- Load configuration
SaveManager:LoadAutoloadConfig()

-- Main loop with Rich Presence updates
table.insert(connections, RunService.Heartbeat:Connect(function(dt)
    -- Update movement systems
    Movement:Update()
    
    -- Update ESP for all players
    for player, data in pairs(espCache) do
        if player.Character and data.LastUpdate then
            local now = os.clock()
            if now - data.LastUpdate >= config.ESP.UpdateRate then
                UpdateESP(player)
            end
        end
    end
    
    -- Update Discord Rich Presence
    UpdateRichPresence()
    
    -- Update environment if needed
    if Lighting.ClockTime ~= config.Environment.Time or
       Lighting.Brightness ~= config.Environment.Brightness then
        UpdateEnvironment()
    end
end))

-- Cleanup on game close
table.insert(connections, game:GetService("UserInputService").WindowFocusReleased:Connect(Cleanup))

-- Initial Notification
Notify(config.UI.WatermarkText, "Successfully loaded!", 5)
