$sasToken = "?sv=2018-03-28&ss=bfqt&srt=sco&sp=rwdlacup&se=2019-09-04T03:04:59Z&st=2019-09-03T19:04:59Z&spr=https&sig=1Fm9lBXguqYVEsh5uIjfQK%2BKpTXniLr7wH7ICKvlb8M%3D"
$zipFileLocation = "D:\"
$opsDir = "C:\OpsgilityTraining"
$azcopy = "$opsDir\azcopy_windows_amd64_10.1.1\azcopy.exe"
$zipFiles = @("cmad1.zip","cmid1.zip","cmdb1.zip","cmaapp1.zip","cmaweb1.zip","cmapp1.zip","cmweb1.zip","cmvpn1.zip")

foreach ($zipFile in $zipFiles) {
    Write-Output "Running command..."
    #Write-Output "cmd /c ""$azcopy copy ""$zipFileLocation$zipFile"" ""https://openhackguides.blob.core.windows.net/migration-open-hack-artifacts/$zipFile$sasToken"" --put-md5"
    cmd /c "$azcopy copy ""$zipFileLocation$zipFile"" ""https://openhackguides.blob.core.windows.net/migration-open-hack-artifacts/$zipFile$sasToken"" --put-md5"
}
