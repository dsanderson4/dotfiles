-- Keybindings mirroring i3/.config/i3/config.
--
-- i3 modifiers: Mod4 = SUPER, Mod1 = ALT.
-- Anything i3 does that Hyprland has no direct equivalent for is noted inline.

local M = {}

function M.setup(programs)
    local terminal = programs.terminal
    local rofi     = "rofi -config ~/.config/rofi/rofidmenu.rasi"

    local dirs = {
        h = "left", j = "down", k = "up", l = "right",
        left = "left", down = "down", up = "up", right = "right",
    }

    ----------------
    -- Launchers --
    ----------------
    hl.bind("SUPER + Return",   hl.dsp.exec_cmd(terminal))
    hl.bind("ALT + SHIFT + T",  hl.dsp.exec_cmd(terminal))

    hl.bind("SUPER + D",         hl.dsp.exec_cmd(rofi .. " -show run"))   -- i3: dmenu_run
    hl.bind("CTRL + Escape",     hl.dsp.exec_cmd(rofi .. " -modi drun -show drun"))
    hl.bind("CTRL + ALT + A",    hl.dsp.exec_cmd(rofi .. " -modi drun -show drun"))
    hl.bind("CTRL + ALT + R",    hl.dsp.exec_cmd(rofi .. " -show run"))
    hl.bind("CTRL + ALT + W",    hl.dsp.exec_cmd(rofi .. " -show window"))

    hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("hyprlock"))             -- i3: i3lock
    hl.bind("Print",             hl.dsp.exec_cmd("grim"))                 -- i3: scrot

    -------------------
    -- Window basics --
    -------------------
    hl.bind("ALT + SHIFT + Q",       hl.dsp.window.close())
    hl.bind("ALT + SHIFT + F",       hl.dsp.window.fullscreen())
    hl.bind("SUPER + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))

    -- i3 "focus mode_toggle": jump between tiled and floating windows on the
    -- current workspace, picking the most recently focused one of the other kind.
    hl.bind("SUPER + space", function()
        local active = hl.get_active_window()
        if not active or not active.workspace then return end
        local best
        for _, w in ipairs(hl.get_workspace_windows(active.workspace)) do
            if w.floating ~= active.floating and w.mapped and not w.hidden then
                if not best or w.focus_history_id < best.focus_history_id then
                    best = w
                end
            end
        end
        if best then hl.dispatch(hl.dsp.focus({ window = best })) end
    end)

    -- i3 "focus parent" (SUPER+A) has no Hyprland equivalent.

    -----------------
    -- Focus / move --
    -----------------
    -- Focus: ALT+SHIFT+hjkl and SUPER+arrows (SUPER+; also focuses right).
    for key, dir in pairs(dirs) do
        if #key == 1 then
            hl.bind("ALT + SHIFT + " .. key, hl.dsp.focus({ direction = dir }))
        else
            hl.bind("SUPER + " .. key,       hl.dsp.focus({ direction = dir }))
        end
        -- Move: SUPER+SHIFT+hjkl and SUPER+SHIFT+arrows.
        hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
    end
    hl.bind("SUPER + semicolon", hl.dsp.focus({ direction = "right" }))

    -----------------------
    -- Layout / "splits" --
    -----------------------
    -- i3 split h / split v -> dwindle preselect for the next window.
    hl.bind("CTRL + ALT + H", hl.dsp.layout("preselect r"))
    hl.bind("CTRL + ALT + V", hl.dsp.layout("preselect d"))
    -- i3 layout toggle split
    hl.bind("SUPER + E",      hl.dsp.layout("togglesplit"))
    -- i3 stacking / tabbed -> Hyprland groups (tabbed container with a groupbar).
    -- With binds.movefocus_cycles_groupfirst, the normal focus keys walk the tabs.
    hl.bind("SUPER + W",      hl.dsp.group.toggle())
    hl.bind("SUPER + S",      hl.dsp.group.toggle())

    hl.config({ binds = { movefocus_cycles_groupfirst = true } })

    ----------------
    -- Workspaces --
    ----------------
    for i = 1, 10 do
        local key = i % 10 -- 10 maps to key 0
        hl.bind("CTRL + ALT + " .. key,    hl.dsp.focus({ workspace = i }))
        -- i3 "move container to workspace" doesn't follow the window.
        hl.bind("SUPER + CTRL + " .. key,  hl.dsp.window.move({ workspace = i, follow = false }))
    end

    -- Move the current workspace to the monitor on the left/right.
    hl.bind("SUPER + CTRL + left",  hl.dsp.workspace.move({ monitor = "l" }))
    hl.bind("SUPER + CTRL + right", hl.dsp.workspace.move({ monitor = "r" }))

    -- Scratchpad. i3 only bound "scratchpad show"; SUPER+SHIFT+minus mirrors
    -- i3's default "move scratchpad" so there's a way to put windows there.
    hl.bind("SUPER + minus",         hl.dsp.workspace.toggle_special("scratchpad"))
    hl.bind("SUPER + SHIFT + minus", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

    -- Scroll through existing workspaces with SUPER + scroll
    hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
    hl.bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

    -----------------
    -- Bar / session --
    -----------------
    -- i3 "bar mode toggle" / "bar hidden_state toggle" -> show/hide waybar.
    hl.bind("ALT + SHIFT + B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))
    hl.bind("SUPER + M",       hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))

    -- i3 reload / restart -> Hyprland has no in-place restart; both reload.
    hl.bind("ALT + SHIFT + C", hl.dsp.reload_config())
    hl.bind("ALT + SHIFT + R", hl.dsp.reload_config())

    -- i3: ~/bin/i3exit.sh (confirm before logging out)
    hl.bind("ALT + SHIFT + E", hl.dsp.exec_cmd("~/bin/hyprexit.sh"))

    -------------------
    -- Resize submap --
    -------------------
    hl.bind("SUPER + R", hl.dsp.submap("resize"))
    hl.define_submap("resize", function()
        local step = 10
        local resizes = {
            h = { x = -step, y = 0 }, left  = { x = -step, y = 0 },
            l = { x =  step, y = 0 }, right = { x =  step, y = 0 },
            k = { x = 0, y = -step }, up    = { x = 0, y = -step },
            j = { x = 0, y =  step }, down  = { x = 0, y =  step },
        }
        for key, d in pairs(resizes) do
            hl.bind(key, hl.dsp.window.resize({ x = d.x, y = d.y, relative = true }), { repeating = true })
        end
        hl.bind("Return",    hl.dsp.submap("reset"))
        hl.bind("Escape",    hl.dsp.submap("reset"))
        hl.bind("SUPER + R", hl.dsp.submap("reset"))
    end)

    -----------
    -- Mouse --
    -----------
    -- i3 floating_modifier Mod4
    hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
    hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

    -----------------
    -- Media keys --
    -----------------
    -- i3 used amixer/light; on Hyprland use wpctl (PipeWire) and brightnessctl.
    local volFeedback = " && paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"
    hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+" .. volFeedback), { locked = true, repeating = true })
    hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" .. volFeedback),      { locked = true, repeating = true })
    hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),                    { locked = true })
    hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),                  { locked = true })
    hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 10%+"),                                        { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"),                                        { locked = true, repeating = true })

    hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"),      { locked = true })
    hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
    hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
end

return M
