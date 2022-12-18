@echo off
set branch="22H2"
set ver="v0.0.1"

:: other variables (do not touch)
set "currentuser=%WinDir%\AtlasModules\NSudo -U:C -P:E -Wait"
set "setSvc=call :setSvc"
set "firewallBlockExe=call :firewallBlockExe"

:: check for administrator privileges
fltmc >nul 2>&1 || (
    goto permFAIL
)

:: check for trusted installer priviliges
whoami /user | find /i "S-1-5-18" >nul 2>&1
if not %ERRORLEVEL%==0 (
    set system=false
)

:permSUCCESS
SETLOCAL EnableDelayedExpansion

:: Startup
if /i "%~1"=="/start"		   goto startup

:: will loop update check if debugging
:: Notifications
if /i "%~1"=="/dn"         goto notiD
if /i "%~1"=="/en"         goto notiE

:: Animations
if /i "%~1"=="/ad"         goto aniD
if /i "%~1"=="/ae"         goto aniE

:: Search Indexing
if /i "%~1"=="/di"         goto indexD
if /i "%~1"=="/ei"         goto indexE

:: Wi-Fi
if /i "%~1"=="/dw"         goto wifiD
if /i "%~1"=="/ew"         goto wifiE

:: Hyper-V and VBS
if /i "%~1"=="/dhyper"         goto hyperD
if /i "%~1"=="/ehyper"         goto hyperE

:: Microsoft Store
if /i "%~1"=="/ds"         goto storeD
if /i "%~1"=="/es"         goto storeE

:: Background Apps
if /i "%~1"=="/backd"         goto backD
if /i "%~1"=="/backe"         goto backE

:: Bluetooth
if /i "%~1"=="/btd"         goto btD
if /i "%~1"=="/bte"         goto btE

:: HDD Prefetching
if /i "%~1"=="/hddd"         goto hddD
if /i "%~1"=="/hdde"         goto hddE