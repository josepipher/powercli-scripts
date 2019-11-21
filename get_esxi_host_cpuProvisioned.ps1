Get-VMhost | Select Name,@{N="Provisioned CPU num";E={$_ | Get-VM | %{($_.NumCpu) -as [int]} | Measure-Object -Sum | Select -ExpandProperty Sum }},
                         @{N="Available CPU num";E={ [math]::Round($_.NumCpu,2) }},
                         @{N="CPU allocation %";E={ [math]::Round( ($_ | Get-VM | %{($_.NumCpu) -as [int]} | Measure-Object -Sum | Select -ExpandProperty Sum ) / $_.NumCpu * 100,2 ) }}
