$datastoreName = "Datastore-*"

$datastoreConsumption = Get-Datastore | Where-Object {$_.name -Like $datastoreName} | Select Name,@{N="FreeSpaceGB";E={ [math]::Round( $_.FreeSpaceGB, 2) } },CapacityGB,@{N="Used Capacity %";E={ [math]::Round( ($_.CapacityGB - $_.FreeSpaceGB) / $_.CapacityGB * 100, 2 ) }} | Sort-Object Name

#$datastoreConsumption

return $datastoreConsumption
