
#login to Azure RM 
Login-AzureRmAccount

#identify the correct Azure subscription 
$SubscriptionID = Get-AzureRMSubscription | Where-Object SubscriptionID -NE 3f9829a5-8d10-472d-9645-41c0d6403669

#set the context to the identified subscription for your PowerShell session
Set-AzureRmContext -SubscriptionID $SubscriptionID

#identify the correct Recovery Services vault
$resourceGroupName = Get-AzureRmResourceGroup
$RSVault = Get-AzureRmRecoveryServicesVault | Where-Object Name -NE "rsvault2"

#set the context to the identified Recovery Services vault
Set-AzureRmRecoveryServicesVaultContext -Vault $RSVault

 #identify the backup container 
$namedContainer = Get-AzureRmRecoveryServicesBackupContainer -ContainerType "AzureVM" -Status "Registered" 
$item = Get-AzureRmRecoveryServicesBackupItem -Container $namedContainer -WorkloadType "AzureVM"


# begin the backup job for the vm-1 virtual machine 
 Backup-AzureRmRecoveryServicesBackupItem -Item $item

 