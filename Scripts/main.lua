local UEHelpers = require("UEHelpers")
local Config = require "config"

local CameraComponent = StaticFindObject("/Script/Engine.CameraComponent")

local function PokeCamera()
    local PlayerController = UEHelpers.GetPlayerController()
    local context = PlayerController:GetClass():GetFullName()

    if context == "BlueprintGeneratedClass /Game/01_Union/Blueprint/System/Input/BP_RacePlayerController.BP_RacePlayerController_C" then
        local pawn = PlayerController.K2_GetPawn()
        local raceCamera = pawn.TPCameraComponent

        print(string.format("[UnionUltrawide] Poking race camera at %s...\n", raceCamera:GetFullName()))
        raceCamera:SetAspectRatioAxisConstraint(Config.axis_constraint_type)
        raceCamera:SetConstraintAspectRatio(false)
    else
        if Config.disable_aspect_ratio_in_all_scenes then
            local camera = PlayerController.PlayerCameraManager.ViewTarget.Target
            local _cameraComponent = camera:GetComponentByClass(CameraComponent)

            if _cameraComponent:IsValid() then
                print(string.format("[UnionUltrawide] Poking generic camera at %s...\n", _cameraComponent:GetFullName()))
                _cameraComponent:SetConstraintAspectRatio(false)
            end
        end
    end
end

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()

    print("[UnionUltrawide] Load level detected, attempting to poke camera...")
    PokeCamera()

end)

RegisterKeyBind(Key.T, {ModifierKey.CONTROL}, PokeCamera)