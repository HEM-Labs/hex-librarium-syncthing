@echo off
setlocal

set "SYNCTHING_RESTART=unless-stopped"

docker volume create hex-librarium
if errorlevel 1 exit /b %errorlevel%

docker compose pull
if errorlevel 1 exit /b %errorlevel%

docker compose up -d --no-build librarium-syncthing
