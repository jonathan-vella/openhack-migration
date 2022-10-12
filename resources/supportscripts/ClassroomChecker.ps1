<#

.SYNOPSIS
This script can be used to check the status of a classroom after is has been started in the Cloud Sandbox. 

This script has specficially been authored to check the lab microsoft-open-hack-line-of-business-migration and will not currently validate any other OpenHack labs.

.DESCRIPTION
To use this script, you will need to navigate to a classroom in the Cloud Sandbox and enter the lab view. 

From the lab view, click the List Credentials button, and then export the CSV. 

This script will take the path of that script as in input and use the credentials to enumerate all of the subscriptions within it.

.EXAMPLE
./ClassroomChecker.ps1 -LabCredentialsFilePath $env:HOMEPATH\Downloads\credentials.csv

.NOTES
This script should only run at least two hours after you have initiated the lab. Running it prior to that will certainly lead to results which lead you to believe the lab has not provisioned successfully, when in fact it is probably just still spinning up.

.LINK
https://github.com/opsgility/labs/master/microsoft-open-hack-migration/

#>

Param (
    [Parameter(Mandatory=$false)]
    [String]
    $ResourceGroupName = "openhackonpremrg",

    [Parameter(Mandatory=$false)]
    [String]
    $PublicIPName = "cmhostip",

    [Parameter(Mandatory=$false)]
    [String]
    $LabCredentialsFilePath = "$PSScriptRoot\credentials.csv"
)

if (Test-Path $LabCredentialsFilePath -PathType Leaf) {
    $csv = Import-Csv -Path $LabCredentialsFilePath -Header "PortalUsername","PortalPassword","AzureSubscriptionId","AzureDisplayName","AzureUsername","AzurePassword" | Sort-Object AzureSubscriptionId -Unique

    $outputCSVPath = "$env:HOMEPATH\Downloads\classscheckresults.csv"

    if (Test-Path $outputCSVPath -PathType Leaf) {
        $userResponse = Read-Host "Found previous output. Would you like to delete it? (y/n)?"

        if ($userResponse.ToLower() -eq "y") {
            Remove-Item -Path $outputCSVPath
        }
    }

    Write-Host "Storing validation results at $outputCSVPath" -ForegroundColor Green

    if (!(Test-Path $outputCSVPath -PathType Leaf)) {
        Add-Content -Path $outputCSVPath -Value '"SiteFound","AzureUsername","AzurePassword","SubscriptionId","FQDN","TenantURL"'
    }

    for ($i = 0; $i -lt $csv.Count; $i++) {
        $record = $csv[$i]
        $labUsername = $record.AzureUsername
        $labPassword = $record.AzurePassword

        if ($labUsername -ne "Azure UserName" -and $labPassword -ne "Azure Password") {
            $subscriptionId = $record.AzureSubscriptionId

            Write-Host "Processing record for $labUsername"

            $secpasswd = ConvertTo-SecureString $labPassword -AsPlainText -Force
            $labPScred = New-Object System.Management.Automation.PSCredential ($labUsername, $secpasswd)

            Connect-AzAccount -Credential $labPScred -Subscription $subscriptionId

            $pip = Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name $PublicIPName

            if ($pip -ne $null) {
                $fqdn = $pip.DnsSettings.Fqdn

                $pingCount = 1
                $siteFound = $false
                while (!$siteFound -and $pingCount -le 5) {
                    try {
                        Write-Host "Checking $fqdn ($pingCount)..." -ForegroundColor Yellow
                        $pingCount++

                        $response = Invoke-WebRequest -Uri "http://$fqdn" -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
                        if ($response.StatusCode -eq 200) {
                            Write-Host "`tFound host $fqdn" -ForegroundColor Green
                            $siteFound = $true;
                        }
                    } catch {}

                    Start-Sleep 2
                }

                $tenantURL = "https://portal.azure.com/" + $labUsername.Split("@")[1]

                if (!$siteFound) {
                    Write-Host "Unable to verfiy site at $fqdn" -ForegroundColor Yellow
                    Write-Host "`tManually verify the subscription at $tenantURL" -ForegroundColor Yellow
                }

                $outputString = '"' + $siteFound + '",'
                $outputString += '"' + $labUsername + '",'
                $outputString += '"' + $labPassword + '",'
                $outputString += '"' + $subscriptionId + '",'
                $outputString += '"' + "http://$fqdn" + '",'
                $outputString += '"' + $tenantURL + '"'

                Add-Content -Path $outputCSVPath -Value $outputString

            } else {
                Write-Host "Could not retrieve the public IP address..." -ForegroundColor Red
            }

            Disconnect-AzAccount -Username $labUsername
        }
    }
} else {
    Write-Error -Message "Unable to find CSV at the path provided." -Category InvalidData
}