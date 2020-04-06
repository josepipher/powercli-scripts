#########################################
# Run to retrieve resource utilization
#########################################
Write-Host "Generating cpu results ..."
$host_cpuProvisioned_beforeHTML = .\get_esxi_host_cpuProvisioned.ps1
Write-Host ""
Write-Host "Generating ram results ..."
$host_memProvisioned_beforeHTML = .\get_esxi_host_memProvisioned.ps1
Write-Host ""
Write-Host "Generating disk results ..."
$ds_consumption = .\get_datastore_consumption.ps1
Write-Host ""
Write-Host "Generating VM results ..."
$vm_distribution = .\get_vm_perHost_or_Cluster.ps1

$vcenter = ([System.Uri]$global:defaultviserver.ServiceUri.AbsoluteUri).Host
$today = get-date -Format yyyy-MM-dd
# Define header for table
$Header = @"
<title>Resource Utilization Report</title>
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse; margin: 20px;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #ff6600; text-align: left; color: "white"}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
<body>
<p>Date : $(get-date -Format yyyy-MM-dd)</p>
<p>Datacenter : $(Get-Datacenter)</p>
<p>vCenter : $(([System.Uri]$global:defaultviserver.ServiceUri.AbsoluteUri).Host)</p>
</body>
"@

Write-Host ""
Write-Host "Generating report ..."
$host_cpuProvisioned_beforeHTML | ft -auto
$host_memProvisioned_beforeHTML | ft -auto
$ds_consumption
$vm_distribution | ft -auto

###########################
# Write table to file
###########################
$host_cpu_report = $host_cpuProvisioned_beforeHTML | ConvertTo-HTML -Fragment
$host_mem_report = $host_memProvisioned_beforeHTML | ConvertTo-HTML -Fragment
$ds_report = $ds_consumption | ConvertTo-HTML -Fragment
$vm_report = $vm_distribution | ConvertTo-HTML -Fragment

$fileName = "Report\host_"+([System.Uri]$global:defaultviserver.ServiceUri.AbsoluteUri).Host+"_ResourceUtilization"+"_$(get-date -Format yyyyMMdd_HHmm).html"
ConvertTo-Html -Body "$host_cpu_report $host_mem_report $ds_report $vm_report" -Property Name,Parent,
           "Provisioned CPU num", "Available CPU num", "CPU allocation %", "CPU Usage Mhz", "CPU Total Mhz", "CPU Usage %",
           "Memory provisioned GB", 
           "FreeSpaceGB",
           "Total VM" -Head $Header | Out-File -FilePath $fileName

#############################
# Email report to Recipients
#############################
$email_sender = "Reporter <report@abc.com>"
$email_recipient = @("ReceiverA <receiverA@abc.com>", "ReceiverB <receiverB@abc.com>")
$smtpServer = "your-SMTP-server"
$smtpPort = 25
$subject = "Resource Utilization Report for $vcenter ($today)"
$body = "Attachment from Your friend."
Send-MailMessage -From $email_sender -To $email_recipient -Subject $subject -Body $body -SmtpServer $smtpServer -Port $smtpPort -Attachments $fileName

Write-Host "Report emailed."
