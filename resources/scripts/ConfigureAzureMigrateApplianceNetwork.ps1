Write-Output "Creating Migrate appliance switch..."
$switchName = 'InternalMigrateSwitch'
New-VMSwitch -Name $switchName -SwitchType Internal
# Connect Azure Migrate switch to the NAT network
$adapter = Get-NetAdapter | Where-Object { $_.Name -like "*"+$switchName+"*" }
New-NetIPAddress -IPAddress 192.168.1.1 -PrefixLength 24 -InterfaceIndex $adapter.ifIndex