###############################
# Date : 20191118
# Objective : set IO limit for VM
#
# Usage : .\set_vmDiskIOPS.ps1 vmName value-of-io-limit
# Notes : value of IO limit is -1 for unlimited; other integers e.g. 100 otherwise
###############################

Function set_vmDiskIOPS ([string]$vmName, [int]$DiskLimitIOPerSecond){
  
  $vm = Get-VM -Name $vmName
  $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
  $vm.ExtensionData.Config.Hardware.Device |
   where {$_ -is [VMware.Vim.VirtualDisk]} | %{
    $dev = New-Object VMware.Vim.VirtualDeviceConfigSpec
    $dev.Operation = "edit"
    $dev.Device = $_
    $dev.Device.StorageIOAllocation.Limit = $DiskLimitIOPerSecond
    $spec.DeviceChange += $dev
  }
  
  $vm.ExtensionData.ReconfigVM_Task($spec)
  
}

set_vmDiskIOPS $args[0] $args[1]
