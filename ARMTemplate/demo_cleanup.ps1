Get-AzureRmResource | where ResourceType -eq "Microsoft.Web/sites" | Remove-AzureRmResource -Force
Get-AzureRmResource | where ResourceType -like "Microsoft.Insights*" | Remove-AzureRmResource -Force
Get-AzureRmResource | where ResourceType -eq "Microsoft.Web/serverFarms" | Remove-AzureRmResource -Force
Get-AzureRmResource | where ResourceType -eq "Microsoft.Web/serverFarms" | Remove-AzureRmResource -Force
Get-AzureRmResource | where ResourceType -eq "Microsoft.Sql/servers/databases" | Remove-AzureRmResource -Force
Get-AzureRmResource | where ResourceType -eq "Microsoft.Sql/servers" | Remove-AzureRmResource -Force
Remove-AzureRmResourceGroup -Name 'PoshSatTampa01'
Remove-AzureRmResourceGroup -Name 'PoshSatTampa-OPS'