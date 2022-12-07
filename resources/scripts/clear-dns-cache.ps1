# Get Windows servers on Domain
####################
$serversraw=Get-ADComputer -Filter {(OperatingSystem -like "*windows*")}

# Filter responsive
####################
$serversup = $serversraw.name | where {Test-Connection $_ -quiet -count 1}

# Flush DNS & reregister
####################
Clear-DnsClientCache -cimsession $serversup
Register-DnsClientCache -cimsession $serversup
