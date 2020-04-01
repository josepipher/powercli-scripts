$vm_in_cluster = get-cluster | select name,
             @{ N="Total VM"; E={ ($_ | get-vm).count} },
             @{ N="VM (ON)"; E={ ( $_ | get-vm | Where-Object {$_.powerstate -eq "PoweredOn"} ).count }},
             @{ N="VM (OFF)"; E={ ( $_ | get-vm | Where-Object {$_.powerstate -eq "PoweredOff"} ).count }} | Sort-Object Name

$vm_in_host = get-vmhost | select name,Parent,
             @{ N="Total VM"; E={ ($_ | get-vm).count} },
             @{ N="VM (ON)"; E={ ( $_ | get-vm | Where-Object {$_.powerstate -eq "PoweredOn"} ).count }},
             @{ N="VM (OFF)"; E={ ( $_ | get-vm | Where-Object {$_.powerstate -eq "PoweredOff"} ).count }} | Sort-Object Parent

#$vm_in_host | ft - auto

$total = (get-vm).count
$totalOn = (get-vm | Where-Object {$_.powerstate -eq "PoweredOn"}).count
$totalOff = (get-vm | Where-Object {$_.powerstate -eq "PoweredOff"}).count
Write-Host "Total VM: " $total
Write-Host "VM (On): " $totalOn
Write-Host "VM (Off): " $totalOff

# Can also Sort-Object outside of function

return $vm_in_cluster
