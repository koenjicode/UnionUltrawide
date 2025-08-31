

local _union_ultrawide_config = {

    -- Allows a custom field of view to be provided, if disabled the game field of view will not be altered.
    use_custom_field_of_view = false,

    -- the FOV used in-game.
    field_of_view = 116,

    -- Aspect Ratio Option
    -- 0 = Y-Axis FOV, 1 = X-Axis FOV, 2 = Major Axis
    axis_constraint_type = 0,

    -- EXPERIMENTAL: Removes aspect ratio restriction in menus.
    -- Hud elements may not be designed to fit elements in an ultrawide setting.
    ultrawide_menu_widgets = true,
}

return _union_ultrawide_config