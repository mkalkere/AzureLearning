#Azure PowerShell cmdlets for deployment slots

#login to azure account
Login-AzureRmAccount

$resourceGroupName = "contosoResourceGroup"
$appServicePlanName = "contosoAppServiceplan"
$location = "East US"
$tier = "Premium"
$workerSize = "small"
$webAppName = "contoso-hrm-app"
$webAppStagingSlotName = "staging"
$productionslotName = "Production"

#Create a Azure Resource Group
New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

#Create Azure App Service Plan
New-AzureRmAppServicePlan -Name $appServicePlanName -Location $location -WorkerSize $workerSize -Tier $tier -ResourceGroupName $resourceGroupName -Verbose

#Create a Web App
New-AzureRmWebApp -ResourceGroupName $resourceGroupName -Name $webAppName -Location $location -AppServicePlan $appServicePlanName

#Create a Deployment Slot
New-AzureRmWebAppSlot -ResourceGroupName $resourceGroupName -Name $webAppName -Slot $webAppStagingSlotName -AppServicePlan $appServicePlanName

# Swap staging and production deployment slots (single phase)
Swap-AzureRmWebAppSlot -ResourceGroupName $resourceGroupName -Name $webAppName -SourceSlotName $webAppStagingSlotName -DestinationSlotName $productionslotName

#Delete deployment slot
Remove-AzureRmResource -ResourceGroupName $resourceGroupName -ResourceType Microsoft.Web/sites/slots –Name $webAppName/$webAppStagingSlotName -ApiVersion 2015-07-01

#Remove Web App
Remove-AzureRmWebApp -ResourceGroupName $resourceGroupName -Name $webAppName -Force -Verbose

#Remove App Service Plan
Remove-AzureRmAppServicePlan -ResourceGroupName $resourceGroupName -Name $appServicePlanName -Force -Verbose

#Delete the Resource Group
Remove-AzureRmResourceGroup -Name $resourceGroupName -Verbose 

Logout-AzureRmAccount
 