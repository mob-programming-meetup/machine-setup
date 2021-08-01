# This script
# iwr -useb https://raw.githubusercontent.com/JayBazuzi/machine-setup/main/windows.ps1 | iex
 
Write-Host -Foreground yellow "Warning: You will need to Reboot when done or AnyDesk will not work properly"

#Requires -RunAsAdministrator

# only run at first boot
$alreadyInstalledMarkerFile = "$env:TEMP\cloud-desktop\installed-already.txt"
if (Test-Path $alreadyInstalledMarkerFile -PathType leaf) {
    exit
}
mkdir "$env:TEMP\cloud-desktop"
echo "$null" >> "$alreadyInstalledMarkerFile"

iwr -useb cin.st | iex
choco feature enable --name=allowGlobalConfirmation
choco feature disable --name=showDownloadProgress

cinst win-no-annoy

cinst firefox googlechrome setdefaultbrowser
SetDefaultBrowser.exe HKLM Firefox-308046B0AF4A39CB

cinst git poshgit # not installing git-fork and github-desktop for now, as it doesn't work when running the script from the cloud 

cinst notepadplusplus sublimetext3
cinst beyondcompare
cinst procexp

# Install Mobster Mob-Programming timer
pushd "$env:TEMP\cloud-desktop"
Invoke-WebRequest https://github.com/dillonkearns/mobster/releases/download/v0.0.48/Mobster-Setup-0.0.48.exe -OutFile Mobster-Setup-0.0.48.exe
.\Mobster-Setup-0.0.48.exe /S 
popd

# delete annoying Windows notification sounds
Remove-Item -ErrorAction SilentlyContinue -Recurse HKCU:\AppEvents\Schemes
Set-Service Audiosrv -StartupType Automatic

# Show seconds in the clock so screen sharing latency is obvious to all
Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced ShowSecondsInSystemClock 1
# Open new explorer windows to This PC instead of Quick Access
Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced LaunchTo 1

# Clean up the task bar
cinst syspin --ignore-checksums
syspin "C:\Program Files\Git\git-bash.exe" "Pin to taskbar"
# syspin "$ENV:LocalAppData\Fork\Fork.exe" "Pin to taskbar"
# syspin "$ENV:LocalAppData\GitHubDesktop\GitHubDesktop.exe" "Pin to taskbar"
syspin "c:\Program Files\Mozilla Firefox\firefox.exe" "Pin to taskbar"
syspin "C:\Program Files\Google\Chrome\Application\chrome.exe" "Pin to taskbar"
syspin "C:\Program Files\internet explorer\iexplore.exe" "Unpin from taskbar"

cinst taskbar-winconfig --params "'/CORTANA:no /INK:no /PEOPLE:no /TASKVIEW:no /KEYBOARD:no'"^

# Set Timezone
Set-Timezone -Id "W. Europe Standard Time" -PassThru
 
# Often fails because anydesk chocolatey authoring is bad
cinst anydesk --ignore-checksums
syspin "C:\ProgramData\chocolatey\lib\anydesk.portable\tools\AnyDesk.exe" "Pin to taskbar"

