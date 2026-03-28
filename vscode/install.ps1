$configPath = "$env:APPDATA\Code\User"
Remove-Item $configPath\settings.json -ErrorAction SilentlyContinue
Remove-Item $configPath\keybindings.json -ErrorAction SilentlyContinue

gsudo { 
    param($settingsPath)
    New-Item -ItemType SymbolicLink -Path $settingsPath\settings.json -Target settings.json
    New-Item -ItemType SymbolicLink -Path $settingsPath\keybindings.json -Target keybindings.json
} -args $configPath
