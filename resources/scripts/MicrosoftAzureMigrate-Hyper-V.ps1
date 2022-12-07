
# ------------------------------------------------------------------------------
#  <copyright file="MicrosoftAzureMigrate-Hyper-V.ps1" company="Microsoft">
#      Copyright (c) Microsoft Corporation. All rights reserved.
#  </copyright>
#
#  Description: Enable WinRM and dependencies for Azure Migrate Hyper-V Host.

#  Version: 2.0.2.0
# ------------------------------------------------------------------------------

$global:IsServerSKU = $false
# Default value.
[System.Version]$global:PsVer = "0.0"
# Minumum supported WMF version.
[System.Version]$global:WmfVer = "5.1"

function ValidatePSVersion
{
    [System.Version]$minVer = "4.0"

    Log-Info "Verifying the PowerShell version to run the script...”

    if ($PSVersionTable.PSVersion)
    {
        $global:PsVer = $PSVersionTable.PSVersion
    }
    
    If ($global:PsVer -lt $minVer)
    {
        Log-Error "PowerShell version $minVer, or higher is required. Current PowerShell version is $global:PsVer. Exiting..."
        exit 1;
    }
    else
    {
        Log-Success "[OK]`n"
    }
}

function ValidateOSVersion
{
    [System.Version]$ver = "0.0"
    [System.Version]$minVer = "6.3"

    Log-Info "Verifying supported Operating System version...”

    $OS = Get-WmiObject Win32_OperatingSystem
    $ver = $OS.Version

    If ($ver -lt $minVer)
    {
        Log-Error "Minimum supported OS version required is $minVer, current version in $OS.Version. Exiting..."
        exit 2;
    }
    else
    {
        if ($OS.Caption.contains("Server") -eq $true)
        {
            $global:IsServerSKU = $true
        }
        
        Log-Success "[OK]`n"
    }
}

function ValidateHyperVRole
{
    # Validate Hyper-V is installed on windows server.
    Log-Info "Verifying Hyper-V Role is installed on the host...”

    if ($global:IsServerSKU -eq $true)
    {
        $hyperv = Get-WindowsFeature -Name Hyper-V
        if ($hyperv.Installed -eq $true)
        {
            $Installed = $true
        }
    }
    else
    {
        $hyperv = Get-WindowsOptionalFeature -online -FeatureName Microsoft-Hyper-V-All
        if ($hyperv.State -eq "Enabled")
        {
            $Installed = $true
        }
    }
        
    if($Installed -eq "True") 
    {
        Log-Success "[OK]`n"
    }
    else
    {
        Log-Error "Hyper-V Role is not enabled. Exiting..."
        exit 3;
    }
}

function ValidateUserRole
{
    [System.Security.Principal.WindowsBuiltInRole]$expectedRole = [Security.Principal.WindowsBuiltinRole]::Administrator
    $myIdentity=[System.Security.Principal.WindowsIdentity]::GetCurrent()
    $curUserRole=new-object System.Security.Principal.WindowsPrincipal($myIdentity)

    Log-Info "Verifying current session is using elevated priviledge..."

    if ($curUserRole.IsInRole($expectedRole))
    {
        Log-Success "[OK]`n"
    } else 
    {
        Log-Error "Current session is not using $expectedRole role. Please re-launch with elevated priviledge. Exiting..."
        exit 4
    }
}

function EnableWinRM
{
    $consent = Read-Host "WinRM is a mandatory requirement for Azure Migrate. Proceed with enabling Remote Management? [Y/N(Exit)]"
    if ($consent -eq 'Y' -or $consent -eq 'y')
    {
        Log-Info "Enabling WinRM settings on the host..."
        $error.Clear()
        
        winrm qc
        
        if ($error.Count -gt 0)
        {
            Log-Error "Failure hit while enabling WinRM settings on the host due to $Error."
            Log-Error "Exiting..."
            exit 5
        }
        else
        {
            Log-Success "[Done]`n"
        }
    }
    else
    {
         Log-Error "User has selected not to enable WinRM settings. Exiting..."
         exit 5
    }
}

function EnablePSRemoting
{
    $consent = Read-Host "PowerShell Remoting is a mandatory requirement for Azure Migrate. Proceed with enabling PowerShell Remoting? [Y/N (Exit)]"
    if ($consent -eq 'Y' -or $consent -eq 'y')
    {
        Log-Info "Enabling PowerShell Remoting on the host..."
        $error.Clear()
        
        Enable-PSRemoting -Force -Verbose

        if ($error.Count -gt 0)
        {
            Log-Error "Failure hit while enabling PowerShell Remoting on the host due to $Error."
            Log-Error "Exiting..."
            exit 6
        }
        else
        {
            Log-Success "[Done]`n"
        }
    }
    else
    {
         Log-Error "User has selected not to enable PowerShell Remoting. Exiting..."
         exit 6
    }

    # TODO: Add Network Profile Check
}

function AddUserToLocalGroup
{
    param(
    [string] $Groupname,
    [string] $Username
    )

    $error.Clear()
    Get-LocalGroupMember -Group $Groupname -Member $Username -ErrorAction SilentlyContinue
    
    if ($error.Count -gt 0)
    {
        $error.Clear()
        Add-LocalGroupMember -Group $Groupname -Member $cred.UserName
        if($error.Count -eq 0)
        {
            Log-Info "User $($cred.UserName) added to group $Groupname."
        }
        else
        {
            Log-Error "Failed to add user $($cred.UserName) to group $Groupname."
            return
        }
    }
    else
    {
        Log-Info "User $($cred.UserName) is already a member of group $Groupname."
    }

    Log-Success "[Done]`n"
}

function CreateLocalUserForAzMig
{
    $consent = Read-Host "Do you want to create non-administrator local user for Azure Migrate and Hyper-V Host communication? [Y/N]"
    if ($consent -eq 'Y' -or $consent -eq 'y')
    {
        Log-Info "Creating LocalUser on the host..."

        $cred = get-credential
        $op = Get-LocalUser | Where-Object {$_.Name -eq $cred.UserName}

        if ( -not $op)
        {
            $error.Clear()
            New-LocalUser -Name $cred.UserName -AccountNeverExpires -Password $cred.Password -PasswordNeverExpires
            if($error.Count -ne 0)
            {
                Log-Error "Failed to create the user $($cred.UserName)."
                exit 7
            }
        }
        else
        {
            Log-Info "User $($cred.UserName) already exists on the host."
        }

        # TODO: Need to move to SSID based ID instead of name for localized hosts.
        AddUserToLocalGroup "Remote Management Users"  $cred.UserName
        AddUserToLocalGroup "Hyper-V Administrators" $cred.UserName
        AddUserToLocalGroup "Performance Monitor Users" $cred.UserName
    }
    else
    {
        Log-Warning "User has selected not to create a local user. Continuing...`n"
    }
}

function EnableCredSSP
{
    $consent = Read-Host "Do you use SMB share(s) to store the VHDs? [Y/N]"
    if ($consent -eq 'Y' -or $consent -eq 'y')
    {
        Log-Info "Enabling CredSSP on the host..."
        $error.clear()

        Enable-WSManCredSSP -Role Server -Force
        Set-Item -Path "WSMan:\localhost\Service\Auth\CredSSP" -Value $true        
        
        if ($error.Count -gt 0)
        {
            Log-Error "Failure hit while enabling CredSSP on the host due to $Error"
            Log-Error "Exiting..."
            exit 6
        }
        else
        {
            Log-Warning "Corresponding change in Azure Migrate Appliance is required to enable CredSSP successfully."
            Log-Warning "Learn more: https://docs.microsoft.com/en-us/powershell/module/microsoft.wsman.management/enable-wsmancredssp?view=powershell-6."
            Log-Success "[Done]`n"
            # TODO: Appliance side settings for CredSSP still needs to be done. Call this out as a message here.
        }

        <#Needs client/Appliance side settings change
        Set-Item -Path "WSMan:\localhost\Client\Auth\CredSSP" -Value $true
        New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation -Name AllowFreshCredentialsWhenNTLMOnly -Force
        New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\AllowFreshCredentialsWhenNTLMOnly -Name 1 -Value * -PropertyType String
        $key = 'hklm:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation'
        if (!(Test-Path $key)) {
            md $key
        }
        New-ItemProperty -Path $key -Name AllowFreshCredentials -Value 1 -PropertyType Dword -Force            

        $key = Join-Path $key 'AllowFreshCredentials'
        if (!(Test-Path $key)) {
            md $key
        }
        $i = 1
        $allowed |% {
            # Script does not take into account existing entries in this key
            New-ItemProperty -Path $key -Name $i -Value $_ -PropertyType String -Force
            $i++
        }
        #>
    }
    else
    {
        Log-Warning "User has selected not to enable CredSPP. Continuing...`n"
    }
}

function EnableIntegrationServicesOnVMs
{
    Log-Info "Verifying Data Exchange Integration Service is enabled on all VMs on the host."

    $vmList = get-vm -ErrorAction SilentlyContinue
    $count = 0
    foreach($vm in $vmList)
    {
      $KVPSetting = $vm | get-VMIntegrationService -Name "Key-Value Pair Exchange"
      if ($KVPSetting.Enabled -eq $false)
      {
          Log-Info "VM Properties like OSName, IP Address etc. need Data Exchange Integration Service to be enabled. One or more VMs on this host has this setting as disabled."
          $consent = Read-Host "Enable Data Exchange Integation Service on the VMs? [Y/N]"
          if ($consent -ne 'Y' -and $consent -ne 'y')
          {
             Log-Warning "Permission denied to enable Data Exchange Integration Service. Continuing...`n"
             return
          }

          $vm | Enable-VMIntegrationService -Name "Key-Value Pair Exchange"
          Log-Info "Data Exchange Integation Service found disabled. Enabling it on $vm."
          $count++
       }
    }

    if ($vmList.count -eq 0)
    {
        Log-Warning "No VMs found on this host.`n"
    }
    elseif ($count -eq 0)
    {
        Log-Success "$($vmList.count) VMs has the Data Exchange Integration Service already enabled. No settings changed.`n"
    }
    else
    {
        $diff = $vmList.count - $count
        Log-Info "Data Exchange Integration Service was enabled for $diff VMs. Data Exchange Integration Service was already enabled on $($vmList.count) VMs."
        Log-Success "[Done]`n"
    }
}

function OpenPortsForWinRM
{
    Log-Info "Azure Migrate needs to enable In-bound WinRM traffic on Port(s): 5985, 5986"
    $consent = Read-Host "Configure firewall to open these ports? [Y/N(Exit)]"
          
    if ($consent -eq 'Y' -or $consent -eq 'y')
    {
        $Error.Clear()
        New-NetFirewallRule -DisplayName 'WinRM Inbound' -Profile @('Domain', 'Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('5985', '5986')
        if ($error.Count -gt 0)
        {
            Log-Error "Failed to allow WinRM Inbound traffic on ports: 5985, 5986`n"
            exit 7
        }
        else
        {
            Log-Success "[Done]`n"
        }
    }
    else
    {
        Log-Error "`User has selected not to allow inbound connection on WinRM port. Exiting..."
        exit 7
    }
}

$CreateTemplateLog = "HyperVLog" + [DateTime]::Now.ToString('_dd-MMM-yyyy-HH-mm-ss') + ".log"

## This routine writes the output string to the console and also to a log file.
function Log-Info([string] $OutputText)
{
    Write-Host $OutputText 
    $OutputText = [string][DateTime]::Now + " " + $OutputText
    $OutputText | %{ Out-File -filepath $CreateTemplateLog -inputobject $_ -append -encoding "ASCII" }
}

## This routine writes the output string to the console and also to a log file.
function Log-Warning([string] $OutputText)
{
    Write-Host $OutputText -ForegroundColor Yellow
    $OutputText = [string][DateTime]::Now + " " + $OutputText
    $OutputText | %{ Out-File -filepath $CreateTemplateLog -inputobject $_ -append -encoding "ASCII" }
}

function Log-Success([string] $OutputText)
{
    Write-Host $OutputText -ForegroundColor Green
    $OutputText = [string][DateTime]::Now + " " + $OutputText
    $OutputText | %{ Out-File -filepath $CreateTemplateLog -inputobject $_ -append -encoding "ASCII" }
}

## This routine writes the output string to the console and also to a log file.
function Log-Error([string] $OutputText)
{
    Write-Host $OutputText -ForegroundColor Red
    $OutputText = [string][DateTime]::Now + " " + $OutputText
    $OutputText | %{ Out-File -filepath $CreateTemplateLog -inputobject $_ -append -encoding "ASCII" }
}

try
{
    $Error.Clear()

    ValidatePSVersion
    ValidateUserRole
    ValidateOSVersion
    ValidateHyperVRole
    EnableWinRM
    EnablePSRemoting
    OpenPortsForWinRM
    EnableIntegrationServicesOnVMs
    EnableCredSSP

    if ($global:PsVer -lt $global:WmfVer)
    {
        Log-Error "This script requires WMF version 5.1 to create localuser. Skipping local user creation."
        Log-Info "To download and install WMF5.1 go to https://www.microsoft.com/en-us/download/confirmation.aspx?id=54616."
        Log-Warning "Please Note:"
        Log-Warning "1. This installation will require the host to be restarted."
        Log-Warning "2. Local user which is part of the group Hyper-V Administrators, Performance Monitor Users and Remote Management Users can be used for Azure Migrate Operations.`n"
    }
    else
    {
        CreateLocalUserForAzMig        
    }

    Log-Success "Script has completed the selected operations successfully on the host."
}
catch
{
    $Error | ForEach-Object { Log-Error $_}
    Log-Error "`nPlease execute the script again after fixing the issue(s)."
}
# SIG # Begin signature block
# MIIjgwYJKoZIhvcNAQcCoIIjdDCCI3ACAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAkdCKlnLd0FYyq
# lVJNXC75WMMii02lorc6N8f6dxcSYqCCDYEwggX/MIID56ADAgECAhMzAAABUZ6N
# j0Bxow5BAAAAAAFRMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMTkwNTAyMjEzNzQ2WhcNMjAwNTAyMjEzNzQ2WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQCVWsaGaUcdNB7xVcNmdfZiVBhYFGcn8KMqxgNIvOZWNH9JYQLuhHhmJ5RWISy1
# oey3zTuxqLbkHAdmbeU8NFMo49Pv71MgIS9IG/EtqwOH7upan+lIq6NOcw5fO6Os
# +12R0Q28MzGn+3y7F2mKDnopVu0sEufy453gxz16M8bAw4+QXuv7+fR9WzRJ2CpU
# 62wQKYiFQMfew6Vh5fuPoXloN3k6+Qlz7zgcT4YRmxzx7jMVpP/uvK6sZcBxQ3Wg
# B/WkyXHgxaY19IAzLq2QiPiX2YryiR5EsYBq35BP7U15DlZtpSs2wIYTkkDBxhPJ
# IDJgowZu5GyhHdqrst3OjkSRAgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUV4Iarkq57esagu6FUBb270Zijc8w
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzAwMTIrNDU0MTM1MB8GA1UdIwQYMBaAFEhu
# ZOVQBdOCqhc3NyK1bajKdQKVMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0w
# Ny0wOC5jcmwwYQYIKwYBBQUHAQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAx
# MS0wNy0wOC5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAWg+A
# rS4Anq7KrogslIQnoMHSXUPr/RqOIhJX+32ObuY3MFvdlRElbSsSJxrRy/OCCZdS
# se+f2AqQ+F/2aYwBDmUQbeMB8n0pYLZnOPifqe78RBH2fVZsvXxyfizbHubWWoUf
# NW/FJlZlLXwJmF3BoL8E2p09K3hagwz/otcKtQ1+Q4+DaOYXWleqJrJUsnHs9UiL
# crVF0leL/Q1V5bshob2OTlZq0qzSdrMDLWdhyrUOxnZ+ojZ7UdTY4VnCuogbZ9Zs
# 9syJbg7ZUS9SVgYkowRsWv5jV4lbqTD+tG4FzhOwcRQwdb6A8zp2Nnd+s7VdCuYF
# sGgI41ucD8oxVfcAMjF9YX5N2s4mltkqnUe3/htVrnxKKDAwSYliaux2L7gKw+bD
# 1kEZ/5ozLRnJ3jjDkomTrPctokY/KaZ1qub0NUnmOKH+3xUK/plWJK8BOQYuU7gK
# YH7Yy9WSKNlP7pKj6i417+3Na/frInjnBkKRCJ/eYTvBH+s5guezpfQWtU4bNo/j
# 8Qw2vpTQ9w7flhH78Rmwd319+YTmhv7TcxDbWlyteaj4RK2wk3pY1oSz2JPE5PNu
# Nmd9Gmf6oePZgy7Ii9JLLq8SnULV7b+IP0UXRY9q+GdRjM2AEX6msZvvPCIoG0aY
# HQu9wZsKEK2jqvWi8/xdeeeSI9FN6K1w4oVQM4Mwggd6MIIFYqADAgECAgphDpDS
# AAAAAAADMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMTAeFw0xMTA3MDgyMDU5MDlaFw0yNjA3MDgyMTA5MDla
# MH4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMT
# H01pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTEwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQCr8PpyEBwurdhuqoIQTTS68rZYIZ9CGypr6VpQqrgG
# OBoESbp/wwwe3TdrxhLYC/A4wpkGsMg51QEUMULTiQ15ZId+lGAkbK+eSZzpaF7S
# 35tTsgosw6/ZqSuuegmv15ZZymAaBelmdugyUiYSL+erCFDPs0S3XdjELgN1q2jz
# y23zOlyhFvRGuuA4ZKxuZDV4pqBjDy3TQJP4494HDdVceaVJKecNvqATd76UPe/7
# 4ytaEB9NViiienLgEjq3SV7Y7e1DkYPZe7J7hhvZPrGMXeiJT4Qa8qEvWeSQOy2u
# M1jFtz7+MtOzAz2xsq+SOH7SnYAs9U5WkSE1JcM5bmR/U7qcD60ZI4TL9LoDho33
# X/DQUr+MlIe8wCF0JV8YKLbMJyg4JZg5SjbPfLGSrhwjp6lm7GEfauEoSZ1fiOIl
# XdMhSz5SxLVXPyQD8NF6Wy/VI+NwXQ9RRnez+ADhvKwCgl/bwBWzvRvUVUvnOaEP
# 6SNJvBi4RHxF5MHDcnrgcuck379GmcXvwhxX24ON7E1JMKerjt/sW5+v/N2wZuLB
# l4F77dbtS+dJKacTKKanfWeA5opieF+yL4TXV5xcv3coKPHtbcMojyyPQDdPweGF
# RInECUzF1KVDL3SV9274eCBYLBNdYJWaPk8zhNqwiBfenk70lrC8RqBsmNLg1oiM
# CwIDAQABo4IB7TCCAekwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFEhuZOVQ
# BdOCqhc3NyK1bajKdQKVMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1Ud
# DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFHItOgIxkEO5FAVO
# 4eqnxzHRI4k0MFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwubWljcm9zb2Z0
# LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcmwwXgYIKwYBBQUHAQEEUjBQME4GCCsGAQUFBzAChkJodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcnQwgZ8GA1UdIASBlzCBlDCBkQYJKwYBBAGCNy4DMIGDMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2RvY3MvcHJpbWFyeWNw
# cy5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AcABvAGwAaQBjAHkA
# XwBzAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAGfyhqWY
# 4FR5Gi7T2HRnIpsLlhHhY5KZQpZ90nkMkMFlXy4sPvjDctFtg/6+P+gKyju/R6mj
# 82nbY78iNaWXXWWEkH2LRlBV2AySfNIaSxzzPEKLUtCw/WvjPgcuKZvmPRul1LUd
# d5Q54ulkyUQ9eHoj8xN9ppB0g430yyYCRirCihC7pKkFDJvtaPpoLpWgKj8qa1hJ
# Yx8JaW5amJbkg/TAj/NGK978O9C9Ne9uJa7lryft0N3zDq+ZKJeYTQ49C/IIidYf
# wzIY4vDFLc5bnrRJOQrGCsLGra7lstnbFYhRRVg4MnEnGn+x9Cf43iw6IGmYslmJ
# aG5vp7d0w0AFBqYBKig+gj8TTWYLwLNN9eGPfxxvFX1Fp3blQCplo8NdUmKGwx1j
# NpeG39rz+PIWoZon4c2ll9DuXWNB41sHnIc+BncG0QaxdR8UvmFhtfDcxhsEvt9B
# xw4o7t5lL+yX9qFcltgA1qFGvVnzl6UJS0gQmYAf0AApxbGbpT9Fdx41xtKiop96
# eiL6SJUfq/tHI4D1nvi/a7dLl+LrdXga7Oo3mXkYS//WsyNodeav+vyL6wuA6mk7
# r/ww7QRMjt/fdW1jkT3RnVZOT7+AVyKheBEyIXrvQQqxP/uozKRdwaGIm1dxVk5I
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIVWDCCFVQCAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAVGejY9AcaMOQQAAAAABUTAN
# BglghkgBZQMEAgEFAKCBrjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgmH0crTDD
# RJ8/1uZzMCcc5+kqJNfR072IInXRPD5Vi4owQgYKKwYBBAGCNwIBDDE0MDKgFIAS
# AE0AaQBjAHIAbwBzAG8AZgB0oRqAGGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbTAN
# BgkqhkiG9w0BAQEFAASCAQBTvlVUBivA37PIlXDBx7OKmDODfX54Vg2D4MpnrZwq
# YPSepOiNr7TlS/FqgtN+NCV8rdgO/BhEDT1NgqXVVhrZTXR+DjNEK50NJ2bi5o5g
# JATjn9ukvPZZzrYC9Ts2+Tb6FUgSmh+sfBoR8OtVBA/NB/O89QJkuZZpzgbGALQy
# 3rjEyv2wTvEXE7zDl6JtYiS37WNFuf4Xkv/S8DfRnVUpmmDxfmtKjiozjGhQp+s5
# bHsHghPWYzIrd1iM9WQamLOOZQV95irXM1CTszMgE9lx5MtiMRCzXGkcx0zVqvWl
# D/xdnlhwB4H6HRuSnKFfmRZcjXJBgGPFOj0BIPWrId08oYIS4jCCEt4GCisGAQQB
# gjcDAwExghLOMIISygYJKoZIhvcNAQcCoIISuzCCErcCAQMxDzANBglghkgBZQME
# AgEFADCCAVEGCyqGSIb3DQEJEAEEoIIBQASCATwwggE4AgEBBgorBgEEAYRZCgMB
# MDEwDQYJYIZIAWUDBAIBBQAEIADCku66Jykee0L7ZwjfC3hQjQUKIbhq9m18ZoUq
# CWYXAgZcy0pPymoYEzIwMTkwNzA0MTI1MTU1Ljc0NFowBIACAfSggdCkgc0wgcox
# CzAJBgNVBAYTAlVTMQswCQYDVQQIEwJXQTEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQg
# SXJlbGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsTHVRoYWxlcyBUU1Mg
# RVNOOkQwODItNEJGRC1FRUJBMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFt
# cCBzZXJ2aWNloIIOOTCCBPEwggPZoAMCAQICEzMAAADiGDh7ZunqwdgAAAAAAOIw
# DQYJKoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
# b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3Jh
# dGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcN
# MTgwODIzMjAyNzAzWhcNMTkxMTIzMjAyNzAzWjCByjELMAkGA1UEBhMCVVMxCzAJ
# BgNVBAgTAldBMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQg
# Q29ycG9yYXRpb24xLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJhdGlv
# bnMgTGltaXRlZDEmMCQGA1UECxMdVGhhbGVzIFRTUyBFU046RDA4Mi00QkZELUVF
# QkExJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIHNlcnZpY2UwggEiMA0G
# CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCoqwO9hRdzQi1uZnyzvw9BGeWHLNNK
# IjEorLFywelhfRjXT+/EMxcAMqcVv/qmUnM6mh2wx/IZW8ZM39w4mIAHaUI5xpC7
# o8CrVkmj9vf5VX+4xah8vb+nh/i3TotC77az0Vt+DMgr6cWcjluB9Ydz5MQgS+UW
# ttbA6oHFS9ZntKLMPEE1EV5iOC8ni3Ux9wnCNgIDQ1047BQX90LDviWMgDmFq03C
# 58sFTeg64oJoKwyZOcPsEeFax35dk/T0WW2flA7dd8MMgfXeiFEbs1fJR7AFXxfL
# fUtGhlT5pEN3NsGjoR6bKelRDPk+Q9j4fMSV9a/Ns+u1kZZhnDj9jVgtAgMBAAGj
# ggEbMIIBFzAdBgNVHQ4EFgQUiT6Q+gbD9qfnKwyS9t9r6BLS8XswHwYDVR0jBBgw
# FoAU1WM6XIoxkPNDe3xGG8UzaFqFbVUwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDov
# L2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvTWljVGltU3RhUENB
# XzIwMTAtMDctMDEuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0
# cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNUaW1TdGFQQ0FfMjAx
# MC0wNy0wMS5jcnQwDAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcDCDAN
# BgkqhkiG9w0BAQsFAAOCAQEAEUB7uyEngbiUhyrg0SNOO9OHB9AewWM3hCKw9eWs
# L4jEXGCHyDh6bxs2TlkID9h5tEa+5L01LtVa0kmkO4tYD1nYajJsOVgZ0kuW8XjI
# YcfVLAEnhPOL1LvNjXmWqRkox9/GAG+Fk/k7Yk5HKCOfawPgkwqtdPLbSMVX2XK9
# 4ne+jhEyB9B74ZZ8Tjlo8BsuLpemWuUaEyxv6KNq6xplYtxcKzVhns2CwTg7hLI8
# xt+pQkbQSgtmQB32zs+cLZFB26oe/ZlCqHIz+K96sX+UzfO8n+oNbk8fifKXZwIu
# Yh7fmbWp4Fqp1UxPD6CERFoQVZRhX0HZBC1Mdjq/dGgKljCCBnEwggRZoAMCAQIC
# CmEJgSoAAAAAAAIwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRp
# ZmljYXRlIEF1dGhvcml0eSAyMDEwMB4XDTEwMDcwMTIxMzY1NVoXDTI1MDcwMTIx
# NDY1NVowfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
# BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQG
# A1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwggEiMA0GCSqGSIb3
# DQEBAQUAA4IBDwAwggEKAoIBAQCpHQ28dxGKOiDs/BOX9fp/aZRrdFQQ1aUKAIKF
# ++18aEssX8XD5WHCdrc+Zitb8BVTJwQxH0EbGpUdzgkTjnxhMFmxMEQP8WCIhFRD
# DNdNuDgIs0Ldk6zWczBXJoKjRQ3Q6vVHgc2/JGAyWGBG8lhHhjKEHnRhZ5FfgVSx
# z5NMksHEpl3RYRNuKMYa+YaAu99h/EbBJx0kZxJyGiGKr0tkiVBisV39dx898Fd1
# rL2KQk1AUdEPnAY+Z3/1ZsADlkR+79BL/W7lmsqxqPJ6Kgox8NpOBpG2iAg16Hgc
# sOmZzTznL0S6p/TcZL2kAcEgCZN4zfy8wMlEXV4WnAEFTyJNAgMBAAGjggHmMIIB
# 4jAQBgkrBgEEAYI3FQEEAwIBADAdBgNVHQ4EFgQU1WM6XIoxkPNDe3xGG8UzaFqF
# bVUwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGGMA8GA1Ud
# EwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZWy4/oolxiaNE9lJBb186aGMQwVgYD
# VR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwv
# cHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3JsMFoGCCsGAQUFBwEB
# BE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9j
# ZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcnQwgaAGA1UdIAEB/wSBlTCB
# kjCBjwYJKwYBBAGCNy4DMIGBMD0GCCsGAQUFBwIBFjFodHRwOi8vd3d3Lm1pY3Jv
# c29mdC5jb20vUEtJL2RvY3MvQ1BTL2RlZmF1bHQuaHRtMEAGCCsGAQUFBwICMDQe
# MiAdAEwAZQBnAGEAbABfAFAAbwBsAGkAYwB5AF8AUwB0AGEAdABlAG0AZQBuAHQA
# LiAdMA0GCSqGSIb3DQEBCwUAA4ICAQAH5ohRDeLG4Jg/gXEDPZ2joSFvs+umzPUx
# vs8F4qn++ldtGTCzwsVmyWrf9efweL3HqJ4l4/m87WtUVwgrUYJEEvu5U4zM9GAS
# inbMQEBBm9xcF/9c+V4XNZgkVkt070IQyK+/f8Z/8jd9Wj8c8pl5SpFSAK84Dxf1
# L3mBZdmptWvkx872ynoAb0swRCQiPM/tA6WWj1kpvLb9BOFwnzJKJ/1Vry/+tuWO
# M7tiX5rbV0Dp8c6ZZpCM/2pif93FSguRJuI57BlKcWOdeyFtw5yjojz6f32WapB4
# pm3S4Zz5Hfw42JT0xqUKloakvZ4argRCg7i1gJsiOCC1JeVk7Pf0v35jWSUPei45
# V3aicaoGig+JFrphpxHLmtgOR5qAxdDNp9DvfYPw4TtxCd9ddJgiCGHasFAeb73x
# 4QDf5zEHpJM692VHeOj4qEir995yfmFrb3epgcunCaw5u+zGy9iCtHLNHfS4hQEe
# gPsbiSpUObJb2sgNVZl6h3M7COaYLeqN4DMuEin1wC9UJyH3yKxO2ii4sanblrKn
# QqLJzxlBTeCG+SqaoxFmMNO7dDJL32N79ZmKLxvHIa9Zta7cRDyXUHHXodLFVeNp
# 3lfB0d4wwP3M5k37Db9dT+mdHhk4L7zPWAUu7w2gUDXa7wknHNWzfjUeCLraNtvT
# X4/edIhJEqGCAsswggI0AgEBMIH4oYHQpIHNMIHKMQswCQYDVQQGEwJVUzELMAkG
# A1UECBMCV0ExEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0IElyZWxhbmQgT3BlcmF0aW9u
# cyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjpEMDgyLTRCRkQtRUVC
# QTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgc2VydmljZaIjCgEBMAcG
# BSsOAwIaAxUAckAlIXhDnr2iPWXP90Bq5F+NoguggYMwgYCkfjB8MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQg
# VGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIFAODILbEwIhgPMjAx
# OTA3MDQxNTQ4MDFaGA8yMDE5MDcwNTE1NDgwMVowdDA6BgorBgEEAYRZCgQBMSww
# KjAKAgUA4MgtsQIBADAHAgEAAgISJDAHAgEAAgIRqzAKAgUA4Ml/MQIBADA2Bgor
# BgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAID
# AYagMA0GCSqGSIb3DQEBBQUAA4GBAA4abNS9AWMYxgfnppN1xjxJBIiATL8ZSfkC
# tIVM5LfK4ImI0F30zq5lTrTIreNkJamzPL5zDxDuHcgQtyVSOUYv3gFpNUy706J6
# a3ohqm85xA8roGQaN0NX/8H6b+m52BjAzHTBpwDlMeR6pn+vNGbLZHELknsboeDL
# E7ooD5/kMYIDDTCCAwkCAQEwgZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
# c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
# MTACEzMAAADiGDh7ZunqwdgAAAAAAOIwDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqG
# SIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0BCQQxIgQgcVxQHoTGuWpi
# /2AvBYmYOqLovysfvuHjfN/ianXbnugwgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHk
# MIG9BCDfAaSUpkAhrm1sFWuLVvmjL3qBzF/5w51TfH4gzjLKyzCBmDCBgKR+MHwx
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
# Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAA4hg4e2bp6sHYAAAAAADi
# MCIEIJn45q/8ghuF7byzeOSGrxo5KYpyQyK75/VKq6289wOKMA0GCSqGSIb3DQEB
# CwUABIIBACK8EBzpX1gH0X0Hx3yAVJjhUpax+OLXMEQqAt7RUg8rBhlLv4vITiim
# +XxLGxL2KCDzes5rxVcP1ObnHLyqMmRDGNZw/+mkw8tt6DqiAoMF9nQvmgC3SKW2
# EHQcFc6P4RmZczy+P9wBG/bmP4wSiheaDQC0u3nKsaDWIuL3QhJakocC9VbdMaBR
# JxGEAe05zEm5HuccA0sMKvprzNhNq2sb/ETgNz2V8myHP43yrwXO/wPiduyJ4RDP
# PCb4+Nqys/bpCRLguvlgo0gGt7PKY7eFc8vxPA2+j6RORcOMOZu/DcffC1j4CTZC
# tbKE6BoPmGbY9tGQqKTBO1t50nWlsPo=
# SIG # End signature block
