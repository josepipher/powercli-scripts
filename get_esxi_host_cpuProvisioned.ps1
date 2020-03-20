# Hypervisors ending in .20x have been excluded

Get-VMhost | Select Name,Parent,
                         @{N="Provisioned CPU num";E={$_ | Get-VM | %{($_.NumCpu) -as [int]} | Measure-Object -Sum | Select -ExpandProperty Sum }},
                         @{N="Available CPU num";E={ [math]::Round($_.NumCpu,2) }},
                         @{N="CPU allocation %";E={ [math]::Round( ($_ | Get-VM | %{($_.NumCpu) -as [int]} | Measure-Object -Sum | Select -ExpandProperty Sum ) / $_.NumCpu * 100,2 ) }},
                         @{N="CPU Usage Mhz";E={ [math]::Round( $_.CpuUsageMhz ) }},
                         @{N="CPU Total Mhz";E={ [math]::Round( $_.CpuTotalMhz ) }},
                         @{N="CPU Usage %";E={ [math]::Round( ($_ | %{($_.CpuUsageMhz) -as [int]} | Measure-Object -Sum | Select -ExpandProperty Sum ) / $_.CpuTotalMhz * 100,2 ) }} | Sort-Object Parent | ft -auto

$host_cpuProvisioned_exclMGMT = Get-VMhost | where-object { $_.Name -NotLike "*.201" -and $_.Name -NotLike "*.202" -and $_.Name -NotLike "*.203" } | Select Name,
                         @{N="Provisioned CPU num";E={$_ | Get-VM | %{($_.NumCpu) -as [int]} | Measure-Object -Sum | Select -ExpandProperty Sum }},
                         @{N="Available CPU num";E={ [math]::Round($_.NumCpu,2) }},
                         @{N="CPU allocation %";E={ [math]::Round( ($_ | Get-VM | %{($_.NumCpu) -as [int]} | Measure-Object -Sum | Select -ExpandProperty Sum ) / $_.NumCpu * 100,2 ) }},
                         @{N="CPU Usage Mhz";E={ [math]::Round( $_.CpuUsageMhz ) }},
                         @{N="CPU Total Mhz";E={ [math]::Round( $_.CpuTotalMhz ) }},
                         @{N="CPU Usage %";E={ [math]::Round( ($_ | %{($_.CpuUsageMhz) -as [int]} | Measure-Object -Sum | Select -ExpandProperty Sum ) / $_.CpuTotalMhz * 100,2 ) }}

Write-Host ""
Write-Host "Excluding MGMT Cluster :"
Write-Host "========================"

$provisionedCapacity=0
foreach($hostValue in $host_cpuProvisioned_exclMGMT){ $provisionedCapacity += $hostValue.'Provisioned CPU num'}
Write-Host "Provisioned CPU (Core) : " $provisionedCapacity

$availableCapacity=0
foreach($hostValue in $host_cpuProvisioned_exclMGMT){ $availableCapacity += $hostValue.'Available CPU num'}
Write-Host "Available CPU (Core) : " $AvailableCapacity

$alloRatio = [math]::Round( $provisionedCapacity / $AvailableCapacity * 100, 2 )
Write-Host "CPU allocation (Core) % : " $alloRatio

$actualCPUGHZ=0
foreach($hostValue in $host_cpuProvisioned_exclMGMT){ $actualCPUGHZ += $hostValue.'CPU Usage Mhz'}
Write-Host "Actual CPU Used (GHz) : " ( [math]::Round( $actualCPUGHZ / 1024,2 ) ).tostring()

$availCPUGHZ=0
foreach($hostValue in $host_cpuProvisioned_exclMGMT){ $availCPUGHZ += $hostValue.'CPU Total Mhz'}
Write-Host "Available CPU (GHz) : " ( [math]::Round( $availCPUGHZ / 1024,2 ) ).tostring()

$consumedCPUGHZ = [math]::Round( $actualCPUGHZ / $availCPUGHZ * 100, 2 )
Write-Host "Actual CPU (GHz) Consumed % : " $consumedCPUGHZ

Write-Host ""
$vmNum_poweredOff = $(Get-VMhost | where-object { $_.Name -NotLike "*.20*" } | get-vm | Where-object {$_.powerstate -eq "poweredoff"}| measure).Count
$vmNum_poweredOn = $(Get-VMhost | where-object { $_.Name -NotLike "*.20*" } | get-vm | Where-object {$_.powerstate -eq "poweredon"}| measure).Count
$totalVM = $vmNum_poweredOff + $vmNum_poweredOn
Write-Host "Number of VMs (OFF) : " $vmNum_poweredOff
Write-Host "Number of VMs (ON) : " $vmNum_poweredOn
Write-Host "Total number of VMs : " $totalVM
