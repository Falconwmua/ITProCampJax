Import-Module Azure
Import-Module AzureRM.Profile
Import-Module AzureRM.Resources


$Azurecred = Get-Credential wwm01@acuitysso.com
$subscriptionid = '76d3e108-7f58-4f95-8dab-206757f82929'

Login-AzureRmAccount -Credential $Azurecred

Get-AzureRmSubscription -SubscriptionId $subscriptionid | Select-AzureRmSubscription

$resourcegroupname = 'CloudSatAtl2017'
$location = 'westus2'
$sitename = 'cloudsatatl2017'
$hostingplan = 'csatl2017hp'
$sqlServerName = 'csatl2017sql'
$sqlAdministratorLogin = 'AdminWill'
$sqlAdministratorPassword = ConvertTo-SecureString -String "P@ssw0rd" -AsPlainText -Force
$repoUrl = "https://github.com/ProjectNami/projectnami"
$branch = "latest"



if ( -not $( Get-AzureRMResourceGroup -Name $resourcegroupname -ErrorAction SilentlyContinue)) {
    New-AzureRMResourceGroup -Name $resourcegroupname -Location $location 
}

$startdate = get-date
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourcegroupname -Name ATLTS2016 -TemplateFile .\ARMTemplate\azure_NAMI_deploy.json -siteName $sitename -siteLocation $location -hostingPlanName $hostingplan -sqlServerName $sqlServerName -sqlAdministratorPassword $sqlAdministratorPassword -sqlAdministratorLogin $sqlAdministratorLogin -branch $branch -repoUrl $repoUrl -Verbose
$startdate - $(get-date)