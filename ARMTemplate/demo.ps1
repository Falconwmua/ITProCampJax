Import-Module Azure
Import-Module AzureRM.Profile
Import-Module AzureRM.Resources


$Azurecred = Get-Credential wwm01@acuitysso.com
$subscriptionid = '76d3e108-7f58-4f95-8dab-206757f82929'

Login-AzureRmAccount -Credential $Azurecred

Get-AzureRmSubscription -SubscriptionId $subscriptionid | Select-AzureRmSubscription

$resourcegroupname = 'ATLTS2016'
$location = 'westus2'
$sitename = 'atlts2016ab'
$hostingplan = 'atlts2016abhp'
$sqlServerName = 'atlts2016absql'
$sqlAdministratorLogin = 'AdminWill'
$sqlAdministratorPassword = ConvertTo-SecureString -String "P@ssw0rd" -AsPlainText -Force
$repoUrl = "https://github.com/ProjectNami/projectnami"
$branch = "latest"



if ( -not $( Get-AzureRMResourceGroup -Name $resourcegroupname -ErrorAction SilentlyContinue)) {
    New-AzureRMResourceGroup -Name $resourcegroupname -Location $location 
}

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourcegroupname -Name AzureUG -TemplateFile .\ARMTemplate\azure_NAMI_deploy.json -siteName $sitename -siteLocation $location -hostingPlanName $hostingplan -sqlServerName $sqlServerName -sqlAdministratorPassword $sqlAdministratorPassword -sqlAdministratorLogin $sqlAdministratorLogin -branch $branch -repoUrl $repoUrl -sku "Free" -Verbose