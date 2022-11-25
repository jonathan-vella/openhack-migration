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

$ErrorActionPreference = 'SilentlyContinue'

Start-Transcript -Path "D:\PostRDSConfigure_log.txt"

Write-Output "Unregister PostRDSConfiguration scheduled task"
Unregister-ScheduledTask -TaskName "PostRDSConfiguration" -Confirm:$false

# Ping website to warm it up
Wait-For-Website('http://192.168.0.6')

# Enable licensing for RDS
<#Write-Output "Setting RDS licensing server to localhost"
$obj = Get-WmiObject -Namespace "Root/CIMV2/TerminalServices" Win32_TerminalServiceSetting
$obj.SetSpecifiedLicenseServerList("localhost")

Write-Output "Setting per-user licensing for RDS"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RCM\Licensing Core" -Name "LicensingMode" -Value 4
#>

# Reboot
Write-Output "Restarting host"
Stop-Transcript

Restart-Computer -Force