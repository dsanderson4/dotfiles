@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0zip-mount.ps1" %*
