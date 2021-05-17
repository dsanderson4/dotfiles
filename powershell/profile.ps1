Import-Module PSReadLine
Set-PSReadLineOption -EditMode Emacs

# Ctrl-Alt-U to go up a directory, like Clink.
Set-PSReadlineKeyHandler -Chord Ctrl+Alt+U -ScriptBlock {
	[Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    Set-Location '..'
}

function prompt {"PS $($executionContext.SessionState.Path.CurrentLocation)$('$' * ($nestedPromptLevel + 1)) ";}

Set-Alias c Copy-Item

Set-Alias d Get-ChildItem

function Edit-File {emacsclient -n $args}
Set-Alias e Edit-File

function Edit-File-Gvim {gvim --remote-silent $args}
Set-Alias v Edit-File-Gvim

Set-Alias emacs runemacs

Set-Alias hd Format-Hex

Set-Alias find "C:\Program Files\Git\usr\bin\find.exe"

Set-Alias 7z "C:\Program Files\7-Zip\7z.exe"

# Set-Alias vim "C:\Program Files (x86)\Vim\vim81\vim.exe"
# Set-Alias gvim "C:\Program Files (x86)\Vim\vim81\gvim.exe"

function New-Directory
{
	 $arg = $args[0]
	 mkdir $arg
	 Set-Location $arg
}

Set-Alias nd New-Directory

Set-Alias t Get-Content

Remove-Item alias:rm -Force
Remove-Item alias:cp -Force
Remove-Item alias:ls -Force
Remove-Item alias:diff -Force
Remove-Item alias:sc -Force
