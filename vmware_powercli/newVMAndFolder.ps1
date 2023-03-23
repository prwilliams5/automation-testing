# Define the desired state of the vSphere environment
$vsphereServer = "vsphere.example.com"
$vsphereUsername = "administrator@example.com"
$vspherePassword = "password"

# Define the desired configuration for the new folder and virtual machine
$folderName = "New Folder"
$vmName = "New VM"
$vmMemoryGB = 2
$vmNumCPU = 2
$vmDiskGB = 20
$vmNetworkAdapter = "Network Adapter 1"

# Connect to the vSphere server
Connect-VIServer -Server $vsphereServer -User $vsphereUsername -Password $vspherePassword

# Define the desired state of the vSphere environment
$folderLocation = Get-Folder -NoRecursion
$folder = New-Folder -Name $folderName -Location $folderLocation
$datastore = Get-Datastore 
$vmHost = Get-VMHost 

# Create the new virtual machine
New-VM -Name $vmName -VMHost $vmHost -Datastore $datastore -MemoryGB $vmMemoryGB -NumCPU $vmNumCPU -DiskGB $vmDiskGB -CD -Floppy -NetworkAdapter $vmNetworkAdapter -Location $folder

# Disconnect from the vSphere server
Disconnect-VIServer -Server $vsphereServer -Confirm:$false
