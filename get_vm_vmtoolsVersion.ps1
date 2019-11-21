###############################
# Date : 20191118
# Objective : check vmware tools version from list of VMs (UUID)
#
# Usage : .\get_vm_vmtoolsVersion.ps1 vmlist.txt
#         where vmlist.txt is a plain list of VM names / UUID
###############################
Function get_vm_vmtoolsVersion( [string]$vmName ){
  Get-VM | where-object {$_.name -like "*$vmName*"} | Select-Object -Property Name,@{Name='ToolsVersion';Expression={$_.Guest.ToolsVersion}}
}

Function read-vm-list( [string]$file ) {

  Write-Host "Reading VM list from $file"
  $content = Get-Content $file
  foreach ($vm in $content) {
    get_vm_vmtoolsVersion $vm
  }
}

read-vm-list $args[0]
