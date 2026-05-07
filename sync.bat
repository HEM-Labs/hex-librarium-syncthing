@echo off
setlocal

docker volume create hex-librarium
if errorlevel 1 exit /b %errorlevel%

docker compose pull
if errorlevel 1 exit /b %errorlevel%

docker compose up --no-build librarium-syncthing
