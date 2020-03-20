Get-VMhost | Select Name,Parent,
                         @{N="Memory provisioned GB";E={$_ | Get-VM | %{($_.MemoryMB / 1KB) -as [int]} | Measure-Object -Sum | Select -ExpandProperty Sum }},
                         @{N="MemoryTotalGB";E={ [math]::Round($_.MemoryTotalGB,2) }},
                         @{N="Memory allocation %";E={ [math]::Round( ($_ | Get-VM | %{($_.MemoryMB / 1KB) -as [int]} | Measure-Object -Sum | Select -ExpandProperty Sum ) / $_.MemoryTotalGB * 100,2 ) }},
                         @{N="Memory Usage GB";E={ [math]::Round( $_.MemoryUsageGB ) }},
                         @{N="Memory Usage %";E={ [math]::Round( ($_ | %{($_.MemoryUsageGB) -as [int]} | Measure-Object -Sum | Select -ExpandProperty Sum ) / $_.MemoryTotalGB * 100,2 ) }} | Sort-Object Parent | ft -auto

$host_RAMProvisioned_exclMGMT = Get-VMhost | Select Name,@{N="Memory provisioned GB";E={$_ | Get-VM | %{($_.MemoryMB / 1KB) -as [int]} | Measure-Object -Sum | Select -ExpandProperty Sum }},
                         @{N="MemoryTotalGB";E={ [math]::Round($_.MemoryTotalGB,2) }},
                         @{N="Memory allocation %";E={ [math]::Round( ($_ | Get-VM | %{($_.MemoryMB / 1KB) -as [int]} | Measure-Object -Sum | Select -ExpandProperty Sum ) / $_.MemoryTotalGB * 100,2 ) }},
                         @{N="Memory Usage GB";E={ [math]::Round( $_.MemoryUsageGB ) }},
                         @{N="Memory Usage %";E={ [math]::Round( ($_ | %{($_.MemoryUsageGB) -as [int]} | Measure-Object -Sum | Select -ExpandProperty Sum ) / $_.MemoryTotalGB * 100,2 ) }}

Write-Host ""
Write-Host "Excluding MGMT Cluster :"
Write-Host "========================"

$provisionedCapacity=0
foreach($hostValue in $host_RAMProvisioned_exclMGMT){ $provisionedCapacity += $hostValue.'Memory provisioned GB'}
Write-Host "Provisioned RAM (GB) : " $provisionedCapacity

$availableCapacity=0
foreach($hostValue in $host_RAMProvisioned_exclMGMT){ $availableCapacity += $hostValue.'MemoryTotalGB'}
Write-Host "Available RAM (GB) : " $AvailableCapacity

$alloRatio = [math]::Round( $provisionedCapacity / $AvailableCapacity * 100, 2 )
Write-Host "RAM allocation % : " $alloRatio

$actualRAMUsed=0
foreach($hostValue in $host_RAMProvisioned_exclMGMT){ $actualRAMUsed += $hostValue.'Memory Usage GB'}
Write-Host "Actual RAM Used (GB) : " $actualRAMUsed

$RAMUsedRatio = [math]::Round( $actualRAMUsed / $AvailableCapacity * 100, 2 )
Write-Host "RAM used % : " $RAMUsedRatio
