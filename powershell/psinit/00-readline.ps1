Import-Module PSReadLine
Set-PSReadLineOption -EditMode Emacs

Set-PSReadLineKeyHandler -Key "Alt+u" -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("cd ..")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
