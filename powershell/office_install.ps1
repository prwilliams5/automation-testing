# Set variables
$sourcePath = "\\server\share\Office2019"
$installPath = "C:\Program Files\Microsoft Office"
$productKey = "AAAAA-BBBBB-CCCCC-DDDDD-EEEEE"
$productId = "ProPlus2019Volume"
$channel = "PerpetualVL2019"
$languageId = "en-us"

# Create Office configuration file
$configuration = New-OfficeConfiguration -ProductID $productId -LanguageID $languageId -Channel $channel \
    -Path "$sourcePath\configuration.xml" -ProductKey $productKey

# Install Office
Start-OfficeInstallation -ConfigurationPath $configuration.Path -Path "$sourcePath\setup.exe" \
    -LogPath "$installPath\Logs"\ -InstallPath $installPath -Wait
