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

#Set-Alias vim "C:\Program Files\Vim\vim82\vim.exe"
#Set-Alias gvim "C:\Program Files\Vim\vim82\gvim.exe"

function New-Directory
{
	 $arg = $args[0]
	 mkdir $arg
	 Set-Location $arg
}

Set-Alias nd New-Directory

Set-Alias t Get-Content

Set-Alias sudo gsudo

function psa
{
    sudo powershell -noe '. C:\Users\dave.anderson\bin\AdminProfile.ps1'
}

function Remove-Directory
{
    Remove-Item -Recurse -Force $args[0]
}
 
Set-Alias rrd Remove-Directory
 
function symlink
{
    gsudo New-item -ItemType SymbolicLink -Path $args[0] -Target $args[1]
}

Remove-Item alias:rm -Force
Remove-Item alias:cp -Force
Remove-Item alias:ls -Force
Remove-Item alias:diff -Force
Remove-Item alias:sc -Force
