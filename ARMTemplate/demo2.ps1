Import-Module Azure
Import-Module AzureRM.Profile
Import-Module AzureRM.Resources


$subscriptionName = "WWM-MSDN"

$OPSRGName = 'ITProCampJax-OPS'
$WEBRGName = 'ITProCampJax01'
$sitename = $("ITProCampJax01").tolower()

$StorPropObject = @{
    accountType = "Standard-LRS"
}
Select-AzureSubscription -SubscriptionName $subscriptionName

Get-AzureRmSubscription –SubscriptionName $subscriptionName | Select-AzureRmSubscription

$location = $(Find-AzureRmResource -ResourceType microsoft.web/sites -ResourceGroupNameContains $WEBRGName | select Location | sort -Property Location -Unique|% { $_.Location})

 
    if ( -not $( Get-AzureRMResourceGroup -Name $OPSRGName -ErrorAction SilentlyContinue)) {
        New-AzureRMResourceGroup -Name $OPSRGName -Location $location
    }
    
    $storageAccountName = "$($sitename)ops$location"
    if ( -not $( Get-AzureRMResource -ResourceName $storageAccountName -ResourceGroupName $OPSRGName -ErrorAction SilentlyContinue)) {
        New-AzureRMResource -ResourceGroupName $OPSRGName -ResourceType "Microsoft.ClassicStorage/storageAccounts" -ResourceName $storageAccountName -Location $location -ApiVersion 2015-06-01 -Properties $StorPropObject -Force
    }

    $key = $(Get-AzureStorageKey -StorageAccountName $storageAccountName).Primary 
    Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccountName $storageAccountName 
    
    if ( -not $(Get-AzureStorageContainer -Name "webapplog-$sitename" -ErrorAction SilentlyContinue)) {
            New-AzureStorageContainer -Name "webapplog-$sitename" -Permission Off
            }
    if ( -not $(Get-AzureStorageContainer -Name "websitelog-$sitename" -ErrorAction SilentlyContinue)) {
            New-AzureStorageContainer -Name "websitelog-$sitename" -Permission Off
            }

    $ctx = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $key

    if ( -not $(Get-AzureStorageContainerStoredAccessPolicy -Container "webapplog-$sitename" -Policy "AzurePortal_$sitename-$($location)_AppLogBlob" -ErrorAction SilentlyContinue)) {
            New-AzureStorageContainerStoredAccessPolicy -Container "webapplog-$sitename" -Permission rwdl -Policy "AzurePortal_$sitename-$($location)_AppLogBlob"
            }

    if ( -not $(Get-AzureStorageContainerStoredAccessPolicy -Container "websitelog-$sitename" -Policy "AzurePortal_$sitename-$($location)_SiteLogBlob" -ErrorAction SilentlyContinue)) {
            New-AzureStorageContainerStoredAccessPolicy -Container "websitelog-$sitename" -Permission rwdl -Policy "AzurePortal_$sitename-$($location)_SiteLogBlob"
            }

        $appSASToken = New-AzureStorageContainerSASToken -Context $ctx -Policy "AzurePortal_$sitename-$($location)_AppLogBlob" -Name "webapplog-$sitename" -ExpiryTime $(get-date).AddMonths(12)
        $siteSASToken = New-AzureStorageContainerSASToken -Context $ctx -Policy "AzurePortal_$sitename-$($location)_SiteLogBlob" -Name "websitelog-$sitename" -ExpiryTime $(get-date).AddMonths(12)

        $PropertiesObject = @{
	        ApplicationLogs = @{
                AzureBlobStorage = @{
                    Level = "Verbose";
                    sasUrl = "https://$storageAccountName.blob.core.windows.net/webapplog-$sitename$appSASToken"
                    retentionInDays = 14
                };
            };
            httpLogs = @{
                AzureBlobStorage = @{
                    sasUrl = "https://$storageAccountName.blob.core.windows.net/websitelog-$sitename$siteSASToken"
                    retentionInDays = 28
                    enabled = "true"
                };
            };
        }
           
   Set-AzureRmResource -Properties $PropertiesObject -ResourceGroupName $WEBRGName -ResourceType Microsoft.Web/sites/config -ResourceName "ITProCampJaxD4A01/logs" -ApiVersion 2015-08-01 -Force



