Import-Module Azure
Import-Module AzureRM.Profile
Import-Module AzureRM.Resources


$Azurecred = Get-Credential
$subscriptionid = '76d3e108-7f58-4f95-8dab-206757f82929'

Login-AzureRmAccount -Credential $Azurecred

Get-AzureRmSubscription -SubscriptionId $subscriptionid | Select-AzureRmSubscription

$resourcegroupname = 'ITProCampJax'
$location = 'eastus2'
$sitename = 'itprocampjaxd4a01'
$hostingplan = 'ITPC4A01'
$sqlServerName = 'itprocampjax'
$sqlAdministratorLogin = 'AdminWill'
$sqlAdministratorPassword = ConvertTo-SecureString -String "P@ssw0rd" -AsPlainText -Force
$repoUrl = "https://github.com/ProjectNami/projectnami"
$branch = "latest"



if ( -not $( Get-AzureRMResourceGroup -Name $resourcegroupname -ErrorAction SilentlyContinue)) {
    New-AzureRMResourceGroup -Name $resourcegroupname -Location $location 
}

get0

