#Script to automate deployment of multiple vms fromtemplate using powercli on vcenter, cvs excel should be use for vm details
 
 
 $cred = Get-Credential
Connect-VIServer hlbavctrp101.corp.standard.com -Credential $cred

#Excel with VM deatils
$vms = Import-Csv -Path C:\Users\s007097_su\Desktop\test.csv

$template = Get-Template -Name "SCCM_Win10_21H2.5"

foreach ($vm in $vms){
    Write-Warning "Creating $($vm.Name) in $($vm.Cluster)"
    New-VM -Name $vm.Name -Datastore $vm.Datastore -Location $vm.Folder -Template $template -DiskStorageFormat Thin -NetworkName $vm.Network -VMHost $vm.vmHost -Confirm:$false
    Get-VM -Name $vm.Name | Set-VM -NumCpu $vm.CPU -CoresPerSocket $vm.Core -MemoryGB $vm.Memory -Confirm:$false
    Get-VM -Name $vm.Name | Get-HardDisk | Set-HardDisk -CapacityGB $vm.HDD -Confirm:$false
}

Disconnect-VIServer hlbavctrp101.corp.standard.com -Confirm:$false
