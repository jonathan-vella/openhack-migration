Function Expand-Files {
    Param (
        [Object]$Files,
        [string]$Destination
    )

    foreach ($file in $files)
    {
        $fileName = $file.FullName

        write-output "Start unzip: $fileName to $Destination"
        
        #(new-object -com shell.application).namespace($Destination).CopyHere((new-object -com shell.application).namespace($fileName).Items(),16)
        $7zEXE = "$opsDir\7z\7za.exe"

        cmd /c "$7zEXE x -y -o$Destination $fileName" | Add-Content $cmdLogPath
        
        write-output "Finish unzip: $fileName to $Destination"
    }
}

Function Wait-For-Website {
    Param (
        [string]$Url
    )

    $i = 1
    while ($true) {

        try {
            Write-Output "Checking ($i)...please wait"
            $i++

            $response = Invoke-WebRequest -Uri $Url -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                return;
            }
        } catch {}

        Start-Sleep 2
    }
}

Function Wait-For-VM-Start {
    Param (
        [string]$VMName,
        [int]$AfterStartDelay=30
    )

    Write-Output "Checking state for VM $VMName..."
    while ((Get-VM -Name $VMName).State -ne "Running") {
        Write-Output "Starting VM $VMName..."
        Start-VM -Name $VMName

        for ($i = 1; $i -le $AfterStartDelay; $i++) {
            Write-Progress -Activity "Warming up VM $VMName..." -Status "Progress:" -PercentComplete ($i/$AfterStartDelay*100)
            Start-Sleep -Seconds 1
        }

        Write-Progress -Activity "Warming up VM $VMName..." -Status "Progress:" -Completed
    }
}

Function Optimize-VM-Rearm {
    Param (
        [string]$ComputerName,
        [string]$Username,
        [string]$Password,
        [string]$DomainName = ""
    )

    Write-Output "Getting IP for $ComputerName..."

    $vm = Get-VM -Name $ComputerName

    do {
        Write-Output "Waiting for IP for $ComputerName..."
        Start-Sleep -Seconds 5
    } until ($vm.NetworkAdapters[0].IPAddresses[0].Length -gt 0)

    $ip = $vm.NetworkAdapters[0].IPAddresses[0]
    Write-Output "Found IP $ip..."

    Write-Output "Creating credentials object..."
    if ($DomainName.Length -gt 0) {
        $localusername = "$DomainName\$Username"
    } else {
        $localusername = "$computerName\$Username"
    }

    $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    $localcredential = New-Object System.Management.Automation.PSCredential ($localusername, $securePassword)

    Write-Output "Re-arm (extend eval license) for VM $ComputerName at $ip..."
    set-item wsman:\localhost\Client\TrustedHosts -value $ip -Force

    Invoke-Command -ComputerName $ip -ScriptBlock { 
        Write-Output $env:COMPUTERNAME; 
        Start-Process "C:\Windows\System32\cscript.exe" -argumentlist "//B ""C:\Windows\System32\slmgr.vbs"" /rearm" -Wait;
        net accounts /maxpwage:unlimited; 
        Start-Sleep -Seconds 60; 
        Restart-Computer -Force 
    } -Credential $localcredential

    Write-Output "Re-arm complete"
}

$ErrorActionPreference = 'SilentlyContinue'
Import-Module BitsTransfer
Import-Module Defender

Start-Transcript -Path "D:\PostRebootConfigure_log.txt"
$cmdLogPath = "D:\PostRebootConfigure_log_cmd.txt"

# Create paths
Write-Output "Creating local directories"
$opsDir = "C:\OpsgilityTraining"
$vmDir = "F:\VirtualMachines"
$tempDir = "D:\"
New-Item -Path $vmDir -ItemType directory -Force

# Exclude VirtualMachines from Windows Defender scanning
Write-Output "Setting Defender exclusions"
Add-MpPreference -ExclusionPath "F:\VirtualMachines\"

# Unregister scheduled task so this script doesn't run again on next reboot
Write-Output "Unregister SetupVMs scheduled task"
Unregister-ScheduledTask -TaskName "SetUpVMs" -Confirm:$false

# Download 7z
Write-Output "Downloading 7z"
$7zaURL = "https://openhackguides.blob.core.windows.net/migration-open-hack-artifacts/7z/7za.exe"
$7zaDLLURL = "https://openhackguides.blob.core.windows.net/migration-open-hack-artifacts/7z/7za.dll"
$7zxaDLLURL = "https://openhackguides.blob.core.windows.net/migration-open-hack-artifacts/7z/7zxa.dll"

$7zDir = "$opsDir\7z"
New-Item -Path $7zDir -ItemType directory -Force

Start-BitsTransfer -Source $7zaURL -Destination "$7zDir\7za.exe"
Start-BitsTransfer -Source $7zaDLLURL -Destination "$7zDir\7za.dll"
Start-BitsTransfer -Source $7zxaDLLURL -Destination "$7zDir\7zxa.dll"

# Download AzCopy. We won't use the aks.ms/downloadazcopy link in case of breaking changes in later versions
Write-Output "Downloading azcopy"
$azcopyUrl = "https://openhackguides.blob.core.windows.net/migration-open-hack-artifacts/azcopy_windows_amd64_10.1.1.zip"
$azcopyZip = "$opsDir\azcopy.zip"
Start-BitsTransfer -Source $azcopyUrl -Destination $azcopyZip
$azcopyZipfile = Get-ChildItem -Path $azcopyZip
Write-Output "Unzip azcopy"
Expand-Files -Files $azcopyZipfile -Destination $opsDir

$azcopy = "$opsDir\azcopy_windows_amd64_10.1.1\azcopy.exe"

# Download VMs from blob storage
Write-Output "Downloading compressed VMs"
$container = 'https://openhackguides.blob.core.windows.net/migration-open-hack-artifacts'
$vmNames = @("cmad1","cmid1","cmdb1","cmaapp1","cmaweb1","cmapp1","cmweb1","cmvpn1")

foreach ($vmName in $vmNames) {
    $vmZip = "$vmName.zip"

    Write-Output "Downloading $vmZip..."
    cmd /c "$azcopy cp --check-md5 FailIfDifferentOrMissing $container/$vmZip $tempDir\$vmZip" | Add-Content $cmdLogPath
}

# Unzip the VMs
Write-Output "Decompressing VMs"
$zipfiles = Get-ChildItem -Path "$tempDir\*.zip"
Expand-Files -Files $zipfiles -Destination $vmDir

Write-Output "Configuring Hyper-V"

Write-Output "Creating Migrate appliance switch..."
$switchName = 'InternalMigrateSwitch'
New-VMSwitch -Name $switchName -SwitchType Internal
# Connect Azure Migrate switch to the NAT network
Write-Output "Creating migrate network..."
$adapter = Get-NetAdapter | Where-Object { $_.Name -like "*"+$switchName+"*" }
New-NetIPAddress -IPAddress 192.168.1.1 -PrefixLength 24 -InterfaceIndex $adapter.ifIndex

# Create the NAT network
<#Write-Output "Creating NAT network..."
$natName = "InternalNat"
New-NetNat -Name $natName -InternalIPInterfaceAddressPrefix 192.168.0.0/16
#>

# Create an internal switch with NAT
Write-Output "Creating NAT switch..."
$switchName = 'InternalNATSwitch'
New-VMSwitch -Name $switchName -SwitchType Internal
$adapter = Get-NetAdapter | Where-Object { $_.Name -like "*"+$switchName+"*" }

# Create an internal network (gateway first)
Write-Output "Creating internal network..."
New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceIndex $adapter.ifIndex

# Add NAT forwarders
Write-Output "Configuring host"

<#Write-Output "Adding NAT forwarders to host..."
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0" -ExternalPort 80   -Protocol TCP -InternalIPAddress "192.168.0.6" -InternalPort 80   -NatName $natName
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0" -ExternalPort 8080 -Protocol TCP -InternalIPAddress "192.168.0.4" -InternalPort 8080 -NatName $natName
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0" -ExternalPort 1433 -Protocol TCP -InternalIPAddress "192.168.0.3" -InternalPort 1433 -NatName $natName
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0" -ExternalPort 500  -Protocol UDP -InternalIPAddress "192.168.0.9" -InternalPort 500  -NatName $natName
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0" -ExternalPort 4500 -Protocol UDP -InternalIPAddress "192.168.0.9" -InternalPort 4500 -NatName $natName
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0" -ExternalPort 1701 -Protocol UDP -InternalIPAddress "192.168.0.9" -InternalPort 1701 -NatName $natName
#>

# Add a firewall rule for HTTP and SQL
Write-Output "Adding firewall rules..."
New-NetFirewallRule -DisplayName "HTTP Inbound" -Direction Inbound -LocalPort 80 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "HTTP Admin Inbound" -Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Microsoft SQL Server Inbound" -Direction Inbound -LocalPort 1433 -Protocol TCP -Action Allow

# Installing RAS
Write-Output "Installing and configuring RAS"
Install-WindowsFeature Routing -IncludeManagementTools
Write-Output "Disabling DHCP for RAS..."
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\RemoteAccess\Parameters\IP' -Name InitialAddressPoolSize -Type DWORD -Value 0
Write-Output "Enabling legacy management..."
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\RemoteAccess\Parameters' -Name ModernStackEnabled -Type DWORD -Value 0
Write-Output "Installing RAS with VPN disabled..."
Install-RemoteAccess -VpnType RoutingOnly

$externalNIC = "Ethernet"
$internalNIC = "vEthernet (InternalNATSwitch)"

cmd.exe /c "netsh routing ip nat install"
cmd.exe /c "netsh routing ip nat add interface ""$externalNIC"""
cmd.exe /c "netsh routing ip nat set interface ""$externalNIC"" mode=full"
cmd.exe /c "netsh routing ip nat add interface ""$internalNIC"""

Write-Output "Configuring NAT services and ports..."
cmd.exe /c "netsh routing ip nat add portmapping name=""$externalNIC"" tcp 0.0.0.0 80 192.168.0.6 80"
cmd.exe /c "netsh routing ip nat add portmapping name=""$externalNIC"" tcp 0.0.0.0 8080 192.168.0.4 8080"
cmd.exe /c "netsh routing ip nat add portmapping name=""$externalNIC"" tcp 0.0.0.0 1433 192.168.0.3 1433"
cmd.exe /c "netsh routing ip nat add portmapping name=""$externalNIC"" udp 0.0.0.0 500 192.168.0.9 500"
cmd.exe /c "netsh routing ip nat add portmapping name=""$externalNIC"" udp 0.0.0.0 1701 192.168.0.9 1701"
cmd.exe /c "netsh routing ip nat add portmapping name=""$externalNIC"" udp 0.0.0.0 4500 192.168.0.9 4500"

# Enable Enhanced Session Mode on Host
Write-Output "Configuring Hyper-V"
Write-Output "Configuring enhanced session mode..."
Set-VMHost -EnableEnhancedSessionMode $true

# Create the nested Windows VMs - from VHDs
Write-Output "Creating VMs"
Write-Output "Creating cmad1..."
New-VM -Name cmad1 -MemoryStartupBytes 4GB -BootDevice VHD -VHDPath "$vmdir\cmad1\cmad1.vhdx" -Path "$vmdir\cmad1" -Generation 2 -Switch $switchName 
Add-VMHardDiskDrive -VMName cmad1 -Path "$vmdir\cmad1\cmad1_data.vhdx" -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 1
Write-Output "Creating cmdb1..."
New-VM -Name cmdb1 -MemoryStartupBytes 8GB -BootDevice VHD -VHDPath "$vmdir\cmdb1\cmdb1.vhdx" -Path "$vmdir\cmdb1" -Generation 1 -Switch $switchName
Set-VMProcessor cmdb1 -Count 2 -Maximum 100 -RelativeWeight 100
Add-VMHardDiskDrive -VMName cmdb1 -Path "$vmdir\cmdb1\cmdb1_data.vhd" -ControllerType IDE -ControllerNumber 0 -ControllerLocation 1
Add-VMHardDiskDrive -VMName cmdb1 -Path "$vmdir\cmdb1\cmdb1_logs.vhd" -ControllerType IDE -ControllerNumber 1 -ControllerLocation 1
Write-Output "Creating cmaweb1..."
New-VM -Name cmaweb1 -MemoryStartupBytes 4GB -BootDevice VHD -VHDPath "$vmdir\cmaweb1\cmaweb1.vhdx" -Path "$vmdir\cmaweb1" -Generation 1 -Switch $switchName
Write-Output "Creating cmaapp1..."
New-VM -Name cmaapp1 -MemoryStartupBytes 4GB -BootDevice VHD -VHDPath "$vmdir\cmaapp1\cmaapp1.vhdx" -Path "$vmdir\cmaapp1" -Generation 1 -Switch $switchName
Write-Output "Creating cmweb1..."
New-VM -Name cmweb1 -MemoryStartupBytes 4GB -BootDevice VHD -VHDPath "$vmdir\cmweb1\cmweb1.vhdx" -Path "$vmdir\cmweb1" -Generation 1 -Switch $switchName
Write-Output "Creating cmapp1..."
New-VM -Name cmapp1 -MemoryStartupBytes 4GB -BootDevice VHD -VHDPath "$vmdir\cmapp1\cmapp1.vhdx" -Path "$vmdir\cmapp1" -Generation 1 -Switch $switchName
Write-Output "Creating cmid1..."
New-VM -Name cmid1 -MemoryStartupBytes 2GB -BootDevice VHD -VHDPath "$vmdir\cmid1\cmid1.vhdx" -Path "$vmdir\cmid1" -Generation 2 -Switch $switchName
Write-Output "Creating cmid1..."
New-VM -Name cmvpn1 -MemoryStartupBytes 2GB -BootDevice VHD -VHDPath "$vmdir\cmvpn1\cmvpn1.vhdx" -Path "$vmdir\cmvpn1" -Generation 2 -Switch $switchName

Write-Output "VMs created. Pausing for 30 seconds..."
Start-Sleep -Seconds 30

# Configure IP addresses (don't change the IPs! VM config depends on them)
Write-Output "Configuring VMs"

Write-Output "Setting network config on cmad1..."
Set-VMNetworkAdapter -VMName cmad1 -StaticMacAddress "00155D000402"
Start-Sleep -Seconds 5

Write-Output "Setting network config on cmdb1..."
Set-VMNetworkAdapter -VMName cmdb1 -StaticMacAddress "00155D000403"
Start-Sleep -Seconds 5

Write-Output "Setting network config on cmaweb1..."
Set-VMNetworkAdapter -VMName cmaweb1 -StaticMacAddress "00155D000404"
Start-Sleep -Seconds 5

Write-Output "Setting network config on cmaapp1..."
Set-VMNetworkAdapter -VMName cmaapp1 -StaticMacAddress "00155D000405"
Start-Sleep -Seconds 5

Write-Output "Setting network config on cmweb1..."
Set-VMNetworkAdapter -VMName cmweb1 -StaticMacAddress "00155D000406"
Start-Sleep -Seconds 5

Write-Output "Setting network config on cmapp1..."
Set-VMNetworkAdapter -VMName cmapp1 -StaticMacAddress "00155D000407"
Start-Sleep -Seconds 5

Write-Output "Setting network config on cmid1..."
Set-VMNetworkAdapter -VMName cmid1 -StaticMacAddress "00155D000408"
Start-Sleep -Seconds 5

Write-Output "Setting network config on cmvpn1..."
Set-VMNetworkAdapter -VMName cmvpn1 -StaticMacAddress "00155D000409"
Start-Sleep -Seconds 5

# Disable VMQ on all VMs
Write-Output "Setting VMQ Weight to 0 (disabled) on all network adapters"
Get-VMNetworkAdapter -All | Set-VMNetworkAdapter -VmqWeight 0

# We always want the VMs to start with the host and shut down cleanly with the host
# (If they just save state, which is the default, they can break if the host re-starts on a different CPU architecture)
Write-Output "Setting VMs to automatically start after host reboot"
Get-VM | Set-VM -AutomaticStartAction Start -AutomaticStopAction ShutDown

# Checkpoint all VMs
Write-Output "Setting bootstrap checkpoint"
Checkpoint-VM -Name "cmad1" -SnapshotName "Before rearm"
Checkpoint-VM -Name "cmdb1" -SnapshotName "Before rearm"
Checkpoint-VM -Name "cmaapp1" -SnapshotName "Before rearm"
Checkpoint-VM -Name "cmapp1" -SnapshotName "Before rearm"
Checkpoint-VM -Name "cmaweb1" -SnapshotName "Before rearm"
Checkpoint-VM -Name "cmweb1" -SnapshotName "Before rearm"
Checkpoint-VM -Name "cmid1" -SnapshotName "Before rearm"
Checkpoint-VM -Name "cmvpn1" -SnapshotName "Before rearm"

# Start all the VMs
Write-Output "VMs present. Waiting for VMs to start..."
Wait-For-VM-Start -VMName "cmad1" -AfterStartDelay 300
Wait-For-VM-Start -VMName "cmdb1" -AfterStartDelay 60
Wait-For-VM-Start -VMName "cmaapp1" -AfterStartDelay 60
Wait-For-VM-Start -VMName "cmapp1" -AfterStartDelay 60
Wait-For-VM-Start -VMName "cmaweb1" -AfterStartDelay 60
Wait-For-VM-Start -VMName "cmweb1" -AfterStartDelay 60
Wait-For-VM-Start -VMName "cmid1" -AfterStartDelay 60
Wait-For-VM-Start -VMName "cmvpn1" -AfterStartDelay 60

# Ping website to warm it up
Wait-For-Website('http://192.168.0.6')

Write-Output "Rearming evaluation licenses"
Write-Output "Rearming cmad1..."
Optimize-VM-Rearm -ComputerName "cmad1" -Username "Administrator" -Password "demo!pass123" -DomainName "CONTOSOMORTGAGE"
Write-Output "Rearming cmdb1..."
Optimize-VM-Rearm -ComputerName "cmdb1" -Username "Administrator" -Password "demo!pass123"
Write-Output "Rearming cmaapp1..."
Optimize-VM-Rearm -ComputerName "cmaapp1" -Username "Administrator" -Password "demo!pass123"
Write-Output "Rearming cmapp1..."
Optimize-VM-Rearm -ComputerName "cmapp1" -Username "Administrator" -Password "demo!pass123"
Write-Output "Rearming cmaweb1..."
Optimize-VM-Rearm -ComputerName "cmaweb1" -Username "Administrator" -Password "demo!pass123"
Write-Output "Rearming cmweb1..."
Optimize-VM-Rearm -ComputerName "cmweb1" -Username "Administrator" -Password "demo!pass123"
Write-Output "Rearming cmid1..."
Optimize-VM-Rearm -ComputerName "cmid1" -Username "Administrator" -Password "demo!pass123"
Write-Output "Rearming cmvpn1..."
Optimize-VM-Rearm -ComputerName "cmvpn1" -Username "Administrator" -Password "demo!pass123"

Write-Output "Setting post-rearm checkpoint"
Checkpoint-VM -Name "cmad1" -SnapshotName "After rearm"
Checkpoint-VM -Name "cmdb1" -SnapshotName "After rearm"
Checkpoint-VM -Name "cmaapp1" -SnapshotName "After rearm"
Checkpoint-VM -Name "cmapp1" -SnapshotName "After rearm"
Checkpoint-VM -Name "cmaweb1" -SnapshotName "After rearm"
Checkpoint-VM -Name "cmweb1" -SnapshotName "After rearm"
Checkpoint-VM -Name "cmid1" -SnapshotName "After rearm"
Checkpoint-VM -Name "cmvpn1" -SnapshotName "After rearm"

# Ping website to warm it up
Wait-For-Website('http://192.168.0.6')

# Register task to run post-reboot script once host is rebooted after Hyper-V install
Write-Output "Registering scheduled task for post-RDS configuration"
$action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe" -Argument "-executionPolicy Bypass -NoProfile -File $opsDir\PostRDSConfigure.ps1"
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName "PostRDSConfiguration" -Action $action -Trigger $trigger -Principal $principal

# Config complete
New-Item "D:\PostRebootConfigure_complete.txt"
Set-Content "D:\PostRebootConfigure_complete.txt" 'Configuration complete'

# Install RDS
Write-Output "Installing RDS role"
Add-WindowsFeature -Name RDS-RD-Server -IncludeAllSubFeature -Restart

Stop-Transcript