param (
    [switch]$DontPromptPasswordUpdateGPU
    )
    

$host.ui.RawUI.WindowTitle = "Cloud Gaming rig Setup Tool"

[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" 

Function ProgressWriter {
    param (
    [int]$percentcomplete,
    [string]$status
    )
    Write-Progress -Activity "Setting Up Your Machine" -Status $status -PercentComplete $PercentComplete
    }

$path = [Environment]::GetFolderPath("Desktop")
$currentusersid = Get-LocalUser "$env:USERNAME" | Select-Object SID | ft -HideTableHeaders | Out-String | ForEach-Object { $_.Trim() }

#show hidden items
function show-hidden-items {
    ProgressWriter -Status "Showing hidden files in Windows Explorer" -PercentComplete $PercentComplete
    set-itemproperty -path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1 | Out-Null
    }

#show file extensions
function show-file-extensions {
    ProgressWriter -Status "Showing file extensions in Windows Explorer" -PercentComplete $PercentComplete
    Set-itemproperty -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name HideFileExt -Value 0 | Out-Null
    }

#disable recent start menu items
function disable-recent-start-menu {
    New-Item -path HKLM:\SOFTWARE\Policies\Microsoft\Windows -name Explorer
    New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -PropertyType DWORD -Name HideRecentlyAddedApps -Value 1
    }

#Disables Server Manager opening on Startup
function disable-server-manager {
    ProgressWriter -Status "Disabling Windows Server Manager from starting at startup" -PercentComplete $PercentComplete
    Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask | Out-Null
    }

#Disable Devices
function disable-devices {
    ProgressWriter -Status "Disabling Microsoft Basic Display Adapter, Generic Non PNP Monitor and other devices" -PercentComplete $PercentComplete
    # Start-Process -FilePath "C:\Program Files\Parsec\vigem\10\x64\devcon.exe" -ArgumentList '/r disable "HDAUDIO\FUNC_01&VEN_10DE&DEV_0083&SUBSYS_10DE11A3*"'
    Get-PnpDevice | where {$_.friendlyname -like "Generic Non-PNP Monitor" -and $_.status -eq "OK"} | Disable-PnpDevice -confirm:$false
    Get-PnpDevice | where {$_.friendlyname -like "Microsoft Basic Display Adapter" -and $_.status -eq "OK"} | Disable-PnpDevice -confirm:$false
    Get-PnpDevice | where {$_.friendlyname -like "Google Graphics Array (GGA)" -and $_.status -eq "OK"} | Disable-PnpDevice -confirm:$false
    Get-PnpDevice | where {$_.friendlyname -like "Microsoft Hyper-V Video" -and $_.status -eq "OK"} | Disable-PnpDevice -confirm:$false
    # Start-Process -FilePath "C:\Program Files\Parsec\vigem\10\x64\devcon.exe" -ArgumentList '/r disable "PCI\VEN_1013&DEV_00B8*"'
    # Start-Process -FilePath "C:\Program Files\Parsec\vigem\10\x64\devcon.exe" -ArgumentList '/r disable "PCI\VEN_1D0F&DEV_1111*"'
    # Start-Process -FilePath "C:\Program Files\Parsec\vigem\10\x64\devcon.exe" -ArgumentList '/r disable "PCI\VEN_1AE0&DEV_A002*"'
    }

#Cleanup recent files
function clean-up-recent {
    ProgressWriter -Status "Delete recently accessed files list from Windows Explorer" -PercentComplete $PercentComplete
    remove-item "$env:AppData\Microsoft\Windows\Recent\*" -Recurse -Force | Out-Null
    }

Write-Host -foregroundcolor green "
                    ~Cloud Gaming rig Setup Script~

                    This script sets up your cloud computer
                    with a bunch of settings and drivers
                    to make your life easier.  
                    
                    It's provided with no warranty, 
                    so use it at your own risk.

                    This tool tested under:

                    OS:
                    Server 2025
                    
                    CLOUD SKU:
                    AWS G5.xlarge    ()
    
"   
$ScripttaskList = @(
"show-hidden-items";
"show-file-extensions";
"disable-server-manager";
"disable-devices";
"clean-up-recent";
)

foreach ($func in $ScripttaskList) {
    $PercentComplete =$($ScriptTaskList.IndexOf($func) / $ScripttaskList.Count * 100)
    & $func $PercentComplete
    }

Write-host "DONE!" -ForegroundColor black -BackgroundColor Green
if ($DontPromptPasswordUpdateGPU) {} 
Else {pause}


