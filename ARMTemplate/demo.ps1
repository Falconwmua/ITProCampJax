Import-Module Azure
Import-Module AzureRM.Profile
Import-Module AzureRM.Resources


$Azurecred = Get-Credential
$subscriptionid = '76d3e108-7f58-4f95-8dab-206757f82929'

Login-AzureRmAccount -Credential $Azurecred

Get-AzureRmSubscription -SubscriptionId $subscriptionid | Select-AzureRmSubscription

$resourcegroupname = 'PoshSatTampa01'
$location = 'eastus'
$sitename = 'PoshSatTampaD4A01'
$hostingplan = 'PSTD4A01'
$sqlServerName = 'poshsattampa01'
$sqlAdministratorLogin = 'AdminWill'
$sqlAdministratorPassword = ConvertTo-SecureString -String "P@ssw0rd" -AsPlainText -Force
$repoUrl = "https://github.com/ProjectNami/projectnami"
$branch = "latest"



if ( -not $( Get-AzureRMResourceGroup -Name $resourcegroupname -ErrorAction SilentlyContinue)) {
    New-AzureRMResourceGroup -Name $resourcegroupname -Location $location 
}

New-AzureRMResourceGroupDeployment -ResourceGroupName $resourcegroupname -Name DeploySat -TemplateFile D:\PoshTampa\ARMTemplate\azure_NAMIv2_deploy.json  -siteName $sitename -hostingPlanName $hostingplan -siteLocation $location -sqlServerName $sqlServerName -sqlAdministratorLogin $sqlAdministratorLogin -sqlAdministratorPassword $sqlAdministratorPassword -repoUrl $repoUrl -branch $branch -verbose -sku Standard

