cls
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
					
"                                         
Write-Output "Setting up Environment"

# simply run PostInstall.ps1
# Unblock -> run
Write-Output "Unblocking files..."
Get-ChildItem -Path $PSScriptRoot\* -Recurse | Unblock-File
Write-Output "Starting main script"
start-process powershell.exe -verb RunAS -argument "-file $PSScriptRoot\PostInstall\PostInstall.ps1" -Wait
Write-Host "The setup is complete. This window can now be closed." -foregroundcolor green
stop-process -Id $PID
