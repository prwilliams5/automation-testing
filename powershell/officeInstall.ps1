$OfficeInstallerUrl = "https://URL-to-Office-Installer"
$DownloadPath = "$env:TEMP\OfficeInstaller.exe"
$LicenseKey = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX" # Replace with a valid license key
$Arguments = "/configure `"$env:TEMP\OfficeConfiguration.xml`""

# Download Office installer
Try {
    Invoke-WebRequest -Uri $OfficeInstallerUrl -OutFile $DownloadPath
} Catch {
    Write-Host "Error downloading Office installer: $_"
    Exit 1
}

# Create Office configuration XML
$ConfigurationXml = @"
<Configuration>
  <Add OfficeClientEdition="64" Channel="Monthly">
    <Product ID="O365ProPlusRetail">
      <Language ID="en-us" />
    </Product>
  </Add>
  <Display Level="None" AcceptEULA="TRUE" />
  <Property Name="AUTOACTIVATE" Value="1" />
  <Property Name="PIDKEY" Value="$LicenseKey" />
</Configuration>
"@

Set-Content -Path "$env:TEMP\OfficeConfiguration.xml" -Value $ConfigurationXml

# Install Office
Try {
    Start-Process -FilePath $DownloadPath -ArgumentList $Arguments -Wait -NoNewWindow
} Catch {
    Write-Host "Error during Office installation: $_"
    Exit 1
}

# Remove installation files
Remove-Item $DownloadPath
Remove-Item "$env:TEMP\OfficeConfiguration.xml"

Write-Host "Office installation completed successfully"
