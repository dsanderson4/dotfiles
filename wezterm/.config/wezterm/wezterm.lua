-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()
config.launch_menu = {}

config.font = wezterm.font 'Lucida Console for Powerline'
config.font_size = 9.0

-- This is where you actually apply your config choices

-- config.default_prog = {'powershell'}


if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = {
        "powershell",
        "-NoExit",
        "vs2022.ps1"
    }

    table.insert(config.launch_menu,
    {
        label = "PowerShell",
        args = { "powershell" }
    })
    table.insert(config.launch_menu,
    {
        label = "VS2022 PowerShell",
        args = {
            "powershell",
            "-NoExit",
            "vs2022.ps1"
        },
        cwd = "~"
    })
    table.insert(config.launch_menu,
    {
        label = "Neovim",
        args = { "nvim" }
    })
    table.insert(config.launch_menu,
    {
        label = "Vifm",
        args = { "c:\\apps\\vifm\\vifm.exe" }
    })
    table.insert(config.launch_menu,
    {
        label = "WSL Arch",
        args = { "wsl", "-d", "Arch" }
    })
    table.insert(config.launch_menu,
    {
        label = "WSL Ubuntu",
        args = { "wsl", "-d", "Ubuntu" }
    })
    table.insert(config.launch_menu,
    {
        label = "MSYS2",
		args = { "cmd.exe ", "/k", "C:\\msys64\\msys2_shell.cmd -defterm -here -no-start -ucrt64 -shell zsh" },
    })
    table.insert(config.launch_menu,
    {
        label = "Command Prompt",
        args = { "cmd" }
    })
elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
    table.insert(config.launch_menu,
    {
        label = "zsh", args = {"zsh"}
    })
    table.insert(config.launch_menu,
    {
        label = "bash", args = {"bash", "-l"}
    })
    table.insert(config.launch_menu,
    {
        label = "Neovim",
        args = { "nvim" }
    })
    table.insert(config.launch_menu,
    {
        label = "Vifm",
        args = { "vifm" }
    })
elseif wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin"  then
    config.font_size = 12.0

    table.insert(config.launch_menu,
    {
        label = "zsh", args = {"zsh"}
    })
    table.insert(config.launch_menu,
    {
        label = "bash", args = {"bash", "-l"}
    })
    table.insert(config.launch_menu,
    {
        label = "Neovim",
        args = { "nvim" }
    })
    table.insert(config.launch_menu,
    {
        label = "Vifm",
        args = { "vifm" }
    })
end

config.default_cwd = "~"

-- For example, changing the color scheme:
config.color_scheme = 'GruvboxDark'

config.keys = {
    {
        key = 'd',
        mods = 'CTRL|SHIFT',
        action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = "h",
        mods = "CTRL|SHIFT",
        action = act.ActivatePaneDirection 'Left'
    },
    {
        key = "l",
        mods = "CTRL|SHIFT",
        action = act.ActivatePaneDirection 'Right'
    },
    {
        key = "t",
        mods = "CTRL|SHIFT",
        action = act.ShowLauncher
    },
}

-- and finally, return the configuration to wezterm
return config
