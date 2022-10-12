Param (
    [string]$AdSiteName = "New-AD-Site",
    [string]$DomainName = "opsgility.com",
    [string]$ReplicationSourceDc = "ad1.opsgility.com",
    [string]$DomainAdminUserName = "OPSGILITY\Administrator",
    [string]$DomainAdminPassword = "demo@pass123"
)

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

$securePassword = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
$domaincredential = New-Object System.Management.Automation.PSCredential ($DomainAdminUserName, $securePassword)

Install-ADDSDomainController -CreateDnsDelegation:$false `
    -Credential $domaincredential `
    -DatabasePath 'F:\Windows\NTDS' `
    -SysvolPath 'F:\Windows\SYSVOL' `
    -LogPath 'F:\Windows\NTDS' `
    -DomainName $DomainName `
    -InstallDns:$true `
    -SiteName $AdSiteName `
    -ReplicationSourceDC $ReplicationSourceDc `
    -NoGlobalCatalog:$false `
    -NoRebootOnCompletion:$true `
    -Force:$true `
    -SafeModeAdministratorPassword $securePassword