Get-VMhost | Select Name,@{N="Memory provisioned GB";E={$_ | Get-VM | %{($_.MemoryMB / 1KB) -as [int]} | Measure-Object -Sum | Select -ExpandProperty Sum }},
                         @{N="MemoryTotalGB";E={ [math]::Round($_.MemoryTotalGB,2) }},
                         @{N="Memory allocation %";E={ [math]::Round( ($_ | Get-VM | %{($_.MemoryMB / 1KB) -as [int]} | Measure-Object -Sum | Select -ExpandProperty Sum ) / $_.MemoryTotalGB * 100,2 ) }}
