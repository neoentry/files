
##################################
#Pre=Requisistes
##################################

#SetExecution Policy
Set-ExecutionPolicy unrestricted  -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Creating Directories
$folders = @(
    "C:\software",
    "C:\software\chrome"
)

foreach ($folder in $folders) {
    if (-Not (Test-Path -Path $folder)) {
        New-Item -Path $folder -ItemType Directory | Out-Null
        Write-Host "Created folder: $folder"
    } else {
        Write-Host "Folder already exists: $folder"
    }
}



#Get Storage Account details
$saname = "softwareaccount1999"
$ctx = New-AzStorageContext -StorageAccountName $saname -Anonymous -Protocol "https"
####################################
#Chrome
######################################

# Set variables
$chrome_blob = "GoogleChromeStandaloneEnterprise64.msi"
$chrome_container = "chrome"
$chrome_dir = "c:\software\chrome"

# Download the blob
#Get-AzStorageBlobContent -Blob $chrome_blob -Container $chrome_container -Destination $chrome_dir -Context $ctx -Force
$chromeUri = "https://$saname.blob.core.windows.net/$chrome_container/$chrome_blob"
$chrome_path = Join-Path -Path $chrome_dir -ChildPath $chrome_blob
Invoke-WebRequest -Uri $chromeUri -OutFile $chrome_path


$chrome_msiPath = $chrome_dir + "\$($chrome_blob)"

# ----- Install the MSI silently -----
Write-Host "Installing the MSI package..."


try {
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$chrome_msiPath`" /qn /norestart" -Wait 
        Write-Host "Chrome installed successfully."
} catch {
        Write-Error "Failed to install google chrome"
}
