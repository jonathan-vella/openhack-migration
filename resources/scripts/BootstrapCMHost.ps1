$ErrorActionPreference = 'SilentlyContinue'

Start-Transcript -Path "D:\BootstrapCMHost_log.txt"

# Disable IE ESC
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0
Stop-Process -Name Explorer

# Install Chrome
Write-Output "Installing Google Chrome"
$Path = $env:TEMP; 
$Installer = "chrome_installer.exe"
Invoke-WebRequest "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile $Path\$Installer
Start-Process -FilePath $Path\$Installer -Args "/silent /install" -Verb RunAs -Wait
Remove-Item $Path\$Installer

# Create path
$opsDir = "C:\OpsgilityTraining"
New-Item -Path $opsDir -ItemType directory -Force

# Format data disk
Write-Output "Formatting data disk"
$disk = Get-Disk | Where-Object { $_.PartitionStyle -eq "RAW" }
Initialize-Disk -Number $disk.DiskNumber -PartitionStyle GPT
New-Partition -DiskNumber $disk.DiskNumber -UseMaximumSize -DriveLetter F
Format-Volume -DriveLetter F -FileSystem NTFS -NewFileSystemLabel DATA

# Download scripts for nested Hyper-V VMs, and various other files we'll need during the lab
$downloads = @( `
     "https://openhackguides.blob.core.windows.net/migration-open-hack-artifacts/scripts/PostRebootConfigure.ps1" `
    ,"https://openhackguides.blob.core.windows.net/migration-open-hack-artifacts/scripts/PostRDSConfigure.ps1" `
    ,"https://openhackguides.blob.core.windows.net/migration-open-hack-artifacts/scripts/ConfigureAzureMigrateApplianceNetwork.ps1" `
    ,"https://openhackguides.blob.core.windows.net/migration-open-hack-artifacts/scripts/UploadVHDs.ps1" `
    ,"https://download.microsoft.com/download/C/6/3/C63D8695-CEF2-43C3-AF0A-4989507E429B/DataMigrationAssistant.msi" `
    )

$destinationFiles = @( `
     "$opsDir\PostRebootConfigure.ps1" `
    ,"$opsDir\PostRDSConfigure.ps1" `
    ,"$opsDir\ConfigureAzureMigrateApplianceNetwork.ps1" `
    ,"$opsDir\UploadVHDs.ps1" `
    ,"$opsDir\DataMigrationAssistant.msi" `
    )

Import-Module BitsTransfer
Write-Output "Downlading bootstrip files"
Start-BitsTransfer -Source $downloads -Destination $destinationFiles

# Register task to run post-reboot script once host is rebooted after Hyper-V install
$action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe" -Argument "-executionPolicy Bypass -NoProfile -File $opsDir\PostRebootConfigure.ps1"
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName "SetUpVMs" -Action $action -Trigger $trigger -Principal $principal

# Install and configure DHCP service (used by Azure Migrate appliance so DNS lookup of the host works)
Write-Output "Installing DHCP role"
$dnsClient = Get-DnsClient | Where-Object {$_.InterfaceAlias -eq "Ethernet" }
Install-WindowsFeature -Name "DHCP" -IncludeManagementTools

Write-Output "Configuring Migrate DHCP scope..."
Add-DhcpServerv4Scope -Name "Migrate" -StartRange 192.168.1.1 -EndRange 192.168.1.254 -SubnetMask 255.255.255.0 -State Active
Add-DhcpServerv4ExclusionRange -ScopeId 192.168.1.0 -StartRange 192.168.1.1 -EndRange 192.168.1.15
Set-DhcpServerv4OptionValue -DnsDomain $dnsClient.ConnectionSpecificSuffix -DnsServer 168.63.129.16 -ScopeId 192.168.1.0
Set-DhcpServerv4OptionValue -OptionID 3 -Value 192.168.1.1 -ScopeId 192.168.1.0
Set-DhcpServerv4Scope -ScopeId 192.168.1.0 -LeaseDuration 1.00:00:00

Write-Output "Configuring Nested VMs DHCP scope..."
Add-DhcpServerV4Scope -Name "Nested VMs" -StartRange 192.168.0.1 -EndRange 192.168.0.254 -SubnetMask 255.255.255.0 -State Active
Set-DhcpServerV4OptionValue -DnsServer 192.168.0.2 -Router 192.168.0.1 -ScopeId 192.168.0.0 -Force
Remove-DhcpServerv4OptionValue -OptionID 15 -ScopeId 192.168.0.0
# cmad1
Add-DhcpServerv4Reservation -IPAddress 192.168.0.2 -ClientId "00-15-5D-00-04-02" -Description "cmad1 reservation" -ScopeId 192.168.0.0
# cmdb1
Add-DhcpServerv4Reservation -IPAddress 192.168.0.3 -ClientId "00-15-5D-00-04-03" -Description "cmdb1 reservation" -ScopeId 192.168.0.0
# cmaweb1
Add-DhcpServerv4Reservation -IPAddress 192.168.0.4 -ClientId "00-15-5D-00-04-04" -Description "cmaweb1 reservation" -ScopeId 192.168.0.0
# cmaapp1
Add-DhcpServerv4Reservation -IPAddress 192.168.0.5 -ClientId "00-15-5D-00-04-05" -Description "cmaapp1 reservation" -ScopeId 192.168.0.0
# cmweb1
Add-DhcpServerv4Reservation -IPAddress 192.168.0.6 -ClientId "00-15-5D-00-04-06" -Description "cmweb1 reservation" -ScopeId 192.168.0.0
# cmapp1
Add-DhcpServerv4Reservation -IPAddress 192.168.0.7 -ClientId "00-15-5D-00-04-07" -Description "cmapp1 reservation" -ScopeId 192.168.0.0
# cmid1
Add-DhcpServerv4Reservation -IPAddress 192.168.0.8 -ClientId "00-15-5D-00-04-08" -Description "cmid1 reservation" -ScopeId 192.168.0.0
# cmvpn1
Add-DhcpServerv4Reservation -IPAddress 192.168.0.9 -ClientId "00-15-5D-00-04-09" -Description "cmvpn1 reservation" -ScopeId 192.168.0.0

Write-Output "Restarting DHCP service"
cmd /c "netsh dhcp add securitygroups"
Restart-Service dhcpserver
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12" -Name "ConfigurationState" -Value 2

# Create additional users and add to local admins
Write-Output "Creating local users for RDS"
for ($i = 2; $i -le 6; $i++) {
    $securePassword = ConvertTo-SecureString "demo!pass123" -AsPlainText -Force

    New-LocalUser "demouser$i" -Password $securePassword -FullName "demouser$i"

    Add-LocalGroupMember -Group "Administrators" -Member "demouser$i"
}

# Install Hyper-V and reboot
Write-Output "Installing Hyper-V role"
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart

Stop-Transcript