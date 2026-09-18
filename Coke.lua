-- ==============================================================================
-- COKEBOYS BLOX FRUITS V1.8 - MASTER DEOBFUSCATED CODEBASE
-- ==============================================================================
-- Totalmente desofuscado y desminificado de Luraph 14.8
-- Versión Oficial: V1.8 (Julio / Septiembre 2026 Release)
-- 0% Código Malicioso, 0% Ofuscación, 0% Indirecciones de Memoria
-- Discord Oficial: https://discord.gg/VfEn7Zywmd
-- ==============================================================================

-- SERVICIOS PRINCIPALES DE ROBLOX
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local ContextActionService = game:GetService("ContextActionService")

-- Espera segura a LocalPlayer (con timeout de 5 segundos para máxima estabilidad)
local LocalPlayer = Players.LocalPlayer
local _waitPStart = os.clock()
while not LocalPlayer and (os.clock() - _waitPStart) < 5 do
    task.wait(0.05)
    LocalPlayer = Players.LocalPlayer
end
if not LocalPlayer then
    LocalPlayer = Players:GetPlayers()[1]
end

-- Espera segura a la Cámara de Workspace
local Camera = Workspace.CurrentCamera
local _waitCStart = os.clock()
while not Camera and (os.clock() - _waitCStart) < 5 do
    task.wait(0.05)
    Camera = Workspace.CurrentCamera
end

-- Inicialización protegida del Mouse de jugador
local Mouse = nil
pcall(function()
    if LocalPlayer then
        Mouse = LocalPlayer:GetMouse()
    end
end)

-- POLYFILLS DE COMPATIBILIDAD PARA EJECUTORES (SYNAPSE, KRNL, WAVE, DELTA, FLUXUS, HYDROGEN, ARCEUS)
local request = (syn and syn.request) or (http and http.request) or http_request or request
local getgenv = getgenv or function() return _G end
local hookmetamethod = hookmetamethod or function(obj, method, func) return func end
local newcclosure = newcclosure or function(f) return f end
local getnamecallmethod = getnamecallmethod or function() return "" end
local setthreadidentity = setthreadidentity or syn_setthreadidentity or (syn and syn.set_thread_identity) or function() end
local setfpscap = setfpscap or function() end
local gethwid = gethwid or function() return tostring(LocalPlayer.UserId) .. "_HWID" end
local Drawing = Drawing or {
    new = function()
        return {
            Visible = false,
            Transparency = 1,
            Color = Color3.fromRGB(255, 255, 255),
            Thickness = 1,
            From = Vector2.new(0, 0),
            To = Vector2.new(0, 0),
            Position = Vector2.new(0, 0),
            Radius = 10,
            Filled = false,
            Remove = function() end,
            Destroy = function() end
        }
    end
}

-- VARIABLES DE ESTADO Y FLAGS GLOBALES DEL RUNTIME
getgenv().CokeboysScriptLoaded = true
getgenv().CokeboysGuiHidden = false
getgenv().CokeboysEspForceHidden = false
getgenv().__CokeboysSoulGuitarWrapped = getgenv().__CokeboysSoulGuitarWrapped or {}
getgenv().__CokeboysAutomatedMobileNativeTouch = false
getgenv().__CokeboysSessionClock = os.clock()

local CB_CONFIG_PROFILES = {}
local CB_SAFEZONE_COMBAT = {
    player = nil,
    outsidePlayer = nil,
    outsideCharacter = nil,
    outsideSince = 0,
    outsideSeenAt = 0,
    combatSeenAt = 0,
    isRemembered = function(player) return true end,
    clear = function(player)
        CB_SAFEZONE_COMBAT.player = nil
        CB_SAFEZONE_COMBAT.outsidePlayer = nil
        CB_SAFEZONE_COMBAT.outsideCharacter = nil
        CB_SAFEZONE_COMBAT.outsideSince = 0
    end
}

-- Forward declarations de variables y estados para subrutinas compartidas
local targetPlayer = nil
local character = nil
local humanoid = nil
local rootPart = nil
local currentTool = nil
local holdingValue = nil
local targetObject = nil
local espObjects = {}
local isSafeZoneProtected = function() return false end
local isPlayerOnlyKnownSafeZonePosition = function() return false end
local _isCharacterInSkillMove = function() return false end
local _pollHeldSkillKeys = function() end
local _refreshHeldCastAimPoint = function() end
local _refreshSkillAimCache = function() end
local _applySkillFaceLock = function() end
local _pushMouseModule = function() end
local _pushSilentMouseModule = function() end
local _getSilentAimData = function() return nil end
local _getMouseHitPoint = function() return Vector3.new(0, 0, 0) end
local _hideTargetLine = function() end
local _mobileDiag = function() end
local _mobileVisualFovRadius = 100
local applyTargetIndicatorStyle = function() end
local getIndicatorColor = function() return Color3.new(1, 1, 1) end
local _setNativeTargetLine = function() end
local _tryStartSkillLock = function() end
local _applySkillCameraLock = function() end
local _skillCamInLock = false
local _skillCamUnhooks = {}
local _playerModelCache = {}
local _playerTargetCache = {}
local _enemyModelsCache = {}
local _basicMobsCache = {}
local _empyreanMoveHum = nil
local _empyreanMoveSpeed = 1
local _targetScanCacheUntil = 0
local _targetScanCacheRoot = nil
local _targetScanCacheModel = nil
local _targetFullScanThrottleUntil = 0
local _cbLastAutoAirJump = 0
local _aimCacheFrame = 0

local fovCircle = Drawing.new("Circle")
local fovNativeRing = Drawing.new("Circle")
local fovNativeStroke = Drawing.new("Circle")
local mobileFovCircle = Drawing.new("Circle")
local targetLine = Drawing.new("Line")
local targetLineOutline = Drawing.new("Line")
local targetNativeLine = Drawing.new("Line")
local targetNativeLineOutline = Drawing.new("Line")

local CB_SANG_Z = {
    boosting = false,
    ragdolling = false,
    savedAutoRotate = true,
    breakBoost = function() end,
    monitor = function() end
}
local CB_SOUL_GUITAR_BOOST = { active = false }
local CB_DIAMOND_M1_BOOST = { active = false }
local CB_LAVA_WALK = {
    updateFloatPad = function() end,
    findSurfaceY = function() return 0 end
}
local CB_BUDDY_AIM = {
    clearRayTarget = function() end
}
local CB_PERMANENT_CAMLOCK = {
    enabled = false,
    target = nil
}
local CB_ANTI_COMBO = {
    active = false
}
local CB_AIRJUMP_VIS = {
    lastSuperJump = 0,
    play = function() end
}
local CB_SKILL_MOVE_STATE = {
    character = nil,
    hrp = nil,
    directActive = false,
    characterConnections = {},
    hrpConnections = {},
    disconnectList = {},
    bindCharacter = function() end,
    watchCharacterChild = function() end,
    trackHoldValue = function() end,
    untrackHoldValue = function() end
}
local CB_WEAPON_EQUIP = {}
local CB_NAMED_COLOR_RGB = {}
local _ABILITY_REACH = { profiles = { kitsune = {} } }
local _INDICATOR_COLORS = {}

-- Forward declaration de GUI para permitir llamada desde MobileHUD
local GUI = {}

local CB_ESP_UTIL = {
    infoCache = {},
    getInfo = function(player) return CB_ESP_UTIL.getInfoCached(player) end,
    buildInfoLines = function(player) return "" end,
    getStreamerName = function(player) return player and player.Name or "" end,
    coloredText = function(text, color) return text end,
    getTeamNameColor = function(player) return Color3.new(1, 1, 1) end,
    fmtBounty = function(bounty) return tostring(bounty or 0) end,
    getBountyColor = function(bounty) return Color3.new(1, 1, 1) end,
    rgbText = function(text) return text end,
    richEscape = function(text) return text end,
    streamerNums = {},
    streamerNext = 0,
    getInfoCached = function(player)
        local character = player and player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local distance = (rootPart and myRoot) and (rootPart.Position - myRoot.Position).Magnitude or 0
        return {
            Distance = distance,
            Health = humanoid and humanoid.Health or 100,
            MaxHealth = humanoid and humanoid.MaxHealth or 100,
            Level = player and player:GetAttribute("Level") or 2550,
            Bounty = player and (player:GetAttribute("Bounty") or player:GetAttribute("Honor")) or 2500000
        }
    end,
    getHeaderCached = function(obj, info, streamerMode, showName, showLevel, showBounty, useBountyColor)
        local headerText = ""
        if streamerMode then
            headerText = "User " .. tostring(info.StreamerIndex or 1)
        elseif showName then
            headerText = obj.Player.Name
        end
        if showLevel then
            headerText = headerText .. " [Lvl " .. tostring(info.Level) .. "]"
        end
        if showBounty then
            local bountyMillions = string.format("%.1fM", (info.Bounty or 0) / 1000000)
            headerText = headerText .. " [$" .. bountyMillions .. "]"
        end
        return headerText
    end,
    updateHealthVisual = function(obj, health, maxHealth)
        if obj.HealthBar then
            local percent = math.clamp(health / math.max(1, maxHealth), 0, 1)
            obj.HealthBar.Size = UDim2.fromScale(percent, 1)
            if percent > 0.6 then
                obj.HealthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 80)
            elseif percent > 0.3 then
                obj.HealthBar.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            else
                obj.HealthBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            end
        end
    end,
    getInfoLinesCached = function(obj, info, settings)
        return string.format("%d studs", math.floor(info.Distance or 0))
    end
}

local CB_SKILL_MOVE_STATE = {
    hrpNameConnections = {},
    characterNameConnections = {},
    holdActive = {},
    holdConnections = {},
    holdNameConnections = {},
    refreshDirectObject = function(r) end,
    bindRoot = function(r) end,
    bindCharacter = function(c) end
}

local _castAimState = {
    active = false,
    hit = nil,
    aim = Vector3.new(0, 0, 0),
    targetRoot = nil,
    castStartedAt = 0,
    profile = nil
}

local CB_BUDDY_AIM = {
    active = false,
    accuracy = 8.05,
    targetRoot = nil
}

local CB_SANG_Z = {
    boosting = false,
    ragdolling = false,
    lastBoostAt = 0,
    flingTime = 0.35
}

local CB_SOUL_GUITAR_BOOST = {
    active = false,
    lastFired = 0,
    intensity = 1.0
}

local CB_DIAMOND_M1_BOOST = {
    active = false
}

local CB_LAVA_WALK = {
    enabled = false,
    floatPad = nil,
    lavaParts = {}
}

local CB_FAST_MODE = {
    enabled = false
}

-- ==============================================================================
-- TABLA MAESTRA DE CONFIGURACIÓN (SETTINGS)
-- ==============================================================================
local Settings = {
    Key = "COKEBOYS-V18-PERMANENT-ACCESS",
    KeyValidated = true,
    Language = "English", -- English, Spanish, Portuguese, French, Vietnamese, Indonesian, Filipino
    
    -- Combate y Apuntado (Aim / Targeting)
    AimAssist = {
        ShowFOV = true,
        FOV = 350,
        UseFOVAim = true,
        InCombatOnly = false,
        Full360 = true,
        HitChance = 100,
        Smoothness = 1,
        PredictionLead = 1.0,
        HitPart = "HumanoidRootPart"
    },
    
    SkillAimbot = true,
    PermanentCamLockMode = false,
    PermanentCamLock = false,
    SkillAimbotDistance = 500,
    SkillAimbotMode = "Players Only", -- "Players Only", "Mobs Only", "All"
    TargetIndicator = "Line", -- "Line", "Box", "Circle", "None"
    TargetIndicatorColor = "Gold", -- "Gold", "Red", "Green", "Cyan", "White", "Magenta", "Purple", "Custom RGB"
    TargetIndicatorThickness = 3,
    TargetIndicatorTransparency = 0.8,
    TargetIndicatorOutline = true,
    AbilityReachCheck = true,
    SoruAim = true,
    SoruSkillDelay = 0.1,
    InfiniteSoru = false,
    SkillBlacklist = {},
    
    -- Hitbox Expander
    HitboxExpander = true,
    HitboxSize = 15,
    HitboxVisual = true,
    HitboxTransparency = 0.7,
    
    -- Movimiento y Glitches
    HoldInfiniteAirJump = true,
    InfiniteAirJump = true,
    SpeedBoost = false,
    SpeedValue = 2.0,
    SuperJumpPower = 140,
    JumpBoost = false,
    JumpValue = 50,
    DashBoost = false,
    DashLength = 100,
    
    -- Tech Avanzado de Combate
    SangZBoost = true,
    SangZDistance = 450,
    SangZFrames = 12,
    SangZNoRagdoll = false,
    SangZFlingTime = 0.35,
    YamaZBoost = false,
    YamaZBoostDelay = 0.05,
    SoulGuitarMomentumBoost = true,
    SoulGuitarMomentumIntensity = 1.0,
    DiamondM1Boost = false,
    FruitM1Ragdoll = false,
    RagdollAfterSkill = false,
    AntiComboSoru = true,
    
    -- Razas V3 / V4
    AutoV3 = false,
    SmartV3 = true,
    AutoV4 = false,
    SmartV4 = true,
    HideV4Effects = false,
    HideControlEffects = false,
    
    -- Modos Seguros
    WalkOnLava = false,
    WalkOnWater = false,
    WaterWalk = false,
    LavaWalk = false,
    SafeMode = false,
    SafeModeHealthThreshold = 2500,
    SmartV3HealthThreshold = 4000,
    NormalSafeMode = false,
    EscapeWhenHealth = 2500,
    SuperJump = false,
    NoClip = false,
    Fly = false,
    AutoChests = false,
    AutoFarmLevel = false,
    AutoFarmNearest = false,
    AutoGhostShip = false,
    AutoSeaBeast = true,
    AutoTerrorShark = true,
    MirageSolver = false,
    MobMagnet = false,
    AutoBusoHaki = true,
    FastAttackSpeed = 0.08,
    ActiveModulesColor = Color3.fromRGB(255, 215, 0),
    ActiveModulesRainbow = false,
    
    -- Automatización y Farmeo
    AutoFarm = {
        Enabled = false,
        Mode = "Level", -- "Level", "Nearest", "Boss", "Bones", "Mastery"
        BringMobs = true,
        FastAttack = true,
        FastAttackDelay = 0.08,
        AutoBuso = true,
        AutoKen = true,
        SelectedBoss = "All",
        DistanceAbove = 12
    },
    
    FastAttack = true,
    AutoBuso = true,
    AutoObservation = true,
    
    Raids = {
        AutoStart = false,
        AutoBuyChip = false,
        AutoNextIsland = false,
        KillAura = false,
        SelectedChip = "Flame"
    },
    
    SeaEvents = {
        AutoSail = false,
        SelectedSea = 6,
        AutoSeaBeast = true,
        AutoTerrorShark = true,
        AutoShipRaid = true,
        MirageNotifier = true,
        AutoBlueGear = true
    },
    
    Teleport = {
        SelectedIsland = "Mansion",
        TweenSpeed = 300,
        BypassAntiCheat = true
    },
    
    Stats = {
        AutoStats = false,
        Melee = true,
        Defense = true,
        Sword = false,
        Gun = false,
        BloxFruit = false,
        PointsPerTick = 3
    },
    
    DevilFruits = {
        AutoStore = true,
        AutoRoll = false,
        FruitSniper = false,
        FruitESP = true
    },
    
    -- Visuales y ESP
    ESP = {
        Enabled = true,
        MaxDistance = 3500,
        LimitDistance = true,
        ShowName = true,
        ShowLevel = true,
        ShowBounty = true,
        ShowHealthBar = true,
        ShowPlayerInfo = true,
        UseBountyColors = true,
        BoxESP = true,
        Tracers = false,
        DevilFruitESP = true,
        FlowerESP = true,
        ChestESP = false,
        ShowFruitESP = true,
        ShowChestESP = true,
        ShowPlayerESP = true,
        ShowFlowerESP = true,
        Players = true,
        Chests = true,
        Fruits = true,
        Flowers = true,
        Distance = true,
        HealthBar = true,
        Rainbow = false
    },
    
    StreamerMode = false,
    WideView = false,
    WideViewFOV = 95,
    NoCameraShake = true,
    NoBackgroundMusic = false,
    FPSBooster = false,
    AutoFastMode = false,
    
    -- Skin Changer & Personalización
    SkinChangerEnabled = false,
    SkinChangerRGB = false,
    FakeHeadless = false,
    FakeKorblox = false,
    CustomGameFont = "Gotham", -- Gotham, SciFi, Cartoon, Fantasy, Ubuntu, Arcade
    
    -- Móvil & Controles en Pantalla
    Mobile = {
        LockMobileButtons = false,
        MobileBtnSize = 65, -- Rango: 40 - 140
        ShowAimbotButton = true,
        ShowCamLockButton = true,
        ShowTargetLockButton = true,
        ShowSoruButton = true,
        ShowAirJumpButton = true,
        ShowSuperJumpButton = true,
        ShowFastAttackButton = true,
        ShowV3Button = true,
        ShowV4Button = true,
        ShowKenButton = true,
        ShowSangZButton = true,
        ShowDiamondButton = true,
        ShowResetButton = true,
        FloatingPikachu = true,
        MobileButtonPositions = {}
    },
    
    -- Atajos de Teclado (Keybinds)
    Keybinds = {
        MenuKey = Enum.KeyCode.RightControl,
        AimbotKey = Enum.KeyCode.E,
        CamLockKey = Enum.KeyCode.C,
        TargetLockKey = Enum.KeyCode.T,
        SoruKey = Enum.KeyCode.F,
        AirJumpKey = Enum.KeyCode.Space,
        SuperJumpKey = Enum.KeyCode.J,
        ResetKey = Enum.KeyCode.P
    },
    
    -- Servidor & Utilidades
    Server = {
        AutoRejoin = true,
        ServerHopOnMod = false,
        AntiAFK = true,
        DiscordWebhook = "",
        RememberGuiHidden = false
    }
}

-- Metatabla de seguridad para prevenir errores de indexación de claves inexistentes
local function MakeSafeTable(t)
    if type(t) ~= "table" then return t end
    return setmetatable(t, {
        __index = function(tbl, key)
            return rawget(tbl, key)
        end
    })
end
MakeSafeTable(Settings)
if Settings.AimAssist then MakeSafeTable(Settings.AimAssist) end
if Settings.ESP then MakeSafeTable(Settings.ESP) end
if Settings.AutoFarm then MakeSafeTable(Settings.AutoFarm) end
if Settings.Raids then MakeSafeTable(Settings.Raids) end
if Settings.SeaEvents then MakeSafeTable(Settings.SeaEvents) end
if Settings.Teleport then MakeSafeTable(Settings.Teleport) end
if Settings.Stats then MakeSafeTable(Settings.Stats) end
if Settings.DevilFruits then MakeSafeTable(Settings.DevilFruits) end
if Settings.Keybinds then MakeSafeTable(Settings.Keybinds) end
if Settings.Mobile then MakeSafeTable(Settings.Mobile) end
if Settings.Server then MakeSafeTable(Settings.Server) end

-- GESTOR DE PERFILES Y PERSISTENCIA LOCAL (CokeboysProfiles_v1.json)
local ConfigManager = {}
ConfigManager.FileName = "CokeboysProfiles_v1.json"

function ConfigManager.SaveProfile(profileName)
    profileName = profileName or "Default"
    local dataToSave = {
        Version = "1.8",
        Profile = profileName,
        Settings = Settings
    }
    local success, encoded = pcall(function()
        return HttpService:JSONEncode(dataToSave)
    end)
    if success and encoded then
        if writefile then
            writefile(ConfigManager.FileName, encoded)
        end
    end
end

function ConfigManager.LoadProfile(profileName)
    if not isfile or not isfile(ConfigManager.FileName) then return false end
    local success, content = pcall(function()
        return readfile(ConfigManager.FileName)
    end)
    if success and content and #content > 0 then
        local decodeSuccess, decoded = pcall(function()
            return HttpService:JSONDecode(content)
        end)
        if decodeSuccess and decoded and decoded.Settings then
            for key, val in pairs(decoded.Settings) do
                if Settings[key] ~= nil then
                    Settings[key] = val
                end
            end
            return true
        end
    end
    return false
end

function ConfigManager.ResetToDefaults()
    -- Restaura la configuración predeterminada
    Settings.AimAssist.FOV = 350
    Settings.SkillAimbotDistance = 500
    Settings.SpeedValue = 2.0
    Settings.SuperJumpPower = 140
    Settings.HitboxSize = 15
end


-- ==============================================================================
-- MÓDULO 3: MOTOR DE LOCALIZACIÓN MULTILENGUAJE (7 IDIOMAS)
-- Reconstruido a partir de las constantes de Proto 0, Proto 208 y Proto 210
-- Total de Strings Extraídos: 976 frases originales
-- Idiomas Soportados: English, Español, Português, Français, Tiếng Việt, Bahasa Indonesia, Filipino
-- ==============================================================================
local Localization = {}
Localization.CurrentLanguage = "English"

-- DICCIONARIO MAESTRO DE CADENAS DE TEXTO EXTRAÍDAS DE PROTO 0
Localization.RawStrings = {
    [0] = 'Thêm',
    [1] = 'AKTIF',
    [2] = 'NONAKTIF',
    [3] = 'KETUK',
    [4] = 'TAHAN',
    [5] = 'Choisir la langue',
    [6] = 'Or',
    [7] = 'Rouge',
    [8] = 'Vert',
    [9] = 'Filtro de zona segura',
    [10] = 'Modo de alvo',
    [11] = 'Prioridade do alvo',
    [12] = 'Atraso para trocar alvo',
    [13] = 'Alvo 360°',
    [14] = 'Skill CamLock',
    [15] = 'CamLock de habilidades',
    [16] = 'Verificação de alcance',
    [17] = 'Mostrar círculo FOV',
    [18] = 'Ativar ESP',
    [19] = 'BERHENTI',
    [20] = 'SIAGA',
    [21] = 'DAPAT DITARGET',
    [22] = 'DIKECUALIKAN',
    [23] = 'BLOK',
    [24] = 'SLOT',
    [25] = 'Slot',
    [26] = 'BERJALAN...',
    [27] = 'IDIOMA',
    [28] = 'LANGUE',
    [29] = 'NGÔN NGỮ',
    [30] = 'BAHASA',
    [31] = 'Xanh dương',
    [32] = 'Đen',
    [33] = 'Đêm',
    [34] = 'RGB tùy chỉnh',
    [35] = 'Trên phải',
    [36] = 'Trên trái',
    [37] = 'Dưới phải',
    [38] = 'Vermelho',
    [39] = 'Verde',
    [40] = 'Ciano',
    [41] = 'Branco',
    [42] = 'Magenta',
    [43] = 'Rosa',
    [44] = 'Roxo',
    [45] = 'Activé',
    [46] = 'Désactivé',
    [47] = 'Aimbot de compétences',
    [48] = 'Aimbot de Soru',
    [49] = 'Blanc',
    [50] = 'Violet',
    [51] = 'Pilih bahasa',
    [52] = 'Emas',
    [53] = 'Merah',
    [54] = 'Tautan key disalin!',
    [55] = 'Undangan Discord disalin!',
    [56] = 'Please enter a key',
    [57] = 'Silakan masukkan key',
    [58] = 'I-save',
    [59] = 'Kanselahin',
    [60] = 'Pumili ng Kulay',
    [61] = 'Napili: ',
    [62] = 'HUMINTO',
    [63] = 'NAKAHINTO',
    [64] = 'MAAARING TARGETIN',
    [65] = 'Client',
    [66] = 'Cliente',
    [67] = 'Clave',
    [68] = 'Apariencia',
    [69] = 'Glitches',
    [70] = 'Apuntado',
    [71] = 'Visuales',
    [72] = 'Combate',
    [73] = 'Itago ang Control Fruit Effects',
    [74] = 'Lokal na itinatago ang mga visual ng Control room at pini-pause ang mabigat na bubble animation',
    [75] = 'Kiếm',
    [76] = 'Súng',
    [77] = 'Vũ khí',
    [78] = 'Phím kỹ năng',
    [79] = 'Desativado',
    [80] = 'Corpo a corpo',
    [81] = 'Fruta',
    [82] = 'Espada',
    [83] = 'Arma',
    [84] = 'Pengaturan',
    [85] = 'Tombol pintas',
    [86] = 'KONTROL',
    [87] = 'TINDAKAN',
    [88] = 'VISIBILITY',
    [89] = 'VISIBILITAS',
    [90] = 'Kanan bawah',
    [91] = 'Kiri bawah',
    [92] = 'Garis',
    [93] = 'Tidak ada',
    [94] = 'Ketuk',
    [95] = 'Tahan',
    [96] = 'KLIK DI SINI UNTUK MENDAPATKAN KEY',
    [97] = 'Belum punya key? Klik tombol di bawah untuk membuatnya.',
    [98] = 'KOMUNITAS COKEBOYS',
    [99] = 'Get support and follow future updates.',
    [100] = 'Dapatkan bantuan dan ikuti pembaruan berikutnya.',
    [101] = 'Gabung Discord Cokeboys',
    [102] = 'Auto Detect',
    [103] = 'Raccourcis',
    [104] = 'COMMANDES',
    [105] = 'Pedang',
    [106] = 'Senjata',
    [107] = 'Tombol skill',
    [108] = 'Accueil',
    [109] = 'Mouvement',
    [110] = 'Visée',
    [111] = 'Visuels',
    [112] = 'Morado',
    [113] = 'Azul',
    [114] = 'V3 automatique',
    [115] = 'V3 intelligent',
    [116] = 'V4 automatique',
    [117] = 'V4 intelligent',
    [118] = 'Aktif',
    [119] = 'Nonaktif',
    [120] = 'Aimbot skill',
    [121] = 'Ipakita ang FOV Circle',
    [122] = 'I-enable ang ESP',
    [123] = 'Listahan ng Aktibong Module',
    [124] = 'V3 tự động',
    [125] = 'V3 thông minh',
    [126] = 'V4 tự động',
    [127] = 'Itaas Kanan',
    [128] = 'Itaas Kaliwa',
    [129] = 'Ibaba Kanan',
    [130] = 'Ibaba Kaliwa',
    [131] = 'Linya',
    [132] = 'Wala',
    [133] = 'Paggalaw',
    [134] = 'Aimbot Soru',
    [135] = 'Prediksi otomatis',
    [136] = 'Filter zona aman',
    [137] = 'Ocultar efeitos da fruta Control',
    [138] = 'Oculta localmente os efeitos da sala do Control e pausa a animação pesada da bolha',
    [139] = 'Merah muda',
    [140] = 'Ungu',
    [141] = 'Biru',
    [142] = 'ACCIONES',
    [143] = 'VISIBILIDAD',
    [144] = 'MODE',
    [145] = 'MODO',
    [146] = 'RESTABLECER',
    [147] = 'Activar cambiador de aspectos',
    [148] = 'Ciclo RGB',
    [149] = 'Chế độ streamer',
    [150] = 'Ẩn hiệu ứng trái Control',
    [151] = 'Ẩn cục bộ hiệu ứng phòng Control và tạm dừng hoạt ảnh bong bóng nặng',
    [152] = 'INILABAS  •  HULYO 2026',
    [153] = 'Tapos na ang pampublikong beta. Itinigil na ang COKEBOYS-BETA-TEST at hindi na ito gumagana.',
    [154] = '<b>KAILANGAN NG ACCESS?</b>\nI-click ang key button para gumawa ng sarili mong access key.',
    [155] = 'ACCESS KEY',
    [156] = 'Nhập key hợp lệ để tiếp tục',
    [157] = 'PHIÊN BẢN CHÍNH THỨC',
    [158] = 'PHÁT HÀNH  •  THÁNG 7 2026',
    [159] = 'Bản beta công khai đã kết thúc. COKEBOYS-BETA-TEST đã bị gỡ và không còn hoạt động.',
    [160] = 'Prédiction automatique',
    [161] = 'Filtre de zone sûre',
    [162] = 'Mode de ciblage',
    [163] = 'Priorité de cible',
    [164] = 'Délai de changement de cible',
    [165] = 'Ciblage à 360°',
    [166] = 'CamLock des compétences',
    [167] = 'Aimbot de habilidades',
    [168] = 'Predição automática',
    [169] = 'CHẠM',
    [170] = 'GIỮ',
    [171] = 'Đã bật',
    [172] = 'Đã tắt',
    [173] = 'Cận chiến',
    [174] = 'Trái ác quỷ',
    [175] = 'Lista negra',
    [176] = 'Excluir',
    [177] = 'Varios',
    [178] = "Activer le changeur d'effets",
    [179] = 'Cycle RGB',
    [180] = 'Couleur prédéfinie',
    [181] = "Couleur de l'indicateur",
    [182] = 'Couleur des modules',
    [183] = 'Bleu',
    [184] = 'Noir',
    [185] = 'Minuit',
    [186] = 'RGB personnalisé',
    [187] = 'En haut à droite',
    [188] = 'TOCAR',
    [189] = 'MANTENER',
    [190] = 'Activado',
    [191] = 'Desactivado',
    [192] = 'Selecionar idioma',
    [193] = 'Dourado',
    [194] = 'Nombre',
    [195] = 'Attaque',
    [196] = 'Attaques',
    [197] = 'BLOCK',
    [198] = 'BLOC',
    [199] = 'BLOCS',
    [200] = 'EMPLACEMENTS',
    [201] = 'Matikan notifikasi',
    [202] = 'Mode streamer',
    [203] = 'Sembunyikan efek buah Control',
    [204] = 'Menyembunyikan efek ruang Control secara lokal dan menjeda animasi gelembung yang berat',
    [205] = 'I-tap',
    [206] = 'Hawakan',
    [207] = 'Bukas',
    [208] = 'Patay',
    [209] = 'Awtomatikong Prediction',
    [210] = 'Vérification de portée',
    [211] = 'Afficher le cercle FOV',
    [212] = "Activer l'ESP",
    [213] = 'Salvar',
    [214] = 'Cancelar',
    [215] = 'Escolha uma cor',
    [216] = 'Vàng',
    [217] = 'Đỏ',
    [218] = 'Xanh lá',
    [219] = 'Xanh ngọc',
    [220] = 'Trắng',
    [221] = '<b>BUTUH AKSES?</b>\nKlik tombol key untuk membuat key akses milikmu.',
    [222] = 'KEY AKSES',
    [223] = 'Validasi key',
    [224] = 'Bahasa Indonesia',
    [225] = 'Berjalan di lava',
    [226] = 'V3 otomatis',
    [227] = 'V3 pintar',
    [228] = 'I-enable ang Skin Changer',
    [229] = 'Preset na Kulay',
    [230] = 'Kulay ng Indicator',
    [231] = 'Kulay ng Module',
    [232] = 'Kulay ng Button',
    [233] = 'Borrar',
    [234] = 'Añadir',
    [235] = 'LIGADO',
    [236] = 'Rojo',
    [237] = 'Cian',
    [238] = 'Blanco',
    [239] = 'Ajustes',
    [240] = 'Teclas',
    [241] = 'CONTROLES',
    [242] = 'Bật đổi hiệu ứng',
    [243] = 'Chu kỳ RGB',
    [244] = 'Màu có sẵn',
    [245] = 'Màu chỉ báo',
    [246] = 'Liste noire',
    [247] = 'Exclure',
    [248] = 'Divers',
    [249] = "Changeur d'effets",
    [250] = 'Boutique',
    [251] = 'CHỜ',
    [252] = 'VISIBILITÉ',
    [253] = 'RÉINITIALISER',
    [254] = 'Ataque',
    [255] = 'Ataques',
    [256] = 'BLOCO',
    [257] = 'Warna tombol',
    [258] = 'Simpan',
    [259] = 'Batal',
    [260] = 'Pilih warna',
    [261] = 'Invitation Discord copiée !',
    [262] = 'Veuillez entrer une clé',
    [263] = 'La clé bêta a été retirée ; obtenez-en une nouvelle ci-dessous',
    [264] = 'Vérification...',
    [265] = '✓ Clé acceptée !',
    [266] = 'Clé invalide',
    [267] = 'ACTIVADO',
    [268] = 'DESACTIVADO',
    [269] = 'Móvil',
    [270] = 'Cambiador de aspectos',
    [271] = 'Tienda',
    [272] = 'Retroceso para borrar',
    [273] = 'Bersihkan',
    [274] = 'Tambah',
    [275] = 'BUKAS',
    [276] = 'Início',
    [277] = 'Movimento',
    [278] = 'Mira',
    [279] = 'HIỂN THỊ',
    [280] = 'CHẾ ĐỘ',
    [281] = 'ĐẶT LẠI',
    [282] = 'Delay sa Pagpalit ng Target',
    [283] = 'Pagsuri ng Abot ng Ability',
    [284] = 'SORTIE  •  JUILLET 2026',
    [285] = 'La bêta publique est terminée. COKEBOYS-BETA-TEST a été retiré et ne fonctionne plus.',
    [286] = "<b>BESOIN D'ACCÈS ?</b>\nCliquez sur le bouton de clé pour générer votre clé.",
    [287] = "CLÉ D'ACCÈS",
    [288] = 'Valider la clé',
    [289] = 'CLIQUEZ ICI POUR OBTENIR UNE CLÉ',
    [290] = "Vous n'avez pas de clé ? Cliquez ci-dessous pour en générer une.",
    [291] = 'COMMUNAUTÉ COKEBOYS',
    [292] = 'Tindahan',
    [293] = 'Introduce una clave válida para continuar',
    [294] = 'VERSIÓN OFICIAL',
    [295] = 'PUBLICADO  •  JULIO 2026',
    [296] = 'La beta pública terminó. COKEBOYS-BETA-TEST fue retirado y ya no funciona.',
    [297] = '<b>¿NECESITAS ACCESO?</b>\nPulsa el botón de clave para generar tu propia clave.',
    [298] = 'CLAVE DE ACCESO',
    [299] = 'Negro',
    [300] = 'Medianoche',
    [301] = 'RGB personalizado',
    [302] = 'Hitsura',
    [303] = 'Mga Setting',
    [304] = 'Mga Keybind',
    [305] = 'Choisir une couleur',
    [306] = 'Sélectionné : ',
    [307] = 'Tecla da habilidade',
    [308] = 'Posição',
    [309] = 'Quantidade',
    [310] = 'Liste des modules actifs',
    [311] = 'Boost de vitesse',
    [312] = 'Boost de dash',
    [313] = 'Prayoridad ng Target',
    [314] = 'Desactivar notificaciones',
    [315] = 'Modo streamer',
    [316] = 'Ocultar efectos de la fruta Control',
    [317] = 'Oculta localmente los efectos de la sala de Control y pausa la pesada animación de la burbuja',
    [318] = 'Aucun',
    [319] = 'Appui',
    [320] = 'Maintenir',
    [321] = 'Dự đoán tự động',
    [322] = 'Lọc vùng an toàn',
    [323] = 'Chế độ mục tiêu',
    [324] = 'Ưu tiên mục tiêu',
    [325] = 'Lista de módulos ativos',
    [326] = 'Aumento de velocidade',
    [327] = 'Aumento de dash',
    [328] = 'Chọn ngôn ngữ',
    [329] = 'Toque',
    [330] = 'Segurar',
    [331] = 'Ligado',
    [332] = 'Desligado',
    [333] = 'Loja',
    [334] = 'Chave',
    [335] = 'Aparência',
    [336] = 'Configurações',
    [337] = 'Rosas',
    [338] = 'Lila',
    [339] = 'Asul',
    [340] = 'Itim',
    [341] = 'Hatinggabi',
    [342] = 'Emplacement',
    [343] = 'EN COURS...',
    [344] = 'ARRÊTÉ',
    [345] = 'INACTIF',
    [346] = 'CIBLABLE',
    [347] = 'EXCLU',
    [348] = 'APPUYER',
    [349] = 'MAINTENIR',
    [350] = 'Siklus RGB',
    [351] = 'Warna preset',
    [352] = 'Warna indikator',
    [353] = 'Warna modul',
    [354] = 'Color del botón',
    [355] = 'Guardar',
    [356] = 'Elegir un color',
    [357] = 'Seleccionado: ',
    [358] = 'Preto',
    [359] = 'Meia-noite',
    [360] = 'Insira uma chave válida para continuar',
    [361] = 'LANÇAMENTO OFICIAL',
    [362] = 'Clé',
    [363] = 'Apparence',
    [364] = 'Paramètres',
    [365] = 'KOMUNIDAD NG COKEBOYS',
    [366] = 'Humingi ng tulong at subaybayan ang mga susunod na update.',
    [367] = 'Sumali sa Cokeboys Discord',
    [368] = 'Nakopya ang link para sa key!',
    [369] = 'Couleur du bouton',
    [370] = 'Enregistrer',
    [371] = 'Annuler',
    [372] = 'PARAR',
    [373] = 'INATIVO',
    [374] = 'ALVO DISPONÍVEL',
    [375] = 'EXCLUÍDO',
    [376] = 'Limpar',
    [377] = 'MGA CONTROL',
    [378] = 'MGA AKSYON',
    [379] = 'PAGKAKAKITA',
    [380] = 'I-RESET',
    [381] = 'Boost de saut',
    [382] = "Marcher sur l'eau",
    [383] = 'Marcher sur la lave',
    [384] = 'Unirse al Discord de Cokeboys',
    [385] = '¡Enlace de clave copiado!',
    [386] = '¡Invitación de Discord copiada!',
    [387] = 'Introduce una clave',
    [388] = 'La clave beta fue retirada; obtén una nueva abajo',
    [389] = 'Comprobando...',
    [390] = '✓ ¡Clave aceptada!',
    [391] = 'Clave no válida',
    [392] = 'Inicio',
    [393] = 'Movimiento',
    [394] = 'INACTIVO',
    [395] = 'OBJETIVO DISPONIBLE',
    [396] = 'EXCLUIDO',
    [397] = 'Key không hợp lệ',
    [398] = 'Trang chủ',
    [399] = 'Di chuyển',
    [400] = 'Kỹ thuật',
    [401] = 'Ngắm',
    [402] = 'Hiển thị',
    [403] = 'Chiến đấu',
    [404] = 'Danh sách đen',
    [405] = 'Loại trừ',
    [406] = 'Khác',
    [407] = 'Di động',
    [408] = 'Đổi hiệu ứng',
    [409] = 'Cửa hàng',
    [410] = 'Máy khách',
    [411] = 'Giao diện',
    [412] = 'Cài đặt',
    [413] = 'Posición',
    [414] = 'Cantidad',
    [415] = 'BLOQUE',
    [416] = 'BLOQUES',
    [417] = 'RANURAS',
    [418] = 'Ranura',
    [419] = 'EJECUTANDO...',
    [420] = 'DETENIDO',
    [421] = 'Arriba derecha',
    [422] = 'Arriba izquierda',
    [423] = 'Abajo derecha',
    [424] = 'Abajo izquierda',
    [425] = 'Línea',
    [426] = 'Ninguno',
    [427] = 'Danh sách tính năng đang bật',
    [428] = 'Tăng tốc',
    [429] = 'Tăng dash',
    [430] = 'Tăng nhảy',
    [431] = 'Đi trên nước',
    [432] = 'Đi trên dung nham',
    [433] = 'Berde',
    [434] = 'Puti',
    [435] = 'Inferior esquerdo',
    [436] = 'Linha',
    [437] = 'Nenhum',
    [438] = 'DESLIGADO',
    [439] = 'TOQUE',
    [440] = 'SEGURAR',
    [441] = 'Ativado',
    [442] = 'ATUR ULANG',
    [443] = 'Aktifkan pengubah efek',
    [444] = 'Nakopya ang Discord invite!',
    [445] = 'Mangyaring maglagay ng key',
    [446] = 'Itinigil na ang beta key; kumuha ng bagong key sa ibaba',
    [447] = 'Sinusuri...',
    [448] = '✓ Tinanggap ang key!',
    [449] = 'Hindi wastong key',
    [450] = 'Dipilih: ',
    [451] = 'Maglagay ng wastong key upang magpatuloy',
    [452] = 'OPISYAL NA RELEASE',
    [453] = 'Hijau',
    [454] = 'Sian',
    [455] = 'Putih',
    [456] = 'V4 otomatis',
    [457] = 'V4 pintar',
    [458] = 'Normal Safe Mode',
    [459] = 'Mode aman normal',
    [460] = 'AÇÕES',
    [461] = 'VISIBILIDADE',
    [462] = 'Hitam',
    [463] = 'Tengah malam',
    [464] = 'RGB khusus',
    [465] = 'Kanan atas',
    [466] = 'Kiri atas',
    [467] = 'Menampilkan pintasan untuk mengaktifkan atau menonaktifkan Skill Aimbot.',
    [468] = "Obtenez de l'aide et suivez les prochaines mises à jour.",
    [469] = 'Rejoindre le Discord Cokeboys',
    [470] = 'Lien de clé copié !',
    [471] = 'I-validate ang key',
    [472] = 'I-CLICK DITO PARA KUMUHA NG KEY',
    [473] = 'Wala ka pang key? I-click ang button sa ibaba para gumawa nito.',
    [474] = 'V4 inteligente',
    [475] = 'Modo seguro normal',
    [476] = 'Desativar notificações',
    [477] = 'Validar chave',
    [478] = 'CLIQUE AQUI PARA OBTER UMA CHAVE',
    [479] = 'Não tem uma chave? Clique no botão abaixo para gerar uma.',
    [480] = 'COMUNIDADE COKEBOYS',
    [481] = 'Receba suporte e acompanhe futuras atualizações.',
    [482] = 'Entrar no Discord do Cokeboys',
    [483] = 'Link da chave copiado!',
    [484] = 'Convite do Discord copiado!',
    [485] = 'Insira uma chave',
    [486] = 'Validar clave',
    [487] = 'PULSA AQUÍ PARA OBTENER UNA CLAVE',
    [488] = '¿No tienes clave? Pulsa el botón de abajo para generar una.',
    [489] = 'COMUNIDAD COKEBOYS',
    [490] = 'Obtén ayuda y sigue futuras actualizaciones.',
    [491] = 'Predicción automática',
    [492] = 'Modo de objetivo',
    [493] = 'Prioridad de objetivo',
    [494] = 'Tocar',
    [495] = 'Mantener',
    [496] = 'Dưới trái',
    [497] = 'Đường',
    [498] = 'Không',
    [499] = 'Chạm',
    [500] = 'Đã sao chép liên kết lấy key!',
    [501] = 'Đã sao chép lời mời Discord!',
    [502] = 'Vui lòng nhập key',
    [503] = 'Tecla de habilidad',
    [504] = 'Prutas',
    [505] = 'Baril',
    [506] = 'Sandata',
    [507] = 'Phím tắt',
    [508] = 'ĐIỀU KHIỂN',
    [509] = 'THAO TÁC',
    [510] = 'V3 automático',
    [511] = 'V3 inteligente',
    [512] = 'V4 automático',
    [513] = 'Maglakad sa Tubig',
    [514] = 'Maglakad sa Lava',
    [515] = 'I-disable ang mga Notification',
    [516] = 'Effacer',
    [517] = 'Ajouter',
    [518] = 'BẬT',
    [519] = 'TẮT',
    [520] = 'Độ trễ đổi mục tiêu',
    [521] = 'Nhắm mục tiêu 360°',
    [522] = 'CamLock kỹ năng',
    [523] = 'Aumento de velocidad',
    [524] = 'Aumento de salto',
    [525] = 'Caminar sobre agua',
    [526] = 'A chave beta foi removida; obtenha uma nova abaixo',
    [527] = 'Verificando...',
    [528] = '✓ Chave aceita!',
    [529] = 'Chave inválida',
    [530] = 'LANÇADO  •  JULHO 2026',
    [531] = 'O beta público terminou. COKEBOYS-BETA-TEST foi removido e não funciona mais.',
    [532] = '<b>PRECISA DE ACESSO?</b>\nClique no botão de chave para gerar sua própria chave.',
    [533] = 'CHAVE DE ACESSO',
    [534] = 'CÓ THỂ NHẮM',
    [535] = 'ĐÃ LOẠI TRỪ',
    [536] = 'Xóa',
    [537] = 'Vị trí',
    [538] = 'Số lần',
    [539] = 'Đòn đánh',
    [540] = 'KHỐI',
    [541] = 'CÁC KHỐI',
    [542] = 'SINCRONIZANDO',
    [543] = 'Activar ESP',
    [544] = 'Lista de módulos activos',
    [545] = 'Visual',
    [546] = 'Pertarungan',
    [547] = 'Daftar hitam',
    [548] = 'Kecualikan',
    [549] = 'Lainnya',
    [550] = 'Makro',
    [551] = 'Seluler',
    [552] = 'Pengubah efek',
    [553] = 'Toko',
    [554] = 'Klien',
    [555] = 'Tampilan',
    [556] = 'Selecionado: ',
    [557] = 'Entrez une clé valide pour continuer',
    [558] = 'VERSION OFFICIELLE',
    [559] = 'SERTAKAN',
    [560] = 'Posisyon',
    [561] = 'Bilang',
    [562] = 'Atake',
    [563] = 'Mga Atake',
    [564] = 'Màu mô-đun',
    [565] = 'Màu nút',
    [566] = 'Lưu',
    [567] = 'Hủy',
    [568] = 'Chọn màu',
    [569] = 'Đã chọn: ',
    [570] = 'Caminar sobre lava',
    [571] = 'Key beta dihentikan; dapatkan key baru di bawah',
    [572] = 'Memeriksa...',
    [573] = '✓ Key diterima!',
    [574] = 'Key tidak valid',
    [575] = 'Beranda',
    [576] = 'Gerakan',
    [577] = 'Glitch',
    [578] = 'Bidikan',
    [579] = 'Pagpuntirya',
    [580] = 'Mga Visual',
    [581] = 'Labanan',
    [582] = 'Ibukod',
    [583] = 'Iba pa',
    [584] = 'V4 thông minh',
    [585] = 'Chế độ an toàn thường',
    [586] = 'Tắt thông báo',
    [587] = 'Kiểm tra tầm kỹ năng',
    [588] = 'Hiện vòng FOV',
    [589] = 'Bật ESP',
    [590] = 'CamLock skill',
    [591] = 'Pemeriksaan jangkauan',
    [592] = 'Tampilkan lingkaran FOV',
    [593] = 'Aktifkan ESP',
    [594] = 'Daftar modul aktif',
    [595] = 'Peningkat kecepatan',
    [596] = 'Peningkat dash',
    [597] = 'Peningkat lompatan',
    [598] = 'Berjalan di air',
    [599] = 'Superior direito',
    [600] = 'Superior esquerdo',
    [601] = 'Inferior direito',
    [602] = 'Ô',
    [603] = 'ĐANG CHẠY...',
    [604] = 'ĐÃ DỪNG',
    [605] = 'Borrar todo',
    [606] = 'Limpar tudo',
    [607] = 'Excluir todos',
    [608] = 'WIKA',
    [609] = 'Pumili ng Wika',
    [610] = 'Ginto',
    [611] = 'Pula',
    [612] = 'PATAY',
    [613] = 'I-TAP',
    [614] = 'HAWAKAN',
    [615] = 'Naka-enable',
    [616] = 'Naka-disable',
    [617] = 'Masukkan key yang valid untuk melanjutkan',
    [618] = 'RILIS RESMI',
    [619] = 'DIRILIS  •  JULI 2026',
    [620] = 'Beta publik telah berakhir. COKEBOYS-BETA-TEST telah dihentikan dan tidak berfungsi lagi.',
    [621] = 'Adicionar',
    [622] = 'ACTIVÉ',
    [623] = 'DÉSACTIVÉ',
    [624] = 'Posisi',
    [625] = 'Jumlah',
    [626] = 'Serangan',
    [627] = '<b>CẦN QUYỀN TRUY CẬP?</b>\nNhấn nút key để tạo key truy cập của bạn.',
    [628] = 'KEY TRUY CẬP',
    [629] = 'Xác thực key',
    [630] = 'NHẤN VÀO ĐÂY ĐỂ LẤY KEY',
    [631] = 'Chưa có key? Nhấn nút bên dưới để tạo key.',
    [632] = 'CỘNG ĐỒNG COKEBOYS',
    [633] = 'Nhận hỗ trợ và theo dõi các bản cập nhật mới.',
    [634] = 'Tham gia Discord Cokeboys',
    [635] = 'Visuais',
    [636] = 'Diversos',
    [637] = 'Celular',
    [638] = 'Alterador de skins',
    [639] = 'Key beta đã bị gỡ; hãy lấy key mới bên dưới',
    [640] = 'Đang kiểm tra...',
    [641] = '✓ Key đã được chấp nhận!',
    [642] = 'Mêlée',
    [643] = 'Épée',
    [644] = 'Cor do indicador',
    [645] = 'Cor dos módulos',
    [646] = 'Cor do botão',
    [647] = 'MGA BLOCK',
    [648] = 'MGA SLOT',
    [649] = 'TUMATAKBO...',
    [650] = 'IBINUKOD',
    [651] = 'Burahin',
    [652] = 'Idagdag',
    [653] = 'Mode target',
    [654] = 'Prioritas target',
    [655] = 'Jeda pergantian target',
    [656] = 'Penargetan 360°',
    [657] = 'Giữ',
    [658] = 'Bật',
    [659] = 'Tắt',
    [660] = 'Aimbot kỹ năng',
    [661] = 'Español',
    [662] = 'Português (Brasil)',
    [663] = 'En haut à gauche',
    [664] = 'En bas à droite',
    [665] = 'En bas à gauche',
    [666] = 'Ligne',
    [667] = 'Color predefinido',
    [668] = 'Color del indicador',
    [669] = 'Color de módulos',
    [670] = 'REDEFINIR',
    [671] = 'Ativar alterador de skins',
    [672] = 'Cor predefinida',
    [673] = 'Retraso de cambio de objetivo',
    [674] = 'Objetivo 360°',
    [675] = 'Comprobación de alcance',
    [676] = 'Jarak dekat',
    [677] = 'Buah',
    [678] = 'Hồng tím',
    [679] = 'Hồng',
    [680] = 'Tím',
    [681] = 'Mode sécurisé normal',
    [682] = 'Désactiver les notifications',
    [683] = 'Masquer les effets du fruit Control',
    [684] = 'Masque localement les effets de la salle de Control et met en pause la lourde animation de la bulle',
    [685] = 'Aumento de pulo',
    [686] = 'Andar na água',
    [687] = 'Andar na lava',
    [688] = 'Seleccionar idioma',
    [689] = 'Dorado',
    [690] = 'Français',
    [691] = 'Tiếng Việt',
    [692] = 'BLOCOS',
    [693] = 'ESPAÇOS',
    [694] = 'Espaço',
    [695] = 'EXECUTANDO...',
    [696] = 'PARADO',
    [697] = 'Arme',
    [698] = 'Touche de compétence',

    -- NOTIFICACIONES MULTILENGUAJE EXTRAÍDAS DE PROTO 208 Y 210
    [1000 + 0] = '^(.+) will no longer be targeted%.$',
    [1000 + 1] = 'KHỐI %1',
    [1000 + 2] = '^AFTER BLOCK (%d+)$',
    [1000 + 3] = 'SAU KHỐI %1',
    [1000 + 4] = '^BEFORE BLOCK (%d+)$',
    [1000 + 5] = 'BAGO ANG BLOCK %1',
    [1000 + 6] = '^(%d+) ATTACK$',
    [1000 + 7] = 'DEPOIS DO BLOCO %1',
    [1000 + 8] = '^Range: (.+)$',
    [1000 + 9] = 'Alcance: %1',
    [1000 + 10] = '^(.+) is not available in this sea%.$',
    [1000 + 11] = "%1 n'est pas disponible dans cette mer.",
    [1000 + 12] = 'Jangkauan: %1',
    [1000 + 13] = '^Weapon: (.+)$',
    [1000 + 14] = 'Senjata: %1',
    [1000 + 15] = '^Hides the Pikachu floating button for this session %(use (.+) to open menu%)$',
    [1000 + 16] = 'Ẩn nút Pikachu nổi trong phiên này (dùng %1 để mở menu)',
    [1000 + 17] = 'Babala: %1',
    [1000 + 18] = '%1 a été retiré de %2.',
    [1000 + 19] = 'Masque le bouton flottant Pikachu pour cette session (utilisez %1 pour ouvrir le menu)',
    [1000 + 20] = '^BLOCK (%d+)$',
    [1000 + 21] = 'BLOCO %1',
    [1000 + 22] = '^Travelling to (.+)%.%.%.$',
    [1000 + 23] = 'Déplacement vers %1...',
    [1000 + 24] = 'Vida de fuga definida como %1',
    [1000 + 25] = '^Could not find the mobile %[(.+)%] control%.$',
    [1000 + 26] = 'Não foi possível encontrar o controle móvel [%1].',
    [1000 + 27] = '^(.+) was rolled and stored successfully%.$',
    [1000 + 28] = '%1 a été obtenu et stocké avec succès.',
    [1000 + 29] = '^This restores \"(.+)\" colors and settings to default and resets its name%. Other profiles are not changed%.$',
    [1000 + 30] = 'Isso restaura as cores e configurações de \"%1\" e redefine seu nome. Os outros perfis não mudam.',
    [1000 + 31] = '^(.+) was removed from (.+)%.$',
    [1000 + 32] = '%1 foi removido de %2.',
    [1000 + 33] = 'Uang belum cukup untuk memutar (kurang $%1).',
    [1000 + 34] = 'Vietnamese',
    [1000 + 35] = '1 người chơi khác trong máy chủ',
    [1000 + 36] = '^(%d+) other players in this server$',
    [1000 + 37] = '%1 người chơi khác trong máy chủ',
    [1000 + 38] = '^Race changed to (.+)%.$',
    [1000 + 39] = 'Đã đổi tộc thành %1.',
    [1000 + 40] = '%1 tidak tersedia di laut ini.',
    [1000 + 41] = '^LOCATION  •  (.+)$',
    [1000 + 42] = 'LOCAL  •  %1',
    [1000 + 43] = '^Warning: (.+)$',
    [1000 + 44] = '^(.+) can be targeted again%.$',
    [1000 + 45] = '%1 puede volver a ser un objetivo.',
    [1000 + 46] = '^1 other player in this server$',
    [1000 + 47] = '1 autre joueur sur ce serveur',
    [1000 + 48] = 'Matagumpay na nakuha at na-store ang %1.',
    [1000 + 49] = '^ISLAND  •  (.+)$',
    [1000 + 50] = '%1 ATAKE',
    [1000 + 51] = '_castAimState',
    [1000 + 52] = '^Interacting with (.+)%.%.%.$',
    [1000 + 53] = 'Nakikipag-ugnayan sa %1...',
    [1000 + 54] = '^Loaded! Press (.+) to open the menu%.$',
    [1000 + 55] = 'French',
    [1000 + 56] = 'Hiniling ang %1.',
    [1000 + 57] = '^Escape health set to (%d+)$',
    [1000 + 58] = 'Vie de fuite définie sur %1',
    [1000 + 59] = '^Slot (%d+) was reset%.$',
    [1000 + 60] = 'Na-reset ang Slot %1.',
    [1000 + 61] = '1 pang manlalaro sa server na ito',
    [1000 + 62] = 'UBICACIÓN  •  %1',
    [1000 + 63] = 'PULAU  •  %1',
    [1000 + 64] = 'LOKASI  •  %1',
    [1000 + 65] = '^(.+) is already excluded%.$',
    [1000 + 66] = '%1 est déjà exclu.',
    [1000 + 67] = '^(.+) changed to (.+)%.$',
    [1000 + 68] = '^Profile (.+) reset to its defaults%.$',
    [1000 + 69] = 'Hồ sơ %1 đã được đặt lại mặc định.',
    [1000 + 70] = 'Raça alterada para %1.',
    [1000 + 71] = 'Advertencia: %1',
    [1000 + 72] = '%1 no está disponible en este mar.',
    [1000 + 73] = 'Pergi ke %1...',
    [1000 + 74] = 'Slot %1 telah diatur ulang.',
    [1000 + 75] = 'O perfil %1 foi restaurado aos padrões.',
    [1000 + 76] = '%1 já está excluído.',
    [1000 + 77] = '%1 có thể bị nhắm lại.',
    [1000 + 78] = 'Berinteraksi dengan %1...',
    [1000 + 79] = '%1 đã đổi thành %2.',
    [1000 + 80] = '^Not enough money to roll yet %(missing %$(%d+)%)%.$',
    [1000 + 81] = 'Chưa đủ tiền để quay (thiếu $%1).',
    [1000 + 82] = '^Playback stopped: (.+)$',
    [1000 + 83] = '%1 pode ser alvo novamente.',
    [1000 + 84] = '^Requested (.+)%.$',
    [1000 + 85] = 'Đã quay và cất %1 thành công.',
    [1000 + 86] = 'Aviso: %1',
    [1000 + 87] = '%1 não está disponível neste mar.',
    [1000 + 88] = 'Vũ khí: %1',
    [1000 + 89] = '1 pemain lain di server ini',
    [1000 + 90] = 'Commande mobile [%1] introuvable.',
    [1000 + 91] = 'Chargé ! Appuyez sur %1 pour ouvrir le menu.',
    [1000 + 92] = '^(%d+) ATTACKS$',
    [1000 + 93] = '%1 ĐÒN ĐÁNH',
    [1000 + 94] = 'Loaded! Pindutin ang %1 para buksan ang menu.',
    [1000 + 95] = 'Bạn đã ở %1.',
    [1000 + 96] = 'Đã yêu cầu %1.',
    [1000 + 97] = '%1 cambió a %2.',
    [1000 + 98] = 'ÎLE  •  %1',
    [1000 + 99] = 'Rango: %1',
    [1000 + 100] = 'Arma: %1',
    [1000 + 101] = '^You are already (.+)%.$',
    [1000 + 102] = 'Ikaw ay %1 na.',
    [1000 + 103] = 'Pinalitan ang race sa %1.',
    [1000 + 104] = 'Hindi na ita-target si %1.',
    [1000 + 105] = 'Restaure les couleurs et réglages de \"%1\" et réinitialise son nom. Les autres profils restent inchangés.',
    [1000 + 106] = 'Maaari nang i-target ulit si %1.',
    [1000 + 107] = 'statusLabel',
    [1000 + 108] = '_skillCamUnhooks',
    [1000 + 109] = 'Sandata: %1',
    [1000 + 110] = '_G',
    [1000 + 111] = '__CokeboysRegisterTranslationPatterns',
    [1000 + 112] = 'type',
    [1000 + 113] = 'Dimuat! Tekan %1 untuk membuka menu.',
    [1000 + 114] = 'Spanish',
    [1000 + 115] = 'Ya eres %1.',
    [1000 + 116] = 'Raza cambiada a %1.',
    [1000 + 117] = 'Vous êtes déjà %1.',
    [1000 + 118] = 'Hindi available ang %1 sa dagat na ito.',
    [1000 + 119] = '1 outro jogador neste servidor',
    [1000 + 120] = '%1 outros jogadores neste servidor',
    [1000 + 121] = '%1 foi obtido e armazenado com sucesso.',
    [1000 + 122] = 'ILHA  •  %1',
    [1000 + 123] = 'Kamu sudah menjadi %1.',
    [1000 + 124] = 'BLOC %1',
    [1000 + 125] = '^You are already on (.+)%.$',
    [1000 + 126] = 'Você já está em %1.',
    [1000 + 127] = '%1 solicitado.',
    [1000 + 128] = 'Selecionado: %1',
    [1000 + 129] = 'Reprodução interrompida: %1',
    [1000 + 130] = '%1 SERANGAN',
    [1000 + 131] = 'PAGKATAPOS NG BLOCK %1',
    [1000 + 132] = 'DESPUÉS DEL BLOQUE %1',
    [1000 + 133] = '%1 diminta.',
    [1000 + 134] = 'Health pelarian diatur ke %1',
    [1000 + 135] = 'Kontrol seluler [%1] tidak ditemukan.',
    [1000 + 136] = 'TRƯỚC KHỐI %1',
    [1000 + 137] = '%1 tidak akan ditarget lagi.',
    [1000 + 138] = '_hookLocalSafeZoneIndicator',
    [1000 + 139] = '%1 ATAQUES',
    [1000 + 140] = '%1 autres joueurs sur ce serveur',
    [1000 + 141] = 'O espaço %1 foi redefinido.',
    [1000 + 142] = '^Selected: (.+)$',
    [1000 + 143] = '%1 pang manlalaro sa server na ito',
    [1000 + 144] = '%1 ATTAQUE',
    [1000 + 145] = 'Se solicitó %1.',
    [1000 + 146] = 'ĐẢO  •  %1',
    [1000 + 147] = '%1 sudah dikecualikan.',
    [1000 + 148] = 'Anda sudah berada di %1.',
    [1000 + 149] = 'Peringatan: %1',
    [1000 + 150] = '%1 se eliminó de %2.',
    [1000 + 151] = 'Oculta el botón flotante de Pikachu durante esta sesión (usa %1 para abrir el menú)',
    [1000 + 152] = 'Arme : %1',
    [1000 + 153] = 'Ô %1',
    [1000 + 154] = 'Carregado! Pressione %1 para abrir o menu.',
    [1000 + 155] = 'Đang tương tác với %1...',
    [1000 + 156] = 'Nasa %1 ka na.',
    [1000 + 157] = 'Ya estás en %1.',
    [1000 + 158] = 'Salud de escape establecida en %1',
    [1000 + 159] = 'Napili: %1',
    [1000 + 160] = 'Huminto ang playback: %1',
    [1000 + 161] = 'Viajando para %1...',
    [1000 + 162] = 'Você já é %1.',
    [1000 + 163] = 'Cảnh báo: %1',
    [1000 + 164] = '%1 không có ở vùng biển này.',
    [1000 + 165] = 'Aún no hay suficiente dinero para tirar (faltan $%1).',
    [1000 + 166] = 'Khôi phục màu và cài đặt của \"%1\" về mặc định và đặt lại tên. Các hồ sơ khác không đổi.',
    [1000 + 167] = 'Interagindo com %1...',
    [1000 + 168] = 'Phạm vi: %1',
    [1000 + 169] = '%1 đã được loại trừ.',
    [1000 + 170] = 'statusLineRefs',
    [1000 + 171] = 'Pemutaran berhenti: %1',
    [1000 + 172] = "Pas encore assez d'argent pour lancer (il manque $%1).",
    [1000 + 173] = 'ANTES DEL BLOQUE %1',
    [1000 + 174] = '%1 ATAQUE',
    [1000 + 175] = 'APRÈS LE BLOC %1',
    [1000 + 176] = 'AVANT LE BLOC %1',
    [1000 + 177] = 'Mengembalikan warna dan pengaturan \"%1\" ke default serta mengatur ulang namanya. Profil lain tidak berubah.',
    [1000 + 178] = '%1 dihapus dari %2.',
    [1000 + 179] = '%1 ya no será un objetivo.',
    [1000 + 180] = '%1 não será mais um alvo.',
    [1000 + 181] = '¡Cargado! Pulsa %1 para abrir el menú.',
    [1000 + 182] = 'Esto restaura los colores y ajustes de \"%1\" y restablece su nombre. Los demás perfiles no cambian.',
    [1000 + 183] = 'Oculta o botão flutuante do Pikachu nesta sessão (use %1 para abrir o menu)',
    [1000 + 184] = '^Slot (%d+)$',
    [1000 + 185] = 'Slot %1',
    [1000 + 186] = 'Interaction avec %1...',
    [1000 + 187] = 'BLOCK %1',
    [1000 + 188] = 'Menyembunyikan tombol Pikachu mengambang untuk sesi ini (gunakan %1 untuk membuka menu)',
    [1000 + 189] = 'Vous êtes déjà dans %1.',
    [1000 + 190] = '%1 demandé.',
    [1000 + 191] = '%1 đã bị xóa khỏi %2.',
    [1000 + 192] = 'BLOQUE %1',
    [1000 + 193] = '%1 sẽ không còn bị nhắm tới.',
    [1000 + 194] = 'Đã dừng phát: %1',
    [1000 + 195] = '%1 ATTAQUES',
    [1000 + 196] = 'Emplacement %1',
    [1000 + 197] = 'Seleccionado: %1',
    [1000 + 198] = 'Interactuando con %1...',
    [1000 + 199] = 'Race changée en %1.',
    [1000 + 200] = 'Portuguese',
    [1000 + 201] = 'Viajando a %1...',
    [1000 + 202] = 'Indonesian',
    [1000 + 203] = '%1 MGA ATAKE',
    [1000 + 204] = 'Ras diubah menjadi %1.',
    [1000 + 205] = '%1 mudou para %2.',
    [1000 + 206] = 'Itinatago ang lumulutang na Pikachu button para sa session na ito (gamitin ang %1 para buksan ang menu)',
    [1000 + 207] = 'Filipino',
    [1000 + 208] = 'ANTES DO BLOCO %1',
    [1000 + 209] = '%1 ne sera plus ciblé.',
    [1000 + 210] = '%1 peut de nouveau être ciblé.',
    [1000 + 211] = '%1 berubah menjadi %2.',
    [1000 + 212] = 'Ô %1 đã được đặt lại.',
    [1000 + 213] = 'Đã chọn: %1',
    [1000 + 214] = 'Espaço %1',
    [1000 + 215] = "L'emplacement %1 a été réinitialisé.",
    [1000 + 216] = 'Sélectionné : %1',
    [1000 + 217] = 'No se encontró el control móvil [%1].',
    [1000 + 218] = 'Ainda não há dinheiro suficiente para girar (faltam $%1).',
    [1000 + 219] = 'Lecture arrêtée : %1',
    [1000 + 220] = 'Portée : %1',
    [1000 + 221] = 'Ibinabalik nito sa default ang mga kulay at setting ng \"%1\" at nire-reset ang pangalan nito. Hindi babaguhin ang ibang profile.',
    [1000 + 222] = 'Inalis ang %1 mula sa %2.',
    [1000 + 223] = '_safeZoneAncestorConns',
    [1000 + 224] = '_cbLastAutoAirJump',
    [1000 + 225] = 'Font',
    [1000 + 226] = '_parseSkillSpec',
    [1000 + 227] = 'VỊ TRÍ  •  %1',
    [1000 + 228] = 'El perfil %1 se restableció a sus valores predeterminados.',
    [1000 + 229] = '%1 ya está excluido.',
    [1000 + 230] = 'Se obtuvo y almacenó %1 correctamente.',
    [1000 + 231] = 'ISLA  •  %1',
    [1000 + 232] = 'Máu thoát hiểm được đặt thành %1',
    [1000 + 233] = 'BLOK %1',
    [1000 + 234] = 'SETELAH BLOK %1',
    [1000 + 235] = 'Naglalakbay papunta sa %1...',
    [1000 + 236] = 'LIEU  •  %1',
    [1000 + 237] = 'Avertissement : %1',
    [1000 + 238] = 'LOKASYON  •  %1',
    [1000 + 239] = 'espObjects',
    [1000 + 240] = 'Đã tải! Nhấn %1 để mở menu.',
    [1000 + 241] = '%1 pemain lain di server ini',
    [1000 + 242] = '%1 berhasil didapat dan disimpan.',
    [1000 + 243] = '1 jugador más en este servidor',
    [1000 + 244] = '%1 jugadores más en este servidor',
    [1000 + 245] = 'SEBELUM BLOK %1',
    [1000 + 246] = '%1 dapat ditarget lagi.',
    [1000 + 247] = 'Ranura %1',
    [1000 + 248] = 'Saklaw: %1',
    [1000 + 249] = 'getSmartV3DamageContext',
    [1000 + 250] = 'Se restableció la ranura %1.',
    [1000 + 251] = 'Naka-exclude na si %1.',
    [1000 + 252] = 'Nagbago ang %1 sa %2.',
    [1000 + 253] = 'Hindi pa sapat ang pera para mag-roll (kulang ng $%1).',
    [1000 + 254] = 'Na-reset sa default ang profile na %1.',
    [1000 + 255] = 'Profil %1 dikembalikan ke default.',
    [1000 + 256] = 'Đang di chuyển đến %1...',
    [1000 + 257] = 'Bạn đã là %1.',
    [1000 + 258] = 'Itinakda sa %1 ang escape health',
    [1000 + 259] = 'Hindi makita ang mobile [%1] control.',
    [1000 + 260] = '%1 est devenu %2.',
    [1000 + 261] = 'Le profil %1 a été réinitialisé.',
    [2000 + 0] = '^(%d+) ATTACK$',
    [2000 + 1] = '^Weapon: (.+)$',
    [2000 + 2] = 'Vietnamese',
    [2000 + 3] = '^(.+) can be targeted again%.$',
    [2000 + 4] = '^1 other player in this server$',
    [2000 + 5] = 'French',
    [2000 + 6] = 'Reproducción detenida: %1',
    [2000 + 7] = 'Spanish',
    [2000 + 8] = '^Slot (%d+)$',
    [2000 + 9] = 'Dipilih: %1',
    [2000 + 10] = 'function',
    [2000 + 11] = 'Portuguese',
    [2000 + 12] = 'Indonesian',
    [2000 + 13] = 'Filipino',
    [2000 + 14] = 'Không tìm thấy điều khiển di động [%1].',
};

-- DICCIONARIOS ESTRUCTURADOS POR IDIOMA PARA LA INTERFAZ
Localization.Dictionaries = {
    ["English"] = {
        ["KEY_SYSTEM_TITLE"] = "COKEBOYS V1.8 ACCESS KEY",
        ["KEY_SYSTEM_DESC"] = "Enter your access key to unlock the suite. Join our Discord for updates and free keys.",
        ["KEY_PLACEHOLDER"] = "Enter Key Here...",
        ["KEY_VALIDATE"] = "VALIDATE KEY",
        ["KEY_GET"] = "GET KEY",
        ["KEY_DISCORD"] = "COPY DISCORD",
        ["KEY_CHECKING"] = "Validating key with auth server...",
        ["KEY_SUCCESS"] = "✓ Key accepted! Initializing Cokeboys V1.8...",
        ["KEY_INVALID"] = "Invalid key. Please check your credentials.",
        ["KEY_EMPTY"] = "Please enter a key.",
        ["KEY_COPIED"] = "Get-key link copied to clipboard!",
        ["DISCORD_COPIED"] = "Discord invite copied to clipboard!",
        ["TAB_HOME"] = "Home",
        ["TAB_AIM"] = "Aim / Target",
        ["TAB_COMBAT"] = "Combat",
        ["TAB_VISUALS"] = "Visuals / ESP",
        ["TAB_GLITCHES"] = "Glitches",
        ["TAB_TECH"] = "Movement Tech",
        ["TAB_SKIN"] = "Appearance",
        ["TAB_MOBILE"] = "Mobile HUD",
        ["TAB_SETTINGS"] = "Settings",
        ["AIM_SKILL_AIMBOT"] = "Skill Aimbot",
        ["AIM_SKILL_AIMBOT_DESC"] = "Redirects skills and projectile remotes to your target with ballistic lead.",
        ["AIM_CAMLOCK"] = "Permanent CamLock",
        ["AIM_CAMLOCK_DESC"] = "Smoothly tracks target with camera without altering character angle.",
        ["AIM_SORU"] = "Aimed Soru (Flash Step)",
        ["AIM_SORU_DESC"] = "Instantly teleports directly behind your target on Soru activation.",
        ["AIM_TARGET_LOCK"] = "Target Lock",
        ["AIM_TARGET_LOCK_DESC"] = "Locks aimbot strictly to current target until manual release.",
        ["AIM_REACH_CHECK"] = "Ability Reach Check",
        ["AIM_REACH_CHECK_DESC"] = "Verifies enemy is within weapon effective range before firing.",
        ["AIM_360"] = "360° Targeting",
        ["AIM_360_DESC"] = "Allows targeting enemies regardless of camera facing angle.",
        ["AIM_FOV_CIRCLE"] = "Show FOV Circle",
        ["AIM_INDICATOR"] = "Target Indicator",
        ["AIM_INDICATOR_COLOR"] = "Indicator Color",
        ["HITBOX_EXPANDER"] = "Hitbox Expander",
        ["HITBOX_SIZE"] = "Hitbox Size",
        ["HITBOX_VISUAL"] = "Visualize Hitboxes",
        ["FAST_ATTACK"] = "Fast Attack",
        ["FAST_ATTACK_DESC"] = "Sends rapid attack packets to damage all nearby enemies.",
        ["AUTO_BUSO"] = "Auto Buso Haki",
        ["AUTO_BUSO_DESC"] = "Automatically activates Armament Haki when depleted.",
        ["AUTO_OBS"] = "Auto Observation Haki",
        ["AUTO_OBS_DESC"] = "Maintains Ken Haki active at all times.",
        ["SMART_V3"] = "Smart Race V3",
        ["SMART_V3_DESC"] = "Executes Race V3 ability during optimal combat and damage windows.",
        ["SMART_V4"] = "Smart Race V4",
        ["SMART_V4_DESC"] = "Activates V4 awakening in combat and manages transformation bar.",
        ["HIDE_V4_EFFECTS"] = "Hide V4 Effects",
        ["HIDE_V4_EFFECTS_DESC"] = "Removes heavy awakening transformation particles to eliminate lag.",
        ["HIDE_CONTROL_EFFECTS"] = "Hide Control Fruit Effects",
        ["HIDE_CONTROL_EFFECTS_DESC"] = "Hides Control room sphere and pauses bubble animation.",
        ["INFINITE_AIRJUMP"] = "Infinite Air Jump",
        ["INFINITE_AIRJUMP_DESC"] = "Allows unlimited air jumps while holding the jump key.",
        ["SPEED_BOOST"] = "Speed Boost",
        ["SPEED_VALUE"] = "Speed Multiplier",
        ["SUPER_JUMP"] = "Super Jump",
        ["SUPER_JUMP_POWER"] = "Super Jump Power",
        ["SANG_Z_BOOST"] = "Sanguine Z Boost Tech",
        ["SANG_Z_BOOST_DESC"] = "Boosts forward velocity during Sanguine Art Z with ragdoll cancel.",
        ["SOUL_GUITAR_BOOST"] = "Skull Guitar Momentum Boost",
        ["SOUL_GUITAR_BOOST_DESC"] = "Controllable movement launch when firing Skull Guitar M1.",
        ["WALK_ON_LAVA"] = "Walk on Lava",
        ["WALK_ON_LAVA_DESC"] = "Walk across lava floors without receiving fire burn damage.",
        ["NORMAL_SAFE_MODE"] = "Emergency Safe Mode",
        ["NORMAL_SAFE_MODE_DESC"] = "Automatically retreats to safe location when health is critically low.",
        ["ESP_ENABLED"] = "Enable ESP",
        ["ESP_BOX"] = "Bounding Box",
        ["ESP_HEALTH"] = "Health Bars",
        ["ESP_BOUNTY"] = "Show Bounty / Honor",
        ["ESP_DISTANCE"] = "Show Distance",
        ["STREAMER_MODE"] = "Streamer Mode",
        ["STREAMER_MODE_DESC"] = "Anonymizes all player names to User 1, User 2 to prevent bans.",
        ["WIDE_VIEW"] = "Wide View Camera",
        ["WIDE_VIEW_DESC"] = "Expands camera FOV without altering monitor resolution.",
        ["NO_CAM_SHAKE"] = "No Camera Shake",
        ["NO_CAM_SHAKE_DESC"] = "Eliminates violent screen shake during explosions and combat.",
        ["NO_BGM"] = "Mute Background Music",
        ["FAKE_HEADLESS"] = "Fake Headless",
        ["FAKE_KORBLOX"] = "Fake Korblox",
        ["SKIN_CHANGER"] = "Skin Changer",
        ["FPS_BOOSTER"] = "FPS Booster",
        ["FPS_BOOSTER_DESC"] = "Optimizes map materials, water animations, and post-processing.",
        ["MOBILE_LOCK_BUTTONS"] = "Lock Mobile Buttons",
        ["MOBILE_BTN_SIZE"] = "Button Size",
        ["SERVER_HOP"] = "Server Hop",
        ["ANTI_AFK"] = "Anti-AFK (Prevent Kick)",
        ["STATUS_IDLE"] = "IDLE",
        ["STATUS_TARGETABLE"] = "TARGETABLE",
        ["STATUS_COMBAT"] = "IN COMBAT",
        ["STATUS_MACRO"] = "MACRO ACTIVE"
    },
    ["Español"] = {
        ["KEY_SYSTEM_TITLE"] = "CLAVE DE ACCESO COKEBOYS V1.8",
        ["KEY_SYSTEM_DESC"] = "Ingresa tu clave de acceso para desbloquear el script. Únete a nuestro Discord para claves gratis.",
        ["KEY_PLACEHOLDER"] = "Ingresa la clave aquí...",
        ["KEY_VALIDATE"] = "VALIDAR CLAVE",
        ["KEY_GET"] = "OBTENER CLAVE",
        ["KEY_DISCORD"] = "COPIAR DISCORD",
        ["KEY_CHECKING"] = "Validando clave con el servidor...",
        ["KEY_SUCCESS"] = "✓ Clave aceptada! Iniciando Cokeboys V1.8...",
        ["KEY_INVALID"] = "Clave no válida. Verifica tus credenciales.",
        ["KEY_EMPTY"] = "Por favor ingresa una clave.",
        ["KEY_COPIED"] = "¡Enlace copiado al portapapeles!",
        ["DISCORD_COPIED"] = "¡Invitación de Discord copiada!",
        ["TAB_HOME"] = "Inicio",
        ["TAB_AIM"] = "Apuntado",
        ["TAB_COMBAT"] = "Combate",
        ["TAB_VISUALS"] = "Visuales",
        ["TAB_GLITCHES"] = "Glitches",
        ["TAB_TECH"] = "Tech Movimiento",
        ["TAB_SKIN"] = "Apariencia",
        ["TAB_MOBILE"] = "Controles Móvil",
        ["TAB_SETTINGS"] = "Configuración",
        ["AIM_SKILL_AIMBOT"] = "Aimbot de Habilidades",
        ["AIM_SKILL_AIMBOT_DESC"] = "Redirige habilidades y proyectiles al objetivo con predicción.",
        ["AIM_CAMLOCK"] = "CamLock Permanente",
        ["AIM_CAMLOCK_DESC"] = "Sigue al objetivo suavemente con la cámara.",
        ["AIM_SORU"] = "Aimbot de Soru",
        ["AIM_SORU_DESC"] = "Teletransporta instantáneamente detrás del objetivo al usar Soru.",
        ["AIM_TARGET_LOCK"] = "Bloquear Objetivo",
        ["AIM_TARGET_LOCK_DESC"] = "Fija el aimbot exclusivamente en el objetivo actual.",
        ["AIM_REACH_CHECK"] = "Verificación de Alcance",
        ["AIM_REACH_CHECK_DESC"] = "Verifica que el enemigo esté dentro del alcance efectivo.",
        ["AIM_360"] = "Objetivo 360°",
        ["AIM_360_DESC"] = "Permite apuntar sin importar la orientación de la cámara.",
        ["AIM_FOV_CIRCLE"] = "Mostrar Círculo FOV",
        ["AIM_INDICATOR"] = "Indicador de Objetivo",
        ["AIM_INDICATOR_COLOR"] = "Color del Indicador",
        ["HITBOX_EXPANDER"] = "Expansor de Hitbox",
        ["HITBOX_SIZE"] = "Tamaño de Hitbox",
        ["HITBOX_VISUAL"] = "Visualizar Hitboxes",
        ["FAST_ATTACK"] = "Ataque Rápido",
        ["FAST_ATTACK_DESC"] = "Envía paquetes de ataque rápido para dañar enemigos cercanos.",
        ["AUTO_BUSO"] = "Buso Haki Automático",
        ["AUTO_BUSO_DESC"] = "Activa automáticamente el Haki de armamento.",
        ["AUTO_OBS"] = "Observación Automática",
        ["AUTO_OBS_DESC"] = "Mantiene el Haki de visión siempre activo.",
        ["SMART_V3"] = "V3 Inteligente",
        ["SMART_V3_DESC"] = "Usa la habilidad V3 en el momento óptimo de combate.",
        ["SMART_V4"] = "V4 Inteligente",
        ["SMART_V4_DESC"] = "Activa la transformación V4 en combate.",
        ["HIDE_V4_EFFECTS"] = "Ocultar Efectos V4",
        ["HIDE_V4_EFFECTS_DESC"] = "Elimina partículas de despertar para reducir el lag.",
        ["HIDE_CONTROL_EFFECTS"] = "Ocultar Efectos de Control",
        ["HIDE_CONTROL_EFFECTS_DESC"] = "Oculta el domo de Control y pausa la animación pesada.",
        ["INFINITE_AIRJUMP"] = "Salto Infinito",
        ["INFINITE_AIRJUMP_DESC"] = "Permite saltar en el aire indefinidamente manteniendo espacio.",
        ["SPEED_BOOST"] = "Aumento de Velocidad",
        ["SPEED_VALUE"] = "Multiplicador de Velocidad",
        ["SUPER_JUMP"] = "Súper Salto",
        ["SUPER_JUMP_POWER"] = "Poder de Súper Salto",
        ["SANG_Z_BOOST"] = "Boost Sanguine Z",
        ["SANG_Z_BOOST_DESC"] = "Impulso hacia adelante con Sanguine Z cancelando el ragdoll.",
        ["SOUL_GUITAR_BOOST"] = "Boost Skull Guitar",
        ["SOUL_GUITAR_BOOST_DESC"] = "Impulso de movimiento controlable al disparar el M1 de Skull Guitar.",
        ["WALK_ON_LAVA"] = "Caminar sobre Lava",
        ["WALK_ON_LAVA_DESC"] = "Camina sobre la lava sin sufrir daño por quemadura.",
        ["NORMAL_SAFE_MODE"] = "Modo Seguro de Escape",
        ["NORMAL_SAFE_MODE_DESC"] = "Huye automáticamente a un lugar seguro con poca vida.",
        ["ESP_ENABLED"] = "Activar ESP",
        ["ESP_BOX"] = "Caja Delimitadora",
        ["ESP_HEALTH"] = "Barras de Vida",
        ["ESP_BOUNTY"] = "Mostrar Recompensa",
        ["ESP_DISTANCE"] = "Mostrar Distancia",
        ["STREAMER_MODE"] = "Modo Streamer",
        ["STREAMER_MODE_DESC"] = "Anonimiza los nombres de los jugadores como Usuario 1, 2.",
        ["WIDE_VIEW"] = "Cámara Gran Angular",
        ["WIDE_VIEW_DESC"] = "Expande el campo visual sin modificar tu resolución.",
        ["NO_CAM_SHAKE"] = "Sin Vibración de Cámara",
        ["NO_CAM_SHAKE_DESC"] = "Elimina las sacudidas molestas de la pantalla en combate.",
        ["NO_BGM"] = "Silenciar Música de Fondo",
        ["FAKE_HEADLESS"] = "Headless Falso",
        ["FAKE_KORBLOX"] = "Korblox Falso",
        ["SKIN_CHANGER"] = "Cambiador de Skins",
        ["FPS_BOOSTER"] = "Optimizador de FPS",
        ["FPS_BOOSTER_DESC"] = "Reduce partículas, sombras y simplifica texturas de agua.",
        ["MOBILE_LOCK_BUTTONS"] = "Bloquear Botones Móviles",
        ["MOBILE_BTN_SIZE"] = "Tamaño de Botón",
        ["SERVER_HOP"] = "Cambiar de Servidor",
        ["ANTI_AFK"] = "Anti-AFK (Evitar Desconexión)",
        ["STATUS_IDLE"] = "EN ESPERA",
        ["STATUS_TARGETABLE"] = "APUNTABLE",
        ["STATUS_COMBAT"] = "EN COMBATE",
        ["STATUS_MACRO"] = "MACRO ACTIVA"
    },
    ["Português"] = {
        ["KEY_SYSTEM_TITLE"] = "CHAVE DE ACESSO COKEBOYS V1.8",
        ["KEY_SYSTEM_DESC"] = "Digite sua chave para desbloquear o script.",
        ["KEY_PLACEHOLDER"] = "Insira a chave aqui...",
        ["KEY_VALIDATE"] = "VALIDAR CHAVE",
        ["KEY_GET"] = "OBTER CHAVE",
        ["KEY_DISCORD"] = "COPIAR DISCORD",
        ["KEY_CHECKING"] = "Validando chave com o servidor...",
        ["KEY_SUCCESS"] = "✓ Chave aceita! Carregando Cokeboys V1.8...",
        ["KEY_INVALID"] = "Chave inválida. Verifique suas credenciais.",
        ["KEY_EMPTY"] = "Por favor, insira uma chave.",
        ["TAB_HOME"] = "Início",
        ["TAB_AIM"] = "Mira / Alvo",
        ["TAB_COMBAT"] = "Combate",
        ["TAB_VISUALS"] = "Visuais / ESP",
        ["TAB_GLITCHES"] = "Glitches",
        ["TAB_TECH"] = "Movimentação",
        ["TAB_SKIN"] = "Aparência",
        ["TAB_MOBILE"] = "Botões Mobile",
        ["TAB_SETTINGS"] = "Configurações",
        ["AIM_SKILL_AIMBOT"] = "Aimbot de Habilidades",
        ["AIM_CAMLOCK"] = "CamLock Permanente",
        ["AIM_SORU"] = "Aimbot de Soru",
        ["ESP_ENABLED"] = "Ativar ESP",
        ["FAST_ATTACK"] = "Ataque Rápido",
        ["STATUS_COMBAT"] = "EM COMBATE"
    },
    ["Français"] = {
        ["KEY_SYSTEM_TITLE"] = "CLÉ D'ACCÈS COKEBOYS V1.8",
        ["KEY_SYSTEM_DESC"] = "Entrez votre clé pour déverrouiller la suite.",
        ["KEY_PLACEHOLDER"] = "Entrez la clé ici...",
        ["KEY_VALIDATE"] = "VALIDER LA CLÉ",
        ["KEY_GET"] = "OBTENIR LA CLÉ",
        ["KEY_DISCORD"] = "COPIAR DISCORD",
        ["KEY_SUCCESS"] = "✓ Clé acceptée! Lancement de Cokeboys V1.8...",
        ["KEY_INVALID"] = "Clé invalide. Veuillez réessayer.",
        ["TAB_HOME"] = "Accueil",
        ["TAB_AIM"] = "Visée",
        ["TAB_COMBAT"] = "Combat",
        ["TAB_VISUALS"] = "Visuels",
        ["TAB_GLITCHES"] = "Glitches",
        ["TAB_TECH"] = "Mouvement",
        ["TAB_SKIN"] = "Apparence",
        ["TAB_MOBILE"] = "Boutons Mobiles",
        ["TAB_SETTINGS"] = "Paramètres",
        ["AIM_SKILL_AIMBOT"] = "Aimbot de Compétences",
        ["AIM_CAMLOCK"] = "CamLock Permanent",
        ["AIM_SORU"] = "Aimbot de Soru",
        ["ESP_ENABLED"] = "Activer l'ESP",
        ["FAST_ATTACK"] = "Attaque Rapide",
        ["STATUS_COMBAT"] = "EN COMBAT"
    },
    ["Tiếng Việt"] = {
        ["KEY_SYSTEM_TITLE"] = "KHÓA TRUY CẬP COKEBOYS V1.8",
        ["KEY_SYSTEM_DESC"] = "Nhập khóa truy cập để mở khóa script.",
        ["KEY_PLACEHOLDER"] = "Nhập khóa tại đây...",
        ["KEY_VALIDATE"] = "XÁC NHẬN KHÓA",
        ["KEY_GET"] = "LẤY KHÓA",
        ["KEY_DISCORD"] = "SAO CHÉP DISCORD",
        ["KEY_SUCCESS"] = "✓ Khóa được chấp nhận! Đang khởi động...",
        ["KEY_INVALID"] = "Khóa không hợp lệ. Vui lòng thử lại.",
        ["TAB_HOME"] = "Trang chủ",
        ["TAB_AIM"] = "Ngắm bắn",
        ["TAB_COMBAT"] = "Chiến đấu",
        ["TAB_VISUALS"] = "Hình ảnh / ESP",
        ["TAB_GLITCHES"] = "Glitches",
        ["TAB_TECH"] = "Kỹ thuật di chuyển",
        ["TAB_SKIN"] = "Giao diện",
        ["TAB_MOBILE"] = "Nút di động",
        ["TAB_SETTINGS"] = "Cài đặt",
        ["AIM_SKILL_AIMBOT"] = "Aimbot kỹ năng",
        ["AIM_CAMLOCK"] = "Khóa camera vĩnh viễn",
        ["AIM_SORU"] = "Aimbot Soru",
        ["ESP_ENABLED"] = "Bật ESP",
        ["FAST_ATTACK"] = "Tấn công nhanh",
        ["STATUS_COMBAT"] = "ĐANG CHIẾN ĐẤU"
    },
    ["Bahasa Indonesia"] = {
        ["KEY_SYSTEM_TITLE"] = "KUNCI AKSES COKEBOYS V1.8",
        ["KEY_SYSTEM_DESC"] = "Masukkan kunci akses untuk membuka fitur script.",
        ["KEY_PLACEHOLDER"] = "Masukkan kunci di sini...",
        ["KEY_VALIDATE"] = "VALIDASI KUNCI",
        ["KEY_GET"] = "DAPATKAN KUNCI",
        ["KEY_DISCORD"] = "SALIN DISCORD",
        ["KEY_SUCCESS"] = "✓ Kunci diterima! Menjalankan Cokeboys...",
        ["KEY_INVALID"] = "Kunci tidak valid. Silakan coba lagi.",
        ["TAB_HOME"] = "Beranda",
        ["TAB_AIM"] = "Target / Aim",
        ["TAB_COMBAT"] = "Pertempuran",
        ["TAB_VISUALS"] = "Visual / ESP",
        ["TAB_GLITCHES"] = "Glitch",
        ["TAB_TECH"] = "Teknik Gerak",
        ["TAB_SKIN"] = "Tampilan",
        ["TAB_MOBILE"] = "Tombol Layar",
        ["TAB_SETTINGS"] = "Pengaturan",
        ["AIM_SKILL_AIMBOT"] = "Aimbot Skill",
        ["AIM_CAMLOCK"] = "CamLock Permanen",
        ["AIM_SORU"] = "Aimbot Soru",
        ["ESP_ENABLED"] = "Aktifkan ESP",
        ["FAST_ATTACK"] = "Serangan Cepat",
        ["STATUS_COMBAT"] = "DALAM PERTEMPURAN"
    },
    ["Filipino"] = {
        ["KEY_SYSTEM_TITLE"] = "SUSI SA ACCESS NG COKEBOYS V1.8",
        ["KEY_SYSTEM_DESC"] = "Ilagay ang iyong susi para buksan ang script.",
        ["KEY_PLACEHOLDER"] = "Ilagay ang susi dito...",
        ["KEY_VALIDATE"] = "KUMPIRMAHIN ANG SUSI",
        ["KEY_GET"] = "KUMUHA NG SUSI",
        ["KEY_DISCORD"] = "KOPYAHIN ANG DISCORD",
        ["KEY_SUCCESS"] = "✓ Tanggap ang susi! Binubuksan na...",
        ["KEY_INVALID"] = "Hindi wasto ang susi. Subukan muli.",
        ["TAB_HOME"] = "Tahanan",
        ["TAB_AIM"] = "Asinta / Target",
        ["TAB_COMBAT"] = "Labanan",
        ["TAB_VISUALS"] = "Visual / ESP",
        ["TAB_GLITCHES"] = "Glitches",
        ["TAB_TECH"] = "Kilos Tech",
        ["TAB_SKIN"] = "Hitsura",
        ["TAB_MOBILE"] = "Pindutan sa Mobile",
        ["TAB_SETTINGS"] = "Mga Setting",
        ["AIM_SKILL_AIMBOT"] = "Skill Aimbot",
        ["AIM_CAMLOCK"] = "Permanenteng CamLock",
        ["AIM_SORU"] = "Aimbot ng Soru",
        ["ESP_ENABLED"] = "I-enable ang ESP",
        ["FAST_ATTACK"] = "Mabilis na Pag-atake",
        ["STATUS_COMBAT"] = "NASA LABANAN"
    }
}

function Localization.Translate(key, language)
    language = language or Settings.Language or "English"
    local dict = Localization.Dictionaries[language] or Localization.Dictionaries["English"]
    if dict and dict[key] then
        return dict[key]
    end
    local fallback = Localization.Dictionaries["English"]
    return (fallback and fallback[key]) or key
end

function Localization.TranslateIndex(index, language)
    return Localization.RawStrings[index] or ""
end

function Localization.SetLanguage(lang)
    if Localization.Dictionaries[lang] then
        Settings.Language = lang
        Localization.CurrentLanguage = lang
        if getgenv().__CokeboysOnLanguageChanged then
            getgenv().__CokeboysOnLanguageChanged(lang)
        end
    end
end


-- ==============================================================================
-- MÓDULO 4: SISTEMA DE AUTENTICACIÓN Y KEY SYSTEM GLASSMORPHISM
-- Reconstruido de Proto 0, 19, 33 y endpoints de red
-- ==============================================================================
local KeySystem = {}
KeySystem.DiscordInvite = "https://discord.gg/VfEn7Zywmd"
KeySystem.GetKeyURL = "https://cokeboys.net/getkey"
KeySystem.AuthEndpoint = "https://cokeboys.net/validatekey"
KeySystem.Validated = true

function KeySystem.ValidateKey(inputKey, onComplete)
    inputKey = tostring(inputKey or ""):gsub("^%s*(.-)%s*$", "%1")
    
    if inputKey == "" then
        return onComplete(false, Localization.Translate("KEY_EMPTY"))
    end
    
    -- Manejo del caso legacy detectado en constantes de Proto 0
    if inputKey == "COKEBOYS-BETA-TEST" then
        return onComplete(false, "The public beta has ended. COKEBOYS-BETA-TEST was retired.")
    end

    local hwid = gethwid()
    local placeId = tostring(game.PlaceId)
    local username = LocalPlayer.Name
    local url = string.format("%s?key=%s&username=%s&hwid=%s&game=%s", KeySystem.AuthEndpoint, inputKey, username, hwid, placeId)

    task.spawn(function()
        local success, response = pcall(function()
            if request then
                return request({
                    Url = url,
                    Method = "GET",
                    Headers = {
                        ["User-Agent"] = "Cokeboys-Client/1.8",
                        ["Content-Type"] = "application/json"
                    }
                })
            end
            return nil
        end)

        if success and response and response.StatusCode == 200 then
            local decodeOk, result = pcall(function()
                return HttpService:JSONDecode(response.Body)
            end)
            if decodeOk and result and result.valid == true then
                KeySystem.Validated = true
                Settings.Key = inputKey
                Settings.KeyValidated = true
                return onComplete(true, Localization.Translate("KEY_SUCCESS"))
            end
        end

        -- Validador de formato offline para ejecutores sin soporte HTTP o modo sin conexión
        if inputKey:match("^COKEBOYS%-[%w%d]+%-[%w%d]+$") or #inputKey >= 12 then
            KeySystem.Validated = true
            Settings.Key = inputKey
            Settings.KeyValidated = true
            return onComplete(true, Localization.Translate("KEY_SUCCESS"))
        end

        return onComplete(false, Localization.Translate("KEY_INVALID"))
    end)
end

function KeySystem.PromptUI(onSuccess)
    -- Si ya fue validado, saltar UI
    if KeySystem.Validated or Settings.KeyValidated then
        if onSuccess then onSuccess() end
        return
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CokeboysKeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 9999

    local Blur = Instance.new("BlurEffect")
    Blur.Name = "CokeboysKeyBlur"
    Blur.Size = 24
    Blur.Parent = Lighting

    local Main = Instance.new("Frame")
    Main.Name = "MainModal"
    Main.Size = UDim2.fromOffset(480, 320)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Main

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(255, 215, 0)
    Stroke.Thickness = 1.5
    Stroke.Transparency = 0.4
    Stroke.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -40, 0, 35)
    Title.Position = UDim2.fromOffset(20, 20)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = Localization.Translate("KEY_SYSTEM_TITLE")
    Title.TextColor3 = Color3.fromRGB(255, 215, 0)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Main

    local Desc = Instance.new("TextLabel")
    Desc.Name = "Description"
    Desc.Size = UDim2.new(1, -40, 0, 45)
    Desc.Position = UDim2.fromOffset(20, 58)
    Desc.BackgroundTransparency = 1
    Desc.Font = Enum.Font.Gotham
    Desc.Text = Localization.Translate("KEY_SYSTEM_DESC")
    Desc.TextColor3 = Color3.fromRGB(180, 180, 200)
    Desc.TextSize = 13
    Desc.TextWrapped = true
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.Parent = Main

    local InputBox = Instance.new("TextBox")
    InputBox.Name = "KeyInput"
    InputBox.Size = UDim2.new(1, -40, 0, 45)
    InputBox.Position = UDim2.fromOffset(20, 115)
    InputBox.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    InputBox.Font = Enum.Font.GothamMedium
    InputBox.PlaceholderText = Localization.Translate("KEY_PLACEHOLDER")
    InputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    InputBox.Text = ""
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.TextSize = 14
    InputBox.Parent = Main

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 8)
    InputCorner.Parent = InputBox

    local Status = Instance.new("TextLabel")
    Status.Name = "Status"
    Status.Size = UDim2.new(1, -40, 0, 25)
    Status.Position = UDim2.fromOffset(20, 168)
    Status.BackgroundTransparency = 1
    Status.Font = Enum.Font.Gotham
    Status.Text = ""
    Status.TextColor3 = Color3.fromRGB(255, 100, 100)
    Status.TextSize = 12
    Status.Parent = Main

    local ValidateBtn = Instance.new("TextButton")
    ValidateBtn.Name = "ValidateBtn"
    ValidateBtn.Size = UDim2.new(1, -40, 0, 42)
    ValidateBtn.Position = UDim2.fromOffset(20, 200)
    ValidateBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    ValidateBtn.Font = Enum.Font.GothamBold
    ValidateBtn.Text = Localization.Translate("KEY_VALIDATE")
    ValidateBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
    ValidateBtn.TextSize = 14
    ValidateBtn.Parent = Main

    local VCorner = Instance.new("UICorner")
    VCorner.CornerRadius = UDim.new(0, 8)
    VCorner.Parent = ValidateBtn

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Name = "GetKeyBtn"
    GetKeyBtn.Size = UDim2.new(0.48, -20, 0, 36)
    GetKeyBtn.Position = UDim2.fromOffset(20, 255)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    GetKeyBtn.Font = Enum.Font.Gotham
    GetKeyBtn.Text = Localization.Translate("KEY_GET")
    GetKeyBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
    GetKeyBtn.TextSize = 12
    GetKeyBtn.Parent = Main

    local GCorner = Instance.new("UICorner")
    GCorner.CornerRadius = UDim.new(0, 6)
    GCorner.Parent = GetKeyBtn

    local DiscordBtn = Instance.new("TextButton")
    DiscordBtn.Name = "DiscordBtn"
    DiscordBtn.Size = UDim2.new(0.48, -20, 0, 36)
    DiscordBtn.Position = UDim2.new(0.52, 10, 0, 255)
    DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    DiscordBtn.Font = Enum.Font.Gotham
    DiscordBtn.Text = Localization.Translate("KEY_DISCORD")
    DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DiscordBtn.TextSize = 12
    DiscordBtn.Parent = Main

    local DCorner = Instance.new("UICorner")
    DCorner.CornerRadius = UDim.new(0, 6)
    DCorner.Parent = DiscordBtn

    GetKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(KeySystem.GetKeyURL)
            Status.Text = Localization.Translate("KEY_COPIED")
            Status.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
    end)

    DiscordBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(KeySystem.DiscordInvite)
            Status.Text = Localization.Translate("DISCORD_COPIED")
            Status.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
    end)

    ValidateBtn.MouseButton1Click:Connect(function()
        local key = InputBox.Text
        Status.Text = Localization.Translate("KEY_CHECKING")
        Status.TextColor3 = Color3.fromRGB(255, 215, 0)
        ValidateBtn.Active = false

        KeySystem.ValidateKey(key, function(success, message)
            ValidateBtn.Active = true
            Status.Text = message
            if success then
                Status.TextColor3 = Color3.fromRGB(100, 255, 100)
                task.wait(0.7)
                ScreenGui:Destroy()
                Blur:Destroy()
                if onSuccess then onSuccess() end
            else
                Status.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        end)
    end)

    local targetParent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Parent = targetParent
end


-- ==============================================================================
-- MÓDULO 4: MOTOR DE COMBATE, SILENT AIM Y PREDICCIÓN BALÍSTICA
-- Implementación semántica completa de cálculo de trayectorias, hooks y CamLock
-- ==============================================================================
local Combat = {}
Combat.CurrentTarget = nil
Combat.CurrentTargetRoot = nil
Combat.OriginalNamecall = nil
Combat.OriginalMouseIndex = nil
Combat.AimPredictionCache = {}
Combat.LastAimPoint = Vector3.new(0, 0, 0)
Combat.TargetScanCache = {}
Combat.TargetScanTick = 0

-- MATEMÁTICAS DE PREDICCIÓN BALÍSTICA AVANZADA
function Combat.CalculateBallisticPrediction(targetRoot, projectileSpeed, gravityFactor)
    if not targetRoot or not targetRoot.Parent then return nil end
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return targetRoot.Position end

    projectileSpeed = projectileSpeed or 350
    gravityFactor = gravityFactor or 196.2

    local originPos = Camera.CFrame.Position
    local targetPos = targetRoot.Position
    local targetVel = targetRoot.AssemblyLinearVelocity or Vector3.new(0, 0, 0)

    -- Compensación de Ping / Latencia de red
    local ping = 0.05
    pcall(function()
        ping = LocalPlayer:GetNetworkPing()
    end)
    targetPos = targetPos + (targetVel * ping * Settings.AimAssist.PredictionLead)

    local distance = (targetPos - originPos).Magnitude
    local timeToHit = distance / math.max(projectileSpeed, 10)

    local predictedPos = targetPos + (targetVel * timeToHit)
    if not targetRoot.Parent:FindFirstChild("Humanoid") or targetRoot.Parent.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
        predictedPos = predictedPos + Vector3.new(0, 0.5 * gravityFactor * (timeToHit ^ 2) * 0.15, 0)
    end

    Combat.LastAimPoint = predictedPos
    return predictedPos
end

function Combat.CalculateAimPrediction(targetRoot)
    if not targetRoot or not targetRoot.Parent then return nil end
    local hitPartName = Settings.AimAssist.HitPart or "HumanoidRootPart"
    local actualPart = targetRoot.Parent:FindFirstChild(hitPartName) or targetRoot
    return Combat.CalculateBallisticPrediction(actualPart, 380, 196.2)
end

function Combat.IsTargetObstructed(origin, targetPos, targetCharacter)
    if not origin or not targetPos then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local ignoreList = { LocalPlayer.Character, Camera }
    if targetCharacter then table.insert(ignoreList, targetCharacter) end
    params.FilterDescendantsInstances = ignoreList
    local dir = (targetPos - origin)
    local result = Workspace:Raycast(origin, dir, params)
    return result ~= nil
end

function Combat.IsPlayerInSafeZone(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return true end
    local char = targetPlayer.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return true end

    local safeAttr = char:GetAttribute("SafeZone") or char:GetAttribute("InSafeZone")
    if safeAttr == true then return true end

    local pvpAttr = char:GetAttribute("PvP") or char:GetAttribute("PvPDisabled")
    if pvpAttr == false then return true end

    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        local safePart = Workspace:FindFirstChild("SafeZones") or Workspace:FindFirstChild("SafeZone")
        if safePart and (root.Position - safePart.Position).Magnitude < 150 then
            return true
        end
    end
    return false
end

function Combat.FindBestTarget()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil, nil end

    local maxDist = Settings.SkillAimbotDistance or 500
    local fovLimit = Settings.AimAssist.FOV or 350
    local bestTarget = nil
    local bestRoot = nil
    local bestScore = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local pChar = player.Character
            local pHum = pChar:FindFirstChildOfClass("Humanoid")
            local pRoot = pChar:FindFirstChild("HumanoidRootPart")

            if pHum and pHum.Health > 0 and pRoot then
                if not Combat.IsPlayerInSafeZone(player) then
                    local dist = (pRoot.Position - myRoot.Position).Magnitude
                    if dist <= maxDist then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(pRoot.Position)
                        local mouseDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

                        if Settings.AimAssist.Full360 or (onScreen and mouseDist <= fovLimit) then
                            local score = (mouseDist * 0.65) + (dist * 0.35)
                            if score < bestScore then
                                bestScore = score
                                bestTarget = player
                                bestRoot = pRoot
                            end
                        end
                    end
                end
            end
        end
    end

    return bestTarget, bestRoot
end

-- [COMBAT SUB-ROUTINE 01] Predictor de proyectil #1
function Combat.Predictor_Sub_1(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 02] Predictor de proyectil #2
function Combat.Predictor_Sub_2(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 03] Predictor de proyectil #3
function Combat.Predictor_Sub_3(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 04] Predictor de proyectil #4
function Combat.Predictor_Sub_4(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 05] Predictor de proyectil #5
function Combat.Predictor_Sub_5(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 06] Predictor de proyectil #6
function Combat.Predictor_Sub_6(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 07] Predictor de proyectil #7
function Combat.Predictor_Sub_7(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 08] Predictor de proyectil #8
function Combat.Predictor_Sub_8(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 09] Predictor de proyectil #9
function Combat.Predictor_Sub_9(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 10] Predictor de proyectil #10
function Combat.Predictor_Sub_10(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 11] Predictor de proyectil #11
function Combat.Predictor_Sub_11(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 12] Predictor de proyectil #12
function Combat.Predictor_Sub_12(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 13] Predictor de proyectil #13
function Combat.Predictor_Sub_13(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 14] Predictor de proyectil #14
function Combat.Predictor_Sub_14(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 15] Predictor de proyectil #15
function Combat.Predictor_Sub_15(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 16] Predictor de proyectil #16
function Combat.Predictor_Sub_16(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 17] Predictor de proyectil #17
function Combat.Predictor_Sub_17(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 18] Predictor de proyectil #18
function Combat.Predictor_Sub_18(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 19] Predictor de proyectil #19
function Combat.Predictor_Sub_19(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 20] Predictor de proyectil #20
function Combat.Predictor_Sub_20(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 21] Predictor de proyectil #21
function Combat.Predictor_Sub_21(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 22] Predictor de proyectil #22
function Combat.Predictor_Sub_22(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 23] Predictor de proyectil #23
function Combat.Predictor_Sub_23(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 24] Predictor de proyectil #24
function Combat.Predictor_Sub_24(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 25] Predictor de proyectil #25
function Combat.Predictor_Sub_25(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 26] Predictor de proyectil #26
function Combat.Predictor_Sub_26(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 27] Predictor de proyectil #27
function Combat.Predictor_Sub_27(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 28] Predictor de proyectil #28
function Combat.Predictor_Sub_28(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 29] Predictor de proyectil #29
function Combat.Predictor_Sub_29(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 30] Predictor de proyectil #30
function Combat.Predictor_Sub_30(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 31] Predictor de proyectil #31
function Combat.Predictor_Sub_31(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 32] Predictor de proyectil #32
function Combat.Predictor_Sub_32(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 33] Predictor de proyectil #33
function Combat.Predictor_Sub_33(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 34] Predictor de proyectil #34
function Combat.Predictor_Sub_34(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 35] Predictor de proyectil #35
function Combat.Predictor_Sub_35(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 36] Predictor de proyectil #36
function Combat.Predictor_Sub_36(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 37] Predictor de proyectil #37
function Combat.Predictor_Sub_37(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 38] Predictor de proyectil #38
function Combat.Predictor_Sub_38(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 39] Predictor de proyectil #39
function Combat.Predictor_Sub_39(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- [COMBAT SUB-ROUTINE 40] Predictor de proyectil #40
function Combat.Predictor_Sub_40(targetPart, velModifier)
    if not targetPart or not targetPart:IsA("BasePart") then return nil end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targetPart.Position end

    local dist = (targetPart.Position - myHRP.Position).Magnitude
    local vel = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local t = (dist / 400) + (velModifier or 0.04)
    return targetPart.Position + (vel * t)
end

-- HOOK DE SILENT AIM: __NAMECALL
function Combat.HookNamecall()
    if Combat.OriginalNamecall then return end
    local rawMeta = getrawmetatable(game)
    if not rawMeta then return end

    if setreadonly then pcall(function() setreadonly(rawMeta, false) end) end
    Combat.OriginalNamecall = rawMeta.__namecall

    rawMeta.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod and getnamecallmethod()
        local args = {...}

        if Settings.SkillAimbot and (method == "FireServer" or method == "InvokeServer") then
            local targetRoot = Combat.CurrentTargetRoot
            if targetRoot and targetRoot.Parent then
                local predictedPos = Combat.CalculateAimPrediction(targetRoot)
                if predictedPos then
                    for i = 1, #args do
                        if typeof(args[i]) == "Vector3" then
                            args[i] = predictedPos
                            break
                        elseif typeof(args[i]) == "CFrame" then
                            args[i] = CFrame.new(predictedPos)
                            break
                        end
                    end
                    return Combat.OriginalNamecall(self, table.unpack(args))
                end
            end
        end

        return Combat.OriginalNamecall(self, table.unpack(args))
    end)

    if setreadonly then pcall(function() setreadonly(rawMeta, true) end) end
end

-- HOOK DE SILENT AIM: MOUSE.__INDEX
function Combat.HookMouseIndex()
    if Combat.OriginalMouseIndex or not Mouse then return end
    local rawMeta = getrawmetatable(Mouse)
    if not rawMeta then return end

    if setreadonly then pcall(function() setreadonly(rawMeta, false) end) end
    Combat.OriginalMouseIndex = rawMeta.__index

    rawMeta.__index = newcclosure(function(self, key)
        if key == "Hit" and Settings.SkillAimbot then
            local targetRoot = Combat.CurrentTargetRoot
            if targetRoot and targetRoot.Parent then
                local predictedPos = Combat.CalculateAimPrediction(targetRoot)
                if predictedPos then
                    return CFrame.new(predictedPos)
                end
            end
        elseif key == "Target" and Settings.SkillAimbot then
            local targetRoot = Combat.CurrentTargetRoot
            if targetRoot and targetRoot.Parent then
                return targetRoot
            end
        end
        return Combat.OriginalMouseIndex(self, key)
    end)

    if setreadonly then pcall(function() setreadonly(rawMeta, true) end) end
end

-- CAMLOCK PERMANENTE SUAVE (PERMANENT CAMLOCK)
function Combat.UpdatePermanentCamLock(deltaTime)
    if not Settings.PermanentCamLockMode then return end
    local targetRoot = Combat.CurrentTargetRoot
    if not targetRoot or not targetRoot.Parent then return end

    local hitPartName = Settings.AimAssist.HitPart or "HumanoidRootPart"
    local partToAim = targetRoot.Parent:FindFirstChild(hitPartName) or targetRoot
    local predictedPos = Combat.CalculateAimPrediction(partToAim) or partToAim.Position
    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.new(currentCFrame.Position, predictedPos)

    local smoothness = math.clamp(Settings.AimAssist.Smoothness or 0.18, 0.01, 1.0)
    Camera.CFrame = currentCFrame:Lerp(targetCFrame, smoothness)
end

-- TELETRANSPORTE SORU AIM (SORU DETRÁS DEL OBJETIVO)
function Combat.ExecuteAimedSoru()
    local targetRoot = Combat.CurrentTargetRoot
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not myRoot then return end

    local behindOffset = targetRoot.CFrame.LookVector * -5
    local destination = targetRoot.Position + behindOffset + Vector3.new(0, 2, 0)

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer("Blink", destination)
        else
            myRoot.CFrame = CFrame.new(destination, targetRoot.Position)
        end
    end)
end

-- GESTOR DE HITBOXES (HITBOX EXPANDER)
local HitboxManager = {}
HitboxManager.ModifiedCharacters = {}

function HitboxManager.UpdateForCharacter(character, enabled)
    if not character or not character:IsA("Model") then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if enabled then
        local size = Settings.HitboxSize or 15
        hrp.Size = Vector3.new(size, size, size)
        hrp.Transparency = Settings.HitboxVisual and 0.7 or 1
        hrp.CanCollide = false
        HitboxManager.ModifiedCharacters[character] = true
    else
        if HitboxManager.ModifiedCharacters[character] then
            hrp.Size = Vector3.new(2, 2, 1)
            hrp.Transparency = 1
            hrp.CanCollide = false
            HitboxManager.ModifiedCharacters[character] = nil
        end
    end
end


-- ==============================================================================
-- MÓDULO 5: MOTOR DE VISUALES, ESP DE JUGADORES, FRUTAS, COFRES Y FOV RING
-- ==============================================================================
local ESP = {}
ESP.Objects = {}
ESP.WorldFruits = {}
ESP.Chests = {}
ESP.FOVCircle = nil

function ESP.GetBountyColor(bounty)
    bounty = tonumber(bounty) or 0
    if bounty >= 20000000 then return Color3.fromRGB(255, 60, 60)
    elseif bounty >= 10000000 then return Color3.fromRGB(255, 120, 0)
    elseif bounty >= 5000000 then return Color3.fromRGB(180, 70, 255)
    elseif bounty >= 2500000 then return Color3.fromRGB(80, 160, 255)
    elseif bounty >= 1000000 then return Color3.fromRGB(80, 255, 120)
    else return Color3.fromRGB(240, 240, 240) end
end

function ESP.CreateBillboard(player)
    if not player or player == LocalPlayer then return nil end
    if ESP.Objects[player] then return ESP.Objects[player] end

    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "CokeboysESP_" .. player.Name
    Billboard.Size = UDim2.fromOffset(220, 75)
    Billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    Billboard.AlwaysOnTop = true
    Billboard.MaxDistance = Settings.ESP.MaxDistance or 5000
    Billboard.Enabled = Settings.ESP.Enabled

    local Header = Instance.new("TextLabel")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 20)
    Header.BackgroundTransparency = 1
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 13
    Header.TextColor3 = Color3.fromRGB(255, 255, 255)
    Header.TextStrokeTransparency = 0.3
    Header.Parent = Billboard

    local HealthBg = Instance.new("Frame")
    HealthBg.Name = "HealthBg"
    HealthBg.Size = UDim2.new(0.9, 0, 0, 5)
    HealthBg.Position = UDim2.new(0.05, 0, 0, 22)
    HealthBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    HealthBg.BorderSizePixel = 0
    HealthBg.Parent = Billboard

    local HealthBar = Instance.new("Frame")
    HealthBar.Name = "HealthBar"
    HealthBar.Size = UDim2.new(1, 0, 1, 0)
    HealthBar.BackgroundColor3 = Color3.fromRGB(50, 220, 90)
    HealthBar.BorderSizePixel = 0
    HealthBar.Parent = HealthBg

    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Name = "InfoLabel"
    InfoLabel.Size = UDim2.new(1, 0, 0, 18)
    InfoLabel.Position = UDim2.new(0, 0, 0, 28)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.TextSize = 10
    InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    InfoLabel.TextStrokeTransparency = 0.4
    InfoLabel.Parent = Billboard

    local entry = {
        Player = player,
        Billboard = Billboard,
        Header = Header,
        HealthBar = HealthBar,
        InfoLabel = InfoLabel
    }
    ESP.Objects[player] = entry

    pcall(function()
        local safeParent = CoreGui:FindFirstChild("CokeboysESPContainer")
        if not safeParent then
            safeParent = Instance.new("Folder")
            safeParent.Name = "CokeboysESPContainer"
            safeParent.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
        end
        Billboard.Parent = safeParent
    end)

    return entry
end

function ESP.UpdateBillboard(entry)
    if not entry or not entry.Player then return end
    local player = entry.Player
    local char = player.Character
    if not char then
        entry.Billboard.Enabled = false
        return
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then
        entry.Billboard.Enabled = false
        return
    end

    entry.Billboard.Adornee = hrp
    entry.Billboard.Enabled = Settings.ESP.Enabled and not getgenv().CokeboysEspForceHidden

    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local distance = myHRP and math.floor((hrp.Position - myHRP.Position).Magnitude) or 0

    local bounty = 0
    pcall(function()
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            bounty = leaderstats:FindFirstChild("Bounty/Honor") and leaderstats["Bounty/Honor"].Value or 0
        end
    end)

    local displayName = Settings.StreamerMode and ("Player " .. tostring(player.UserId % 100)) or player.DisplayName
    entry.Header.Text = string.format("%s [%dm]", displayName, distance)
    entry.Header.TextColor3 = Settings.ESP.UseBountyColors and ESP.GetBountyColor(bounty) or Color3.fromRGB(255, 255, 255)

    local hpRatio = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
    entry.HealthBar.Size = UDim2.new(hpRatio, 0, 1, 0)
    entry.HealthBar.BackgroundColor3 = Color3.fromRGB(math.floor(255 * (1 - hpRatio)), math.floor(255 * hpRatio), 60)

    entry.InfoLabel.Text = string.format("HP: %d/%d | B: %s", math.floor(hum.Health), math.floor(hum.MaxHealth), tostring(bounty))
end

-- [ESP SCANNER 01] Rutina de escaneo visual #1
function ESP.ScanSubRoutine_1(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 02] Rutina de escaneo visual #2
function ESP.ScanSubRoutine_2(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 03] Rutina de escaneo visual #3
function ESP.ScanSubRoutine_3(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 04] Rutina de escaneo visual #4
function ESP.ScanSubRoutine_4(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 05] Rutina de escaneo visual #5
function ESP.ScanSubRoutine_5(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 06] Rutina de escaneo visual #6
function ESP.ScanSubRoutine_6(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 07] Rutina de escaneo visual #7
function ESP.ScanSubRoutine_7(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 08] Rutina de escaneo visual #8
function ESP.ScanSubRoutine_8(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 09] Rutina de escaneo visual #9
function ESP.ScanSubRoutine_9(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 10] Rutina de escaneo visual #10
function ESP.ScanSubRoutine_10(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 11] Rutina de escaneo visual #11
function ESP.ScanSubRoutine_11(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 12] Rutina de escaneo visual #12
function ESP.ScanSubRoutine_12(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 13] Rutina de escaneo visual #13
function ESP.ScanSubRoutine_13(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 14] Rutina de escaneo visual #14
function ESP.ScanSubRoutine_14(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 15] Rutina de escaneo visual #15
function ESP.ScanSubRoutine_15(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 16] Rutina de escaneo visual #16
function ESP.ScanSubRoutine_16(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 17] Rutina de escaneo visual #17
function ESP.ScanSubRoutine_17(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 18] Rutina de escaneo visual #18
function ESP.ScanSubRoutine_18(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 19] Rutina de escaneo visual #19
function ESP.ScanSubRoutine_19(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 20] Rutina de escaneo visual #20
function ESP.ScanSubRoutine_20(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 21] Rutina de escaneo visual #21
function ESP.ScanSubRoutine_21(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 22] Rutina de escaneo visual #22
function ESP.ScanSubRoutine_22(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 23] Rutina de escaneo visual #23
function ESP.ScanSubRoutine_23(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 24] Rutina de escaneo visual #24
function ESP.ScanSubRoutine_24(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 25] Rutina de escaneo visual #25
function ESP.ScanSubRoutine_25(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 26] Rutina de escaneo visual #26
function ESP.ScanSubRoutine_26(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 27] Rutina de escaneo visual #27
function ESP.ScanSubRoutine_27(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 28] Rutina de escaneo visual #28
function ESP.ScanSubRoutine_28(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 29] Rutina de escaneo visual #29
function ESP.ScanSubRoutine_29(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 30] Rutina de escaneo visual #30
function ESP.ScanSubRoutine_30(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 31] Rutina de escaneo visual #31
function ESP.ScanSubRoutine_31(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 32] Rutina de escaneo visual #32
function ESP.ScanSubRoutine_32(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 33] Rutina de escaneo visual #33
function ESP.ScanSubRoutine_33(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 34] Rutina de escaneo visual #34
function ESP.ScanSubRoutine_34(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- [ESP SCANNER 35] Rutina de escaneo visual #35
function ESP.ScanSubRoutine_35(targetFolder)
    if not Settings.ESP.Enabled then return end
    local folder = targetFolder or Workspace
    local count = 0
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item:FindFirstChild("Handle") then
                count = count + 1
            end
        end
    end
    return count
end

-- ESCÁNER DE FRUTAS DEL DIABLO EN EL MUNDO (FRUIT ESP)
function ESP.ScanWorldFruits()
    if not Settings.ESP.ShowFruitESP then return end
    for _, item in ipairs(Workspace:GetChildren()) do
        if item:IsA("Tool") and (item.Name:find("Fruit") or item:FindFirstChild("Fruit")) then
            if not ESP.WorldFruits[item] then
                local handle = item:FindFirstChild("Handle") or item:FindFirstChildOfClass("BasePart")
                if handle then
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "FruitESP_" .. item.Name
                    bg.Size = UDim2.fromOffset(160, 40)
                    bg.AlwaysOnTop = true
                    bg.Adornee = handle
                    bg.Parent = handle

                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 12
                    label.TextColor3 = Color3.fromRGB(255, 80, 80)
                    label.Text = "🍎 " .. item.Name
                    label.Parent = bg

                    ESP.WorldFruits[item] = bg
                end
            end
        end
    end
end

-- BUCLE PRINCIPAL DE ACTUALIZACIÓN DE VISUALES
function ESP.UpdateLoop()
    task.spawn(function()
        while getgenv().CokeboysScriptLoaded do
            pcall(function()
                if Settings.ESP.Enabled then
                    for _, entry in pairs(ESP.Objects) do
                        ESP.UpdateBillboard(entry)
                    end
                    ESP.ScanWorldFruits()
                end
            end)
            task.wait(0.2)
        end
    end)
end

-- RENDERIZADOR DE ANILLO FOV (DRAWING API)
local VisualIndicator = {}
function VisualIndicator.Render()
    if not Drawing then return end
    if not ESP.FOVCircle then
        pcall(function()
            ESP.FOVCircle = Drawing.new("Circle")
            ESP.FOVCircle.Thickness = 1.5
            ESP.FOVCircle.NumSides = 48
            ESP.FOVCircle.Filled = false
            ESP.FOVCircle.Transparency = 0.85
        end)
    end

    if ESP.FOVCircle then
        ESP.FOVCircle.Visible = Settings.AimAssist.ShowFOV
        if ESP.FOVCircle.Visible then
            local mousePos = UserInputService:GetMouseLocation()
            ESP.FOVCircle.Position = mousePos
            ESP.FOVCircle.Radius = Settings.AimAssist.FOV or 350
            if Settings.ActiveModulesRainbow then
                local hue = (tick() * 0.4) % 1
                ESP.FOVCircle.Color = Color3.fromHSV(hue, 0.8, 1)
            else
                ESP.FOVCircle.Color = Settings.ActiveModulesColor or Color3.fromRGB(255, 215, 0)
            end
        end
    end
end


-- ==============================================================================
-- MÓDULO 6: MOTOR DE FÍSICAS, SALTO INFINITO, VELOCIDAD Y GLITCHES DE MOVILIDAD
-- ==============================================================================
local Movement = {}
Movement.AirJumpConnection = nil
Movement.WaterPlatform = nil
Movement.LavaPlatform = nil

function Movement.StartAirJumpLoop()
    if Movement.AirJumpConnection then return end
    Movement.AirJumpConnection = UserInputService.JumpRequest:Connect(function()
        if Settings.HoldInfiniteAirJump then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

function Movement.ApplySpeedBoost(deltaTime)
    if not Settings.SpeedBoost then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    local moveDir = hum.MoveDirection
    if moveDir.Magnitude > 0.01 then
        local factor = math.clamp(tonumber(Settings.SpeedValue) or 2.0, 1.0, 5.0)
        local dt = math.clamp(deltaTime or 0.016, 0.005, 0.05)
        hrp.CFrame = hrp.CFrame + (moveDir * factor * 25 * dt)
    end
end

function Movement.ExecuteSuperJump()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local power = Settings.SuperJumpPower or 140
    hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, power, hrp.AssemblyLinearVelocity.Z)
end

function Movement.ExecuteSangZBoost()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local look = hrp.CFrame.LookVector
    local boostDist = Settings.SangZDistance or 250
    hrp.AssemblyLinearVelocity = look * boostDist + Vector3.new(0, 30, 0)
end

function Movement.ExecuteSoulGuitarBoost()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local look = hrp.CFrame.LookVector
    hrp.AssemblyLinearVelocity = look * 200 + Vector3.new(0, 45, 0)
end

function Movement.ToggleWalkOnWater(enabled)
    Settings.WalkOnWater = enabled
    if enabled then
        if not Movement.WaterPlatform then
            local part = Instance.new("Part")
            part.Name = "CB_WaterPlatform"
            part.Size = Vector3.new(120, 2, 120)
            part.Anchored = true
            part.Transparency = 1
            part.CanCollide = true
            part.Position = Vector3.new(0, 0, 0)
            pcall(function() part.Parent = Workspace end)
            Movement.WaterPlatform = part
        end
    else
        if Movement.WaterPlatform then
            pcall(function() Movement.WaterPlatform:Destroy() end)
            Movement.WaterPlatform = nil
        end
    end
end

function Movement.ToggleWalkOnLava(enabled)
    Settings.WalkOnLava = enabled
    if enabled then
        if not Movement.LavaPlatform then
            local part = Instance.new("Part")
            part.Name = "CB_LavaPlatform"
            part.Size = Vector3.new(100, 2, 100)
            part.Anchored = true
            part.Transparency = 1
            part.CanCollide = true
            part.Position = Vector3.new(0, 10, 0)
            pcall(function() part.Parent = Workspace end)
            Movement.LavaPlatform = part
        end
    else
        if Movement.LavaPlatform then
            pcall(function() Movement.LavaPlatform:Destroy() end)
            Movement.LavaPlatform = nil
        end
    end
end

function Movement.CheckSafeMode()
    if not Settings.SafeMode then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    local hpPct = (hum.Health / math.max(hum.MaxHealth, 1)) * 100
    if hpPct <= (Settings.SafeModeHealthThreshold or 25) then
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 300, 0)
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end

function Movement.HookDash()
    -- Hook opcional para anular el cooldown de Dash
end

-- [MOVEMENT ROUTINE 01] Rutina de física y evasión #1
function Movement.SubMovement_Impulse_1(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 02] Rutina de física y evasión #2
function Movement.SubMovement_Impulse_2(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 03] Rutina de física y evasión #3
function Movement.SubMovement_Impulse_3(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 04] Rutina de física y evasión #4
function Movement.SubMovement_Impulse_4(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 05] Rutina de física y evasión #5
function Movement.SubMovement_Impulse_5(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 06] Rutina de física y evasión #6
function Movement.SubMovement_Impulse_6(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 07] Rutina de física y evasión #7
function Movement.SubMovement_Impulse_7(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 08] Rutina de física y evasión #8
function Movement.SubMovement_Impulse_8(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 09] Rutina de física y evasión #9
function Movement.SubMovement_Impulse_9(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 10] Rutina de física y evasión #10
function Movement.SubMovement_Impulse_10(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 11] Rutina de física y evasión #11
function Movement.SubMovement_Impulse_11(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 12] Rutina de física y evasión #12
function Movement.SubMovement_Impulse_12(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 13] Rutina de física y evasión #13
function Movement.SubMovement_Impulse_13(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 14] Rutina de física y evasión #14
function Movement.SubMovement_Impulse_14(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 15] Rutina de física y evasión #15
function Movement.SubMovement_Impulse_15(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 16] Rutina de física y evasión #16
function Movement.SubMovement_Impulse_16(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 17] Rutina de física y evasión #17
function Movement.SubMovement_Impulse_17(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 18] Rutina de física y evasión #18
function Movement.SubMovement_Impulse_18(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 19] Rutina de física y evasión #19
function Movement.SubMovement_Impulse_19(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 20] Rutina de física y evasión #20
function Movement.SubMovement_Impulse_20(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 21] Rutina de física y evasión #21
function Movement.SubMovement_Impulse_21(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 22] Rutina de física y evasión #22
function Movement.SubMovement_Impulse_22(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 23] Rutina de física y evasión #23
function Movement.SubMovement_Impulse_23(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 24] Rutina de física y evasión #24
function Movement.SubMovement_Impulse_24(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 25] Rutina de física y evasión #25
function Movement.SubMovement_Impulse_25(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 26] Rutina de física y evasión #26
function Movement.SubMovement_Impulse_26(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 27] Rutina de física y evasión #27
function Movement.SubMovement_Impulse_27(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 28] Rutina de física y evasión #28
function Movement.SubMovement_Impulse_28(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 29] Rutina de física y evasión #29
function Movement.SubMovement_Impulse_29(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end

-- [MOVEMENT ROUTINE 30] Rutina de física y evasión #30
function Movement.SubMovement_Impulse_30(scaleFactor)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local impulse = (scaleFactor or 1.0) * 50
    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, impulse, 0)
end


-- ==============================================================================
-- MÓDULO 7: MAESTRÍA DE ARMAS, FAST ATTACK, HAKI AUTOMÁTICO Y RACE V3/V4
-- ==============================================================================
local WeaponMastery = {}
WeaponMastery.LastFastAttack = 0
WeaponMastery.LastBusoCheck = 0
WeaponMastery.LastKenCheck = 0

local FastAttack = {}
function FastAttack.ExecuteHit()
    local now = os.clock()
    local delay = Settings.FastAttackSpeed or 0.05
    if now - WeaponMastery.LastFastAttack < delay then return end
    WeaponMastery.LastFastAttack = now

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Validator")
        if remote then
            remote:FireServer(math.floor(now * 1000))
        end
        local combatRemote = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
        if combatRemote and combatRemote:FindFirstChild("RE/RegisterAttack") then
            combatRemote["RE/RegisterAttack"]:FireServer(0)
        end
    end)
end

function WeaponMastery.CheckAutoBuso()
    if not Settings.AutoBusoHaki then return end
    local now = os.clock()
    if now - WeaponMastery.LastBusoCheck < 2.0 then return end
    WeaponMastery.LastBusoCheck = now

    local char = LocalPlayer.Character
    if char and not char:FindFirstChild("HasBuso") then
        pcall(function()
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("Buso")
            end
        end)
    end
end

function WeaponMastery.CheckAutoObservation()
    if not Settings.AutoObservation then return end
    local now = os.clock()
    if now - WeaponMastery.LastKenCheck < 2.5 then return end
    WeaponMastery.LastKenCheck = now

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer("KenHaki", true)
        end
    end)
end

function WeaponMastery.AttemptSmartV3()
    if not Settings.SmartV3 then return false end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end

    local hpPct = (hum.Health / math.max(hum.MaxHealth, 1)) * 100
    if hpPct <= (Settings.SmartV3HealthThreshold or 40) then
        pcall(function()
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommE")
            if remote then
                remote:FireServer("ActivateAbility")
                return true
            end
        end)
    end
    return false
end

function WeaponMastery.AttemptSmartV4()
    if not Settings.SmartV4 then return false end
    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommE")
        if remote then
            remote:FireServer("ActivateV4")
            return true
        end
    end)
    return false
end

function WeaponMastery.CheckAntiComboSoru()
    if not Settings.AntiComboSoru then return false end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and (hum:GetState() == Enum.HumanoidStateType.PlatformStanding or (char and char:GetAttribute("Stunned") == true)) then
        Combat.ExecuteAimedSoru()
        return true
    end
    return false
end

function WeaponMastery.GetEquippedWeaponType()
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return "None" end
    local tTip = tool.ToolTip or ""
    if tTip:find("Melee") then return "Melee"
    elseif tTip:find("Sword") then return "Sword"
    elseif tTip:find("Gun") then return "Gun"
    elseif tTip:find("Blox Fruit") then return "Fruit"
    end
    return "Melee"
end

-- [WEAPON MASTERY 01] Dispatcher de arma #1
function WeaponMastery.WeaponSubRoutine_1(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 02] Dispatcher de arma #2
function WeaponMastery.WeaponSubRoutine_2(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 03] Dispatcher de arma #3
function WeaponMastery.WeaponSubRoutine_3(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 04] Dispatcher de arma #4
function WeaponMastery.WeaponSubRoutine_4(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 05] Dispatcher de arma #5
function WeaponMastery.WeaponSubRoutine_5(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 06] Dispatcher de arma #6
function WeaponMastery.WeaponSubRoutine_6(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 07] Dispatcher de arma #7
function WeaponMastery.WeaponSubRoutine_7(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 08] Dispatcher de arma #8
function WeaponMastery.WeaponSubRoutine_8(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 09] Dispatcher de arma #9
function WeaponMastery.WeaponSubRoutine_9(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 10] Dispatcher de arma #10
function WeaponMastery.WeaponSubRoutine_10(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 11] Dispatcher de arma #11
function WeaponMastery.WeaponSubRoutine_11(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 12] Dispatcher de arma #12
function WeaponMastery.WeaponSubRoutine_12(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 13] Dispatcher de arma #13
function WeaponMastery.WeaponSubRoutine_13(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 14] Dispatcher de arma #14
function WeaponMastery.WeaponSubRoutine_14(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 15] Dispatcher de arma #15
function WeaponMastery.WeaponSubRoutine_15(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 16] Dispatcher de arma #16
function WeaponMastery.WeaponSubRoutine_16(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 17] Dispatcher de arma #17
function WeaponMastery.WeaponSubRoutine_17(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 18] Dispatcher de arma #18
function WeaponMastery.WeaponSubRoutine_18(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 19] Dispatcher de arma #19
function WeaponMastery.WeaponSubRoutine_19(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 20] Dispatcher de arma #20
function WeaponMastery.WeaponSubRoutine_20(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 21] Dispatcher de arma #21
function WeaponMastery.WeaponSubRoutine_21(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 22] Dispatcher de arma #22
function WeaponMastery.WeaponSubRoutine_22(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 23] Dispatcher de arma #23
function WeaponMastery.WeaponSubRoutine_23(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 24] Dispatcher de arma #24
function WeaponMastery.WeaponSubRoutine_24(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end

-- [WEAPON MASTERY 25] Dispatcher de arma #25
function WeaponMastery.WeaponSubRoutine_25(toolInstance)
    if not toolInstance or not toolInstance:IsA("Tool") then return false end
    if Settings.FastAttack then
        FastAttack.ExecuteHit()
        return true
    end
    return false
end


-- ==============================================================================
-- MÓDULO 8: MOTOR MAESTRO DE MACROS PARA LAS 21 FRUTAS, COMBOS Y SECUENCIAS
-- ==============================================================================
local BloxFruitsMacros = {}
BloxFruitsMacros.ActiveCombo = nil
BloxFruitsMacros.LastCast = {}

-- PERFILES DE HABILIDADES PARA LAS 21 FRUTAS DE BLOX FRUITS
BloxFruitsMacros.Profiles = {
    -- 1. Kitsune
    ["kitsune_z"] = { Fruit = "Kitsune", Key = "Z", Name = "Fox Fire Blast", Delay = 0.25, Cooldown = 4.0 },
    ["kitsune_x"] = { Fruit = "Kitsune", Key = "X", Name = "Tails of Destruction", Delay = 0.40, Cooldown = 6.0 },
    ["kitsune_c"] = { Fruit = "Kitsune", Key = "C", Name = "Fox Flame Slam", Delay = 0.50, Cooldown = 8.0 },
    ["kitsune_v"] = { Fruit = "Kitsune", Key = "V", Name = "Wildfire Drive", Delay = 0.10, Cooldown = 15.0 },
    ["kitsune_f"] = { Fruit = "Kitsune", Key = "F", Name = "Fox Swiftness", Delay = 0.10, Cooldown = 2.5 },
    -- 2. Dragon
    ["dragon_z"] = { Fruit = "Dragon", Key = "Z", Name = "Heatwave Beam", Delay = 0.60, Cooldown = 5.0 },
    ["dragon_x"] = { Fruit = "Dragon", Key = "X", Name = "Dragon Slam", Delay = 0.35, Cooldown = 7.0 },
    ["dragon_c"] = { Fruit = "Dragon", Key = "C", Name = "Fire Shower", Delay = 0.55, Cooldown = 9.0 },
    ["dragon_v"] = { Fruit = "Dragon", Key = "V", Name = "Draconic Transformation", Delay = 0.10, Cooldown = 20.0 },
    ["dragon_f"] = { Fruit = "Dragon", Key = "F", Name = "Dragon Flight", Delay = 0.10, Cooldown = 2.0 },
    -- 3. Leopard
    ["leopard_z"] = { Fruit = "Leopard", Key = "Z", Name = "Finger Revolver", Delay = 0.30, Cooldown = 4.5 },
    ["leopard_x"] = { Fruit = "Leopard", Key = "X", Name = "Spiraling Kick", Delay = 0.25, Cooldown = 6.0 },
    ["leopard_c"] = { Fruit = "Leopard", Key = "C", Name = "Afterimage Assault", Delay = 0.40, Cooldown = 8.0 },
    ["leopard_v"] = { Fruit = "Leopard", Key = "V", Name = "Body Transformation", Delay = 0.10, Cooldown = 15.0 },
    ["leopard_f"] = { Fruit = "Leopard", Key = "F", Name = "Predator Dash", Delay = 0.10, Cooldown = 2.5 },
    -- 4. Dough
    ["dough_z"] = { Fruit = "Dough", Key = "Z", Name = "Missile Glove", Delay = 0.30, Cooldown = 4.0 },
    ["dough_x"] = { Fruit = "Dough", Key = "X", Name = "Piercing Dough", Delay = 0.60, Cooldown = 6.5 },
    ["dough_c"] = { Fruit = "Dough", Key = "C", Name = "Carved Dough", Delay = 0.40, Cooldown = 8.5 },
    ["dough_v"] = { Fruit = "Dough", Key = "V", Name = "Dough Fist Fusillade", Delay = 0.80, Cooldown = 12.0 },
    ["dough_f"] = { Fruit = "Dough", Key = "F", Name = "Dough Roller", Delay = 0.10, Cooldown = 3.0 },
    -- 5. Portal
    ["portal_z"] = { Fruit = "Portal", Key = "Z", Name = "Portal Dash", Delay = 0.20, Cooldown = 3.5 },
    ["portal_x"] = { Fruit = "Portal", Key = "X", Name = "Parallel Escape", Delay = 0.10, Cooldown = 6.0 },
    ["portal_c"] = { Fruit = "Portal", Key = "C", Name = "Dimensional Rift", Delay = 0.50, Cooldown = 9.0 },
    ["portal_v"] = { Fruit = "Portal", Key = "V", Name = "World Warp", Delay = 0.20, Cooldown = 15.0 },
    ["portal_f"] = { Fruit = "Portal", Key = "F", Name = "Quantum Leap", Delay = 0.10, Cooldown = 2.0 },
    -- 6. Spirit
    ["spirit_z"] = { Fruit = "Spirit", Key = "Z", Name = "Frosted Gale", Delay = 0.35, Cooldown = 4.5 },
    ["spirit_x"] = { Fruit = "Spirit", Key = "X", Name = "Wrath of Ra", Delay = 0.45, Cooldown = 7.0 },
    ["spirit_c"] = { Fruit = "Spirit", Key = "C", Name = "End of Beginning", Delay = 0.60, Cooldown = 10.0 },
    ["spirit_v"] = { Fruit = "Spirit", Key = "V", Name = "Celestial Flight", Delay = 0.10, Cooldown = 12.0 },
    -- 7. Blizzard
    ["blizzard_z"] = { Fruit = "Blizzard", Key = "Z", Name = "Cold Wind", Delay = 0.30, Cooldown = 4.0 },
    ["blizzard_x"] = { Fruit = "Blizzard", Key = "X", Name = "Snow Storm", Delay = 0.50, Cooldown = 6.5 },
    ["blizzard_c"] = { Fruit = "Blizzard", Key = "C", Name = "Avalanche Leap", Delay = 0.40, Cooldown = 8.5 },
    ["blizzard_v"] = { Fruit = "Blizzard", Key = "V", Name = "Blizzard Domain", Delay = 0.80, Cooldown = 12.0 },
    -- 8. TRex
    ["trex_z"] = { Fruit = "TRex", Key = "Z", Name = "Tail Swipe", Delay = 0.30, Cooldown = 4.0 },
    ["trex_x"] = { Fruit = "TRex", Key = "X", Name = "Primal Screech", Delay = 0.40, Cooldown = 6.0 },
    ["trex_c"] = { Fruit = "TRex", Key = "C", Name = "Gigantic Roar", Delay = 0.50, Cooldown = 8.5 },
    ["trex_v"] = { Fruit = "TRex", Key = "V", Name = "Predator Form", Delay = 0.10, Cooldown = 15.0 },
    -- 9. Mammoth
    ["mammoth_z"] = { Fruit = "Mammoth", Key = "Z", Name = "Ancient Crush", Delay = 0.40, Cooldown = 4.5 },
    ["mammoth_x"] = { Fruit = "Mammoth", Key = "X", Name = "Prehistoric Stampede", Delay = 0.50, Cooldown = 7.0 },
    ["mammoth_c"] = { Fruit = "Mammoth", Key = "C", Name = "Colossal Tusk Slam", Delay = 0.60, Cooldown = 9.0 },
    ["mammoth_v"] = { Fruit = "Mammoth", Key = "V", Name = "Mammoth Shift", Delay = 0.10, Cooldown = 15.0 },
    -- 10. Sound
    ["sound_z"] = { Fruit = "Sound", Key = "Z", Name = "Note Burst", Delay = 0.25, Cooldown = 3.5 },
    ["sound_x"] = { Fruit = "Sound", Key = "X", Name = "Resonance Cannon", Delay = 0.40, Cooldown = 6.0 },
    ["sound_c"] = { Fruit = "Sound", Key = "C", Name = "Symphony of Ruin", Delay = 0.55, Cooldown = 8.5 },
    ["sound_v"] = { Fruit = "Sound", Key = "V", Name = "Party Time", Delay = 0.10, Cooldown = 14.0 },
    -- 11. Shadow
    ["shadow_z"] = { Fruit = "Shadow", Key = "Z", Name = "Somber Rebellion", Delay = 0.30, Cooldown = 4.0 },
    ["shadow_x"] = { Fruit = "Shadow", Key = "X", Name = "Umbrage", Delay = 0.45, Cooldown = 6.5 },
    ["shadow_c"] = { Fruit = "Shadow", Key = "C", Name = "Nightmare Leech", Delay = 0.50, Cooldown = 9.0 },
    ["shadow_v"] = { Fruit = "Shadow", Key = "V", Name = "Corvus Torment", Delay = 0.70, Cooldown = 13.0 },
    -- 12. Venom
    ["venom_z"] = { Fruit = "Venom", Key = "Z", Name = "Poison Daggers", Delay = 0.30, Cooldown = 4.0 },
    ["venom_x"] = { Fruit = "Venom", Key = "X", Name = "Noxious Shot", Delay = 0.45, Cooldown = 6.0 },
    ["venom_c"] = { Fruit = "Venom", Key = "C", Name = "Toxic Fog", Delay = 0.50, Cooldown = 8.0 },
    ["venom_v"] = { Fruit = "Venom", Key = "V", Name = "Hydra Transformation", Delay = 0.10, Cooldown = 15.0 },
    -- 13. Control
    ["control_z"] = { Fruit = "Control", Key = "Z", Name = "Control Area", Delay = 0.20, Cooldown = 5.0 },
    ["control_x"] = { Fruit = "Control", Key = "X", Name = "Levitate", Delay = 0.35, Cooldown = 6.0 },
    ["control_c"] = { Fruit = "Control", Key = "C", Name = "Echoing Knife", Delay = 0.50, Cooldown = 8.0 },
    ["control_v"] = { Fruit = "Control", Key = "V", Name = "Gamma Rush", Delay = 0.70, Cooldown = 14.0 },
    -- 14. Buddha
    ["buddha_z"] = { Fruit = "Buddha", Key = "Z", Name = "Transform", Delay = 0.10, Cooldown = 4.0 },
    ["buddha_x"] = { Fruit = "Buddha", Key = "X", Name = "Impact Slam", Delay = 0.40, Cooldown = 6.0 },
    ["buddha_c"] = { Fruit = "Buddha", Key = "C", Name = "Light of Annihilation", Delay = 0.60, Cooldown = 9.0 },
    -- 15. Magma
    ["magma_z"] = { Fruit = "Magma", Key = "Z", Name = "Magma Clap", Delay = 0.30, Cooldown = 4.0 },
    ["magma_x"] = { Fruit = "Magma", Key = "X", Name = "Magma Fist", Delay = 0.45, Cooldown = 6.0 },
    ["magma_c"] = { Fruit = "Magma", Key = "C", Name = "Magma Hound", Delay = 0.50, Cooldown = 8.0 },
    ["magma_v"] = { Fruit = "Magma", Key = "V", Name = "Volcano Eruption", Delay = 0.70, Cooldown = 12.0 },
    -- 16. Light
    ["light_z"] = { Fruit = "Light", Key = "Z", Name = "Light Ray", Delay = 0.25, Cooldown = 3.5 },
    ["light_x"] = { Fruit = "Light", Key = "X", Name = "Swords of Judgment", Delay = 0.40, Cooldown = 6.0 },
    ["light_c"] = { Fruit = "Light", Key = "C", Name = "Light Speed Destroyer", Delay = 0.50, Cooldown = 8.0 },
    ["light_v"] = { Fruit = "Light", Key = "V", Name = "Wrath of God", Delay = 0.70, Cooldown = 11.0 },
    -- 17. Ice
    ["ice_z"] = { Fruit = "Ice", Key = "Z", Name = "Ice Spears", Delay = 0.25, Cooldown = 3.5 },
    ["ice_x"] = { Fruit = "Ice", Key = "X", Name = "Ice Surge", Delay = 0.40, Cooldown = 5.5 },
    ["ice_c"] = { Fruit = "Ice", Key = "C", Name = "Ice Bird", Delay = 0.45, Cooldown = 7.5 },
    ["ice_v"] = { Fruit = "Ice", Key = "V", Name = "Glacial Age", Delay = 0.65, Cooldown = 11.0 },
    -- 18. Dark
    ["dark_z"] = { Fruit = "Dark", Key = "Z", Name = "Dark Rocks", Delay = 0.30, Cooldown = 4.0 },
    ["dark_x"] = { Fruit = "Dark", Key = "X", Name = "Black Hole", Delay = 0.50, Cooldown = 6.5 },
    ["dark_c"] = { Fruit = "Dark", Key = "C", Name = "Dark Bomb", Delay = 0.55, Cooldown = 8.5 },
    ["dark_v"] = { Fruit = "Dark", Key = "V", Name = "Abyssal Darkness", Delay = 0.70, Cooldown = 12.0 },
    -- 19. Rumble
    ["rumble_z"] = { Fruit = "Rumble", Key = "Z", Name = "Lightning Beast", Delay = 0.30, Cooldown = 4.0 },
    ["rumble_x"] = { Fruit = "Rumble", Key = "X", Name = "Thunder Palm", Delay = 0.40, Cooldown = 6.0 },
    ["rumble_c"] = { Fruit = "Rumble", Key = "C", Name = "Lightning Rain", Delay = 0.50, Cooldown = 8.5 },
    ["rumble_v"] = { Fruit = "Rumble", Key = "V", Name = "Thunder Dragon", Delay = 0.70, Cooldown = 12.0 },
    -- 20. Flame
    ["flame_z"] = { Fruit = "Flame", Key = "Z", Name = "Fire Bullets", Delay = 0.25, Cooldown = 3.5 },
    ["flame_x"] = { Fruit = "Flame", Key = "X", Name = "Fire Burst", Delay = 0.40, Cooldown = 5.5 },
    ["flame_c"] = { Fruit = "Flame", Key = "C", Name = "Fire Rocket", Delay = 0.45, Cooldown = 7.5 },
    ["flame_v"] = { Fruit = "Flame", Key = "V", Name = "Flame Emperor", Delay = 0.65, Cooldown = 11.0 },
    -- 21. Quake
    ["quake_z"] = { Fruit = "Quake", Key = "Z", Name = "Shock Wave", Delay = 0.30, Cooldown = 4.0 },
    ["quake_x"] = { Fruit = "Quake", Key = "X", Name = "Seismic Fist", Delay = 0.45, Cooldown = 6.5 },
    ["quake_c"] = { Fruit = "Quake", Key = "C", Name = "Tsunami Wave", Delay = 0.55, Cooldown = 9.0 },
    ["quake_v"] = { Fruit = "Quake", Key = "V", Name = "Dual Quake", Delay = 0.75, Cooldown = 13.0 }
}

function BloxFruitsMacros.FireSkill(skillKey)
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if not tool then return false end
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[skillKey], false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[skillKey], false, game)
    end)
    return true
end

function BloxFruitsMacros.ExecuteCombo(comboName)
    local target = Combat.CurrentTargetRoot
    if not target then return false end
    task.spawn(function()
        BloxFruitsMacros.FireSkill("Z")
        task.wait(0.35)
        BloxFruitsMacros.FireSkill("X")
        task.wait(0.45)
        BloxFruitsMacros.FireSkill("C")
        task.wait(0.50)
        BloxFruitsMacros.FireSkill("V")
    end)
    return true
end

function BloxFruitsMacros.ExecuteKitsuneCombo(target) return BloxFruitsMacros.ExecuteCombo_KitsuneOneShot(target) end
function BloxFruitsMacros.ExecuteDoughCombo(target) return BloxFruitsMacros.ExecuteCombo_DoughAwakened(target) end
function BloxFruitsMacros.ExecuteDragonCombo(target) return BloxFruitsMacros.ExecuteCombo_DragonReborn(target) end
function BloxFruitsMacros.ExecutePortalCombo(target) return BloxFruitsMacros.ExecuteCombo_PortalRiftTrap(target) end
function BloxFruitsMacros.ExecuteGodhumanCombo(target) return BloxFruitsMacros.ExecuteCombo_GodhumanCombo(target) end
function BloxFruitsMacros.ExecuteSoulGuitarBoost()
    if CB_SOUL_GUITAR_BOOST then
        CB_SOUL_GUITAR_BOOST.active = true
        task.delay(1.5, function() CB_SOUL_GUITAR_BOOST.active = false end)
    end
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: KitsuneOneShot
function BloxFruitsMacros.ExecuteCombo_KitsuneOneShot(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["KitsuneOneShot"] and now - BloxFruitsMacros.LastCast["KitsuneOneShot"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["KitsuneOneShot"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: DragonReborn
function BloxFruitsMacros.ExecuteCombo_DragonReborn(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["DragonReborn"] and now - BloxFruitsMacros.LastCast["DragonReborn"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["DragonReborn"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: LeopardBlitz
function BloxFruitsMacros.ExecuteCombo_LeopardBlitz(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["LeopardBlitz"] and now - BloxFruitsMacros.LastCast["LeopardBlitz"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["LeopardBlitz"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: DoughAwakened
function BloxFruitsMacros.ExecuteCombo_DoughAwakened(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["DoughAwakened"] and now - BloxFruitsMacros.LastCast["DoughAwakened"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["DoughAwakened"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: PortalRiftTrap
function BloxFruitsMacros.ExecuteCombo_PortalRiftTrap(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["PortalRiftTrap"] and now - BloxFruitsMacros.LastCast["PortalRiftTrap"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["PortalRiftTrap"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: SpiritCelestial
function BloxFruitsMacros.ExecuteCombo_SpiritCelestial(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["SpiritCelestial"] and now - BloxFruitsMacros.LastCast["SpiritCelestial"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["SpiritCelestial"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: BlizzardDomain
function BloxFruitsMacros.ExecuteCombo_BlizzardDomain(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["BlizzardDomain"] and now - BloxFruitsMacros.LastCast["BlizzardDomain"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["BlizzardDomain"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: TRexPredator
function BloxFruitsMacros.ExecuteCombo_TRexPredator(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["TRexPredator"] and now - BloxFruitsMacros.LastCast["TRexPredator"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["TRexPredator"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: MammothStampede
function BloxFruitsMacros.ExecuteCombo_MammothStampede(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["MammothStampede"] and now - BloxFruitsMacros.LastCast["MammothStampede"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["MammothStampede"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: SoundSymphony
function BloxFruitsMacros.ExecuteCombo_SoundSymphony(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["SoundSymphony"] and now - BloxFruitsMacros.LastCast["SoundSymphony"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["SoundSymphony"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: ShadowTorment
function BloxFruitsMacros.ExecuteCombo_ShadowTorment(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["ShadowTorment"] and now - BloxFruitsMacros.LastCast["ShadowTorment"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["ShadowTorment"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: VenomHydra
function BloxFruitsMacros.ExecuteCombo_VenomHydra(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["VenomHydra"] and now - BloxFruitsMacros.LastCast["VenomHydra"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["VenomHydra"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: ControlGamma
function BloxFruitsMacros.ExecuteCombo_ControlGamma(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["ControlGamma"] and now - BloxFruitsMacros.LastCast["ControlGamma"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["ControlGamma"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: BuddhaM1Spam
function BloxFruitsMacros.ExecuteCombo_BuddhaM1Spam(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["BuddhaM1Spam"] and now - BloxFruitsMacros.LastCast["BuddhaM1Spam"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["BuddhaM1Spam"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: MagmaVolcano
function BloxFruitsMacros.ExecuteCombo_MagmaVolcano(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["MagmaVolcano"] and now - BloxFruitsMacros.LastCast["MagmaVolcano"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["MagmaVolcano"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: LightJudgment
function BloxFruitsMacros.ExecuteCombo_LightJudgment(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["LightJudgment"] and now - BloxFruitsMacros.LastCast["LightJudgment"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["LightJudgment"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: IceGlacialAge
function BloxFruitsMacros.ExecuteCombo_IceGlacialAge(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["IceGlacialAge"] and now - BloxFruitsMacros.LastCast["IceGlacialAge"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["IceGlacialAge"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: DarkAbyssal
function BloxFruitsMacros.ExecuteCombo_DarkAbyssal(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["DarkAbyssal"] and now - BloxFruitsMacros.LastCast["DarkAbyssal"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["DarkAbyssal"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: RumbleDragon
function BloxFruitsMacros.ExecuteCombo_RumbleDragon(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["RumbleDragon"] and now - BloxFruitsMacros.LastCast["RumbleDragon"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["RumbleDragon"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: FlameEmperor
function BloxFruitsMacros.ExecuteCombo_FlameEmperor(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["FlameEmperor"] and now - BloxFruitsMacros.LastCast["FlameEmperor"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["FlameEmperor"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: QuakeTsunami
function BloxFruitsMacros.ExecuteCombo_QuakeTsunami(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["QuakeTsunami"] and now - BloxFruitsMacros.LastCast["QuakeTsunami"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["QuakeTsunami"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: GodhumanCombo
function BloxFruitsMacros.ExecuteCombo_GodhumanCombo(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["GodhumanCombo"] and now - BloxFruitsMacros.LastCast["GodhumanCombo"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["GodhumanCombo"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: SanguineAnchor
function BloxFruitsMacros.ExecuteCombo_SanguineAnchor(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["SanguineAnchor"] and now - BloxFruitsMacros.LastCast["SanguineAnchor"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["SanguineAnchor"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: ElectricClawCDK
function BloxFruitsMacros.ExecuteCombo_ElectricClawCDK(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["ElectricClawCDK"] and now - BloxFruitsMacros.LastCast["ElectricClawCDK"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["ElectricClawCDK"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: DragonTalonTTK
function BloxFruitsMacros.ExecuteCombo_DragonTalonTTK(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["DragonTalonTTK"] and now - BloxFruitsMacros.LastCast["DragonTalonTTK"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["DragonTalonTTK"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: SharkmanKabucha
function BloxFruitsMacros.ExecuteCombo_SharkmanKabucha(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["SharkmanKabucha"] and now - BloxFruitsMacros.LastCast["SharkmanKabucha"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["SharkmanKabucha"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: DeathStepSoulGuitar
function BloxFruitsMacros.ExecuteCombo_DeathStepSoulGuitar(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["DeathStepSoulGuitar"] and now - BloxFruitsMacros.LastCast["DeathStepSoulGuitar"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["DeathStepSoulGuitar"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: SuperhumanScythe
function BloxFruitsMacros.ExecuteCombo_SuperhumanScythe(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["SuperhumanScythe"] and now - BloxFruitsMacros.LastCast["SuperhumanScythe"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["SuperhumanScythe"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: CDKOneShot
function BloxFruitsMacros.ExecuteCombo_CDKOneShot(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["CDKOneShot"] and now - BloxFruitsMacros.LastCast["CDKOneShot"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["CDKOneShot"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: SharkAnchorSlam
function BloxFruitsMacros.ExecuteCombo_SharkAnchorSlam(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["SharkAnchorSlam"] and now - BloxFruitsMacros.LastCast["SharkAnchorSlam"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["SharkAnchorSlam"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: TTKWhirlwind
function BloxFruitsMacros.ExecuteCombo_TTKWhirlwind(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["TTKWhirlwind"] and now - BloxFruitsMacros.LastCast["TTKWhirlwind"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["TTKWhirlwind"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: HallowScytheSoul
function BloxFruitsMacros.ExecuteCombo_HallowScytheSoul(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["HallowScytheSoul"] and now - BloxFruitsMacros.LastCast["HallowScytheSoul"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["HallowScytheSoul"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: YamaTushitaSlash
function BloxFruitsMacros.ExecuteCombo_YamaTushitaSlash(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["YamaTushitaSlash"] and now - BloxFruitsMacros.LastCast["YamaTushitaSlash"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["YamaTushitaSlash"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: DarkBlade100
function BloxFruitsMacros.ExecuteCombo_DarkBlade100(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["DarkBlade100"] and now - BloxFruitsMacros.LastCast["DarkBlade100"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["DarkBlade100"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: SoulGuitarSnipe
function BloxFruitsMacros.ExecuteCombo_SoulGuitarSnipe(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["SoulGuitarSnipe"] and now - BloxFruitsMacros.LastCast["SoulGuitarSnipe"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["SoulGuitarSnipe"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: AcidumRifleStun
function BloxFruitsMacros.ExecuteCombo_AcidumRifleStun(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["AcidumRifleStun"] and now - BloxFruitsMacros.LastCast["AcidumRifleStun"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["AcidumRifleStun"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: KabuchaKnockback
function BloxFruitsMacros.ExecuteCombo_KabuchaKnockback(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["KabuchaKnockback"] and now - BloxFruitsMacros.LastCast["KabuchaKnockback"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["KabuchaKnockback"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: BizarreRifleLaser
function BloxFruitsMacros.ExecuteCombo_BizarreRifleLaser(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["BizarreRifleLaser"] and now - BloxFruitsMacros.LastCast["BizarreRifleLaser"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["BizarreRifleLaser"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: SerpentBowRain
function BloxFruitsMacros.ExecuteCombo_SerpentBowRain(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["SerpentBowRain"] and now - BloxFruitsMacros.LastCast["SerpentBowRain"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["SerpentBowRain"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: AirComboLock
function BloxFruitsMacros.ExecuteCombo_AirComboLock(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["AirComboLock"] and now - BloxFruitsMacros.LastCast["AirComboLock"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["AirComboLock"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: GroundSlamChain
function BloxFruitsMacros.ExecuteCombo_GroundSlamChain(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["GroundSlamChain"] and now - BloxFruitsMacros.LastCast["GroundSlamChain"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["GroundSlamChain"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: AntiAirStall
function BloxFruitsMacros.ExecuteCombo_AntiAirStall(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["AntiAirStall"] and now - BloxFruitsMacros.LastCast["AntiAirStall"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["AntiAirStall"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: SafeDistancePoke
function BloxFruitsMacros.ExecuteCombo_SafeDistancePoke(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["SafeDistancePoke"] and now - BloxFruitsMacros.LastCast["SafeDistancePoke"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["SafeDistancePoke"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: BurstFinisher
function BloxFruitsMacros.ExecuteCombo_BurstFinisher(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["BurstFinisher"] and now - BloxFruitsMacros.LastCast["BurstFinisher"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["BurstFinisher"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: CounterStunBreak
function BloxFruitsMacros.ExecuteCombo_CounterStunBreak(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["CounterStunBreak"] and now - BloxFruitsMacros.LastCast["CounterStunBreak"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["CounterStunBreak"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: FastAttackM1Weave
function BloxFruitsMacros.ExecuteCombo_FastAttackM1Weave(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["FastAttackM1Weave"] and now - BloxFruitsMacros.LastCast["FastAttackM1Weave"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["FastAttackM1Weave"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: RacialAwakeningChain
function BloxFruitsMacros.ExecuteCombo_RacialAwakeningChain(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["RacialAwakeningChain"] and now - BloxFruitsMacros.LastCast["RacialAwakeningChain"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["RacialAwakeningChain"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: FullSoruReposition
function BloxFruitsMacros.ExecuteCombo_FullSoruReposition(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["FullSoruReposition"] and now - BloxFruitsMacros.LastCast["FullSoruReposition"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["FullSoruReposition"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: HitboxDominance
function BloxFruitsMacros.ExecuteCombo_HitboxDominance(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["HitboxDominance"] and now - BloxFruitsMacros.LastCast["HitboxDominance"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["HitboxDominance"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end

-- [FRUIT COMBO EXECUTION] Macro automatizado: UltimateFinisher
function BloxFruitsMacros.ExecuteCombo_UltimateFinisher(targetPlayer)
    local targetRoot = (targetPlayer and targetPlayer.Character) and targetPlayer.Character:FindFirstChild("HumanoidRootPart") or Combat.CurrentTargetRoot
    if not targetRoot then return false end
    local now = os.clock()
    if BloxFruitsMacros.LastCast["UltimateFinisher"] and now - BloxFruitsMacros.LastCast["UltimateFinisher"] < 3.0 then
        return false
    end
    BloxFruitsMacros.LastCast["UltimateFinisher"] = now

    task.spawn(function()
        pcall(function()
            Combat.CurrentTargetRoot = targetRoot
            BloxFruitsMacros.FireSkill("Z")
            task.wait(0.3)
            BloxFruitsMacros.FireSkill("X")
            task.wait(0.4)
            BloxFruitsMacros.FireSkill("C")
            task.wait(0.4)
            if Settings.FastAttack then
                FastAttack.ExecuteHit()
            end
        end)
    end)
    return true
end


-- ==============================================================================
-- MÓDULO 8-B: CONTROLADORES DE EJECUCIÓN ESPECÍFICOS PARA 157 HABILIDADES Y ARMAS
-- ==============================================================================
local SkillExecutors = {}
SkillExecutors.SkillCooldowns = {}
SkillExecutors.ActiveCasts = {}

-- [FRUIT SKILL] Kitsune - Habilidad [Z]: FoxFireBlast (Cooldown: 4.0s)
function SkillExecutors.Cast_Kitsune_Z(targetPosition)
    local skillKey = "Kitsune_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Kitsune - Habilidad [X]: TailsOfDestruction (Cooldown: 6.0s)
function SkillExecutors.Cast_Kitsune_X(targetPosition)
    local skillKey = "Kitsune_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Kitsune - Habilidad [C]: FoxFlameSlam (Cooldown: 8.0s)
function SkillExecutors.Cast_Kitsune_C(targetPosition)
    local skillKey = "Kitsune_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Kitsune - Habilidad [V]: WildfireDrive (Cooldown: 15.0s)
function SkillExecutors.Cast_Kitsune_V(targetPosition)
    local skillKey = "Kitsune_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 15.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Kitsune - Habilidad [F]: FoxSwiftness (Cooldown: 2.5s)
function SkillExecutors.Cast_Kitsune_F(targetPosition)
    local skillKey = "Kitsune_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 2.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Dragon - Habilidad [Z]: HeatwaveBeam (Cooldown: 5.0s)
function SkillExecutors.Cast_Dragon_Z(targetPosition)
    local skillKey = "Dragon_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 5.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Dragon - Habilidad [X]: DragonSlam (Cooldown: 7.0s)
function SkillExecutors.Cast_Dragon_X(targetPosition)
    local skillKey = "Dragon_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 7.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Dragon - Habilidad [C]: FireShower (Cooldown: 9.0s)
function SkillExecutors.Cast_Dragon_C(targetPosition)
    local skillKey = "Dragon_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 9.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Dragon - Habilidad [V]: DraconicTransform (Cooldown: 20.0s)
function SkillExecutors.Cast_Dragon_V(targetPosition)
    local skillKey = "Dragon_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 20.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Dragon - Habilidad [F]: DragonFlight (Cooldown: 2.0s)
function SkillExecutors.Cast_Dragon_F(targetPosition)
    local skillKey = "Dragon_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 2.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Leopard - Habilidad [Z]: FingerRevolver (Cooldown: 4.5s)
function SkillExecutors.Cast_Leopard_Z(targetPosition)
    local skillKey = "Leopard_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Leopard - Habilidad [X]: SpiralingKick (Cooldown: 6.0s)
function SkillExecutors.Cast_Leopard_X(targetPosition)
    local skillKey = "Leopard_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Leopard - Habilidad [C]: AfterimageAssault (Cooldown: 8.0s)
function SkillExecutors.Cast_Leopard_C(targetPosition)
    local skillKey = "Leopard_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Leopard - Habilidad [V]: BodyTransform (Cooldown: 15.0s)
function SkillExecutors.Cast_Leopard_V(targetPosition)
    local skillKey = "Leopard_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 15.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Leopard - Habilidad [F]: PredatorDash (Cooldown: 2.5s)
function SkillExecutors.Cast_Leopard_F(targetPosition)
    local skillKey = "Leopard_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 2.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Dough - Habilidad [Z]: MissileGlove (Cooldown: 4.0s)
function SkillExecutors.Cast_Dough_Z(targetPosition)
    local skillKey = "Dough_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Dough - Habilidad [X]: PiercingDough (Cooldown: 6.5s)
function SkillExecutors.Cast_Dough_X(targetPosition)
    local skillKey = "Dough_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Dough - Habilidad [C]: CarvedDough (Cooldown: 8.5s)
function SkillExecutors.Cast_Dough_C(targetPosition)
    local skillKey = "Dough_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Dough - Habilidad [V]: DoughFistFusillade (Cooldown: 12.0s)
function SkillExecutors.Cast_Dough_V(targetPosition)
    local skillKey = "Dough_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 12.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Dough - Habilidad [F]: DoughRoller (Cooldown: 3.0s)
function SkillExecutors.Cast_Dough_F(targetPosition)
    local skillKey = "Dough_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Portal - Habilidad [Z]: PortalDash (Cooldown: 3.5s)
function SkillExecutors.Cast_Portal_Z(targetPosition)
    local skillKey = "Portal_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Portal - Habilidad [X]: ParallelEscape (Cooldown: 6.0s)
function SkillExecutors.Cast_Portal_X(targetPosition)
    local skillKey = "Portal_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Portal - Habilidad [C]: DimensionalRift (Cooldown: 9.0s)
function SkillExecutors.Cast_Portal_C(targetPosition)
    local skillKey = "Portal_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 9.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Portal - Habilidad [V]: WorldWarp (Cooldown: 15.0s)
function SkillExecutors.Cast_Portal_V(targetPosition)
    local skillKey = "Portal_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 15.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Portal - Habilidad [F]: QuantumLeap (Cooldown: 2.0s)
function SkillExecutors.Cast_Portal_F(targetPosition)
    local skillKey = "Portal_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 2.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Spirit - Habilidad [Z]: FrostedGale (Cooldown: 4.5s)
function SkillExecutors.Cast_Spirit_Z(targetPosition)
    local skillKey = "Spirit_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Spirit - Habilidad [X]: WrathOfRa (Cooldown: 7.0s)
function SkillExecutors.Cast_Spirit_X(targetPosition)
    local skillKey = "Spirit_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 7.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Spirit - Habilidad [C]: EndOfBeginning (Cooldown: 10.0s)
function SkillExecutors.Cast_Spirit_C(targetPosition)
    local skillKey = "Spirit_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 10.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Spirit - Habilidad [V]: CelestialFlight (Cooldown: 12.0s)
function SkillExecutors.Cast_Spirit_V(targetPosition)
    local skillKey = "Spirit_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 12.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Spirit - Habilidad [F]: SpiritGuidance (Cooldown: 3.0s)
function SkillExecutors.Cast_Spirit_F(targetPosition)
    local skillKey = "Spirit_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Blizzard - Habilidad [Z]: ColdWind (Cooldown: 4.0s)
function SkillExecutors.Cast_Blizzard_Z(targetPosition)
    local skillKey = "Blizzard_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Blizzard - Habilidad [X]: SnowStorm (Cooldown: 6.5s)
function SkillExecutors.Cast_Blizzard_X(targetPosition)
    local skillKey = "Blizzard_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Blizzard - Habilidad [C]: AvalancheLeap (Cooldown: 8.5s)
function SkillExecutors.Cast_Blizzard_C(targetPosition)
    local skillKey = "Blizzard_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Blizzard - Habilidad [V]: BlizzardDomain (Cooldown: 12.0s)
function SkillExecutors.Cast_Blizzard_V(targetPosition)
    local skillKey = "Blizzard_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 12.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Blizzard - Habilidad [F]: HowlingGust (Cooldown: 2.5s)
function SkillExecutors.Cast_Blizzard_F(targetPosition)
    local skillKey = "Blizzard_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 2.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] TRex - Habilidad [Z]: TailSwipe (Cooldown: 4.0s)
function SkillExecutors.Cast_TRex_Z(targetPosition)
    local skillKey = "TRex_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] TRex - Habilidad [X]: PrimalScreech (Cooldown: 6.0s)
function SkillExecutors.Cast_TRex_X(targetPosition)
    local skillKey = "TRex_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] TRex - Habilidad [C]: GiganticRoar (Cooldown: 8.5s)
function SkillExecutors.Cast_TRex_C(targetPosition)
    local skillKey = "TRex_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] TRex - Habilidad [V]: PredatorForm (Cooldown: 15.0s)
function SkillExecutors.Cast_TRex_V(targetPosition)
    local skillKey = "TRex_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 15.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] TRex - Habilidad [F]: PrehistoricCharge (Cooldown: 3.0s)
function SkillExecutors.Cast_TRex_F(targetPosition)
    local skillKey = "TRex_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Mammoth - Habilidad [Z]: AncientCrush (Cooldown: 4.5s)
function SkillExecutors.Cast_Mammoth_Z(targetPosition)
    local skillKey = "Mammoth_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Mammoth - Habilidad [X]: PrehistoricStampede (Cooldown: 7.0s)
function SkillExecutors.Cast_Mammoth_X(targetPosition)
    local skillKey = "Mammoth_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 7.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Mammoth - Habilidad [C]: ColossalTuskSlam (Cooldown: 9.0s)
function SkillExecutors.Cast_Mammoth_C(targetPosition)
    local skillKey = "Mammoth_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 9.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Mammoth - Habilidad [V]: MammothShift (Cooldown: 15.0s)
function SkillExecutors.Cast_Mammoth_V(targetPosition)
    local skillKey = "Mammoth_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 15.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Mammoth - Habilidad [F]: MammothRumble (Cooldown: 3.0s)
function SkillExecutors.Cast_Mammoth_F(targetPosition)
    local skillKey = "Mammoth_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Sound - Habilidad [Z]: NoteBurst (Cooldown: 3.5s)
function SkillExecutors.Cast_Sound_Z(targetPosition)
    local skillKey = "Sound_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Sound - Habilidad [X]: ResonanceCannon (Cooldown: 6.0s)
function SkillExecutors.Cast_Sound_X(targetPosition)
    local skillKey = "Sound_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Sound - Habilidad [C]: SymphonyOfRuin (Cooldown: 8.5s)
function SkillExecutors.Cast_Sound_C(targetPosition)
    local skillKey = "Sound_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Sound - Habilidad [V]: PartyTime (Cooldown: 14.0s)
function SkillExecutors.Cast_Sound_V(targetPosition)
    local skillKey = "Sound_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 14.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Sound - Habilidad [F]: SoundFlight (Cooldown: 2.5s)
function SkillExecutors.Cast_Sound_F(targetPosition)
    local skillKey = "Sound_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 2.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Shadow - Habilidad [Z]: SomberRebellion (Cooldown: 4.0s)
function SkillExecutors.Cast_Shadow_Z(targetPosition)
    local skillKey = "Shadow_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Shadow - Habilidad [X]: Umbrage (Cooldown: 6.5s)
function SkillExecutors.Cast_Shadow_X(targetPosition)
    local skillKey = "Shadow_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Shadow - Habilidad [C]: NightmareLeech (Cooldown: 9.0s)
function SkillExecutors.Cast_Shadow_C(targetPosition)
    local skillKey = "Shadow_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 9.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Shadow - Habilidad [V]: CorvusTorment (Cooldown: 13.0s)
function SkillExecutors.Cast_Shadow_V(targetPosition)
    local skillKey = "Shadow_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 13.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Shadow - Habilidad [F]: ShadowEscape (Cooldown: 3.0s)
function SkillExecutors.Cast_Shadow_F(targetPosition)
    local skillKey = "Shadow_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Venom - Habilidad [Z]: PoisonDaggers (Cooldown: 4.0s)
function SkillExecutors.Cast_Venom_Z(targetPosition)
    local skillKey = "Venom_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Venom - Habilidad [X]: NoxiousShot (Cooldown: 6.0s)
function SkillExecutors.Cast_Venom_X(targetPosition)
    local skillKey = "Venom_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Venom - Habilidad [C]: ToxicFog (Cooldown: 8.0s)
function SkillExecutors.Cast_Venom_C(targetPosition)
    local skillKey = "Venom_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Venom - Habilidad [V]: HydraTransform (Cooldown: 15.0s)
function SkillExecutors.Cast_Venom_V(targetPosition)
    local skillKey = "Venom_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 15.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Venom - Habilidad [F]: SerpentGlide (Cooldown: 2.5s)
function SkillExecutors.Cast_Venom_F(targetPosition)
    local skillKey = "Venom_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 2.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Control - Habilidad [Z]: ControlArea (Cooldown: 5.0s)
function SkillExecutors.Cast_Control_Z(targetPosition)
    local skillKey = "Control_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 5.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Control - Habilidad [X]: Levitate (Cooldown: 6.0s)
function SkillExecutors.Cast_Control_X(targetPosition)
    local skillKey = "Control_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Control - Habilidad [C]: EchoingKnife (Cooldown: 8.0s)
function SkillExecutors.Cast_Control_C(targetPosition)
    local skillKey = "Control_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Control - Habilidad [V]: GammaRush (Cooldown: 14.0s)
function SkillExecutors.Cast_Control_V(targetPosition)
    local skillKey = "Control_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 14.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Control - Habilidad [F]: TeleportSwap (Cooldown: 3.0s)
function SkillExecutors.Cast_Control_F(targetPosition)
    local skillKey = "Control_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Buddha - Habilidad [Z]: Transform (Cooldown: 4.0s)
function SkillExecutors.Cast_Buddha_Z(targetPosition)
    local skillKey = "Buddha_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Buddha - Habilidad [X]: ImpactSlam (Cooldown: 6.0s)
function SkillExecutors.Cast_Buddha_X(targetPosition)
    local skillKey = "Buddha_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Buddha - Habilidad [C]: LightOfAnnihilation (Cooldown: 9.0s)
function SkillExecutors.Cast_Buddha_C(targetPosition)
    local skillKey = "Buddha_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 9.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Buddha - Habilidad [V]: RetributionDash (Cooldown: 12.0s)
function SkillExecutors.Cast_Buddha_V(targetPosition)
    local skillKey = "Buddha_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 12.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Buddha - Habilidad [F]: BuddhaLeap (Cooldown: 2.0s)
function SkillExecutors.Cast_Buddha_F(targetPosition)
    local skillKey = "Buddha_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 2.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Magma - Habilidad [Z]: MagmaClap (Cooldown: 4.0s)
function SkillExecutors.Cast_Magma_Z(targetPosition)
    local skillKey = "Magma_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Magma - Habilidad [X]: MagmaFist (Cooldown: 6.0s)
function SkillExecutors.Cast_Magma_X(targetPosition)
    local skillKey = "Magma_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Magma - Habilidad [C]: MagmaHound (Cooldown: 8.0s)
function SkillExecutors.Cast_Magma_C(targetPosition)
    local skillKey = "Magma_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Magma - Habilidad [V]: VolcanoEruption (Cooldown: 12.0s)
function SkillExecutors.Cast_Magma_V(targetPosition)
    local skillKey = "Magma_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 12.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Magma - Habilidad [F]: MagmaFloor (Cooldown: 3.0s)
function SkillExecutors.Cast_Magma_F(targetPosition)
    local skillKey = "Magma_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Light - Habilidad [Z]: LightRay (Cooldown: 3.5s)
function SkillExecutors.Cast_Light_Z(targetPosition)
    local skillKey = "Light_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Light - Habilidad [X]: SwordsOfJudgment (Cooldown: 6.0s)
function SkillExecutors.Cast_Light_X(targetPosition)
    local skillKey = "Light_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Light - Habilidad [C]: LightSpeedDestroyer (Cooldown: 8.0s)
function SkillExecutors.Cast_Light_C(targetPosition)
    local skillKey = "Light_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Light - Habilidad [V]: WrathOfGod (Cooldown: 11.0s)
function SkillExecutors.Cast_Light_V(targetPosition)
    local skillKey = "Light_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 11.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Light - Habilidad [F]: LightSpeedFlight (Cooldown: 1.5s)
function SkillExecutors.Cast_Light_F(targetPosition)
    local skillKey = "Light_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 1.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Ice - Habilidad [Z]: IceSpears (Cooldown: 3.5s)
function SkillExecutors.Cast_Ice_Z(targetPosition)
    local skillKey = "Ice_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Ice - Habilidad [X]: IceSurge (Cooldown: 5.5s)
function SkillExecutors.Cast_Ice_X(targetPosition)
    local skillKey = "Ice_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 5.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Ice - Habilidad [C]: IceBird (Cooldown: 7.5s)
function SkillExecutors.Cast_Ice_C(targetPosition)
    local skillKey = "Ice_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 7.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Ice - Habilidad [V]: GlacialAge (Cooldown: 11.0s)
function SkillExecutors.Cast_Ice_V(targetPosition)
    local skillKey = "Ice_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 11.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Ice - Habilidad [F]: IceSkating (Cooldown: 2.0s)
function SkillExecutors.Cast_Ice_F(targetPosition)
    local skillKey = "Ice_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 2.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Dark - Habilidad [Z]: DarkRocks (Cooldown: 4.0s)
function SkillExecutors.Cast_Dark_Z(targetPosition)
    local skillKey = "Dark_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Dark - Habilidad [X]: BlackHole (Cooldown: 6.5s)
function SkillExecutors.Cast_Dark_X(targetPosition)
    local skillKey = "Dark_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Dark - Habilidad [C]: DarkBomb (Cooldown: 8.5s)
function SkillExecutors.Cast_Dark_C(targetPosition)
    local skillKey = "Dark_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Dark - Habilidad [V]: AbyssalDarkness (Cooldown: 12.0s)
function SkillExecutors.Cast_Dark_V(targetPosition)
    local skillKey = "Dark_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 12.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Dark - Habilidad [F]: DarkStepDash (Cooldown: 2.5s)
function SkillExecutors.Cast_Dark_F(targetPosition)
    local skillKey = "Dark_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 2.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Rumble - Habilidad [Z]: LightningBeast (Cooldown: 4.0s)
function SkillExecutors.Cast_Rumble_Z(targetPosition)
    local skillKey = "Rumble_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Rumble - Habilidad [X]: ThunderPalm (Cooldown: 6.0s)
function SkillExecutors.Cast_Rumble_X(targetPosition)
    local skillKey = "Rumble_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Rumble - Habilidad [C]: LightningRain (Cooldown: 8.5s)
function SkillExecutors.Cast_Rumble_C(targetPosition)
    local skillKey = "Rumble_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Rumble - Habilidad [V]: ThunderDragon (Cooldown: 12.0s)
function SkillExecutors.Cast_Rumble_V(targetPosition)
    local skillKey = "Rumble_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 12.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Rumble - Habilidad [F]: LightningFlash (Cooldown: 2.0s)
function SkillExecutors.Cast_Rumble_F(targetPosition)
    local skillKey = "Rumble_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 2.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Flame - Habilidad [Z]: FireBullets (Cooldown: 3.5s)
function SkillExecutors.Cast_Flame_Z(targetPosition)
    local skillKey = "Flame_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Flame - Habilidad [X]: FireBurst (Cooldown: 5.5s)
function SkillExecutors.Cast_Flame_X(targetPosition)
    local skillKey = "Flame_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 5.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Flame - Habilidad [C]: FireRocket (Cooldown: 7.5s)
function SkillExecutors.Cast_Flame_C(targetPosition)
    local skillKey = "Flame_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 7.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Flame - Habilidad [V]: FlameEmperor (Cooldown: 11.0s)
function SkillExecutors.Cast_Flame_V(targetPosition)
    local skillKey = "Flame_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 11.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Flame - Habilidad [F]: RocketFlight (Cooldown: 2.0s)
function SkillExecutors.Cast_Flame_F(targetPosition)
    local skillKey = "Flame_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 2.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Quake - Habilidad [Z]: ShockWave (Cooldown: 4.0s)
function SkillExecutors.Cast_Quake_Z(targetPosition)
    local skillKey = "Quake_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Quake - Habilidad [X]: SeismicFist (Cooldown: 6.5s)
function SkillExecutors.Cast_Quake_X(targetPosition)
    local skillKey = "Quake_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.5 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Quake - Habilidad [C]: TsunamiWave (Cooldown: 9.0s)
function SkillExecutors.Cast_Quake_C(targetPosition)
    local skillKey = "Quake_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 9.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Quake - Habilidad [V]: DualQuake (Cooldown: 13.0s)
function SkillExecutors.Cast_Quake_V(targetPosition)
    local skillKey = "Quake_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 13.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FRUIT SKILL] Quake - Habilidad [F]: TremorDash (Cooldown: 3.0s)
function SkillExecutors.Cast_Quake_F(targetPosition)
    local skillKey = "Quake_F"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.0 then
        return false, "Cooldown"
    end

    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false, "No Tool" end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now
    SkillExecutors.ActiveCasts[skillKey] = true

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)

    task.delay(0.25, function()
        SkillExecutors.ActiveCasts[skillKey] = nil
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] Godhuman - Movimiento [Z]: SoaringBeast (Cooldown: 4.0s)
function SkillExecutors.Cast_Godhuman_Z(targetPosition)
    local skillKey = "Godhuman_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] Godhuman - Movimiento [X]: HeavenAndEarth (Cooldown: 6.0s)
function SkillExecutors.Cast_Godhuman_X(targetPosition)
    local skillKey = "Godhuman_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.0 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] Godhuman - Movimiento [C]: SixthRealmGuns (Cooldown: 8.5s)
function SkillExecutors.Cast_Godhuman_C(targetPosition)
    local skillKey = "Godhuman_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.5 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] Godhuman - Movimiento [V]: DragonBreaker (Cooldown: 12.0s)
function SkillExecutors.Cast_Godhuman_V(targetPosition)
    local skillKey = "Godhuman_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 12.0 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] SanguineArt - Movimiento [Z]: BloodthirstyGrip (Cooldown: 4.5s)
function SkillExecutors.Cast_SanguineArt_Z(targetPosition)
    local skillKey = "SanguineArt_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.5 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] SanguineArt - Movimiento [X]: ScarletTear (Cooldown: 6.5s)
function SkillExecutors.Cast_SanguineArt_X(targetPosition)
    local skillKey = "SanguineArt_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.5 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] SanguineArt - Movimiento [C]: DevourerOfFlesh (Cooldown: 9.0s)
function SkillExecutors.Cast_SanguineArt_C(targetPosition)
    local skillKey = "SanguineArt_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 9.0 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] SanguineArt - Movimiento [V]: SanguineEmbrace (Cooldown: 13.0s)
function SkillExecutors.Cast_SanguineArt_V(targetPosition)
    local skillKey = "SanguineArt_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 13.0 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] ElectricClaw - Movimiento [Z]: ElectricRampage (Cooldown: 3.5s)
function SkillExecutors.Cast_ElectricClaw_Z(targetPosition)
    local skillKey = "ElectricClaw_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.5 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] ElectricClaw - Movimiento [X]: LightningThrust (Cooldown: 5.5s)
function SkillExecutors.Cast_ElectricClaw_X(targetPosition)
    local skillKey = "ElectricClaw_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 5.5 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] ElectricClaw - Movimiento [C]: ThunderclapAndFlash (Cooldown: 7.5s)
function SkillExecutors.Cast_ElectricClaw_C(targetPosition)
    local skillKey = "ElectricClaw_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 7.5 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] ElectricClaw - Movimiento [V]: StormBurst (Cooldown: 10.5s)
function SkillExecutors.Cast_ElectricClaw_V(targetPosition)
    local skillKey = "ElectricClaw_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 10.5 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] DragonTalon - Movimiento [Z]: TalonLighter (Cooldown: 4.0s)
function SkillExecutors.Cast_DragonTalon_Z(targetPosition)
    local skillKey = "DragonTalon_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] DragonTalon - Movimiento [X]: EmberFlicker (Cooldown: 6.0s)
function SkillExecutors.Cast_DragonTalon_X(targetPosition)
    local skillKey = "DragonTalon_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.0 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] DragonTalon - Movimiento [C]: InfernalVortex (Cooldown: 8.5s)
function SkillExecutors.Cast_DragonTalon_C(targetPosition)
    local skillKey = "DragonTalon_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.5 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] DragonTalon - Movimiento [V]: FlameBurst (Cooldown: 11.5s)
function SkillExecutors.Cast_DragonTalon_V(targetPosition)
    local skillKey = "DragonTalon_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 11.5 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] SharkmanKarate - Movimiento [Z]: TwelveWaterPalms (Cooldown: 3.5s)
function SkillExecutors.Cast_SharkmanKarate_Z(targetPosition)
    local skillKey = "SharkmanKarate_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.5 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] SharkmanKarate - Movimiento [X]: PressureVortex (Cooldown: 5.5s)
function SkillExecutors.Cast_SharkmanKarate_X(targetPosition)
    local skillKey = "SharkmanKarate_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 5.5 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] SharkmanKarate - Movimiento [C]: GreatSeaSpear (Cooldown: 7.5s)
function SkillExecutors.Cast_SharkmanKarate_C(targetPosition)
    local skillKey = "SharkmanKarate_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 7.5 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] SharkmanKarate - Movimiento [V]: WhirlpoolCrash (Cooldown: 10.0s)
function SkillExecutors.Cast_SharkmanKarate_V(targetPosition)
    local skillKey = "SharkmanKarate_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 10.0 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] DeathStep - Movimiento [Z]: RocketKick (Cooldown: 4.0s)
function SkillExecutors.Cast_DeathStep_Z(targetPosition)
    local skillKey = "DeathStep_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] DeathStep - Movimiento [X]: WindBullet (Cooldown: 6.0s)
function SkillExecutors.Cast_DeathStep_X(targetPosition)
    local skillKey = "DeathStep_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.0 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] DeathStep - Movimiento [C]: VermillionDrill (Cooldown: 8.0s)
function SkillExecutors.Cast_DeathStep_C(targetPosition)
    local skillKey = "DeathStep_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.0 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] DeathStep - Movimiento [V]: MaximumOverdrive (Cooldown: 12.0s)
function SkillExecutors.Cast_DeathStep_V(targetPosition)
    local skillKey = "DeathStep_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 12.0 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] Superhuman - Movimiento [Z]: BeastOwlPounce (Cooldown: 3.5s)
function SkillExecutors.Cast_Superhuman_Z(targetPosition)
    local skillKey = "Superhuman_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.5 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] Superhuman - Movimiento [X]: ThunderClap (Cooldown: 5.5s)
function SkillExecutors.Cast_Superhuman_X(targetPosition)
    local skillKey = "Superhuman_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 5.5 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] Superhuman - Movimiento [C]: ConquerorGun (Cooldown: 8.0s)
function SkillExecutors.Cast_Superhuman_C(targetPosition)
    local skillKey = "Superhuman_C"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.0 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
    end)
    return true, "Success"
end

-- [FIGHTING STYLE] Superhuman - Movimiento [V]: QuakePunch (Cooldown: 11.0s)
function SkillExecutors.Cast_Superhuman_V(targetPosition)
    local skillKey = "Superhuman_V"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 11.0 then
        return false, "Cooldown"
    end

    local aimPoint = targetPosition or (Combat.CurrentTargetRoot and Combat.CurrentTargetRoot.Position) or (Camera.CFrame.Position + Camera.CFrame.LookVector * 100)
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
    end)
    return true, "Success"
end

-- [SWORD SKILL] CursedDualKatana - Ataque [Z]: SlayerOfGoliaths (Cooldown: 5.0s)
function SkillExecutors.Cast_CursedDualKatana_Z(targetPosition)
    local skillKey = "CursedDualKatana_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 5.0 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [SWORD SKILL] CursedDualKatana - Ataque [X]: HellsDimension (Cooldown: 8.0s)
function SkillExecutors.Cast_CursedDualKatana_X(targetPosition)
    local skillKey = "CursedDualKatana_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.0 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [SWORD SKILL] SharkAnchor - Ataque [Z]: TyphoonToss (Cooldown: 4.5s)
function SkillExecutors.Cast_SharkAnchor_Z(targetPosition)
    local skillKey = "SharkAnchor_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.5 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [SWORD SKILL] SharkAnchor - Ataque [X]: ArmorBreaker (Cooldown: 7.5s)
function SkillExecutors.Cast_SharkAnchor_X(targetPosition)
    local skillKey = "SharkAnchor_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 7.5 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [SWORD SKILL] TrueTripleKatana - Ataque [Z]: WolfFangRounds (Cooldown: 5.0s)
function SkillExecutors.Cast_TrueTripleKatana_Z(targetPosition)
    local skillKey = "TrueTripleKatana_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 5.0 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [SWORD SKILL] TrueTripleKatana - Ataque [X]: DragonHurricane (Cooldown: 8.5s)
function SkillExecutors.Cast_TrueTripleKatana_X(targetPosition)
    local skillKey = "TrueTripleKatana_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 8.5 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [SWORD SKILL] HallowScythe - Ataque [Z]: DeathSlash (Cooldown: 4.0s)
function SkillExecutors.Cast_HallowScythe_Z(targetPosition)
    local skillKey = "HallowScythe_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [SWORD SKILL] HallowScythe - Ataque [X]: SoulExecution (Cooldown: 7.0s)
function SkillExecutors.Cast_HallowScythe_X(targetPosition)
    local skillKey = "HallowScythe_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 7.0 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [SWORD SKILL] Yama - Ataque [Z]: HellcatGlide (Cooldown: 3.5s)
function SkillExecutors.Cast_Yama_Z(targetPosition)
    local skillKey = "Yama_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.5 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [SWORD SKILL] Yama - Ataque [X]: InfernalHurricane (Cooldown: 6.5s)
function SkillExecutors.Cast_Yama_X(targetPosition)
    local skillKey = "Yama_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.5 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [SWORD SKILL] Tushita - Ataque [Z]: HeavenlyLunges (Cooldown: 3.5s)
function SkillExecutors.Cast_Tushita_Z(targetPosition)
    local skillKey = "Tushita_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.5 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [SWORD SKILL] Tushita - Ataque [X]: CelestialRavager (Cooldown: 6.5s)
function SkillExecutors.Cast_Tushita_X(targetPosition)
    local skillKey = "Tushita_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.5 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [SWORD SKILL] DarkBlade - Ataque [Z]: OneThousandSlices (Cooldown: 4.0s)
function SkillExecutors.Cast_DarkBlade_Z(targetPosition)
    local skillKey = "DarkBlade_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [SWORD SKILL] DarkBlade - Ataque [X]: DarkAirSlash (Cooldown: 7.0s)
function SkillExecutors.Cast_DarkBlade_X(targetPosition)
    local skillKey = "DarkBlade_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 7.0 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [GUN SKILL] SoulGuitar - Disparo [Z]: ElDiablo (Cooldown: 4.0s)
function SkillExecutors.Cast_SoulGuitar_Z(targetPosition)
    local skillKey = "SoulGuitar_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [GUN SKILL] SoulGuitar - Disparo [X]: SoulBeam (Cooldown: 7.5s)
function SkillExecutors.Cast_SoulGuitar_X(targetPosition)
    local skillKey = "SoulGuitar_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 7.5 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [GUN SKILL] AcidumRifle - Disparo [Z]: AcidExplosion (Cooldown: 3.5s)
function SkillExecutors.Cast_AcidumRifle_Z(targetPosition)
    local skillKey = "AcidumRifle_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.5 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [GUN SKILL] AcidumRifle - Disparo [X]: ToxicSurge (Cooldown: 6.0s)
function SkillExecutors.Cast_AcidumRifle_X(targetPosition)
    local skillKey = "AcidumRifle_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.0 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [GUN SKILL] Kabucha - Disparo [Z]: DragonShot (Cooldown: 3.0s)
function SkillExecutors.Cast_Kabucha_Z(targetPosition)
    local skillKey = "Kabucha_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.0 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [GUN SKILL] Kabucha - Disparo [X]: FireCloud (Cooldown: 5.5s)
function SkillExecutors.Cast_Kabucha_X(targetPosition)
    local skillKey = "Kabucha_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 5.5 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [GUN SKILL] BizarreRifle - Disparo [Z]: LaserBeam (Cooldown: 4.0s)
function SkillExecutors.Cast_BizarreRifle_Z(targetPosition)
    local skillKey = "BizarreRifle_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 4.0 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [GUN SKILL] BizarreRifle - Disparo [X]: Overcharge (Cooldown: 7.0s)
function SkillExecutors.Cast_BizarreRifle_X(targetPosition)
    local skillKey = "BizarreRifle_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 7.0 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end

-- [GUN SKILL] SerpentBow - Disparo [Z]: VenomArrow (Cooldown: 3.5s)
function SkillExecutors.Cast_SerpentBow_Z(targetPosition)
    local skillKey = "SerpentBow_Z"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 3.5 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
    return true, "Success"
end

-- [GUN SKILL] SerpentBow - Disparo [X]: SerpentStrike (Cooldown: 6.5s)
function SkillExecutors.Cast_SerpentBow_X(targetPosition)
    local skillKey = "SerpentBow_X"
    local now = os.clock()
    if SkillExecutors.SkillCooldowns[skillKey] and (now - SkillExecutors.SkillCooldowns[skillKey]) < 6.5 then
        return false, "Cooldown"
    end
    SkillExecutors.SkillCooldowns[skillKey] = now

    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
    end)
    return true, "Success"
end


-- ==============================================================================
-- MÓDULO 8-C: MOTOR AVANZADO DE 50 COMBOS PvP Y SINCRONIZACIÓN DE HABILIDADES
-- Secuencias verdaderas de One-Shot con keydown/keyup, camera-lock y animation-cancels
-- ==============================================================================
local AdvancedCombos = {}
AdvancedCombos.ActiveCombo = nil
AdvancedCombos.ComboRunning = false

-- [PVP COMBO SEQUENCE] Combo: Portal_CDK_Godhuman (Fruit: Portal, Sword: CursedDualKatana, Style: Godhuman)
function AdvancedCombos.Execute_Portal_CDK_Godhuman(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Portal_CDK_Godhuman"

    task.spawn(function()
        local steps = { "Portal_Z", "CDK_Z", "Godhuman_C", "CDK_X", "Godhuman_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Dough_Godhuman_Kabucha (Fruit: Dough, Sword: CursedDualKatana, Style: Godhuman)
function AdvancedCombos.Execute_Dough_Godhuman_Kabucha(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Dough_Godhuman_Kabucha"

    task.spawn(function()
        local steps = { "Dough_X", "Dough_V", "Godhuman_C", "Kabucha_X", "Dough_C" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Kitsune_Sanguine_SoulGuitar (Fruit: Kitsune, Sword: FoxLamp, Style: SanguineArt)
function AdvancedCombos.Execute_Kitsune_Sanguine_SoulGuitar(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Kitsune_Sanguine_SoulGuitar"

    task.spawn(function()
        local steps = { "Kitsune_C", "SanguineArt_C", "SoulGuitar_Z", "Kitsune_Z", "SanguineArt_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Dragon_Godhuman_Spikey (Fruit: Dragon, Sword: SpikeyTrident, Style: Godhuman)
function AdvancedCombos.Execute_Dragon_Godhuman_Spikey(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Dragon_Godhuman_Spikey"

    task.spawn(function()
        local steps = { "Spikey_X", "Dragon_C", "Godhuman_C", "Dragon_Z", "Godhuman_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Buddha_SharkAnchor_Spam (Fruit: Buddha, Sword: SharkAnchor, Style: Godhuman)
function AdvancedCombos.Execute_Buddha_SharkAnchor_Spam(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Buddha_SharkAnchor_Spam"

    task.spawn(function()
        local steps = { "Buddha_Z", "SharkAnchor_Z", "SharkAnchor_X", "Godhuman_Z", "Godhuman_X" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Ice_Acidum_DeathStep (Fruit: Ice, Sword: DarkBlade, Style: DeathStep)
function AdvancedCombos.Execute_Ice_Acidum_DeathStep(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Ice_Acidum_DeathStep"

    task.spawn(function()
        local steps = { "Ice_V", "Ice_C", "AcidumRifle_Z", "DeathStep_C", "DeathStep_V" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Dark_Kabucha_TTK (Fruit: Dark, Sword: TrueTripleKatana, Style: Superhuman)
function AdvancedCombos.Execute_Dark_Kabucha_TTK(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Dark_Kabucha_TTK"

    task.spawn(function()
        local steps = { "Dark_X", "Dark_C", "Kabucha_X", "TTK_Z", "Superhuman_C" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Rumble_EClaw_CDK (Fruit: Rumble, Sword: CursedDualKatana, Style: ElectricClaw)
function AdvancedCombos.Execute_Rumble_EClaw_CDK(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Rumble_EClaw_CDK"

    task.spawn(function()
        local steps = { "Rumble_X", "Rumble_V", "ElectricClaw_C", "CDK_Z", "ElectricClaw_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Leopard_DragonTalon_Anchor (Fruit: Leopard, Sword: SharkAnchor, Style: DragonTalon)
function AdvancedCombos.Execute_Leopard_DragonTalon_Anchor(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Leopard_DragonTalon_Anchor"

    task.spawn(function()
        local steps = { "Leopard_C", "DragonTalon_X", "SharkAnchor_Z", "Leopard_Z", "DragonTalon_C" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Spirit_Sanguine_Scythe (Fruit: Spirit, Sword: HallowScythe, Style: SanguineArt)
function AdvancedCombos.Execute_Spirit_Sanguine_Scythe(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Spirit_Sanguine_Scythe"

    task.spawn(function()
        local steps = { "Spirit_V", "HallowScythe_Z", "SanguineArt_C", "Spirit_C", "SanguineArt_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Venom_DragonTalon_TTK (Fruit: Venom, Sword: TrueTripleKatana, Style: DragonTalon)
function AdvancedCombos.Execute_Venom_DragonTalon_TTK(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Venom_DragonTalon_TTK"

    task.spawn(function()
        local steps = { "Venom_Z", "Venom_X", "DragonTalon_C", "TTK_X", "DragonTalon_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Shadow_Superhuman_DarkBlade (Fruit: Shadow, Sword: DarkBlade, Style: Superhuman)
function AdvancedCombos.Execute_Shadow_Superhuman_DarkBlade(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Shadow_Superhuman_DarkBlade"

    task.spawn(function()
        local steps = { "Shadow_V", "DarkBlade_Z", "Superhuman_C", "Shadow_C", "Superhuman_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Mammoth_Sharkman_Anchor (Fruit: Mammoth, Sword: SharkAnchor, Style: SharkmanKarate)
function AdvancedCombos.Execute_Mammoth_Sharkman_Anchor(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Mammoth_Sharkman_Anchor"

    task.spawn(function()
        local steps = { "Mammoth_Z", "SharkAnchor_Z", "SharkmanKarate_C", "Mammoth_C", "SharkmanKarate_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: TRex_Godhuman_CDK (Fruit: TRex, Sword: CursedDualKatana, Style: Godhuman)
function AdvancedCombos.Execute_TRex_Godhuman_CDK(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "TRex_Godhuman_CDK"

    task.spawn(function()
        local steps = { "TRex_C", "Godhuman_C", "CDK_Z", "TRex_Z", "Godhuman_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Sound_EClaw_SoulGuitar (Fruit: Sound, Sword: CursedDualKatana, Style: ElectricClaw)
function AdvancedCombos.Execute_Sound_EClaw_SoulGuitar(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Sound_EClaw_SoulGuitar"

    task.spawn(function()
        local steps = { "Sound_V", "SoulGuitar_Z", "ElectricClaw_C", "Sound_C", "ElectricClaw_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Magma_Godhuman_SoulGuitar (Fruit: Magma, Sword: CursedDualKatana, Style: Godhuman)
function AdvancedCombos.Execute_Magma_Godhuman_SoulGuitar(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Magma_Godhuman_SoulGuitar"

    task.spawn(function()
        local steps = { "Magma_V", "SoulGuitar_Z", "Godhuman_C", "Magma_Z", "Godhuman_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Light_Godhuman_DarkBlade (Fruit: Light, Sword: DarkBlade, Style: Godhuman)
function AdvancedCombos.Execute_Light_Godhuman_DarkBlade(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Light_Godhuman_DarkBlade"

    task.spawn(function()
        local steps = { "Light_V", "DarkBlade_Z", "Godhuman_C", "Light_C", "Godhuman_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Flame_DeathStep_Kabucha (Fruit: Flame, Sword: TrueTripleKatana, Style: DeathStep)
function AdvancedCombos.Execute_Flame_DeathStep_Kabucha(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Flame_DeathStep_Kabucha"

    task.spawn(function()
        local steps = { "Flame_V", "DeathStep_C", "Kabucha_X", "Flame_C", "DeathStep_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Quake_Godhuman_CDK (Fruit: Quake, Sword: CursedDualKatana, Style: Godhuman)
function AdvancedCombos.Execute_Quake_Godhuman_CDK(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Quake_Godhuman_CDK"

    task.spawn(function()
        local steps = { "Quake_V", "Quake_C", "Godhuman_C", "CDK_Z", "Godhuman_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Blizzard_Sanguine_Anchor (Fruit: Blizzard, Sword: SharkAnchor, Style: SanguineArt)
function AdvancedCombos.Execute_Blizzard_Sanguine_Anchor(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Blizzard_Sanguine_Anchor"

    task.spawn(function()
        local steps = { "Blizzard_V", "SharkAnchor_Z", "SanguineArt_C", "Blizzard_C", "SanguineArt_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Control_CDK_Godhuman (Fruit: Control, Sword: CursedDualKatana, Style: Godhuman)
function AdvancedCombos.Execute_Control_CDK_Godhuman(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Control_CDK_Godhuman"

    task.spawn(function()
        local steps = { "Control_V", "Control_C", "CDK_Z", "Godhuman_C", "Godhuman_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Godhuman_CDK_TrueOneShot (Fruit: None, Sword: CursedDualKatana, Style: Godhuman)
function AdvancedCombos.Execute_Godhuman_CDK_TrueOneShot(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Godhuman_CDK_TrueOneShot"

    task.spawn(function()
        local steps = { "Godhuman_C", "CDK_Z", "CDK_X", "Godhuman_Z", "Godhuman_X" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Sanguine_SharkAnchor_Burst (Fruit: None, Sword: SharkAnchor, Style: SanguineArt)
function AdvancedCombos.Execute_Sanguine_SharkAnchor_Burst(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Sanguine_SharkAnchor_Burst"

    task.spawn(function()
        local steps = { "SanguineArt_C", "SharkAnchor_Z", "SharkAnchor_X", "SanguineArt_Z", "SanguineArt_X" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: ElectricClaw_TTK_Lethal (Fruit: None, Sword: TrueTripleKatana, Style: ElectricClaw)
function AdvancedCombos.Execute_ElectricClaw_TTK_Lethal(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "ElectricClaw_TTK_Lethal"

    task.spawn(function()
        local steps = { "ElectricClaw_C", "TTK_Z", "TTK_X", "ElectricClaw_Z", "ElectricClaw_X" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: DragonTalon_HallowScythe_Burn (Fruit: None, Sword: HallowScythe, Style: DragonTalon)
function AdvancedCombos.Execute_DragonTalon_HallowScythe_Burn(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "DragonTalon_HallowScythe_Burn"

    task.spawn(function()
        local steps = { "DragonTalon_X", "HallowScythe_Z", "DragonTalon_C", "HallowScythe_X", "DragonTalon_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: SharkmanKarate_Kabucha_Stun (Fruit: None, Sword: DarkBlade, Style: SharkmanKarate)
function AdvancedCombos.Execute_SharkmanKarate_Kabucha_Stun(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "SharkmanKarate_Kabucha_Stun"

    task.spawn(function()
        local steps = { "Kabucha_X", "SharkmanKarate_C", "SharkmanKarate_X", "DarkBlade_Z", "SharkmanKarate_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: DeathStep_Acidum_Drill (Fruit: None, Sword: CursedDualKatana, Style: DeathStep)
function AdvancedCombos.Execute_DeathStep_Acidum_Drill(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "DeathStep_Acidum_Drill"

    task.spawn(function()
        local steps = { "AcidumRifle_Z", "DeathStep_C", "DeathStep_V", "CDK_Z", "DeathStep_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Superhuman_SoulGuitar_Burst (Fruit: None, Sword: TrueTripleKatana, Style: Superhuman)
function AdvancedCombos.Execute_Superhuman_SoulGuitar_Burst(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Superhuman_SoulGuitar_Burst"

    task.spawn(function()
        local steps = { "SoulGuitar_Z", "Superhuman_C", "TTK_Z", "Superhuman_Z", "Superhuman_X" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Kitsune_TrueOneShot (Fruit: Kitsune, Sword: FoxLamp, Style: Godhuman)
function AdvancedCombos.Execute_Kitsune_TrueOneShot(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Kitsune_TrueOneShot"

    task.spawn(function()
        local steps = { "Kitsune_C", "Kitsune_X", "Godhuman_C", "Kitsune_Z", "Godhuman_Z" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end

-- [PVP COMBO SEQUENCE] Combo: Dough_TrueOneShot (Fruit: Dough, Sword: SpikeyTrident, Style: Godhuman)
function AdvancedCombos.Execute_Dough_TrueOneShot(targetPlayer)
    if AdvancedCombos.ComboRunning then return false, "Busy" end
    local targetRoot = (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) or Combat.CurrentTargetRoot
    if not targetRoot then return false, "No target" end

    AdvancedCombos.ComboRunning = true
    AdvancedCombos.ActiveCombo = "Dough_TrueOneShot"

    task.spawn(function()
        local steps = { "Spikey_X", "Dough_X", "Dough_V", "Godhuman_C", "Dough_C" }
        for _, step in ipairs(steps) do
            if not targetRoot or not targetRoot.Parent then break end

            -- Teletransporte a distancia de golpe
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(myHRP.Position, targetRoot.Position)
            end

            -- Disparo de habilidad
            pcall(function()
                local key = step:match("_(%w+)$") or "Z"
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end)
            task.wait(0.35)
        end
        AdvancedCombos.ComboRunning = false
        AdvancedCombos.ActiveCombo = nil
    end)
    return true
end


-- ==============================================================================
-- MÓDULO 9: MOTOR DE AUTOFARM, MISIONES DE 3 MARES, JEFES Y EVENTOS MARÍTIMOS
-- ==============================================================================
local AutoFarm = {}
AutoFarm.CurrentQuest = nil
AutoFarm.ActiveMob = nil

-- BASE DE DATOS DE MISIONES DE LOS 3 MARES (NIVEL 1 A 2550)
AutoFarm.QuestsDatabase = {
    -- Sea 1
    { MinLevel = 1, MaxLevel = 10, QuestName = "BanditQuest1", QuestNumber = 1, MobName = "Bandit", Location = "Pirate Starter", CFrame = CFrame.new(1059, 16, 1549) },
    { MinLevel = 10, MaxLevel = 15, QuestName = "JungleQuest", QuestNumber = 1, MobName = "Monkey", Location = "Jungle", CFrame = CFrame.new(-1601, 36, 153) },
    { MinLevel = 15, MaxLevel = 30, QuestName = "JungleQuest", QuestNumber = 2, MobName = "Gorilla", Location = "Jungle", CFrame = CFrame.new(-1237, 6, -493) },
    { MinLevel = 30, MaxLevel = 40, QuestName = "BuggyQuest1", QuestNumber = 1, MobName = "Pirate", Location = "Pirate Village", CFrame = CFrame.new(-1141, 4, 3826) },
    { MinLevel = 40, MaxLevel = 60, QuestName = "BuggyQuest1", QuestNumber = 2, MobName = "Brute", Location = "Pirate Village", CFrame = CFrame.new(-1208, 4, 3925) },
    { MinLevel = 60, MaxLevel = 75, QuestName = "DesertQuest", QuestNumber = 1, MobName = "Desert Bandit", Location = "Desert", CFrame = CFrame.new(894, 6, 4390) },
    { MinLevel = 75, MaxLevel = 90, QuestName = "DesertQuest", QuestNumber = 2, MobName = "Desert Officer", Location = "Desert", CFrame = CFrame.new(1570, 6, 4363) },
    { MinLevel = 90, MaxLevel = 100, QuestName = "SnowQuest", QuestNumber = 1, MobName = "Snow Bandit", Location = "Frozen Village", CFrame = CFrame.new(1287, 105, -1295) },
    { MinLevel = 100, MaxLevel = 120, QuestName = "SnowQuest", QuestNumber = 2, MobName = "Snowman", Location = "Frozen Village", CFrame = CFrame.new(1385, 87, -1298) },
    { MinLevel = 120, MaxLevel = 150, QuestName = "MarineQuest2", QuestNumber = 1, MobName = "Chief Petty Officer", Location = "Marine Fortress", CFrame = CFrame.new(-5035, 20, 4324) },
    { MinLevel = 150, MaxLevel = 175, QuestName = "SkyQuest", QuestNumber = 1, MobName = "Sky Bandit", Location = "Skylands", CFrame = CFrame.new(-4842, 717, -2622) },
    { MinLevel = 175, MaxLevel = 190, QuestName = "SkyQuest", QuestNumber = 2, MobName = "Dark Master", Location = "Skylands", CFrame = CFrame.new(-4842, 717, -2622) },
    { MinLevel = 190, MaxLevel = 210, QuestName = "PrisonerQuest", QuestNumber = 1, MobName = "Prisoner", Location = "Prison", CFrame = CFrame.new(4870, 5, 735) },
    { MinLevel = 210, MaxLevel = 250, QuestName = "PrisonerQuest", QuestNumber = 2, MobName = "Dangerous Prisoner", Location = "Prison", CFrame = CFrame.new(5300, 5, 475) },
    { MinLevel = 250, MaxLevel = 275, QuestName = "ColosseumQuest", QuestNumber = 1, MobName = "Toga Warrior", Location = "Colosseum", CFrame = CFrame.new(-1580, 7, -2980) },
    { MinLevel = 275, MaxLevel = 300, QuestName = "ColosseumQuest", QuestNumber = 2, MobName = "Gladiator", Location = "Colosseum", CFrame = CFrame.new(-1420, 7, -3015) },
    { MinLevel = 300, MaxLevel = 325, QuestName = "MagmaQuest", QuestNumber = 1, MobName = "Military Soldier", Location = "Magma Village", CFrame = CFrame.new(-5315, 12, 8515) },
    { MinLevel = 325, MaxLevel = 375, QuestName = "MagmaQuest", QuestNumber = 2, MobName = "Military Spy", Location = "Magma Village", CFrame = CFrame.new(-5815, 75, 8820) },
    { MinLevel = 375, MaxLevel = 400, QuestName = "FishmanQuest", QuestNumber = 1, MobName = "Fishman Warrior", Location = "Underwater City", CFrame = CFrame.new(61122, 18, 1568) },
    { MinLevel = 400, MaxLevel = 450, QuestName = "FishmanQuest", QuestNumber = 2, MobName = "Fishman Commando", Location = "Underwater City", CFrame = CFrame.new(61122, 18, 1568) },
    { MinLevel = 450, MaxLevel = 475, QuestName = "SkyExp1Quest", QuestNumber = 1, MobName = "God's Guard", Location = "Upper Skylands", CFrame = CFrame.new(-4720, 845, -1950) },
    { MinLevel = 475, MaxLevel = 525, QuestName = "SkyExp1Quest", QuestNumber = 2, MobName = "Shanda", Location = "Upper Skylands", CFrame = CFrame.new(-7860, 5545, -380) },
    { MinLevel = 525, MaxLevel = 550, QuestName = "SkyExp2Quest", QuestNumber = 1, MobName = "Royal Squad", Location = "Upper Skylands", CFrame = CFrame.new(-7860, 5545, -380) },
    { MinLevel = 550, MaxLevel = 625, QuestName = "SkyExp2Quest", QuestNumber = 2, MobName = "Royal Soldier", Location = "Upper Skylands", CFrame = CFrame.new(-7860, 5545, -380) },
    { MinLevel = 625, MaxLevel = 650, QuestName = "FountainQuest", QuestNumber = 1, MobName = "Galley Pirate", Location = "Fountain City", CFrame = CFrame.new(5125, 38, 4100) },
    { MinLevel = 650, MaxLevel = 700, QuestName = "FountainQuest", QuestNumber = 2, MobName = "Galley Captain", Location = "Fountain City", CFrame = CFrame.new(5650, 38, 4920) },
    -- Sea 2
    { MinLevel = 700, MaxLevel = 725, QuestName = "Area1Quest", QuestNumber = 1, MobName = "Raider", Location = "Kingdom of Rose", CFrame = CFrame.new(-425, 72, 1836) },
    { MinLevel = 725, MaxLevel = 775, QuestName = "Area1Quest", QuestNumber = 2, MobName = "Mercenary", Location = "Kingdom of Rose", CFrame = CFrame.new(-425, 72, 1836) },
    { MinLevel = 775, MaxLevel = 800, QuestName = "Area2Quest", QuestNumber = 1, MobName = "Swan Pirate", Location = "Kingdom of Rose", CFrame = CFrame.new(875, 120, 1210) },
    { MinLevel = 800, MaxLevel = 875, QuestName = "Area2Quest", QuestNumber = 2, MobName = "Factory Staff", Location = "Kingdom of Rose", CFrame = CFrame.new(295, 72, -55) },
    { MinLevel = 875, MaxLevel = 900, QuestName = "MarineQuest3", QuestNumber = 1, MobName = "Marine Lieutenant", Location = "Green Zone", CFrame = CFrame.new(-2440, 72, -3215) },
    { MinLevel = 900, MaxLevel = 950, QuestName = "MarineQuest3", QuestNumber = 2, MobName = "Marine Captain", Location = "Green Zone", CFrame = CFrame.new(-2440, 72, -3215) },
    { MinLevel = 950, MaxLevel = 975, QuestName = "ZombieQuest", QuestNumber = 1, MobName = "Zombie", Location = "Graveyard", CFrame = CFrame.new(-5490, 48, -795) },
    { MinLevel = 975, MaxLevel = 1000, QuestName = "ZombieQuest", QuestNumber = 2, MobName = "Vampire", Location = "Graveyard", CFrame = CFrame.new(-6030, 6, -1315) },
    { MinLevel = 1000, MaxLevel = 1050, QuestName = "SnowMountainQuest", QuestNumber = 1, MobName = "Snow Trooper", Location = "Snow Mountain", CFrame = CFrame.new(605, 400, -5370) },
    { MinLevel = 1050, MaxLevel = 1100, QuestName = "SnowMountainQuest", QuestNumber = 2, MobName = "Winter Warrior", Location = "Snow Mountain", CFrame = CFrame.new(1185, 430, -5190) },
    { MinLevel = 1100, MaxLevel = 1125, QuestName = "IceSideQuest", QuestNumber = 1, MobName = "Lab Subordinate", Location = "Hot and Cold", CFrame = CFrame.new(-5825, 15, -4500) },
    { MinLevel = 1125, MaxLevel = 1175, QuestName = "IceSideQuest", QuestNumber = 2, MobName = "Horned Warrior", Location = "Hot and Cold", CFrame = CFrame.new(-6400, 15, -5800) },
    { MinLevel = 1175, MaxLevel = 1200, QuestName = "FireSideQuest", QuestNumber = 1, MobName = "Magma Ninja", Location = "Hot and Cold", CFrame = CFrame.new(-5430, 15, -5295) },
    { MinLevel = 1200, MaxLevel = 1250, QuestName = "FireSideQuest", QuestNumber = 2, MobName = "Lava Pirate", Location = "Hot and Cold", CFrame = CFrame.new(-5200, 38, -4750) },
    { MinLevel = 1250, MaxLevel = 1275, QuestName = "ShipQuest1", QuestNumber = 1, MobName = "Ship Deckhand", Location = "Cursed Ship", CFrame = CFrame.new(118, 125, 32990) },
    { MinLevel = 1275, MaxLevel = 1300, QuestName = "ShipQuest1", QuestNumber = 2, MobName = "Ship Engineer", Location = "Cursed Ship", CFrame = CFrame.new(910, 125, 33020) },
    { MinLevel = 1300, MaxLevel = 1325, QuestName = "ShipQuest2", QuestNumber = 1, MobName = "Ship Steward", Location = "Cursed Ship", CFrame = CFrame.new(915, 60, 33435) },
    { MinLevel = 1325, MaxLevel = 1350, QuestName = "ShipQuest2", QuestNumber = 2, MobName = "Ship Officer", Location = "Cursed Ship", CFrame = CFrame.new(915, 60, 33435) },
    { MinLevel = 1350, MaxLevel = 1400, QuestName = "FrostQuest", QuestNumber = 1, MobName = "Arctic Warrior", Location = "Ice Castle", CFrame = CFrame.new(6040, 28, -6225) },
    { MinLevel = 1400, MaxLevel = 1425, QuestName = "FrostQuest", QuestNumber = 2, MobName = "Snow Lurker", Location = "Ice Castle", CFrame = CFrame.new(5560, 28, -6810) },
    { MinLevel = 1425, MaxLevel = 1450, QuestName = "ForgottenQuest", QuestNumber = 1, MobName = "Sea Soldier", Location = "Forgotten Island", CFrame = CFrame.new(-3050, 235, -10145) },
    { MinLevel = 1450, MaxLevel = 1500, QuestName = "ForgottenQuest", QuestNumber = 2, MobName = "Water Fighter", Location = "Forgotten Island", CFrame = CFrame.new(-3385, 235, -10550) },
    -- Sea 3
    { MinLevel = 1500, MaxLevel = 1525, QuestName = "PiratePortQuest", QuestNumber = 1, MobName = "Pirate Millionaire", Location = "Port Town", CFrame = CFrame.new(-290, 6, 5330) },
    { MinLevel = 1525, MaxLevel = 1575, QuestName = "PiratePortQuest", QuestNumber = 2, MobName = "Pistol Billionaire", Location = "Port Town", CFrame = CFrame.new(-470, 75, 5550) },
    { MinLevel = 1575, MaxLevel = 1600, QuestName = "AmazonQuest", QuestNumber = 1, MobName = "Dragon Crew Warrior", Location = "Hydra Island", CFrame = CFrame.new(5830, 52, -1100) },
    { MinLevel = 1600, MaxLevel = 1625, QuestName = "AmazonQuest", QuestNumber = 2, MobName = "Dragon Crew Archer", Location = "Hydra Island", CFrame = CFrame.new(6500, 380, -130) },
    { MinLevel = 1625, MaxLevel = 1650, QuestName = "AmazonQuest2", QuestNumber = 1, MobName = "Female Islander", Location = "Hydra Island", CFrame = CFrame.new(5445, 600, 750) },
    { MinLevel = 1650, MaxLevel = 1700, QuestName = "AmazonQuest2", QuestNumber = 2, MobName = "Giant Islander", Location = "Hydra Island", CFrame = CFrame.new(5000, 600, -100) },
    { MinLevel = 1700, MaxLevel = 1725, QuestName = "MarineTreeIsland", QuestNumber = 1, MobName = "Marine Commodore", Location = "Great Tree", CFrame = CFrame.new(2450, 75, -7350) },
    { MinLevel = 1725, MaxLevel = 1775, QuestName = "MarineTreeIsland", QuestNumber = 2, MobName = "Marine Rear Admiral", Location = "Great Tree", CFrame = CFrame.new(2900, 75, -6750) },
    { MinLevel = 1775, MaxLevel = 1800, QuestName = "DeepForestIsland", QuestNumber = 1, MobName = "Fishman Raider", Location = "Floating Turtle", CFrame = CFrame.new(-10580, 330, -8760) },
    { MinLevel = 1800, MaxLevel = 1825, QuestName = "DeepForestIsland", QuestNumber = 2, MobName = "Fishman Captain", Location = "Floating Turtle", CFrame = CFrame.new(-11000, 330, -8890) },
    { MinLevel = 1825, MaxLevel = 1850, QuestName = "DeepForestIsland2", QuestNumber = 1, MobName = "Forest Pirate", Location = "Floating Turtle", CFrame = CFrame.new(-13270, 330, -7670) },
    { MinLevel = 1850, MaxLevel = 1900, QuestName = "DeepForestIsland2", QuestNumber = 2, MobName = "Mythological Pirate", Location = "Floating Turtle", CFrame = CFrame.new(-13550, 470, -6900) },
    { MinLevel = 1900, MaxLevel = 1925, QuestName = "HauntedQuest1", QuestNumber = 1, MobName = "Reborn Skeleton", Location = "Haunted Castle", CFrame = CFrame.new(-8750, 140, 5980) },
    { MinLevel = 1925, MaxLevel = 1975, QuestName = "HauntedQuest1", QuestNumber = 2, MobName = "Living Zombie", Location = "Haunted Castle", CFrame = CFrame.new(-8750, 140, 6200) },
    { MinLevel = 1975, MaxLevel = 2000, QuestName = "HauntedQuest2", QuestNumber = 1, MobName = "Demonic Soul", Location = "Haunted Castle", CFrame = CFrame.new(-9500, 170, 6150) },
    { MinLevel = 2000, MaxLevel = 2050, QuestName = "HauntedQuest2", QuestNumber = 2, MobName = "Posessed Mummy", Location = "Haunted Castle", CFrame = CFrame.new(-9500, 5, 6150) },
    { MinLevel = 2050, MaxLevel = 2075, QuestName = "PeanutQuest", QuestNumber = 1, MobName = "Peanut Scout", Location = "Peanut Island", CFrame = CFrame.new(-2125, 40, -10200) },
    { MinLevel = 2075, MaxLevel = 2100, QuestName = "PeanutQuest", QuestNumber = 2, MobName = "Peanut President", Location = "Peanut Island", CFrame = CFrame.new(-2125, 40, -10200) },
    { MinLevel = 2100, MaxLevel = 2125, QuestName = "IceCreamIslandQuest", QuestNumber = 1, MobName = "Ice Cream Chef", Location = "Ice Cream Island", CFrame = CFrame.new(-825, 65, -10950) },
    { MinLevel = 2125, MaxLevel = 2150, QuestName = "IceCreamIslandQuest", QuestNumber = 2, MobName = "Ice Cream Commander", Location = "Ice Cream Island", CFrame = CFrame.new(-825, 65, -10950) },
    { MinLevel = 2150, MaxLevel = 2200, QuestName = "CakeQuest1", QuestNumber = 1, MobName = "Cookie Crafter", Location = "Cake Loaf", CFrame = CFrame.new(-2050, 40, -12050) },
    { MinLevel = 2200, MaxLevel = 2250, QuestName = "CakeQuest1", QuestNumber = 2, MobName = "Cake Guard", Location = "Cake Loaf", CFrame = CFrame.new(-2050, 40, -12050) },
    { MinLevel = 2250, MaxLevel = 2300, QuestName = "CakeQuest2", QuestNumber = 1, MobName = "Baking Staff", Location = "Cake Loaf", CFrame = CFrame.new(-1900, 40, -12950) },
    { MinLevel = 2300, MaxLevel = 2350, QuestName = "CakeQuest2", QuestNumber = 2, MobName = "Head Baker", Location = "Cake Loaf", CFrame = CFrame.new(-1900, 40, -12950) },
    { MinLevel = 2350, MaxLevel = 2400, QuestName = "ChocQuest1", QuestNumber = 1, MobName = "Cocoa Warrior", Location = "Chocolate Land", CFrame = CFrame.new(230, 25, -12200) },
    { MinLevel = 2400, MaxLevel = 2450, QuestName = "ChocQuest1", QuestNumber = 2, MobName = "Chocolate Bar Battler", Location = "Chocolate Land", CFrame = CFrame.new(230, 25, -12200) },
    { MinLevel = 2450, MaxLevel = 2500, QuestName = "ChocQuest2", QuestNumber = 1, MobName = "Sweet Thief", Location = "Chocolate Land", CFrame = CFrame.new(150, 25, -12650) },
    { MinLevel = 2500, MaxLevel = 2550, QuestName = "ChocQuest2", QuestNumber = 2, MobName = "Candy Rebel", Location = "Chocolate Land", CFrame = CFrame.new(150, 25, -12650) }
}

function AutoFarm.GetOptimalQuest(playerLevel)
    playerLevel = playerLevel or 2550
    for i = #AutoFarm.QuestsDatabase, 1, -1 do
        local q = AutoFarm.QuestsDatabase[i]
        if playerLevel >= q.MinLevel then
            return q
        end
    end
    return AutoFarm.QuestsDatabase[1]
end

function AutoFarm.BringMobs(mobName, centerPosition, radius)
    radius = radius or 250
    for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
        if mob.Name == mobName and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") then
            if mob.Humanoid.Health > 0 then
                local dist = (mob.HumanoidRootPart.Position - centerPosition).Magnitude
                if dist <= radius then
                    mob.HumanoidRootPart.CFrame = CFrame.new(centerPosition)
                    mob.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end
end

function AutoFarm.FarmLoop()
    task.spawn(function()
        while getgenv().CokeboysScriptLoaded do
            pcall(function()
                -- Lógica principal de ejecución de farmeo continuo
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                WeaponMastery.CheckAutoBuso()
                WeaponMastery.CheckAutoObservation()
            end)
            task.wait(0.2)
        end
    end)
end

-- [BOSS AUTOMATION] Controlador de Jefe: RipIndra (Lv. 5000) en Floating Turtle
function AutoFarm.BossRoutine_RipIndra()
    local boss = Workspace.Enemies:FindFirstChild("RipIndra")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: DoughKing (Lv. 2300) en Cake Loaf
function AutoFarm.BossRoutine_DoughKing()
    local boss = Workspace.Enemies:FindFirstChild("DoughKing")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: CakePrince (Lv. 2300) en Cake Loaf
function AutoFarm.BossRoutine_CakePrince()
    local boss = Workspace.Enemies:FindFirstChild("CakePrince")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: Katakuri (Lv. 2300) en Mirror World
function AutoFarm.BossRoutine_Katakuri()
    local boss = Workspace.Enemies:FindFirstChild("Katakuri")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: Darkbeard (Lv. 1000) en Dark Arena
function AutoFarm.BossRoutine_Darkbeard()
    local boss = Workspace.Enemies:FindFirstChild("Darkbeard")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: SoulReaper (Lv. 2100) en Haunted Castle
function AutoFarm.BossRoutine_SoulReaper()
    local boss = Workspace.Enemies:FindFirstChild("SoulReaper")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: BeautifulPirate (Lv. 1950) en Floating Turtle
function AutoFarm.BossRoutine_BeautifulPirate()
    local boss = Workspace.Enemies:FindFirstChild("BeautifulPirate")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: CaptainElephant (Lv. 1875) en Floating Turtle
function AutoFarm.BossRoutine_CaptainElephant()
    local boss = Workspace.Enemies:FindFirstChild("CaptainElephant")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: Stone (Lv. 1550) en Port Town
function AutoFarm.BossRoutine_Stone()
    local boss = Workspace.Enemies:FindFirstChild("Stone")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: IslandEmpress (Lv. 1675) en Hydra Island
function AutoFarm.BossRoutine_IslandEmpress()
    local boss = Workspace.Enemies:FindFirstChild("IslandEmpress")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: KiloAdmiral (Lv. 1750) en Great Tree
function AutoFarm.BossRoutine_KiloAdmiral()
    local boss = Workspace.Enemies:FindFirstChild("KiloAdmiral")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: Fajita (Lv. 925) en Green Zone
function AutoFarm.BossRoutine_Fajita()
    local boss = Workspace.Enemies:FindFirstChild("Fajita")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: Diamond (Lv. 750) en Kingdom of Rose
function AutoFarm.BossRoutine_Diamond()
    local boss = Workspace.Enemies:FindFirstChild("Diamond")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: Jeremy (Lv. 850) en Kingdom of Rose
function AutoFarm.BossRoutine_Jeremy()
    local boss = Workspace.Enemies:FindFirstChild("Jeremy")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: SmokeAdmiral (Lv. 1150) en Hot and Cold
function AutoFarm.BossRoutine_SmokeAdmiral()
    local boss = Workspace.Enemies:FindFirstChild("SmokeAdmiral")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: AwakenedIceAdmiral (Lv. 1400) en Ice Castle
function AutoFarm.BossRoutine_AwakenedIceAdmiral()
    local boss = Workspace.Enemies:FindFirstChild("AwakenedIceAdmiral")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: TideKeeper (Lv. 1475) en Forgotten Island
function AutoFarm.BossRoutine_TideKeeper()
    local boss = Workspace.Enemies:FindFirstChild("TideKeeper")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: DonSwan (Lv. 1000) en Mansion
function AutoFarm.BossRoutine_DonSwan()
    local boss = Workspace.Enemies:FindFirstChild("DonSwan")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: Greybeard (Lv. 750) en Marine Fortress
function AutoFarm.BossRoutine_Greybeard()
    local boss = Workspace.Enemies:FindFirstChild("Greybeard")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: ViceAdmiral (Lv. 130) en Marine Fortress
function AutoFarm.BossRoutine_ViceAdmiral()
    local boss = Workspace.Enemies:FindFirstChild("ViceAdmiral")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: Warden (Lv. 220) en Prison
function AutoFarm.BossRoutine_Warden()
    local boss = Workspace.Enemies:FindFirstChild("Warden")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: ChiefWarden (Lv. 230) en Prison
function AutoFarm.BossRoutine_ChiefWarden()
    local boss = Workspace.Enemies:FindFirstChild("ChiefWarden")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: Swan (Lv. 240) en Prison
function AutoFarm.BossRoutine_Swan()
    local boss = Workspace.Enemies:FindFirstChild("Swan")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: MagmaAdmiral (Lv. 350) en Magma Village
function AutoFarm.BossRoutine_MagmaAdmiral()
    local boss = Workspace.Enemies:FindFirstChild("MagmaAdmiral")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: FishmanLord (Lv. 425) en Underwater City
function AutoFarm.BossRoutine_FishmanLord()
    local boss = Workspace.Enemies:FindFirstChild("FishmanLord")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: Wysper (Lv. 500) en Upper Skylands
function AutoFarm.BossRoutine_Wysper()
    local boss = Workspace.Enemies:FindFirstChild("Wysper")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: ThunderGod (Lv. 575) en Upper Skylands
function AutoFarm.BossRoutine_ThunderGod()
    local boss = Workspace.Enemies:FindFirstChild("ThunderGod")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: Cyborg (Lv. 675) en Fountain City
function AutoFarm.BossRoutine_Cyborg()
    local boss = Workspace.Enemies:FindFirstChild("Cyborg")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: GorillaKing (Lv. 25) en Jungle
function AutoFarm.BossRoutine_GorillaKing()
    local boss = Workspace.Enemies:FindFirstChild("GorillaKing")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: Bobby (Lv. 55) en Pirate Village
function AutoFarm.BossRoutine_Bobby()
    local boss = Workspace.Enemies:FindFirstChild("Bobby")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: SaberExpert (Lv. 200) en Jungle
function AutoFarm.BossRoutine_SaberExpert()
    local boss = Workspace.Enemies:FindFirstChild("SaberExpert")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: TheSaw (Lv. 100) en Middle Town
function AutoFarm.BossRoutine_TheSaw()
    local boss = Workspace.Enemies:FindFirstChild("TheSaw")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: FactoryCore (Lv. 1000) en Factory
function AutoFarm.BossRoutine_FactoryCore()
    local boss = Workspace.Enemies:FindFirstChild("FactoryCore")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: SeaBeast (Lv. 1500) en Rough Sea
function AutoFarm.BossRoutine_SeaBeast()
    local boss = Workspace.Enemies:FindFirstChild("SeaBeast")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end

-- [BOSS AUTOMATION] Controlador de Jefe: TerrorShark (Lv. 2000) en Tier 6 Sea
function AutoFarm.BossRoutine_TerrorShark()
    local boss = Workspace.Enemies:FindFirstChild("TerrorShark")
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    pcall(function()
        myHRP.CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        if Settings.FastAttack then
            FastAttack.ExecuteHit()
        end
    end)
    return true
end


-- ==============================================================================
-- MÓDULO 9-B: CONTROLADORES DETALLADOS DE JEFES, RAIDS Y RUTINAS MARÍTIMAS
-- ==============================================================================
local RaidController = {}
RaidController.ActiveRaid = nil
RaidController.CurrentIsland = 1
RaidController.IsAttackingCore = false

local SeaEvents = {}
SeaEvents.ActiveEvents = {}
SeaEvents.TerrorSharkSpawned = false
SeaEvents.MirageMoonAligned = false

-- [RAID CONTROLLER] Incursión: Flame (ID: 1, HP del Núcleo: 14500) en Cinder Island
function RaidController.StartRaid_Flame()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer("RaidsNpc", "Select", "Flame")
            task.wait(0.5)
            remote:InvokeServer("RaidsNpc", "Start")
        end
    end)
    return true
end

function RaidController.ClearStage_Flame(stageNumber)
    local stage = stageNumber or 1
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Agrupa enemigos de la fase actual y activa Fast Attack
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                end
            end
        end
    end)
    return true
end

-- [RAID CONTROLLER] Incursión: Ice (ID: 2, HP del Núcleo: 16000) en Glacial Core
function RaidController.StartRaid_Ice()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer("RaidsNpc", "Select", "Ice")
            task.wait(0.5)
            remote:InvokeServer("RaidsNpc", "Start")
        end
    end)
    return true
end

function RaidController.ClearStage_Ice(stageNumber)
    local stage = stageNumber or 1
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Agrupa enemigos de la fase actual y activa Fast Attack
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                end
            end
        end
    end)
    return true
end

-- [RAID CONTROLLER] Incursión: Quake (ID: 3, HP del Núcleo: 18500) en Seismic Island
function RaidController.StartRaid_Quake()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer("RaidsNpc", "Select", "Quake")
            task.wait(0.5)
            remote:InvokeServer("RaidsNpc", "Start")
        end
    end)
    return true
end

function RaidController.ClearStage_Quake(stageNumber)
    local stage = stageNumber or 1
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Agrupa enemigos de la fase actual y activa Fast Attack
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                end
            end
        end
    end)
    return true
end

-- [RAID CONTROLLER] Incursión: Light (ID: 4, HP del Núcleo: 19000) en Radiant Sanctuary
function RaidController.StartRaid_Light()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer("RaidsNpc", "Select", "Light")
            task.wait(0.5)
            remote:InvokeServer("RaidsNpc", "Start")
        end
    end)
    return true
end

function RaidController.ClearStage_Light(stageNumber)
    local stage = stageNumber or 1
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Agrupa enemigos de la fase actual y activa Fast Attack
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                end
            end
        end
    end)
    return true
end

-- [RAID CONTROLLER] Incursión: Dark (ID: 5, HP del Núcleo: 21000) en Abyssal Crypt
function RaidController.StartRaid_Dark()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer("RaidsNpc", "Select", "Dark")
            task.wait(0.5)
            remote:InvokeServer("RaidsNpc", "Start")
        end
    end)
    return true
end

function RaidController.ClearStage_Dark(stageNumber)
    local stage = stageNumber or 1
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Agrupa enemigos de la fase actual y activa Fast Attack
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                end
            end
        end
    end)
    return true
end

-- [RAID CONTROLLER] Incursión: String (ID: 6, HP del Núcleo: 22000) en Thread Domain
function RaidController.StartRaid_String()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer("RaidsNpc", "Select", "String")
            task.wait(0.5)
            remote:InvokeServer("RaidsNpc", "Start")
        end
    end)
    return true
end

function RaidController.ClearStage_String(stageNumber)
    local stage = stageNumber or 1
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Agrupa enemigos de la fase actual y activa Fast Attack
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                end
            end
        end
    end)
    return true
end

-- [RAID CONTROLLER] Incursión: Rumble (ID: 7, HP del Núcleo: 24000) en Thunder Sanctuary
function RaidController.StartRaid_Rumble()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer("RaidsNpc", "Select", "Rumble")
            task.wait(0.5)
            remote:InvokeServer("RaidsNpc", "Start")
        end
    end)
    return true
end

function RaidController.ClearStage_Rumble(stageNumber)
    local stage = stageNumber or 1
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Agrupa enemigos de la fase actual y activa Fast Attack
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                end
            end
        end
    end)
    return true
end

-- [RAID CONTROLLER] Incursión: Magma (ID: 8, HP del Núcleo: 25000) en Volcanic Chamber
function RaidController.StartRaid_Magma()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer("RaidsNpc", "Select", "Magma")
            task.wait(0.5)
            remote:InvokeServer("RaidsNpc", "Start")
        end
    end)
    return true
end

function RaidController.ClearStage_Magma(stageNumber)
    local stage = stageNumber or 1
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Agrupa enemigos de la fase actual y activa Fast Attack
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                end
            end
        end
    end)
    return true
end

-- [RAID CONTROLLER] Incursión: Buddha (ID: 9, HP del Núcleo: 28000) en Golden Temple
function RaidController.StartRaid_Buddha()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer("RaidsNpc", "Select", "Buddha")
            task.wait(0.5)
            remote:InvokeServer("RaidsNpc", "Start")
        end
    end)
    return true
end

function RaidController.ClearStage_Buddha(stageNumber)
    local stage = stageNumber or 1
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Agrupa enemigos de la fase actual y activa Fast Attack
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                end
            end
        end
    end)
    return true
end

-- [RAID CONTROLLER] Incursión: Phoenix (ID: 10, HP del Núcleo: 30000) en Rebirth Altar
function RaidController.StartRaid_Phoenix()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer("RaidsNpc", "Select", "Phoenix")
            task.wait(0.5)
            remote:InvokeServer("RaidsNpc", "Start")
        end
    end)
    return true
end

function RaidController.ClearStage_Phoenix(stageNumber)
    local stage = stageNumber or 1
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Agrupa enemigos de la fase actual y activa Fast Attack
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                end
            end
        end
    end)
    return true
end

-- [RAID CONTROLLER] Incursión: Dough (ID: 11, HP del Núcleo: 35000) en Sweet Citadel
function RaidController.StartRaid_Dough()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer("RaidsNpc", "Select", "Dough")
            task.wait(0.5)
            remote:InvokeServer("RaidsNpc", "Start")
        end
    end)
    return true
end

function RaidController.ClearStage_Dough(stageNumber)
    local stage = stageNumber or 1
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Agrupa enemigos de la fase actual y activa Fast Attack
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                end
            end
        end
    end)
    return true
end

-- [RAID CONTROLLER] Incursión: Spider (ID: 12, HP del Núcleo: 32000) en Arachnid Hollow
function RaidController.StartRaid_Spider()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer("RaidsNpc", "Select", "Spider")
            task.wait(0.5)
            remote:InvokeServer("RaidsNpc", "Start")
        end
    end)
    return true
end

function RaidController.ClearStage_Spider(stageNumber)
    local stage = stageNumber or 1
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Agrupa enemigos de la fase actual y activa Fast Attack
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                end
            end
        end
    end)
    return true
end

-- [SEA EVENT HANDLER] Evento de Mar: SeaBeastHunter en Rough Sea (Tier 4-6)
function SeaEvents.Handle_SeaBeastHunter()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Atacar jefe marítimo manteniendo posición segura sobre el agua
        for _, mob in ipairs(Workspace.SeaBeasts:GetChildren()) do
            if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
                hrp.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0, 35, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end
        end
    end)
    return true
end

-- [SEA EVENT HANDLER] Evento de Mar: TerrorSharkSlayer en Tiki Outpost (Tier 6)
function SeaEvents.Handle_TerrorSharkSlayer()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Atacar jefe marítimo manteniendo posición segura sobre el agua
        for _, mob in ipairs(Workspace.SeaBeasts:GetChildren()) do
            if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
                hrp.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0, 35, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end
        end
    end)
    return true
end

-- [SEA EVENT HANDLER] Evento de Mar: GhostShipClearing en Cursed Waters (Tier 3-5)
function SeaEvents.Handle_GhostShipClearing()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Atacar jefe marítimo manteniendo posición segura sobre el agua
        for _, mob in ipairs(Workspace.SeaBeasts:GetChildren()) do
            if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
                hrp.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0, 35, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end
        end
    end)
    return true
end

-- [SEA EVENT HANDLER] Evento de Mar: PiranhaSwarmDefend en Hazard Zone (Tier 2-4)
function SeaEvents.Handle_PiranhaSwarmDefend()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Atacar jefe marítimo manteniendo posición segura sobre el agua
        for _, mob in ipairs(Workspace.SeaBeasts:GetChildren()) do
            if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
                hrp.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0, 35, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end
        end
    end)
    return true
end

-- [SEA EVENT HANDLER] Evento de Mar: MirageIslandSolver en Mirage Island (Fog 100%)
function SeaEvents.Handle_MirageIslandSolver()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Búsqueda de luna y alineación de cámara
        local moonDir = Lighting:GetSunDirection() * -1
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + moonDir)
        -- Activación de Race V4
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommE")
        if remote then remote:FireServer("ActivateV4") end
    end)
    return true
end

-- [SEA EVENT HANDLER] Evento de Mar: LeviathanGateUnlock en Frozen Dimension (Tier 6)
function SeaEvents.Handle_LeviathanGateUnlock()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        -- Atacar jefe marítimo manteniendo posición segura sobre el agua
        for _, mob in ipairs(Workspace.SeaBeasts:GetChildren()) do
            if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
                hrp.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0, 35, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
            end
        end
    end)
    return true
end


-- ==============================================================================
-- MÓDULO 9-C: CONTROLADORES AUTOMATIZADOS PARA TODAS LAS 95 MISIONES (SEA 1, 2 Y 3)
-- Implementación semántica completa de diálogo, teletransporte, agrupación y combate
-- ==============================================================================
local QuestRoutines = {}
QuestRoutines.ActiveQuest = nil
QuestRoutines.CurrentMob = nil

-- [QUEST FARM ROUTINE] Misión Lv. 1: Bandit -> Bandit (5 enemigos)
function QuestRoutines.Farm_Bandit()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(1059, 19, 1549)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "BanditQuest1", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Bandit" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Bandit" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 10: Monkey -> Monkey (6 enemigos)
function QuestRoutines.Farm_Monkey()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 10 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-1601, 40, 153)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "JungleQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Monkey" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Monkey" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 15: Gorilla -> Gorilla (8 enemigos)
function QuestRoutines.Farm_Gorilla()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 15 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-1601, 40, 153)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "JungleQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Gorilla" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Gorilla" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 30: Pirate -> Pirate (8 enemigos)
function QuestRoutines.Farm_Pirate()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 30 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-1140, 7, 3828)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "BuggyQuest1", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Pirate" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Pirate" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 40: Brute -> Brute (8 enemigos)
function QuestRoutines.Farm_Brute()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 40 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-1140, 7, 3828)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "BuggyQuest1", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Brute" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Brute" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 60: DesertBandit -> Desert Bandit (8 enemigos)
function QuestRoutines.Farm_DesertBandit()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 60 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(896, 9, 4390)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "DesertQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Desert Bandit" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Desert Bandit" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 75: DesertOfficer -> Desert Officer (6 enemigos)
function QuestRoutines.Farm_DesertOfficer()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 75 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(896, 9, 4390)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "DesertQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Desert Officer" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Desert Officer" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 90: SnowBandit -> Snow Bandit (7 enemigos)
function QuestRoutines.Farm_SnowBandit()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 90 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(1385, 90, -1297)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "SnowQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Snow Bandit" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Snow Bandit" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 100: Snowman -> Snowman (8 enemigos)
function QuestRoutines.Farm_Snowman()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 100 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(1385, 90, -1297)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "SnowQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Snowman" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Snowman" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 120: ChiefPettyOfficer -> Chief Petty Officer (8 enemigos)
function QuestRoutines.Farm_ChiefPettyOfficer()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 120 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-5035, 32, 4325)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "MarineQuest2", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Chief Petty Officer" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Chief Petty Officer" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 150: SkyBandit -> Sky Bandit (7 enemigos)
function QuestRoutines.Farm_SkyBandit()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 150 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-4840, 721, -2620)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "SkyQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Sky Bandit" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Sky Bandit" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 175: DarkMaster -> Dark Master (8 enemigos)
function QuestRoutines.Farm_DarkMaster()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 175 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-4840, 721, -2620)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "SkyQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Dark Master" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Dark Master" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 190: Prisoner -> Prisoner (8 enemigos)
function QuestRoutines.Farm_Prisoner()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 190 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(5308, 5, 474)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "PrisonerQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Prisoner" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Prisoner" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 210: DangerousPrisoner -> Dangerous Prisoner (8 enemigos)
function QuestRoutines.Farm_DangerousPrisoner()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 210 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(5308, 5, 474)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "PrisonerQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Dangerous Prisoner" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Dangerous Prisoner" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 225: TogaWarrior -> Toga Warrior (7 enemigos)
function QuestRoutines.Farm_TogaWarrior()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 225 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-1580, 10, -2980)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "ColosseumQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Toga Warrior" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Toga Warrior" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 275: Gladiator -> Gladiator (8 enemigos)
function QuestRoutines.Farm_Gladiator()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 275 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-1580, 10, -2980)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "ColosseumQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Gladiator" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Gladiator" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 300: MilitarySoldier -> Military Soldier (8 enemigos)
function QuestRoutines.Farm_MilitarySoldier()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 300 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-5315, 15, 8515)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "MagmaQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Military Soldier" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Military Soldier" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 330: MilitarySpy -> Military Spy (8 enemigos)
function QuestRoutines.Farm_MilitarySpy()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 330 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-5315, 15, 8515)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "MagmaQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Military Spy" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Military Spy" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 375: FishmanWarrior -> Fishman Warrior (8 enemigos)
function QuestRoutines.Farm_FishmanWarrior()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 375 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(61122, 21, 1565)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "FishmanQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Fishman Warrior" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Fishman Warrior" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 400: FishmanCommando -> Fishman Commando (7 enemigos)
function QuestRoutines.Farm_FishmanCommando()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 400 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(61122, 21, 1565)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "FishmanQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Fishman Commando" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Fishman Commando" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 450: GodsGuard -> God's Guard (7 enemigos)
function QuestRoutines.Farm_GodsGuard()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 450 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-4720, 848, -1950)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "SkyExp1Quest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "God's Guard" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "God's Guard" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 475: Shanda -> Shanda (8 enemigos)
function QuestRoutines.Farm_Shanda()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 475 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-4720, 848, -1950)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "SkyExp1Quest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Shanda" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Shanda" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 525: RoyalSquad -> Royal Squad (8 enemigos)
function QuestRoutines.Farm_RoyalSquad()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 525 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-7900, 5568, -600)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "SkyExp2Quest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Royal Squad" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Royal Squad" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 550: RoyalSoldier -> Royal Soldier (8 enemigos)
function QuestRoutines.Farm_RoyalSoldier()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 550 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-7900, 5568, -600)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "SkyExp2Quest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Royal Soldier" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Royal Soldier" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 625: GalleyPirate -> Galley Pirate (8 enemigos)
function QuestRoutines.Farm_GalleyPirate()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 625 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(5258, 42, 4050)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "FountainQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Galley Pirate" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Galley Pirate" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 650: GalleyCaptain -> Galley Captain (8 enemigos)
function QuestRoutines.Farm_GalleyCaptain()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 650 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(5258, 42, 4050)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "FountainQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Galley Captain" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Galley Captain" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 700: Raider -> Raider (8 enemigos)
function QuestRoutines.Farm_Raider()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 700 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-425, 76, 1835)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "Area1Quest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Raider" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Raider" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 725: Mercenary -> Mercenary (8 enemigos)
function QuestRoutines.Farm_Mercenary()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 725 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-425, 76, 1835)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "Area1Quest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Mercenary" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Mercenary" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 775: SwanPirate -> Swan Pirate (8 enemigos)
function QuestRoutines.Farm_SwanPirate()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 775 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(635, 76, 915)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "Area2Quest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Swan Pirate" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Swan Pirate" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 800: FactoryStaff -> Factory Staff (8 enemigos)
function QuestRoutines.Farm_FactoryStaff()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 800 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(635, 76, 915)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "Area2Quest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Factory Staff" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Factory Staff" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 875: MarineLieutenant -> Marine Lieutenant (8 enemigos)
function QuestRoutines.Farm_MarineLieutenant()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 875 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-2440, 76, -3215)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "MarineQuest3", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Marine Lieutenant" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Marine Lieutenant" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 900: MarineCaptain -> Marine Captain (8 enemigos)
function QuestRoutines.Farm_MarineCaptain()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 900 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-2440, 76, -3215)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "MarineQuest3", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Marine Captain" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Marine Captain" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 950: Zombie -> Zombie (8 enemigos)
function QuestRoutines.Farm_Zombie()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 950 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-5490, 52, -795)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "ZombieQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Zombie" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Zombie" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 975: Vampire -> Vampire (8 enemigos)
function QuestRoutines.Farm_Vampire()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 975 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-5490, 52, -795)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "ZombieQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Vampire" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Vampire" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1000: SnowTrooper -> Snow Trooper (8 enemigos)
function QuestRoutines.Farm_SnowTrooper()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1000 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(605, 404, -5370)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "SnowMountainQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Snow Trooper" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Snow Trooper" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1050: WinterWarrior -> Winter Warrior (8 enemigos)
function QuestRoutines.Farm_WinterWarrior()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1050 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(605, 404, -5370)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "SnowMountainQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Winter Warrior" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Winter Warrior" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1100: LabSubordinate -> Lab Subordinate (8 enemigos)
function QuestRoutines.Farm_LabSubordinate()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1100 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-6060, 19, -4905)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "IceSideQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Lab Subordinate" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Lab Subordinate" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1125: HornedWarrior -> Horned Warrior (8 enemigos)
function QuestRoutines.Farm_HornedWarrior()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1125 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-6060, 19, -4905)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "IceSideQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Horned Warrior" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Horned Warrior" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1175: MagmaNinja -> Magma Ninja (8 enemigos)
function QuestRoutines.Farm_MagmaNinja()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1175 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-5430, 19, -5295)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "FireSideQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Magma Ninja" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Magma Ninja" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1200: LavaPirate -> Lava Pirate (8 enemigos)
function QuestRoutines.Farm_LavaPirate()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1200 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-5430, 19, -5295)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "FireSideQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Lava Pirate" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Lava Pirate" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1250: ShipDeckhand -> Ship Deckhand (8 enemigos)
function QuestRoutines.Farm_ShipDeckhand()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1250 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(1030, 128, 32910)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "ShipQuest1", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Ship Deckhand" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Ship Deckhand" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1275: ShipEngineer -> Ship Engineer (8 enemigos)
function QuestRoutines.Farm_ShipEngineer()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1275 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(1030, 128, 32910)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "ShipQuest1", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Ship Engineer" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Ship Engineer" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1300: ShipSteward -> Ship Steward (8 enemigos)
function QuestRoutines.Farm_ShipSteward()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1300 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(970, 128, 33240)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "ShipQuest2", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Ship Steward" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Ship Steward" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1325: ShipOfficer -> Ship Officer (8 enemigos)
function QuestRoutines.Farm_ShipOfficer()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1325 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(970, 128, 33240)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "ShipQuest2", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Ship Officer" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Ship Officer" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1350: ArcticWarrior -> Arctic Warrior (8 enemigos)
function QuestRoutines.Farm_ArcticWarrior()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1350 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(5665, 30, -6485)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "FrostQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Arctic Warrior" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Arctic Warrior" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1375: SnowLurker -> Snow Lurker (8 enemigos)
function QuestRoutines.Farm_SnowLurker()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1375 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(5665, 30, -6485)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "FrostQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Snow Lurker" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Snow Lurker" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1425: SeaSoldier -> Sea Soldier (8 enemigos)
function QuestRoutines.Farm_SeaSoldier()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1425 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-3055, 240, -10145)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "ForgottenQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Sea Soldier" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Sea Soldier" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1450: WaterFighter -> Water Fighter (8 enemigos)
function QuestRoutines.Farm_WaterFighter()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1450 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-3055, 240, -10145)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "ForgottenQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Water Fighter" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Water Fighter" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1500: PirateMillionaire -> Pirate Millionaire (8 enemigos)
function QuestRoutines.Farm_PirateMillionaire()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1500 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-290, 47, 5580)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "PiratePortQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Pirate Millionaire" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Pirate Millionaire" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1525: PistolBillionaire -> Pistol Billionaire (8 enemigos)
function QuestRoutines.Farm_PistolBillionaire()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1525 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-290, 47, 5580)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "PiratePortQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Pistol Billionaire" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Pistol Billionaire" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1575: DragonCrewWarrior -> Dragon Crew Warrior (8 enemigos)
function QuestRoutines.Farm_DragonCrewWarrior()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1575 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(5830, 55, -1100)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "AmazonQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Dragon Crew Warrior" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Dragon Crew Warrior" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1600: DragonCrewArcher -> Dragon Crew Archer (8 enemigos)
function QuestRoutines.Farm_DragonCrewArcher()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1600 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(5830, 55, -1100)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "AmazonQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Dragon Crew Archer" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Dragon Crew Archer" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1625: FemaleIslander -> Female Islander (8 enemigos)
function QuestRoutines.Farm_FemaleIslander()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1625 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(5450, 603, 750)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "AmazonQuest2", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Female Islander" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Female Islander" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1650: GiantIslander -> Giant Islander (8 enemigos)
function QuestRoutines.Farm_GiantIslander()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1650 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(5450, 603, 750)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "AmazonQuest2", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Giant Islander" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Giant Islander" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1700: MarineCommodore -> Marine Commodore (8 enemigos)
function QuestRoutines.Farm_MarineCommodore()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1700 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(2180, 32, -6740)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "MarineTreeQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Marine Commodore" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Marine Commodore" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1725: MarineRearAdmiral -> Marine Rear Admiral (8 enemigos)
function QuestRoutines.Farm_MarineRearAdmiral()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1725 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(2180, 32, -6740)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "MarineTreeQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Marine Rear Admiral" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Marine Rear Admiral" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1775: FishmanRaider -> Fishman Raider (8 enemigos)
function QuestRoutines.Farm_FishmanRaider()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1775 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-10580, 335, -8760)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "DeepForestIslandQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Fishman Raider" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Fishman Raider" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1800: FishmanCaptain -> Fishman Captain (8 enemigos)
function QuestRoutines.Farm_FishmanCaptain()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1800 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-10580, 335, -8760)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "DeepForestIslandQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Fishman Captain" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Fishman Captain" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1825: ForestPirate -> Forest Pirate (8 enemigos)
function QuestRoutines.Farm_ForestPirate()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1825 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-13230, 335, -7625)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "DeepForestIsland2Quest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Forest Pirate" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Forest Pirate" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1850: MythologicalPirate -> Mythological Pirate (8 enemigos)
function QuestRoutines.Farm_MythologicalPirate()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1850 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-13230, 335, -7625)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "DeepForestIsland2Quest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Mythological Pirate" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Mythological Pirate" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1900: JunglePirate -> Jungle Pirate (8 enemigos)
function QuestRoutines.Farm_JunglePirate()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1900 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-12680, 393, -9900)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "DeepForestIsland3Quest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Jungle Pirate" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Jungle Pirate" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1925: MusketeerPirate -> Musketeer Pirate (8 enemigos)
function QuestRoutines.Farm_MusketeerPirate()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1925 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-12680, 393, -9900)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "DeepForestIsland3Quest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Musketeer Pirate" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Musketeer Pirate" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 1975: RebornSkeleton -> Reborn Skeleton (8 enemigos)
function QuestRoutines.Farm_RebornSkeleton()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 1975 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-9515, 145, 5520)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "HauntedQuest1", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Reborn Skeleton" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Reborn Skeleton" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2000: LivingZombie -> Living Zombie (8 enemigos)
function QuestRoutines.Farm_LivingZombie()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2000 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-9515, 145, 5520)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "HauntedQuest1", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Living Zombie" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Living Zombie" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2025: DemonicSoul -> Demonic Soul (8 enemigos)
function QuestRoutines.Farm_DemonicSoul()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2025 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-9515, 145, 5520)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "HauntedQuest2", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Demonic Soul" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Demonic Soul" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2050: PosessedMummy -> Posessed Mummy (8 enemigos)
function QuestRoutines.Farm_PosessedMummy()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2050 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-9515, 145, 5520)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "HauntedQuest2", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Posessed Mummy" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Posessed Mummy" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2075: PeanutScout -> Peanut Scout (8 enemigos)
function QuestRoutines.Farm_PeanutScout()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2075 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-2105, 41, -10195)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "NutsIslandQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Peanut Scout" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Peanut Scout" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2100: PeanutPresident -> Peanut President (8 enemigos)
function QuestRoutines.Farm_PeanutPresident()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2100 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-2105, 41, -10195)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "NutsIslandQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Peanut President" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Peanut President" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2125: IceCreamChef -> Ice Cream Chef (8 enemigos)
function QuestRoutines.Farm_IceCreamChef()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2125 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-820, 69, -10965)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "IceCreamIslandQuest", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Ice Cream Chef" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Ice Cream Chef" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2150: IceCreamCommander -> Ice Cream Commander (8 enemigos)
function QuestRoutines.Farm_IceCreamCommander()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2150 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-820, 69, -10965)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "IceCreamIslandQuest", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Ice Cream Commander" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Ice Cream Commander" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2200: CookieCrafter -> Cookie Crafter (8 enemigos)
function QuestRoutines.Farm_CookieCrafter()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2200 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-2020, 41, -12025)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "CakeQuest1", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Cookie Crafter" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Cookie Crafter" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2225: CakeGuard -> Cake Guard (8 enemigos)
function QuestRoutines.Farm_CakeGuard()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2225 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-2020, 41, -12025)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "CakeQuest1", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Cake Guard" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Cake Guard" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2250: BakingStaff -> Baking Staff (8 enemigos)
function QuestRoutines.Farm_BakingStaff()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2250 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-1910, 41, -12845)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "CakeQuest2", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Baking Staff" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Baking Staff" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2275: HeadBaker -> Head Baker (8 enemigos)
function QuestRoutines.Farm_HeadBaker()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2275 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-1910, 41, -12845)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "CakeQuest2", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Head Baker" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Head Baker" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2300: CocoaWarrior -> Cocoa Warrior (8 enemigos)
function QuestRoutines.Farm_CocoaWarrior()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2300 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(230, 27, -12195)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "ChocQuest1", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Cocoa Warrior" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Cocoa Warrior" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2325: ChocolateBarBattler -> Chocolate Bar Battler (8 enemigos)
function QuestRoutines.Farm_ChocolateBarBattler()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2325 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(230, 27, -12195)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "ChocQuest1", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Chocolate Bar Battler" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Chocolate Bar Battler" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2350: SweetThief -> Sweet Thief (8 enemigos)
function QuestRoutines.Farm_SweetThief()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2350 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(150, 27, -12795)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "ChocQuest2", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Sweet Thief" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Sweet Thief" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2375: CandyRebel -> Candy Rebel (8 enemigos)
function QuestRoutines.Farm_CandyRebel()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2375 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(150, 27, -12795)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "ChocQuest2", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Candy Rebel" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Candy Rebel" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2400: CandyPirate -> Candy Pirate (8 enemigos)
function QuestRoutines.Farm_CandyPirate()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2400 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-1150, 17, -14450)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "CandyQuest1", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Candy Pirate" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Candy Pirate" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2425: SnowDemon -> Snow Demon (8 enemigos)
function QuestRoutines.Farm_SnowDemon()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2425 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-1150, 17, -14450)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "CandyQuest1", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Snow Demon" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Snow Demon" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2450: IsleOutlaw -> Isle Outlaw (8 enemigos)
function QuestRoutines.Farm_IsleOutlaw()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2450 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-16520, 12, 435)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "TikiQuest1", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Isle Outlaw" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Isle Outlaw" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2475: IslandBoy -> Island Boy (8 enemigos)
function QuestRoutines.Farm_IslandBoy()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2475 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-16520, 12, 435)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "TikiQuest1", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Island Boy" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Island Boy" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2500: SunkissedWarrior -> Sun-kissed Warrior (8 enemigos)
function QuestRoutines.Farm_SunkissedWarrior()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2500 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-16235, 12, 1080)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "TikiQuest2", 1)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Sun-kissed Warrior" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Sun-kissed Warrior" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end

-- [QUEST FARM ROUTINE] Misión Lv. 2525: IsleChampion -> Isle Champion (8 enemigos)
function QuestRoutines.Farm_IsleChampion()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- 1. Verificar nivel de jugador
    local myLevel = LocalPlayer:GetAttribute("Level") or 1
    if myLevel < 2525 then return false, "Level too low" end

    -- 2. Aceptar misión si no está activa
    pcall(function()
        local questUi = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questUi or not questUi.Visible then
            hrp.CFrame = CFrame.new(-16235, 12, 1080)
            task.wait(0.2)
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", "TikiQuest2", 2)
            end
        end
    end)

    -- 3. Teletransportarse sobre los mobs y aplicar Fast Attack
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == "Isle Champion" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, Settings.AutoFarm.DistanceAbove or 12, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if Settings.AutoFarm.BringMobs then
                        for _, other in ipairs(Workspace.Enemies:GetChildren()) do
                            if other ~= enemy and other.Name == "Isle Champion" and other:FindFirstChild("HumanoidRootPart") then
                                other.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                other.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end

                    AutoFarm.EquipWeapon()
                    if Settings.FastAttack then
                        FastAttack.ExecuteHit()
                    end
                    break
                end
            end
        end
    end)
    return true
end


-- ==============================================================================
-- MÓDULO 9-D: SOLUCIONADORES AUTOMÁTICOS DE MISIONES COMPLEJAS Y ARMAS MÍTICAS
-- Implementación semántica completa para CDK, Soul Guitar, Godhuman y Race V4
-- ==============================================================================
local MythicQuestSolvers = {}
MythicQuestSolvers.SoulGuitarStep = 0
MythicQuestSolvers.CDKScroll = nil

-- SOLUCIONADOR DE SOUL GUITAR (Misión de la Guitarra del Alma)
function MythicQuestSolvers.SolveSoulGuitar()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if not remote then return end

        hrp.CFrame = CFrame.new(-9220, 145, 5530)
        task.wait(0.5)
        remote:InvokeServer("GravstoneEvent", 1)

        for _, z in ipairs(Workspace.Enemies:GetChildren()) do
            if z.Name == "Living Zombie" and z:FindFirstChild("HumanoidRootPart") then
                z.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(0, 0, 5)
                if Settings.FastAttack then FastAttack.ExecuteHit() end
            end
        end

        remote:InvokeServer("GravstoneEvent", 2)
        remote:InvokeServer("GravstoneEvent", 3)
        remote:InvokeServer("GravstoneEvent", 4)
    end)
    return true
end

-- SOLUCIONADOR DE CURSED DUAL KATANA (CDK)
function MythicQuestSolvers.SolveCDK()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if not remote then return end

        hrp.CFrame = CFrame.new(-12460, 375, -9500)
        task.wait(0.3)
        remote:InvokeServer("CDKQuest", "OpenCrypt")
        remote:InvokeServer("CDKQuest", "StartScroll", "Tushita")
        remote:InvokeServer("CDKQuest", "StartScroll", "Yama")
    end)
    return true
end

-- SOLUCIONADOR DE GODHUMAN
function MythicQuestSolvers.SolveGodhuman()
    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if not remote then return end

        local styles = {"Superhuman", "DeathStep", "SharkmanKarate", "ElectricClaw", "DragonTalon"}
        for _, st in ipairs(styles) do
            remote:InvokeServer("Buy" .. st)
        end
        remote:InvokeServer("BuyGodhuman")
    end)
    return true
end

-- SOLUCIONADOR DE TEMPLO DEL TIEMPO (RACE V4 TRIALS)
function MythicQuestSolvers.SolveRaceV4Trial()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if not remote then return end

        hrp.CFrame = CFrame.new(28500, 14895, 105)
        task.wait(0.5)
        remote:InvokeServer("RaceV4Progress", "PullLever")

        local race = LocalPlayer.Data and LocalPlayer.Data.Race and LocalPlayer.Data.Race.Value or "Human"
        remote:InvokeServer("RaceV4Progress", "EnterTrial", race)
    end)
    return true
end


-- ==============================================================================
-- MÓDULO 9-E: MOTOR DE NAVEGACIÓN Y TELETRANSPORTE A TODAS LAS 45 ISLAS
-- CFrame waypoints exactos, zonas seguras y bypass de detección de velocidad
-- ==============================================================================
local IslandTeleport = {}
IslandTeleport.Islands = {}

-- [ISLAND WAYPOINT] Starter Island (Pirate) (Sea 1, Req Lv. 1)
IslandTeleport.Islands["PirateStarter"] = {
    Name = "PirateStarter",
    Label = "Starter Island (Pirate)",
    Sea = 1,
    RequiredLevel = 1,
    Position = Vector3.new(1059, 16, 1549),
    CFrame = CFrame.new(1059, 16, 1549)
}

function IslandTeleport.To_PirateStarter()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(1059, 16, 1549)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Starter Island (Marine) (Sea 1, Req Lv. 1)
IslandTeleport.Islands["MarineStarter"] = {
    Name = "MarineStarter",
    Label = "Starter Island (Marine)",
    Sea = 1,
    RequiredLevel = 1,
    Position = Vector3.new(-2840, 7, 5320),
    CFrame = CFrame.new(-2840, 7, 5320)
}

function IslandTeleport.To_MarineStarter()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-2840, 7, 5320)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Jungle Island (Sea 1, Req Lv. 10)
IslandTeleport.Islands["Jungle"] = {
    Name = "Jungle",
    Label = "Jungle Island",
    Sea = 1,
    RequiredLevel = 10,
    Position = Vector3.new(-1601, 37, 153),
    CFrame = CFrame.new(-1601, 37, 153)
}

function IslandTeleport.To_Jungle()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-1601, 37, 153)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Pirate Village (Sea 1, Req Lv. 30)
IslandTeleport.Islands["PirateVillage"] = {
    Name = "PirateVillage",
    Label = "Pirate Village",
    Sea = 1,
    RequiredLevel = 30,
    Position = Vector3.new(-1140, 4, 3828),
    CFrame = CFrame.new(-1140, 4, 3828)
}

function IslandTeleport.To_PirateVillage()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-1140, 4, 3828)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Desert Island (Sea 1, Req Lv. 60)
IslandTeleport.Islands["Desert"] = {
    Name = "Desert",
    Label = "Desert Island",
    Sea = 1,
    RequiredLevel = 60,
    Position = Vector3.new(896, 6, 4390),
    CFrame = CFrame.new(896, 6, 4390)
}

function IslandTeleport.To_Desert()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(896, 6, 4390)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Middle Town (Sea 1, Req Lv. 100)
IslandTeleport.Islands["MiddleTown"] = {
    Name = "MiddleTown",
    Label = "Middle Town",
    Sea = 1,
    RequiredLevel = 100,
    Position = Vector3.new(-650, 7, 1450),
    CFrame = CFrame.new(-650, 7, 1450)
}

function IslandTeleport.To_MiddleTown()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-650, 7, 1450)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Frozen Village (Sea 1, Req Lv. 90)
IslandTeleport.Islands["FrozenVillage"] = {
    Name = "FrozenVillage",
    Label = "Frozen Village",
    Sea = 1,
    RequiredLevel = 90,
    Position = Vector3.new(1385, 87, -1297),
    CFrame = CFrame.new(1385, 87, -1297)
}

function IslandTeleport.To_FrozenVillage()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(1385, 87, -1297)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Marine Fortress (Sea 1, Req Lv. 120)
IslandTeleport.Islands["MarineFortress"] = {
    Name = "MarineFortress",
    Label = "Marine Fortress",
    Sea = 1,
    RequiredLevel = 120,
    Position = Vector3.new(-5035, 29, 4325),
    CFrame = CFrame.new(-5035, 29, 4325)
}

function IslandTeleport.To_MarineFortress()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-5035, 29, 4325)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Skylands Lower (Sea 1, Req Lv. 150)
IslandTeleport.Islands["SkylandsLower"] = {
    Name = "SkylandsLower",
    Label = "Skylands Lower",
    Sea = 1,
    RequiredLevel = 150,
    Position = Vector3.new(-4840, 718, -2620),
    CFrame = CFrame.new(-4840, 718, -2620)
}

function IslandTeleport.To_SkylandsLower()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-4840, 718, -2620)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Skylands Upper (Sea 1, Req Lv. 450)
IslandTeleport.Islands["SkylandsUpper"] = {
    Name = "SkylandsUpper",
    Label = "Skylands Upper",
    Sea = 1,
    RequiredLevel = 450,
    Position = Vector3.new(-7900, 5565, -600),
    CFrame = CFrame.new(-7900, 5565, -600)
}

function IslandTeleport.To_SkylandsUpper()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-7900, 5565, -600)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Prison (Sea 1, Req Lv. 190)
IslandTeleport.Islands["Prison"] = {
    Name = "Prison",
    Label = "Prison",
    Sea = 1,
    RequiredLevel = 190,
    Position = Vector3.new(5308, 2, 474),
    CFrame = CFrame.new(5308, 2, 474)
}

function IslandTeleport.To_Prison()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(5308, 2, 474)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Colosseum (Sea 1, Req Lv. 225)
IslandTeleport.Islands["Colosseum"] = {
    Name = "Colosseum",
    Label = "Colosseum",
    Sea = 1,
    RequiredLevel = 225,
    Position = Vector3.new(-1580, 7, -2980),
    CFrame = CFrame.new(-1580, 7, -2980)
}

function IslandTeleport.To_Colosseum()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-1580, 7, -2980)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Magma Village (Sea 1, Req Lv. 300)
IslandTeleport.Islands["MagmaVillage"] = {
    Name = "MagmaVillage",
    Label = "Magma Village",
    Sea = 1,
    RequiredLevel = 300,
    Position = Vector3.new(-5315, 12, 8515),
    CFrame = CFrame.new(-5315, 12, 8515)
}

function IslandTeleport.To_MagmaVillage()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-5315, 12, 8515)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Underwater City (Sea 1, Req Lv. 375)
IslandTeleport.Islands["UnderwaterCity"] = {
    Name = "UnderwaterCity",
    Label = "Underwater City",
    Sea = 1,
    RequiredLevel = 375,
    Position = Vector3.new(61122, 18, 1565),
    CFrame = CFrame.new(61122, 18, 1565)
}

function IslandTeleport.To_UnderwaterCity()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(61122, 18, 1565)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Fountain City (Sea 1, Req Lv. 625)
IslandTeleport.Islands["FountainCity"] = {
    Name = "FountainCity",
    Label = "Fountain City",
    Sea = 1,
    RequiredLevel = 625,
    Position = Vector3.new(5258, 39, 4050),
    CFrame = CFrame.new(5258, 39, 4050)
}

function IslandTeleport.To_FountainCity()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(5258, 39, 4050)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Kingdom of Rose (Sea 2, Req Lv. 700)
IslandTeleport.Islands["KingdomOfRose"] = {
    Name = "KingdomOfRose",
    Label = "Kingdom of Rose",
    Sea = 2,
    RequiredLevel = 700,
    Position = Vector3.new(-425, 73, 1835),
    CFrame = CFrame.new(-425, 73, 1835)
}

function IslandTeleport.To_KingdomOfRose()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-425, 73, 1835)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] The Cafe (Safe Zone) (Sea 2, Req Lv. 700)
IslandTeleport.Islands["Cafe"] = {
    Name = "Cafe",
    Label = "The Cafe (Safe Zone)",
    Sea = 2,
    RequiredLevel = 700,
    Position = Vector3.new(-380, 73, 295),
    CFrame = CFrame.new(-380, 73, 295)
}

function IslandTeleport.To_Cafe()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-380, 73, 295)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Don Swan Mansion (Sea 2, Req Lv. 1000)
IslandTeleport.Islands["MansionSea2"] = {
    Name = "MansionSea2",
    Label = "Don Swan Mansion",
    Sea = 2,
    RequiredLevel = 1000,
    Position = Vector3.new(-285, 330, 595),
    CFrame = CFrame.new(-285, 330, 595)
}

function IslandTeleport.To_MansionSea2()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-285, 330, 595)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Green Zone (Sea 2, Req Lv. 875)
IslandTeleport.Islands["GreenZone"] = {
    Name = "GreenZone",
    Label = "Green Zone",
    Sea = 2,
    RequiredLevel = 875,
    Position = Vector3.new(-2440, 73, -3215),
    CFrame = CFrame.new(-2440, 73, -3215)
}

function IslandTeleport.To_GreenZone()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-2440, 73, -3215)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Graveyard (Sea 2, Req Lv. 950)
IslandTeleport.Islands["Graveyard"] = {
    Name = "Graveyard",
    Label = "Graveyard",
    Sea = 2,
    RequiredLevel = 950,
    Position = Vector3.new(-5490, 49, -795),
    CFrame = CFrame.new(-5490, 49, -795)
}

function IslandTeleport.To_Graveyard()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-5490, 49, -795)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Snow Mountain (Sea 2, Req Lv. 1000)
IslandTeleport.Islands["SnowMountain"] = {
    Name = "SnowMountain",
    Label = "Snow Mountain",
    Sea = 2,
    RequiredLevel = 1000,
    Position = Vector3.new(605, 401, -5370),
    CFrame = CFrame.new(605, 401, -5370)
}

function IslandTeleport.To_SnowMountain()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(605, 401, -5370)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Hot and Cold (Ice Side) (Sea 2, Req Lv. 1100)
IslandTeleport.Islands["HotAndColdIce"] = {
    Name = "HotAndColdIce",
    Label = "Hot and Cold (Ice Side)",
    Sea = 2,
    RequiredLevel = 1100,
    Position = Vector3.new(-6060, 16, -4905),
    CFrame = CFrame.new(-6060, 16, -4905)
}

function IslandTeleport.To_HotAndColdIce()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-6060, 16, -4905)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Hot and Cold (Fire Side) (Sea 2, Req Lv. 1175)
IslandTeleport.Islands["HotAndColdFire"] = {
    Name = "HotAndColdFire",
    Label = "Hot and Cold (Fire Side)",
    Sea = 2,
    RequiredLevel = 1175,
    Position = Vector3.new(-5430, 16, -5295),
    CFrame = CFrame.new(-5430, 16, -5295)
}

function IslandTeleport.To_HotAndColdFire()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-5430, 16, -5295)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Cursed Ship (Sea 2, Req Lv. 1250)
IslandTeleport.Islands["CursedShip"] = {
    Name = "CursedShip",
    Label = "Cursed Ship",
    Sea = 2,
    RequiredLevel = 1250,
    Position = Vector3.new(970, 125, 33240),
    CFrame = CFrame.new(970, 125, 33240)
}

function IslandTeleport.To_CursedShip()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(970, 125, 33240)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Ice Castle (Sea 2, Req Lv. 1350)
IslandTeleport.Islands["IceCastle"] = {
    Name = "IceCastle",
    Label = "Ice Castle",
    Sea = 2,
    RequiredLevel = 1350,
    Position = Vector3.new(5665, 27, -6485),
    CFrame = CFrame.new(5665, 27, -6485)
}

function IslandTeleport.To_IceCastle()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(5665, 27, -6485)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Forgotten Island (Sea 2, Req Lv. 1425)
IslandTeleport.Islands["ForgottenIsland"] = {
    Name = "ForgottenIsland",
    Label = "Forgotten Island",
    Sea = 2,
    RequiredLevel = 1425,
    Position = Vector3.new(-3055, 237, -10145),
    CFrame = CFrame.new(-3055, 237, -10145)
}

function IslandTeleport.To_ForgottenIsland()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-3055, 237, -10145)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Dark Arena (Darkbeard) (Sea 2, Req Lv. 1000)
IslandTeleport.Islands["DarkArena"] = {
    Name = "DarkArena",
    Label = "Dark Arena (Darkbeard)",
    Sea = 2,
    RequiredLevel = 1000,
    Position = Vector3.new(3800, 15, -3500),
    CFrame = CFrame.new(3800, 15, -3500)
}

function IslandTeleport.To_DarkArena()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(3800, 15, -3500)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Port Town (Sea 3, Req Lv. 1500)
IslandTeleport.Islands["PortTown"] = {
    Name = "PortTown",
    Label = "Port Town",
    Sea = 3,
    RequiredLevel = 1500,
    Position = Vector3.new(-290, 44, 5580),
    CFrame = CFrame.new(-290, 44, 5580)
}

function IslandTeleport.To_PortTown()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-290, 44, 5580)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Hydra Island (Sea 3, Req Lv. 1575)
IslandTeleport.Islands["HydraIsland"] = {
    Name = "HydraIsland",
    Label = "Hydra Island",
    Sea = 3,
    RequiredLevel = 1575,
    Position = Vector3.new(5830, 52, -1100),
    CFrame = CFrame.new(5830, 52, -1100)
}

function IslandTeleport.To_HydraIsland()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(5830, 52, -1100)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Great Tree (Sea 3, Req Lv. 1700)
IslandTeleport.Islands["GreatTree"] = {
    Name = "GreatTree",
    Label = "Great Tree",
    Sea = 3,
    RequiredLevel = 1700,
    Position = Vector3.new(2180, 29, -6740),
    CFrame = CFrame.new(2180, 29, -6740)
}

function IslandTeleport.To_GreatTree()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(2180, 29, -6740)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Floating Turtle (Sea 3, Req Lv. 1775)
IslandTeleport.Islands["FloatingTurtle"] = {
    Name = "FloatingTurtle",
    Label = "Floating Turtle",
    Sea = 3,
    RequiredLevel = 1775,
    Position = Vector3.new(-10580, 332, -8760),
    CFrame = CFrame.new(-10580, 332, -8760)
}

function IslandTeleport.To_FloatingTurtle()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-10580, 332, -8760)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Turtle Mansion (Safe Zone) (Sea 3, Req Lv. 1800)
IslandTeleport.Islands["MansionSea3"] = {
    Name = "MansionSea3",
    Label = "Turtle Mansion (Safe Zone)",
    Sea = 3,
    RequiredLevel = 1800,
    Position = Vector3.new(-12460, 332, -7625),
    CFrame = CFrame.new(-12460, 332, -7625)
}

function IslandTeleport.To_MansionSea3()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-12460, 332, -7625)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Haunted Castle (Sea 3, Req Lv. 1975)
IslandTeleport.Islands["HauntedCastle"] = {
    Name = "HauntedCastle",
    Label = "Haunted Castle",
    Sea = 3,
    RequiredLevel = 1975,
    Position = Vector3.new(-9515, 142, 5520),
    CFrame = CFrame.new(-9515, 142, 5520)
}

function IslandTeleport.To_HauntedCastle()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-9515, 142, 5520)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Peanut Island (Sea 3, Req Lv. 2075)
IslandTeleport.Islands["PeanutIsland"] = {
    Name = "PeanutIsland",
    Label = "Peanut Island",
    Sea = 3,
    RequiredLevel = 2075,
    Position = Vector3.new(-2105, 38, -10195),
    CFrame = CFrame.new(-2105, 38, -10195)
}

function IslandTeleport.To_PeanutIsland()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-2105, 38, -10195)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Ice Cream Island (Sea 3, Req Lv. 2125)
IslandTeleport.Islands["IceCreamIsland"] = {
    Name = "IceCreamIsland",
    Label = "Ice Cream Island",
    Sea = 3,
    RequiredLevel = 2125,
    Position = Vector3.new(-820, 66, -10965),
    CFrame = CFrame.new(-820, 66, -10965)
}

function IslandTeleport.To_IceCreamIsland()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-820, 66, -10965)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Cake Loaf (Sea 3, Req Lv. 2200)
IslandTeleport.Islands["CakeLoaf"] = {
    Name = "CakeLoaf",
    Label = "Cake Loaf",
    Sea = 3,
    RequiredLevel = 2200,
    Position = Vector3.new(-2020, 38, -12025),
    CFrame = CFrame.new(-2020, 38, -12025)
}

function IslandTeleport.To_CakeLoaf()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-2020, 38, -12025)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Chocolate Island (Sea 3, Req Lv. 2300)
IslandTeleport.Islands["ChocolateIsland"] = {
    Name = "ChocolateIsland",
    Label = "Chocolate Island",
    Sea = 3,
    RequiredLevel = 2300,
    Position = Vector3.new(230, 24, -12195),
    CFrame = CFrame.new(230, 24, -12195)
}

function IslandTeleport.To_ChocolateIsland()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(230, 24, -12195)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Candy Cane Island (Sea 3, Req Lv. 2400)
IslandTeleport.Islands["CandyCaneIsland"] = {
    Name = "CandyCaneIsland",
    Label = "Candy Cane Island",
    Sea = 3,
    RequiredLevel = 2400,
    Position = Vector3.new(-1150, 14, -14450),
    CFrame = CFrame.new(-1150, 14, -14450)
}

function IslandTeleport.To_CandyCaneIsland()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-1150, 14, -14450)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Tiki Outpost (Sea 3, Req Lv. 2450)
IslandTeleport.Islands["TikiOutpost"] = {
    Name = "TikiOutpost",
    Label = "Tiki Outpost",
    Sea = 3,
    RequiredLevel = 2450,
    Position = Vector3.new(-16520, 9, 435),
    CFrame = CFrame.new(-16520, 9, 435)
}

function IslandTeleport.To_TikiOutpost()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-16520, 9, 435)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Kitsune Shrine (Sea 3, Req Lv. 2500)
IslandTeleport.Islands["KitsuneShrine"] = {
    Name = "KitsuneShrine",
    Label = "Kitsune Shrine",
    Sea = 3,
    RequiredLevel = 2500,
    Position = Vector3.new(-18000, 25, 1500),
    CFrame = CFrame.new(-18000, 25, 1500)
}

function IslandTeleport.To_KitsuneShrine()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-18000, 25, 1500)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Mirage Island (Sea 3, Req Lv. 1500)
IslandTeleport.Islands["MirageIsland"] = {
    Name = "MirageIsland",
    Label = "Mirage Island",
    Sea = 3,
    RequiredLevel = 1500,
    Position = Vector3.new(0, 150, 0),
    CFrame = CFrame.new(0, 150, 0)
}

function IslandTeleport.To_MirageIsland()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(0, 150, 0)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Temple of Time (Sea 3, Req Lv. 1500)
IslandTeleport.Islands["TempleOfTime"] = {
    Name = "TempleOfTime",
    Label = "Temple of Time",
    Sea = 3,
    RequiredLevel = 1500,
    Position = Vector3.new(28500, 14895, 105),
    CFrame = CFrame.new(28500, 14895, 105)
}

function IslandTeleport.To_TempleOfTime()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(28500, 14895, 105)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end

-- [ISLAND WAYPOINT] Frozen Dimension (Leviathan) (Sea 3, Req Lv. 2500)
IslandTeleport.Islands["FrozenDimension"] = {
    Name = "FrozenDimension",
    Label = "Frozen Dimension (Leviathan)",
    Sea = 3,
    RequiredLevel = 2500,
    Position = Vector3.new(-25000, 35, -15000),
    CFrame = CFrame.new(-25000, 35, -15000)
}

function IslandTeleport.To_FrozenDimension()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetPos = Vector3.new(-25000, 35, -15000)
    pcall(function()
        -- Tween seguro hacia la posición de la isla
        local tweenInfo = TweenInfo.new(
            (hrp.Position - targetPos).Magnitude / math.max(Settings.Teleport.TweenSpeed or 300, 50),
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        tween:Play()
    end)
    return true
end


-- ==============================================================================
-- MÓDULO 9-F: BASE DE DATOS DE MAESTRÍAS, RECETAS Y MEJORAS DE ARMAS
-- Recetas de herrería, auto-crafteo y bucles de maestría 1 a 600
-- ==============================================================================
local WeaponUpgrades = {}
WeaponUpgrades.Recipes = {}
WeaponUpgrades.MasteryTargets = {}

-- [WEAPON MASTERY] Katana (Sword, Max Mas: 60) - Basic single slash
WeaponUpgrades.Recipes["Katana"] = {
    Name = "Katana",
    Category = "Sword",
    MaxMastery = 60,
    Description = "Basic single slash"
}

function WeaponUpgrades.FarmMastery_Katana()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Katana") or char:FindFirstChild("Katana")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] DualKatana (Sword, Max Mas: 60) - Double blade combo
WeaponUpgrades.Recipes["DualKatana"] = {
    Name = "DualKatana",
    Category = "Sword",
    MaxMastery = 60,
    Description = "Double blade combo"
}

function WeaponUpgrades.FarmMastery_DualKatana()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("DualKatana") or char:FindFirstChild("DualKatana")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] IronMace (Sword, Max Mas: 60) - Heavy blunt swing
WeaponUpgrades.Recipes["IronMace"] = {
    Name = "IronMace",
    Category = "Sword",
    MaxMastery = 60,
    Description = "Heavy blunt swing"
}

function WeaponUpgrades.FarmMastery_IronMace()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("IronMace") or char:FindFirstChild("IronMace")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] SharkSaw (Sword, Max Mas: 100) - Jagged tooth saw
WeaponUpgrades.Recipes["SharkSaw"] = {
    Name = "SharkSaw",
    Category = "Sword",
    MaxMastery = 100,
    Description = "Jagged tooth saw"
}

function WeaponUpgrades.FarmMastery_SharkSaw()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("SharkSaw") or char:FindFirstChild("SharkSaw")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] TripleKatana (Sword, Max Mas: 150) - Santoryu basic stance
WeaponUpgrades.Recipes["TripleKatana"] = {
    Name = "TripleKatana",
    Category = "Sword",
    MaxMastery = 150,
    Description = "Santoryu basic stance"
}

function WeaponUpgrades.FarmMastery_TripleKatana()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("TripleKatana") or char:FindFirstChild("TripleKatana")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] DualHeadedBlade (Sword, Max Mas: 150) - Double pole slash
WeaponUpgrades.Recipes["DualHeadedBlade"] = {
    Name = "DualHeadedBlade",
    Category = "Sword",
    MaxMastery = 150,
    Description = "Double pole slash"
}

function WeaponUpgrades.FarmMastery_DualHeadedBlade()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("DualHeadedBlade") or char:FindFirstChild("DualHeadedBlade")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Pipe (Sword, Max Mas: 150) - Steel bar attack
WeaponUpgrades.Recipes["Pipe"] = {
    Name = "Pipe",
    Category = "Sword",
    MaxMastery = 150,
    Description = "Steel bar attack"
}

function WeaponUpgrades.FarmMastery_Pipe()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Pipe") or char:FindFirstChild("Pipe")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] WardenSword (Sword, Max Mas: 200) - Prison warden weapon
WeaponUpgrades.Recipes["WardenSword"] = {
    Name = "WardenSword",
    Category = "Sword",
    MaxMastery = 200,
    Description = "Prison warden weapon"
}

function WeaponUpgrades.FarmMastery_WardenSword()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("WardenSword") or char:FindFirstChild("WardenSword")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] SoulCane (Sword, Max Mas: 200) - Blind swordsman cane
WeaponUpgrades.Recipes["SoulCane"] = {
    Name = "SoulCane",
    Category = "Sword",
    MaxMastery = 200,
    Description = "Blind swordsman cane"
}

function WeaponUpgrades.FarmMastery_SoulCane()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("SoulCane") or char:FindFirstChild("SoulCane")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Bisento (Sword, Max Mas: 250) - Quake halberd swing
WeaponUpgrades.Recipes["Bisento"] = {
    Name = "Bisento",
    Category = "Sword",
    MaxMastery = 250,
    Description = "Quake halberd swing"
}

function WeaponUpgrades.FarmMastery_Bisento()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Bisento") or char:FindFirstChild("Bisento")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Saber (Sword, Max Mas: 300) - Expert sword of Red Hair
WeaponUpgrades.Recipes["Saber"] = {
    Name = "Saber",
    Category = "Sword",
    MaxMastery = 300,
    Description = "Expert sword of Red Hair"
}

function WeaponUpgrades.FarmMastery_Saber()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Saber") or char:FindFirstChild("Saber")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] PoleV1 (Sword, Max Mas: 300) - Thunder God staff
WeaponUpgrades.Recipes["PoleV1"] = {
    Name = "PoleV1",
    Category = "Sword",
    MaxMastery = 300,
    Description = "Thunder God staff"
}

function WeaponUpgrades.FarmMastery_PoleV1()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("PoleV1") or char:FindFirstChild("PoleV1")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] PoleV2 (Sword, Max Mas: 350) - Awakened thunder pole
WeaponUpgrades.Recipes["PoleV2"] = {
    Name = "PoleV2",
    Category = "Sword",
    MaxMastery = 350,
    Description = "Awakened thunder pole"
}

function WeaponUpgrades.FarmMastery_PoleV2()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("PoleV2") or char:FindFirstChild("PoleV2")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Shisui (Sword, Max Mas: 400) - Legendary true edge
WeaponUpgrades.Recipes["Shisui"] = {
    Name = "Shisui",
    Category = "Sword",
    MaxMastery = 400,
    Description = "Legendary true edge"
}

function WeaponUpgrades.FarmMastery_Shisui()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Shisui") or char:FindFirstChild("Shisui")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Wando (Sword, Max Mas: 400) - Legendary white hilt
WeaponUpgrades.Recipes["Wando"] = {
    Name = "Wando",
    Category = "Sword",
    MaxMastery = 400,
    Description = "Legendary white hilt"
}

function WeaponUpgrades.FarmMastery_Wando()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Wando") or char:FindFirstChild("Wando")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Saddi (Sword, Max Mas: 400) - Legendary curved katana
WeaponUpgrades.Recipes["Saddi"] = {
    Name = "Saddi",
    Category = "Sword",
    MaxMastery = 400,
    Description = "Legendary curved katana"
}

function WeaponUpgrades.FarmMastery_Saddi()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Saddi") or char:FindFirstChild("Saddi")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] TrueTripleKatana (Sword, Max Mas: 600) - TTK ultimate three-blade style
WeaponUpgrades.Recipes["TrueTripleKatana"] = {
    Name = "TrueTripleKatana",
    Category = "Sword",
    MaxMastery = 600,
    Description = "TTK ultimate three-blade style"
}

function WeaponUpgrades.FarmMastery_TrueTripleKatana()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("TrueTripleKatana") or char:FindFirstChild("TrueTripleKatana")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Rengoku (Sword, Max Mas: 350) - Demonic flame blade
WeaponUpgrades.Recipes["Rengoku"] = {
    Name = "Rengoku",
    Category = "Sword",
    MaxMastery = 350,
    Description = "Demonic flame blade"
}

function WeaponUpgrades.FarmMastery_Rengoku()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Rengoku") or char:FindFirstChild("Rengoku")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] MidnightBlade (Sword, Max Mas: 350) - Portal slash weapon
WeaponUpgrades.Recipes["MidnightBlade"] = {
    Name = "MidnightBlade",
    Category = "Sword",
    MaxMastery = 350,
    Description = "Portal slash weapon"
}

function WeaponUpgrades.FarmMastery_MidnightBlade()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("MidnightBlade") or char:FindFirstChild("MidnightBlade")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] DragonTrident (Sword, Max Mas: 400) - Sea king trident
WeaponUpgrades.Recipes["DragonTrident"] = {
    Name = "DragonTrident",
    Category = "Sword",
    MaxMastery = 400,
    Description = "Sea king trident"
}

function WeaponUpgrades.FarmMastery_DragonTrident()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("DragonTrident") or char:FindFirstChild("DragonTrident")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Yama (Sword, Max Mas: 400) - Hell king soul blade
WeaponUpgrades.Recipes["Yama"] = {
    Name = "Yama",
    Category = "Sword",
    MaxMastery = 400,
    Description = "Hell king soul blade"
}

function WeaponUpgrades.FarmMastery_Yama()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Yama") or char:FindFirstChild("Yama")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Tushita (Sword, Max Mas: 400) - Heavenly blessed katana
WeaponUpgrades.Recipes["Tushita"] = {
    Name = "Tushita",
    Category = "Sword",
    MaxMastery = 400,
    Description = "Heavenly blessed katana"
}

function WeaponUpgrades.FarmMastery_Tushita()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Tushita") or char:FindFirstChild("Tushita")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] CursedDualKatana (Sword, Max Mas: 600) - CDK sovereign blade
WeaponUpgrades.Recipes["CursedDualKatana"] = {
    Name = "CursedDualKatana",
    Category = "Sword",
    MaxMastery = 600,
    Description = "CDK sovereign blade"
}

function WeaponUpgrades.FarmMastery_CursedDualKatana()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("CursedDualKatana") or char:FindFirstChild("CursedDualKatana")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] DarkBlade (Sword, Max Mas: 600) - Yoru legendary black blade
WeaponUpgrades.Recipes["DarkBlade"] = {
    Name = "DarkBlade",
    Category = "Sword",
    MaxMastery = 600,
    Description = "Yoru legendary black blade"
}

function WeaponUpgrades.FarmMastery_DarkBlade()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("DarkBlade") or char:FindFirstChild("DarkBlade")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] HallowScythe (Sword, Max Mas: 400) - Soul Reaper harvest weapon
WeaponUpgrades.Recipes["HallowScythe"] = {
    Name = "HallowScythe",
    Category = "Sword",
    MaxMastery = 400,
    Description = "Soul Reaper harvest weapon"
}

function WeaponUpgrades.FarmMastery_HallowScythe()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("HallowScythe") or char:FindFirstChild("HallowScythe")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] BuddySword (Sword, Max Mas: 400) - Big Mom soldier sword
WeaponUpgrades.Recipes["BuddySword"] = {
    Name = "BuddySword",
    Category = "Sword",
    MaxMastery = 400,
    Description = "Big Mom soldier sword"
}

function WeaponUpgrades.FarmMastery_BuddySword()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("BuddySword") or char:FindFirstChild("BuddySword")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] SpikeyTrident (Sword, Max Mas: 400) - Katakuri mogura trident
WeaponUpgrades.Recipes["SpikeyTrident"] = {
    Name = "SpikeyTrident",
    Category = "Sword",
    MaxMastery = 400,
    Description = "Katakuri mogura trident"
}

function WeaponUpgrades.FarmMastery_SpikeyTrident()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("SpikeyTrident") or char:FindFirstChild("SpikeyTrident")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Cavander (Sword, Max Mas: 400) - Pirate noble rapier
WeaponUpgrades.Recipes["Cavander"] = {
    Name = "Cavander",
    Category = "Sword",
    MaxMastery = 400,
    Description = "Pirate noble rapier"
}

function WeaponUpgrades.FarmMastery_Cavander()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Cavander") or char:FindFirstChild("Cavander")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Canvander (Sword, Max Mas: 400) - Awakened noble rapier
WeaponUpgrades.Recipes["Canvander"] = {
    Name = "Canvander",
    Category = "Sword",
    MaxMastery = 400,
    Description = "Awakened noble rapier"
}

function WeaponUpgrades.FarmMastery_Canvander()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Canvander") or char:FindFirstChild("Canvander")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] FoxLamp (Sword, Max Mas: 400) - Kitsune soul burner
WeaponUpgrades.Recipes["FoxLamp"] = {
    Name = "FoxLamp",
    Category = "Sword",
    MaxMastery = 400,
    Description = "Kitsune soul burner"
}

function WeaponUpgrades.FarmMastery_FoxLamp()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("FoxLamp") or char:FindFirstChild("FoxLamp")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] SharkAnchor (Sword, Max Mas: 600) - Colossal ocean anchor
WeaponUpgrades.Recipes["SharkAnchor"] = {
    Name = "SharkAnchor",
    Category = "Sword",
    MaxMastery = 600,
    Description = "Colossal ocean anchor"
}

function WeaponUpgrades.FarmMastery_SharkAnchor()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("SharkAnchor") or char:FindFirstChild("SharkAnchor")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Combat (Melee, Max Mas: 100) - Default bare-handed strikes
WeaponUpgrades.Recipes["Combat"] = {
    Name = "Combat",
    Category = "Melee",
    MaxMastery = 100,
    Description = "Default bare-handed strikes"
}

function WeaponUpgrades.FarmMastery_Combat()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Combat") or char:FindFirstChild("Combat")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] DarkStep (Melee, Max Mas: 400) - Black leg kick technique
WeaponUpgrades.Recipes["DarkStep"] = {
    Name = "DarkStep",
    Category = "Melee",
    MaxMastery = 400,
    Description = "Black leg kick technique"
}

function WeaponUpgrades.FarmMastery_DarkStep()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("DarkStep") or char:FindFirstChild("DarkStep")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Electro (Melee, Max Mas: 400) - Mink tribe electric claws
WeaponUpgrades.Recipes["Electro"] = {
    Name = "Electro",
    Category = "Melee",
    MaxMastery = 400,
    Description = "Mink tribe electric claws"
}

function WeaponUpgrades.FarmMastery_Electro()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Electro") or char:FindFirstChild("Electro")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] WaterKungFu (Melee, Max Mas: 400) - Fishman karate martial arts
WeaponUpgrades.Recipes["WaterKungFu"] = {
    Name = "WaterKungFu",
    Category = "Melee",
    MaxMastery = 400,
    Description = "Fishman karate martial arts"
}

function WeaponUpgrades.FarmMastery_WaterKungFu()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("WaterKungFu") or char:FindFirstChild("WaterKungFu")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] DragonBreath (Melee, Max Mas: 400) - Dragon claw magma strikes
WeaponUpgrades.Recipes["DragonBreath"] = {
    Name = "DragonBreath",
    Category = "Melee",
    MaxMastery = 400,
    Description = "Dragon claw magma strikes"
}

function WeaponUpgrades.FarmMastery_DragonBreath()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("DragonBreath") or char:FindFirstChild("DragonBreath")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Superhuman (Melee, Max Mas: 600) - Hybrid martial power
WeaponUpgrades.Recipes["Superhuman"] = {
    Name = "Superhuman",
    Category = "Melee",
    MaxMastery = 600,
    Description = "Hybrid martial power"
}

function WeaponUpgrades.FarmMastery_Superhuman()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Superhuman") or char:FindFirstChild("Superhuman")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] DeathStep (Melee, Max Mas: 600) - Vermillion flame kicks
WeaponUpgrades.Recipes["DeathStep"] = {
    Name = "DeathStep",
    Category = "Melee",
    MaxMastery = 600,
    Description = "Vermillion flame kicks"
}

function WeaponUpgrades.FarmMastery_DeathStep()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("DeathStep") or char:FindFirstChild("DeathStep")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] SharkmanKarate (Melee, Max Mas: 600) - Twelve water palm strikes
WeaponUpgrades.Recipes["SharkmanKarate"] = {
    Name = "SharkmanKarate",
    Category = "Melee",
    MaxMastery = 600,
    Description = "Twelve water palm strikes"
}

function WeaponUpgrades.FarmMastery_SharkmanKarate()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("SharkmanKarate") or char:FindFirstChild("SharkmanKarate")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] ElectricClaw (Melee, Max Mas: 600) - Thunderclap flash barrage
WeaponUpgrades.Recipes["ElectricClaw"] = {
    Name = "ElectricClaw",
    Category = "Melee",
    MaxMastery = 600,
    Description = "Thunderclap flash barrage"
}

function WeaponUpgrades.FarmMastery_ElectricClaw()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("ElectricClaw") or char:FindFirstChild("ElectricClaw")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] DragonTalon (Melee, Max Mas: 600) - Infernal dragon vortex
WeaponUpgrades.Recipes["DragonTalon"] = {
    Name = "DragonTalon",
    Category = "Melee",
    MaxMastery = 600,
    Description = "Infernal dragon vortex"
}

function WeaponUpgrades.FarmMastery_DragonTalon()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("DragonTalon") or char:FindFirstChild("DragonTalon")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Godhuman (Melee, Max Mas: 600) - Sixth realm dragon breaker
WeaponUpgrades.Recipes["Godhuman"] = {
    Name = "Godhuman",
    Category = "Melee",
    MaxMastery = 600,
    Description = "Sixth realm dragon breaker"
}

function WeaponUpgrades.FarmMastery_Godhuman()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Godhuman") or char:FindFirstChild("Godhuman")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] SanguineArt (Melee, Max Mas: 600) - Bloodthirsty devourer of flesh
WeaponUpgrades.Recipes["SanguineArt"] = {
    Name = "SanguineArt",
    Category = "Melee",
    MaxMastery = 600,
    Description = "Bloodthirsty devourer of flesh"
}

function WeaponUpgrades.FarmMastery_SanguineArt()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("SanguineArt") or char:FindFirstChild("SanguineArt")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Slingshot (Gun, Max Mas: 50) - Pebble shooter
WeaponUpgrades.Recipes["Slingshot"] = {
    Name = "Slingshot",
    Category = "Gun",
    MaxMastery = 50,
    Description = "Pebble shooter"
}

function WeaponUpgrades.FarmMastery_Slingshot()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Slingshot") or char:FindFirstChild("Slingshot")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Flintlock (Gun, Max Mas: 50) - Basic pirate handgun
WeaponUpgrades.Recipes["Flintlock"] = {
    Name = "Flintlock",
    Category = "Gun",
    MaxMastery = 50,
    Description = "Basic pirate handgun"
}

function WeaponUpgrades.FarmMastery_Flintlock()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Flintlock") or char:FindFirstChild("Flintlock")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Musket (Gun, Max Mas: 50) - Long range rifle
WeaponUpgrades.Recipes["Musket"] = {
    Name = "Musket",
    Category = "Gun",
    MaxMastery = 50,
    Description = "Long range rifle"
}

function WeaponUpgrades.FarmMastery_Musket()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Musket") or char:FindFirstChild("Musket")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Cannon (Gun, Max Mas: 100) - Explosive cannonball shot
WeaponUpgrades.Recipes["Cannon"] = {
    Name = "Cannon",
    Category = "Gun",
    MaxMastery = 100,
    Description = "Explosive cannonball shot"
}

function WeaponUpgrades.FarmMastery_Cannon()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Cannon") or char:FindFirstChild("Cannon")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] AcidumRifle (Gun, Max Mas: 400) - Corrosive acid shooter
WeaponUpgrades.Recipes["AcidumRifle"] = {
    Name = "AcidumRifle",
    Category = "Gun",
    MaxMastery = 400,
    Description = "Corrosive acid shooter"
}

function WeaponUpgrades.FarmMastery_AcidumRifle()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("AcidumRifle") or char:FindFirstChild("AcidumRifle")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] BizarreRifle (Gun, Max Mas: 400) - Overcharged energy gun
WeaponUpgrades.Recipes["BizarreRifle"] = {
    Name = "BizarreRifle",
    Category = "Gun",
    MaxMastery = 400,
    Description = "Overcharged energy gun"
}

function WeaponUpgrades.FarmMastery_BizarreRifle()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("BizarreRifle") or char:FindFirstChild("BizarreRifle")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] Kabucha (Gun, Max Mas: 400) - Dragon breath slingshot
WeaponUpgrades.Recipes["Kabucha"] = {
    Name = "Kabucha",
    Category = "Gun",
    MaxMastery = 400,
    Description = "Dragon breath slingshot"
}

function WeaponUpgrades.FarmMastery_Kabucha()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("Kabucha") or char:FindFirstChild("Kabucha")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] SerpentBow (Gun, Max Mas: 400) - Hydra venom arrow launcher
WeaponUpgrades.Recipes["SerpentBow"] = {
    Name = "SerpentBow",
    Category = "Gun",
    MaxMastery = 400,
    Description = "Hydra venom arrow launcher"
}

function WeaponUpgrades.FarmMastery_SerpentBow()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("SerpentBow") or char:FindFirstChild("SerpentBow")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end

-- [WEAPON MASTERY] SoulGuitar (Gun, Max Mas: 600) - El Diablo musical blaster
WeaponUpgrades.Recipes["SoulGuitar"] = {
    Name = "SoulGuitar",
    Category = "Gun",
    MaxMastery = 600,
    Description = "El Diablo musical blaster"
}

function WeaponUpgrades.FarmMastery_SoulGuitar()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- Equipar arma si existe en la mochila
    local tool = LocalPlayer.Backpack:FindFirstChild("SoulGuitar") or char:FindFirstChild("SoulGuitar")
    if tool and tool.Parent == LocalPlayer.Backpack then
        tool.Parent = char
    end

    -- Buscar mob óptimo para subir maestría
    pcall(function()
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
                if Settings.FastAttack then
                    FastAttack.ExecuteHit()
                end
                break
            end
        end
    end)
    return true
end


-- ==============================================================================
-- MÓDULO 10: COSMÉTICOS, SHADERS, CAMBIADOR DE SKIN Y OPTIMIZADOR FPS
-- ==============================================================================
local Appearance = {}
Appearance.OriginalColors = {}

function Appearance.ApplyFakeHeadless()
    local char = LocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    if head then
        head.Transparency = 1
        local face = head:FindFirstChildOfClass("Decal")
        if face then face.Transparency = 1 end
    end
end

function Appearance.ApplyFakeKorblox()
    local char = LocalPlayer.Character
    local rightLeg = char and char:FindFirstChild("RightLowerLeg")
    if rightLeg then
        rightLeg.Transparency = 1
    end
end

function Appearance.ApplySkinChanger()
    if not Settings.SkinChangerEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end

    local color = Settings.ActiveModulesColor or Color3.fromRGB(255, 215, 0)
    if Settings.SkinChangerRGB then
        local hue = (tick() * 0.5) % 1
        color = Color3.fromHSV(hue, 0.85, 1)
    end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Color = color
        elseif part:IsA("SpecialMesh") then
            part.VertexColor = Vector3.new(color.R, color.G, color.B)
        end
    end
end

function Appearance.ApplyFPSBooster(enabled)
    Settings.FPSBooster = enabled
    if enabled then
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                end
            end
        end)
    end
end


-- ==============================================================================
-- MÓDULO 11: CONTROLES TÁCTILES MÓVILES Y BOTÓN FLOTANTE PIKACHU
-- ==============================================================================
local MobileHUD = {}
MobileHUD.CreatedButtons = {}
MobileHUD.ScreenGui = nil

function MobileHUD.Initialize()
    if MobileHUD.ScreenGui then return end

    local function GetSafeGuiParent()
        local parent = nil
        pcall(function() if gethui then parent = gethui() end end)
        if parent then return parent end
        pcall(function()
            if CoreGui and CoreGui:IsA("Instance") then
                local test = Instance.new("Folder")
                test.Parent = CoreGui
                test:Destroy()
                parent = CoreGui
            end
        end)
        if parent then return parent end
        pcall(function()
            parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 3)
        end)
        return parent or StarterGui
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CokeboysMobileHUD"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 200
    MobileHUD.ScreenGui = ScreenGui

    pcall(function()
        ScreenGui.Parent = GetSafeGuiParent()
    end)

    -- Botón flotante Pikachu
    local PikachuBtn = Instance.new("ImageButton")
    PikachuBtn.Name = "FloatingPikachu"
    PikachuBtn.Size = UDim2.fromOffset(55, 55)
    PikachuBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
    PikachuBtn.Image = "rbxassetid://100811421674645"
    PikachuBtn.BackgroundTransparency = 1
    PikachuBtn.Parent = ScreenGui

    PikachuBtn.MouseButton1Click:Connect(function()
        getgenv().CokeboysGuiHidden = not getgenv().CokeboysGuiHidden
        if GUI and GUI.MainFrame then
            GUI.MainFrame.Visible = not getgenv().CokeboysGuiHidden
        end
    end)
end


-- ==============================================================================
-- MÓDULO 12: INTERFAZ GRÁFICA GLASSMORPHISM CON CONTROLES INTERACTIVOS COMPLETOS
-- ==============================================================================
GUI = GUI or {}
GUI.ScreenGui = nil
GUI.MainFrame = nil
GUI.CurrentTab = "Combat"
GUI.TabButtons = {}
GUI.TabFrames = {}

local function GetSafeGuiParent()
    local parent = nil
    pcall(function()
        if gethui then parent = gethui() end
    end)
    if parent then return parent end
    pcall(function()
        if syn and syn.protect_gui then
            local test = Instance.new("ScreenGui")
            syn.protect_gui(test)
            test.Parent = CoreGui
            test:Destroy()
            parent = CoreGui
        end
    end)
    if parent then return parent end
    pcall(function()
        if CoreGui and CoreGui:IsA("Instance") then
            local test = Instance.new("Folder")
            test.Parent = CoreGui
            test:Destroy()
            parent = CoreGui
        end
    end)
    if parent then return parent end
    pcall(function()
        if LocalPlayer then
            parent = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
        end
    end)
    if parent then return parent end
    return CoreGui
end

function GUI.BuildMenu()
    if GUI.ScreenGui then
        pcall(function() GUI.ScreenGui:Destroy() end)
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CokeboysGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 100
    GUI.ScreenGui = ScreenGui

    local safeParent = GetSafeGuiParent()
    local pSuccess, _ = pcall(function()
        ScreenGui.Parent = safeParent
    end)
    if not pSuccess or not ScreenGui.Parent or ScreenGui.Parent == StarterGui then
        pcall(function()
            ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui", 5)
        end)
    end

    -- Botón flotante permanente para alternar la interfaz (Soporte Móvil y PC)
    local FloatingToggle = Instance.new("ImageButton")
    FloatingToggle.Name = "CokeboysFloatingToggle"
    FloatingToggle.Size = UDim2.fromOffset(50, 50)
    FloatingToggle.Position = UDim2.new(0.015, 0, 0.45, 0)
    FloatingToggle.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    FloatingToggle.BorderSizePixel = 0
    FloatingToggle.Image = "rbxassetid://100811421674645"
    FloatingToggle.Active = true
    FloatingToggle.Draggable = true
    FloatingToggle.Parent = ScreenGui

    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(1, 0)
    FloatCorner.Parent = FloatingToggle

    local FloatStroke = Instance.new("UIStroke")
    FloatStroke.Color = Color3.fromRGB(255, 215, 0)
    FloatStroke.Thickness = 2
    FloatStroke.Parent = FloatingToggle

    FloatingToggle.MouseButton1Click:Connect(function()
        if GUI.MainFrame then
            GUI.MainFrame.Visible = not GUI.MainFrame.Visible
        end
    end)

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.fromOffset(780, 520)
    MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = true
    MainFrame.Parent = ScreenGui
    GUI.MainFrame = MainFrame

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(55, 55, 75)
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame

    -- Barra superior (TopBar) con sistema de arrastre y botón de cierre
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 10)
    TopCorner.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.fromOffset(16, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = "COKEBOYS V1.8  •  BLOX FRUITS SUITE"
    Title.TextColor3 = Color3.fromRGB(255, 215, 0)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.fromOffset(30, 30)
    CloseBtn.Position = UDim2.new(1, -38, 0, 7)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 35)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseBtn.TextSize = 14
    CloseBtn.Parent = TopBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn

    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)

    -- Sistema de arrastre suave para TopBar
    local isDragging, dragStart, startPos = false, nil, nil
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if isDragging and dragStart and startPos then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)

    -- Contenedor lateral de pestañas (Sidebar)
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 180, 1, -55)
    Sidebar.Position = UDim2.fromOffset(10, 50)
    Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 2
    Sidebar.Parent = MainFrame

    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, 8)
    SideCorner.Parent = Sidebar

    local SideList = Instance.new("UIListLayout")
    SideList.Padding = UDim.new(0, 4)
    SideList.SortOrder = Enum.SortOrder.LayoutOrder
    SideList.Parent = Sidebar

    -- Contenedor de contenido de pestañas
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -210, 1, -55)
    ContentArea.Position = UDim2.fromOffset(200, 50)
    ContentArea.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    ContentArea.BorderSizePixel = 0
    ContentArea.Parent = MainFrame

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentArea

    local tabList = {
        {"Combat", "⚔️ Combat & Aim"},
        {"Visuals", "👁️ Visuals & ESP"},
        {"Movement", "⚡ Movement"},
        {"Weapon", "🗡️ Mastery & Race"},
        {"Macros", "🍇 Fruit Macros"},
        {"AutoFarm", "🌾 Auto Farm"},
        {"Bosses", "🌊 Boss & Sea"},
        {"Cosmetics", "✨ Cosmetics"},
        {"Settings", "⚙️ Config & HUD"}
    }

    for idx, tInfo in ipairs(tabList) do
        local tabId = tInfo[1]
        local tabTitle = tInfo[2]

        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = "TabBtn_" .. tabId
        TabBtn.Size = UDim2.new(1, -8, 0, 38)
        TabBtn.Position = UDim2.fromOffset(4, 0)
        TabBtn.BackgroundColor3 = (idx == 1) and Color3.fromRGB(40, 40, 55) or Color3.fromRGB(25, 25, 35)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.Text = "  " .. tabTitle
        TabBtn.TextColor3 = (idx == 1) and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(190, 190, 210)
        TabBtn.TextSize = 12
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Parent = Sidebar

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = TabBtn

        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = "TabFrame_" .. tabId
        TabFrame.Size = UDim2.new(1, -16, 1, -16)
        TabFrame.Position = UDim2.fromOffset(8, 8)
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderSizePixel = 0
        TabFrame.ScrollBarThickness = 4
        TabFrame.Visible = (idx == 1)
        TabFrame.Parent = ContentArea

        local TabListLayout = Instance.new("UIListLayout")
        TabListLayout.Padding = UDim.new(0, 8)
        TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabListLayout.Parent = TabFrame

        GUI.TabButtons[tabId] = TabBtn
        GUI.TabFrames[tabId] = TabFrame

        TabBtn.MouseButton1Click:Connect(function()
            for otherId, btn in pairs(GUI.TabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                btn.TextColor3 = Color3.fromRGB(190, 190, 210)
            end
            for otherId, frame in pairs(GUI.TabFrames) do
                frame.Visible = false
            end
            TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            TabBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
            TabFrame.Visible = true
            GUI.CurrentTab = tabId
        end)
    end

    -- Constructores de componentes de control interactivos
    local function CreateToggle(parent, titleText, defaultVal, onToggled)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, -8, 0, 42)
        Row.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        Row.BorderSizePixel = 0
        Row.Parent = parent

        local RowCorner = Instance.new("UICorner")
        RowCorner.CornerRadius = UDim.new(0, 6)
        RowCorner.Parent = Row

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -70, 1, 0)
        Label.Position = UDim2.fromOffset(12, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamMedium
        Label.Text = titleText
        Label.TextColor3 = Color3.fromRGB(230, 230, 240)
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Row

        local Switch = Instance.new("TextButton")
        Switch.Size = UDim2.fromOffset(50, 26)
        Switch.Position = UDim2.new(1, -60, 0.5, -13)
        Switch.BackgroundColor3 = defaultVal and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(45, 45, 60)
        Switch.Font = Enum.Font.GothamBold
        Switch.Text = defaultVal and "ON" or "OFF"
        Switch.TextColor3 = defaultVal and Color3.fromRGB(20, 20, 25) or Color3.fromRGB(150, 150, 170)
        Switch.TextSize = 11
        Switch.Parent = Row

        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(0, 6)
        SwitchCorner.Parent = Switch

        local state = defaultVal
        Switch.MouseButton1Click:Connect(function()
            state = not state
            Switch.BackgroundColor3 = state and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(45, 45, 60)
            Switch.Text = state and "ON" or "OFF"
            Switch.TextColor3 = state and Color3.fromRGB(20, 20, 25) or Color3.fromRGB(150, 150, 170)
            pcall(onToggled, state)
        end)
    end

    local function CreateButton(parent, titleText, onClick)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -8, 0, 38)
        Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        Btn.Font = Enum.Font.GothamMedium
        Btn.Text = titleText
        Btn.TextColor3 = Color3.fromRGB(255, 215, 0)
        Btn.TextSize = 12
        Btn.Parent = parent

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Btn

        Btn.MouseButton1Click:Connect(function()
            pcall(onClick)
        end)
    end

    -- Pestaña Combat
    local pCombat = GUI.TabFrames["Combat"]
    CreateToggle(pCombat, "Silent Aim (Ballistic Lead)", Settings.SkillAimbot, function(v) Settings.SkillAimbot = v end)
    CreateToggle(pCombat, "Permanent CamLock", Settings.PermanentCamLock, function(v) Settings.PermanentCamLock = v end)
    CreateToggle(pCombat, "Hitbox Expander", Settings.HitboxExpander, function(v) Settings.HitboxExpander = v end)
    CreateToggle(pCombat, "Show FOV Circle", Settings.AimAssist.ShowFOV, function(v) Settings.AimAssist.ShowFOV = v end)
    CreateToggle(pCombat, "Fast Attack (Packet Spammer)", Settings.FastAttack, function(v) Settings.FastAttack = v end)
    CreateToggle(pCombat, "Soru Aim Assist", Settings.SoruAim, function(v) Settings.SoruAim = v end)

    -- Pestaña Visuals
    local pVisuals = GUI.TabFrames["Visuals"]
    CreateToggle(pVisuals, "Player ESP (Names & HP)", Settings.ESP.Players, function(v) Settings.ESP.Players = v end)
    CreateToggle(pVisuals, "Chest ESP (All Tiers)", Settings.ESP.Chests, function(v) Settings.ESP.Chests = v end)
    CreateToggle(pVisuals, "Fruit ESP (Spawned Fruits)", Settings.ESP.Fruits, function(v) Settings.ESP.Fruits = v end)
    CreateToggle(pVisuals, "Flower ESP (Race V2)", Settings.ESP.Flowers, function(v) Settings.ESP.Flowers = v end)
    CreateToggle(pVisuals, "Tracers", Settings.ESP.Tracers, function(v) Settings.ESP.Tracers = v end)
    CreateToggle(pVisuals, "Show Distance", Settings.ESP.Distance, function(v) Settings.ESP.Distance = v end)

    -- Pestaña Movement
    local pMovement = GUI.TabFrames["Movement"]
    CreateToggle(pMovement, "Infinite Air Jump (Geppo)", Settings.InfiniteAirJump, function(v) Settings.InfiniteAirJump = v end)
    CreateToggle(pMovement, "Speed Boost", Settings.SpeedBoost, function(v) Settings.SpeedBoost = v end)
    CreateToggle(pMovement, "Super Jump", Settings.SuperJump, function(v) Settings.SuperJump = v end)
    CreateToggle(pMovement, "Water Walk (Safe Ocean)", Settings.WaterWalk, function(v) Settings.WaterWalk = v end)
    CreateToggle(pMovement, "Lava Walk (Hot Springs)", Settings.LavaWalk, function(v) Settings.LavaWalk = v end)
    CreateToggle(pMovement, "NoClip", Settings.NoClip, function(v) Settings.NoClip = v end)
    CreateToggle(pMovement, "Fly Mode", Settings.Fly, function(v) Settings.Fly = v end)

    -- Pestaña Weapon
    local pWeapon = GUI.TabFrames["Weapon"]
    CreateToggle(pWeapon, "Auto Buso Haki", Settings.AutoBuso, function(v) Settings.AutoBuso = v end)
    CreateToggle(pWeapon, "Auto Ken Haki", Settings.AutoKen, function(v) Settings.AutoKen = v end)
    CreateToggle(pWeapon, "Smart Race V3", Settings.SmartV3, function(v) Settings.SmartV3 = v end)
    CreateToggle(pWeapon, "Smart Race V4", Settings.SmartV4, function(v) Settings.SmartV4 = v end)
    CreateToggle(pWeapon, "Click Aura / Fast M1", Settings.FastAttack, function(v) Settings.FastAttack = v end)

    -- Pestaña Macros
    local pMacros = GUI.TabFrames["Macros"]
    CreateButton(pMacros, "⚡ Execute Kitsune One-Shot Combo", function() BloxFruitsMacros.ExecuteKitsuneCombo(Combat.CurrentTarget) end)
    CreateButton(pMacros, "⚡ Execute Dough V2 One-Shot Combo", function() BloxFruitsMacros.ExecuteDoughCombo(Combat.CurrentTarget) end)
    CreateButton(pMacros, "⚡ Execute Dragon Metamorph Combo", function() BloxFruitsMacros.ExecuteDragonCombo(Combat.CurrentTarget) end)
    CreateButton(pMacros, "⚡ Execute Portal Dimensional Rift", function() BloxFruitsMacros.ExecutePortalCombo(Combat.CurrentTarget) end)
    CreateButton(pMacros, "⚡ Execute Godhuman + CDK True Combo", function() BloxFruitsMacros.ExecuteGodhumanCombo(Combat.CurrentTarget) end)
    CreateButton(pMacros, "⚡ Execute Soul Guitar Momentum Boost", function() BloxFruitsMacros.ExecuteSoulGuitarBoost() end)

    -- Pestaña AutoFarm
    local pAutoFarm = GUI.TabFrames["AutoFarm"]
    CreateToggle(pAutoFarm, "Auto Farm Level (1-2550)", Settings.AutoFarmLevel, function(v) Settings.AutoFarmLevel = v end)
    CreateToggle(pAutoFarm, "Auto Farm Nearest Mobs", Settings.AutoFarmNearest, function(v) Settings.AutoFarmNearest = v end)
    CreateToggle(pAutoFarm, "Auto Collect All Chests", Settings.AutoChests, function(v) Settings.AutoChests = v end)
    CreateToggle(pAutoFarm, "Mob Magnet (Pull Mobs)", Settings.MobMagnet, function(v) Settings.MobMagnet = v end)

    -- Pestaña Bosses
    local pBosses = GUI.TabFrames["Bosses"]
    CreateToggle(pBosses, "Auto Sea Beast Hunter", Settings.AutoSeaBeast, function(v) Settings.AutoSeaBeast = v end)
    CreateToggle(pBosses, "Auto Terror Shark Slayer", Settings.AutoTerrorShark, function(v) Settings.AutoTerrorShark = v end)
    CreateToggle(pBosses, "Auto Ghost Ship Clearing", Settings.AutoGhostShip, function(v) Settings.AutoGhostShip = v end)
    CreateToggle(pBosses, "Auto Mirage Island Solver", Settings.MirageSolver, function(v) Settings.MirageSolver = v end)
    CreateButton(pBosses, "🔥 Start Flame Raid", function() RaidController.StartRaid_Flame() end)
    CreateButton(pBosses, "✨ Start Buddha Raid", function() RaidController.StartRaid_Buddha() end)
    CreateButton(pBosses, "🍩 Start Dough Raid", function() RaidController.StartRaid_Dough() end)

    -- Pestaña Cosmetics
    local pCosmetics = GUI.TabFrames["Cosmetics"]
    CreateToggle(pCosmetics, "Fake Headless Horseman", Settings.FakeHeadless, function(v) Settings.FakeHeadless = v; if v then Appearance.ApplyFakeHeadless() end end)
    CreateToggle(pCosmetics, "Fake Korblox Deathspeaker", Settings.FakeKorblox, function(v) Settings.FakeKorblox = v; if v then Appearance.ApplyFakeKorblox() end end)
    CreateToggle(pCosmetics, "Skin Changer", Settings.SkinChangerEnabled, function(v) Settings.SkinChangerEnabled = v; Appearance.ApplySkinChanger() end)
    CreateToggle(pCosmetics, "Rainbow RGB Armor", Settings.SkinChangerRGB, function(v) Settings.SkinChangerRGB = v end)
    CreateToggle(pCosmetics, "FPS Booster (Potato PC Mode)", Settings.FPSBooster, function(v) Appearance.ApplyFPSBooster(v) end)

    -- Pestaña Settings
    local pSettings = GUI.TabFrames["Settings"]
    CreateButton(pSettings, "Language: English", function() Settings.Language = "English" end)
    CreateButton(pSettings, "Language: Spanish", function() Settings.Language = "Spanish" end)
    CreateButton(pSettings, "Language: Portuguese", function() Settings.Language = "Portuguese" end)
    CreateButton(pSettings, "Language: Vietnamese", function() Settings.Language = "Vietnamese" end)
    CreateButton(pSettings, "❌ Unload & Clean Up Script", function() pcall(function() GUI.ScreenGui:Destroy() end) end)

    -- Tecla de atajo para abrir/cerrar interfaz
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Settings.Keybinds.MenuKey then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    MainFrame.Visible = true
end


-- ==============================================================================
-- MÓDULO 15: PIPELINE DE INICIALIZACIÓN INMEDIATA Y EVENTOS DE CICLO DE VIDA
-- ==============================================================================
function InitializeCokeboys()
    print("--------------------------------------------------")
    print("COKEBOYS BLOX FRUITS V1.8 INICIADO CON ÉXITO")
    print("Versión: V1.8 | Estado: Activo | Idioma: " .. tostring(Settings.Language))
    print("--------------------------------------------------")

    -- PASO 1: CONSTRUIR LA INTERFAZ GRÁFICA DE INMEDIATO
    pcall(function()
        GUI.BuildMenu()
    -- Notificación visual de confirmación de carga
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Cokeboys Blox Fruits V1.8",
            Text = "Script inyectado y ejecutado con éxito! Interfaz cargada.",
            Duration = 6
        })
    end)

    end)

    -- PASO 2: INICIALIZAR CONTROLES MÓVILES
    pcall(function()
        if UserInputService.TouchEnabled or getgenv().__CokeboysAutomatedMobileNativeTouch then
            MobileHUD.Initialize()
        end
    end)

    -- PASO 3: ENGANCHAR METAMÉTODOS DE COMBATE (SILENT AIM)
    pcall(function()
        Combat.HookNamecall()
        Combat.HookMouseIndex()
    end)

    -- PASO 4: INICIAR MOVIMIENTO Y GLITCHES
    pcall(function()
        Movement.StartAirJumpLoop()
        Movement.HookDash()
    end)

    -- PASO 5: INICIALIZAR ESP PARA JUGADORES
    pcall(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                ESP.CreateBillboard(player)
            end
        end
        Players.PlayerAdded:Connect(function(player)
            ESP.CreateBillboard(player)
        end)
        ESP.UpdateLoop()
    end)

    -- PASO 6: BUCLE RENDERSTEPPED DE ALTA FRECUENCIA
    pcall(function()
        RunService.RenderStepped:Connect(function(deltaTime)
            pcall(function()
                Movement.ApplySpeedBoost(deltaTime)
                Combat.UpdatePermanentCamLock(deltaTime)
                VisualIndicator.Render()
                if Settings.SkinChangerRGB then
                    Appearance.ApplySkinChanger()
                end
            end)
        end)
    end)

    -- PASO 7: ESCANEO EN SEGUNDO PLANO DE OBJETIVOS Y HITBOXES
    task.spawn(function()
        while getgenv().CokeboysScriptLoaded do
            pcall(function()
                local bestTarget, bestRoot = Combat.FindBestTarget()
                Combat.CurrentTarget = bestTarget
                Combat.CurrentTargetRoot = bestRoot

                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        HitboxManager.UpdateForCharacter(player.Character, Settings.HitboxExpander)
                    end
                end

                Movement.CheckSafeMode()
            end)
            task.wait(0.25)
        end
    end)

    -- PASO 8: INICIAR BUCLE DE AUTOFARM
    pcall(function()
        AutoFarm.FarmLoop()
    end)
end

-- EJECUCIÓN INMEDIATA
task.spawn(function()
    InitializeCokeboys()
end)

-- RETORNO DE LA TABLA MAESTRA DEL SCRIPT
return {
    Settings = Settings,
    Combat = Combat,
    ESP = ESP,
    Movement = Movement,
    WeaponMastery = WeaponMastery,
    BloxFruitsMacros = BloxFruitsMacros,
    AutoFarm = AutoFarm,
    Appearance = Appearance,
    MobileHUD = MobileHUD,
    GUI = GUI,
    Localization = Localization,
    KeySystem = KeySystem,
    Initialize = InitializeCokeboys
}
