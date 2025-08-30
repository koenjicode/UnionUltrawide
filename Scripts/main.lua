local UEHelpers = require("UEHelpers")
local Config = require "config"

local function PokeCamera()
    local PlayerController = UEHelpers.GetPlayerController()
    local context = PlayerController:GetClass():GetFullName()

    if context == "BlueprintGeneratedClass /Game/01_Union/Blueprint/System/Input/BP_RacePlayerController.BP_RacePlayerController_C" then
        local pawn = PlayerController.K2_GetPawn()
        local raceCamera = pawn.TPCameraComponent

        print(string.format("[UnionUltrawide] Poking race camera at %s...\n", raceCamera:GetFullName()))
        raceCamera:SetAspectRatioAxisConstraint(Config.axis_constraint_type)
        raceCamera:SetConstraintAspectRatio(false)
    end
end

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()

    print("[UnionUltrawide] Load level detected, attempting to poke camera...")
    PokeCamera()
end)