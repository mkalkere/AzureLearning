#Configure Application Settings Azure Web Apps

#login to azure account
Login-AzureRmAccount

$resourceGroupName = "contosoResourceGroup" 
$webAppName = "contoso-hrm-app"
 
#Get current app settings
$webApp = Get-AzureRmWebApp -ResourceGroupName $resourceGroupName -Name $webAppName
$settings = $webApp.SiteConfig.AppSettings

#Add new Settings to the Current Set of Settings
$newSettings = New-Object hashtable
$newSettings["setting1"] = "value-1"
$newSettings["setting2"] = "value-2"

foreach($setting in $settings){
    $newSettings.Add($setting.Name,$setting.Value)
}

#Apply the new App Settings to the Web App
Set-AzureRmWebApp -ResourceGroupName $resourceGroupName -Name $webAppName -AppSettings $newSettings
