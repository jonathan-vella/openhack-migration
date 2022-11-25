Param (
    [string]$AdSiteName = "New-AD-Site",
    [string]$ReplicationSubnet = "10.0.0.0/24",
    [string]$Location = ""
)

Import-Module ActiveDirectory

New-ADReplicationSite -Name $adSiteName
New-ADReplicationSubnet -Name $ReplicationSubnet -Site $adSiteName -Location $Location
New-ADReplicationSiteLink -Name "OnPremises-Azure" -SitesIncluded "Default-First-Site-Name",$adSiteName
Set-ADReplicationSiteLink "OnPremises-Azure" -Cost 100 -ReplicationFrequencyInMinutes 15