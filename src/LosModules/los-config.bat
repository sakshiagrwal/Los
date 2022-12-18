@echo off
set branch="22H2"
set ver="v0.0.1"

:: other variables (do not touch)
set "currentuser=%WinDir%\LosModules\NSudo -U:C -P:E -Wait"
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

:: DEP (nx)
if /i "%~1"=="/depE"         goto depE
if /i "%~1"=="/depD"         goto depD

:: Start Menu
if /i "%~1"=="/ssD"         goto SearchStart
if /i "%~1"=="/ssE"         goto enableStart
if /i "%~1"=="/openshell"         goto openshellInstall

:: Remove UWP
if /i "%~1"=="/uwp"			goto uwp
if /i "%~1"=="/uwpE"			goto uwpE
if /i "%~1"=="/mite"			goto mitE

:: Remove Start Menu layout (allow tiles in Start Menu)
if /i "%~1"=="/stico"          goto startlayout

:: Sleep States
if /i "%~1"=="/sleepD"         goto sleepD
if /i "%~1"=="/sleepE"         goto sleepE

:: Idle
if /i "%~1"=="/idled"          goto idleD
if /i "%~1"=="/idlee"          goto idleE

:: Process Explorer
if /i "%~1"=="/procexpd"          goto procexpD
if /i "%~1"=="/procexpe"          goto procexpE

:: Xbox
if /i "%~1"=="/xboxU"         goto xboxU

:: Reinstall VC++ Redistributables
if /i "%~1"=="/vcreR"         goto vcreR

:: User Account Control
if /i "%~1"=="/uacD"		goto uacD
if /i "%~1"=="/uacE"		goto uacE

:: Workstation Service (SMB)
if /i "%~1"=="/workD"		goto workstationD
if /i "%~1"=="/workE"		goto workstationE

:: Windows Firewall
if /i "%~1"=="/firewallD"		goto firewallD
if /i "%~1"=="/firewallE"		goto firewallE

:: Printing
if /i "%~1"=="/printD"		goto printD
if /i "%~1"=="/printE"		goto printE

:: Data Queue Sizes
if /i "%~1"=="/dataQueueM"		goto dataQueueM
if /i "%~1"=="/dataQueueK"		goto dataQueueK

:: Network
if /i "%~1"=="/netWinDefault"		goto netWinDefault
if /i "%~1"=="/netLosDefault"		goto netLosDefault

:: Clipboard History Service (also required for Snip and Sketch to copy correctly)
if /i "%~1"=="/cbdhsvcD"    goto cbdhsvcD
if /i "%~1"=="/cbdhsvcE"    goto cbdhsvcE

:: VPN
if /i "%~1"=="/vpnD"    goto vpnD
if /i "%~1"=="/vpnE"    goto vpnE

:: Scoop and Chocolatey
if /i "%~1"=="/scoop" goto scoop
if /i "%~1"=="/choco" goto choco
if /i "%~1"=="/browserscoop" goto browserscoop
if /i "%~1"=="/altsoftwarescoop" goto altSoftwarescoop
if /i "%~1"=="/browserchoco" goto browserchoco
if /i "%~1"=="/altsoftwarechoco" goto altSoftwarechoco
if /i "%~1"=="/removescoopcache" goto scoopCache

:: NVIDIA P-State 0
if /i "%~1"=="/nvpstateD" goto NVPstate
if /i "%~1"=="/nvpstateE" goto revertNVPState

:: DSCP
if /i "%~1"=="/dscpauto" goto DSCPauto

:: Display Scaling
if /i "%~1"=="/displayscalingd" goto displayScalingD

:: Static IP
if /i "%~1"=="/staticip" goto staticIP

:: Windows Media Player
if /i "%~1"=="/wmpd" goto wmpD

:: Internet Explorer
if /i "%~1"=="/ied" goto ieD

:: Task Scheduler
if /i "%~1"=="/scheduled"  goto scheduleD
if /i "%~1"=="/schedulee"  goto scheduleE

:: Event Log
if /i "%~1"=="/eventlogd" goto eventlogD
if /i "%~1"=="/eventloge" goto eventlogE

:: NVIDIA Display Container LS - he3als
if /i "%~1"=="/nvcontainerD" goto nvcontainerD
if /i "%~1"=="/nvcontainerE" goto nvcontainerE
if /i "%~1"=="/nvcontainerCMD" goto nvcontainerCMD
if /i "%~1"=="/nvcontainerCME" goto nvcontainerCME

:: Network Sharing
if /i "%~1"=="/networksharingE" goto networksharingE

:: Diagnostics
if /i "%~1"=="/diagd" goto diagD
if /i "%~1"=="/diage" goto diagE

:: debugging purposes only
if /i "%~1"=="/test"         goto TestPrompt

:argumentFAIL
echo los-config had no arguements passed to it, either you are launching los-config directly or the "%~nx0" script is broken.
echo Please report this to the Los Discord or Github.
pause & exit

:TestPrompt
set /p c="Test with echo on?"
if %c% equ Y echo on
set /p argPrompt="Which script would you like to test? E.g. (:testScript)"
goto %argPrompt%
echo You should not reach this message!
pause & exit

:startup
:: create log directory for troubleshooting
mkdir %WinDir%\LosModules\logs
cls & echo Please wait, this may take a moment.
setx path "%path%;%WinDir%\LosModules;" -m  >nul 2>nul
IF %ERRORLEVEL%==0 (echo %date% - %time% Los Modules path set...>> %WinDir%\LosModules\logs\install.log
) ELSE (echo %date% - %time% Failed to set Los Modules path! >> %WinDir%\LosModules\logs\install.log)

:: breaks setting keyboard language
:: Rundll32.exe advapi32.dll,ProcessIdleTasks
break > C:\Users\Public\success.txt
echo false > C:\Users\Public\success.txt

:auto
SETLOCAL EnableDelayedExpansion
%WinDir%\LosModules\vcredist.exe /ai
if %ERRORLEVEL%==0 (echo %date% - %time% Visual C++ Runtimes installed...>> %WinDir%\LosModules\logs\install.log
) ELSE (echo %date% - %time% Failed to install Visual C++ Runtimes! >> %WinDir%\LosModules\logs\install.log)

:: change ntp server from windows server to pool.ntp.org
sc config W32Time start=demand >nul 2>nul
sc start W32Time >nul 2>nul
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"
sc queryex "w32time" | find "STATE" | find /v "RUNNING" || (
    net stop w32time
    net start w32time
) >nul 2>nul

:: resync time to pool.ntp.org
w32tm /config /update
w32tm /resync
sc stop W32Time
sc config W32Time start=disabled
if %ERRORLEVEL%==0 (echo %date% - %time% NTP server set...>> %WinDir%\LosModules\logs\install.log
) ELSE (echo %date% - %time% Failed to set NTP server! >> %WinDir%\LosModules\logs\install.log)

cls & echo Please wait. This may take a moment.

:: optimize NTFS parameters
:: disable last access information on directories, performance/privacy
fsutil behavior set disableLastAccess 1

:: https://ttcshelbyville.wordpress.com/2018/12/02/should-you-disable-8dot3-for-performance-and-security
fsutil behavior set disable8dot3 1

:: enable delete notifications (aka trim or unmap)
:: should be enabled by default but it is here to be sure
fsutil behavior set disabledeletenotify 0

:: disable file system mitigations
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f

if %ERRORLEVEL%==0 (echo %date% - %time% File system optimized...>> %WinDir%\LosModules\logs\install.log
) ELSE (echo %date% - %time% Failed to optimize file system! >> %WinDir%\LosModules\logs\install.log)

:: attempt to fix language packs issue
:: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/language-packs-known-issue
schtasks /Change /Disable /TN "\Microsoft\Windows\LanguageComponentsInstaller\Uninstallation" >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Control Panel\International" /v "BlockCleanupOfUnusedPreinstalledLangPacks" /t REG_DWORD /d "1" /f

:: disable unneeded scheduled tasks

:: breaks setting lock screen
:: schtasks /Change /Disable /TN "\Microsoft\Windows\Shell\CreateObjectTask"

for %%a in (
	"\MicrosoftEdgeUpdateTaskMachineCore"
	"\MicrosoftEdgeUpdateTaskMachineUA"
	"\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
	"\Microsoft\Windows\Windows Error Reporting\QueueReporting"
	"\Microsoft\Windows\DiskFootprint\Diagnostics"
	"\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
	"\Microsoft\Windows\Application Experience\StartupAppTask"
	"\Microsoft\Windows\Autochk\Proxy"
	"\Microsoft\Windows\Application Experience\PcaPatchDbTask"
	"\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask"
	"\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
	"\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
	"\Microsoft\Windows\Defrag\ScheduledDefrag"
	"\Microsoft\Windows\DiskFootprint\StorageSense"
	"\MicrosoftEdgeUpdateBrowserReplacementTask"
	"\Microsoft\Windows\Registry\RegIdleBackup"
	"\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange"
	"\Microsoft\Windows\Shell\IndexerAutomaticMaintenance"
	"\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork"
	"\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskLogon"
	"\Microsoft\Windows\StateRepository\MaintenanceTasks"
	"\Microsoft\Windows\UpdateOrchestrator\Report policies"
	"\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task"
	"\Microsoft\Windows\UpdateOrchestrator\UpdateModelTask"
	"\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker"
	"\Microsoft\Windows\UpdateOrchestrator\Schedule Work"
	"\Microsoft\Windows\UPnP\UPnPHostConfig"
	"\Microsoft\Windows\RetailDemo\CleanupOfflineContent"
	"\Microsoft\Windows\Shell\FamilySafetyMonitor"
	"\Microsoft\Windows\InstallService\ScanForUpdates"
	"\Microsoft\Windows\InstallService\ScanForUpdatesAsUser"
	"\Microsoft\Windows\InstallService\SmartRetry"
	"\Microsoft\Windows\International\Synchronize Language Settings"
	"\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents"
	"\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic"
	"\Microsoft\Windows\Multimedia\Microsoft\Windows\Multimedia"
	"\Microsoft\Windows\Printing\EduPrintProv"
	"\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask"
	"\Microsoft\Windows\Ras\MobilityManager"
	"\Microsoft\Windows\PushToInstall\LoginCheck"
	"\Microsoft\Windows\Time Synchronization\SynchronizeTime"
	"\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime"
	"\Microsoft\Windows\Time Zone\SynchronizeTimeZone"
	"\Microsoft\Windows\UpdateOrchestrator\Schedule Scan"
	"\Microsoft\Windows\WaaSMedic\PerformRemediation"
	"\Microsoft\Windows\DiskCleanup\SilentCleanup"
	"\Microsoft\Windows\Diagnosis\Scheduled"
	"\Microsoft\Windows\Wininet\CacheTask"
	"\Microsoft\Windows\Device Setup\Metadata Refresh"
	"\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"
	"\Microsoft\Windows\WindowsUpdate\Scheduled Start"
) do (
	schtasks /Change /Disable /TN %%a > nul
)

if %ERRORLEVEL%==0 (echo %date% - %time% Disabled scheduled tasks...>> %WinDir%\LosModules\logs\install.log
) ELSE (echo %date% - %time% Failed to disable scheduled tasks! >> %WinDir%\LosModules\logs\install.log)
cls & echo Please wait. This may take a moment.

:: enable MSI mode on USB controllers
:: second command for each device deletes device priorty, setting it to undefined
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID ^| findstr /L "PCI\VEN_"') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
)
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID ^| findstr /L "PCI\VEN_"') do (
    reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul
)

:: enable MSI mode on GPU
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID ^| findstr /L "PCI\VEN_"') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
)
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID ^| findstr /L "PCI\VEN_"') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul
)

:: enable MSI mode on network adapters
:: undefined priority on some virtual machines may break connection
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID ^| findstr /L "PCI\VEN_"') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
)
:: if e.g. VMWare is used, skip setting to undefined
wmic computersystem get manufacturer /format:value | findstr /i /C:VMWare && goto vmGO
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID ^| findstr /L "PCI\VEN_"') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul
)
goto noVM

:vmGO
:: set to normal priority
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID ^| findstr /L "PCI\VEN_"') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "2"  /f
)

:noVM
:: enable MSI mode on SATA controllers
for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID ^| findstr /L "PCI\VEN_"') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
)
for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID ^| findstr /L "PCI\VEN_"') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul
)
if %ERRORLEVEL%==0 (echo %date% - %time% MSI mode set...>> %WinDir%\LosModules\logs\install.log
) ELSE (echo %date% - %time% Failed to set MSI mode! >> %WinDir%\LosModules\logs\install.log)

cls & echo Please wait. This may take a moment.

:: --- Hardening ---

:: delete defaultuser0 account
:: used during OOBE
net user defaultuser0 /delete >nul 2>nul

:: disable "administrator" account
:: used in oem situations to install oem-specific programs when a user is not yet created
net user administrator /active:no

:: delete adobe font type manager
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Drivers" /v "Adobe Type Manager" /f

:: disable USB autorun/play
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d "1" /f

:: disable camera access when locked
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /t REG_DWORD /d "1" /f

:: disable remote assistance
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowFullControl" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fEnableChatControl" /t REG_DWORD /d "0" /f
