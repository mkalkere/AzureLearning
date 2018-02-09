Login-AzureRmAccount

# Variable for Common values
$resourceGroup = "myResourceGroup"
$location = "westeurope"
$vmName = "myVM"

# 1. Create user object
$cred = Get-Credential -Message "Enter a username and password for the virtual machine."

# 2. Create a resource group
New-AzureRmResourceGroup -Name $resourceGroup -Location $location

# 3. Create a subnet configuration
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name mySubnet -AddressPrefix 192.168.1.0/24

# 4. Create a virtual network
$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $resourceGroup -Location $location `
-Name MYVNET -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig

# 5. Create a public IP address and specify DNS name
$pip = New-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup -Location $location `
-Name "mypublicdns$(Get-Random)" -AllocationMethod Static -IdleTimeoutInMinutes 4

# 6. Create an inbound network security group rule for port 3389
$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig  -Name myNetworkSecurityGroupRuleRDP -Protocol Tcp `
-Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
-DestinationPortRange 3389 -Access Allow

#7. Create a network security group
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroup -Location $location `
-Name myNetworkSecurityGroup -SecurityRules $nsgRuleRDP

# 8. Create a virtual network card and associate with public IP address and NSG
$nic = New-AzureRmNetworkInterface -Name myNIC -ResourceGroupName $resourceGroup `
-Location $location -SubnetId $vnet.Subnets[0].Id   -PublicIpAddressId $pip.Id `
-NetworkSecurityGroupId $nsg.Id 

#9. Create a virtual machine configuration
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize Standard_D1 | `
Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2016-Datacenter -Version latest | `
Add-AzureRmVMNetworkInterface -Id $nic.Id

# 10. Create virtual machine
New-AzureRmVM -ResourceGroupName $resourceGroup -Location $location -VM $vmConfig