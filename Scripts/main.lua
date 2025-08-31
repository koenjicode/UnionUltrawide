local UEHelpers = require("UEHelpers")
local Config = require "config"

local isRaceMode = false

function PokeCamera(cameraToPoke)
    cameraToPoke.AspectRatioAxisConstraint = Config.axis_constraint_type
    cameraToPoke.bConstrainAspectRatio = false

    print(string.format("[UnionUltrawide] Poked %s.\n", cameraToPoke:GetFullName()))
end

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()

    print("[UnionUltrawide] Load level detected, attempting to poke camera...")
    local PlayerController = UEHelpers.GetPlayerController()
    local context = PlayerController:GetClass():GetFullName()

    if context == "BlueprintGeneratedClass /Game/01_Union/Blueprint/System/Input/BP_RacePlayerController.BP_RacePlayerController_C" then

        isRaceMode = true

        local pawn = PlayerController.K2_GetPawn()
        local raceCamera = pawn.TPCameraComponent

        if raceCamera:IsValid() then
            PokeCamera(raceCamera)
        end
    else
        isRaceMode = false
    end
end)

RegisterHook("Function /Script/UNION.RaceSequenceStateReady:StartRace", function(Context)
    print(string.format("[UnionUltrawide] Adjusting Game FOV to %s...\n", Config.field_of_view))
    local command = "fov " .. tostring(Config.field_of_view)

    KismetSystemLibrary = StaticFindObject("/Script/Engine.Default__KismetSystemLibrary")
    KismetSystemLibrary:ExecuteConsoleCommand(UEHelpers.GetWorld(), command, PlayerController)
end)

NotifyOnNewObject("/Script/UNION.RaceCameraActor", function(self)
    ExecuteInGameThread(function()
        print(string.format("[UnionUltrawide] RaceCameraActor %s was created, poking...\n", self:GetFullName()))
        PokeCamera(self.RaceCameraComponent)
    end)
end)

NotifyOnNewObject("/Script/CinematicCamera.CineCameraActor", function(self)
    ExecuteInGameThread(function()
        if Config.ultrawide_menu_widgets and not isRaceMode then
            print(string.format("[UnionUltrawide] CineCameraActor %s was created, poking...\n", self:GetFullName()))
            PokeCamera(self.CameraComponent)
        end
    end)
end)