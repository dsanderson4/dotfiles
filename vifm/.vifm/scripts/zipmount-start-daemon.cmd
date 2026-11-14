@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command ". $HOME\dotfiles\powershell\psinit\16-zipmount.ps1; Start-ZipMountDaemon"
