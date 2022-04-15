#Script to automate deployment of multiple vms fromtemplate using powercli on vcenter, cvs excel should be use for vm details
 
 
 $cred = Get-Credential
Connect-VIServer vcenter.domain.com -Credential $cred

#Excel with VM deatils
$vms = Import-Csv -Path C:\Users\ravi\Desktop\test.csv

$template = Get-Template -Name "vmTemplate"

foreach ($vm in $vms){
    Write-Warning "Creating $($vm.Name) in $($vm.Cluster)"
    New-VM -Name $vm.Name -Datastore $vm.Datastore -Location $vm.Folder -Template $template -DiskStorageFormat Thin -NetworkName $vm.Network -VMHost $vm.vmHost -Confirm:$false
    Get-VM -Name $vm.Name | Set-VM -NumCpu $vm.CPU -CoresPerSocket $vm.Core -MemoryGB $vm.Memory -Confirm:$false
    Get-VM -Name $vm.Name | Get-HardDisk | Set-HardDisk -CapacityGB $vm.HDD -Confirm:$false
}

Disconnect-VIServer vcenter.domain.com -Confirm:$false



#Use CSV file with below format to provide details in script for deployment


#Name	Datastore	Folder	Network	vmHost	CPU	Core	Memory	HDD
#test           testdatastore  testFol     VMNet     host1.com  4     4                4            100
