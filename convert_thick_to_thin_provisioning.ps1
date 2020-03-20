# Define variables
$vmName = "My-VM"
$targetDatastorename = "*localDatastore02"

# Locate VM
$vm = get-vm -Name $vmName

# Check if its thick provisioned
$vm | get-view | select name,@{N='ThinProvisioned';E={$_.config.hardware.Device.Backing.ThinProvisioned } }

# Obtain disk object
$targetDisk = $vm | get-harddisk

# Define original and target datastores
$originalDS = $vm | get-datastore
$newDS = $vm | get-vmhost | get-datastore | Where-Object { $_.Name -like $targetDatastorename }

# Migrate disks in order to change storage format
Move-HardDisk -HardDisk $targetDisk -Datastore $newDS -StorageFormat Thin -Confirm:$false

# Migrate disk back to original datastore in new thick provisioned format
Move-HardDisk -HardDisk $targetDisk -Datastore $originalDS -StorageFormat Thin -Confirm:$false
