resourceGroup=$(cat configs.dat | grep -w "resourceGroup" | cut -d'=' -f2)
spId=$(cat configs.dat | grep -w "spId" | cut -d'=' -f2)

echo "\n*************  Linux App Service Bot Cleanup*******************************"
echo "Creating the following resources:\n"
echo "  Resource Group: $resourceGroup"
echo "  Service Principal Id: $spId\n"
echo "**************************************************************************"

# Remove App / SP
echo "Removing Service Principal"
echo "az ad app delete --id $spId"
az ad app delete --id $spId

#Remove Resource Group (removes all resources in the rg)
echo "Removing resource group (removes all resources in the resource group"
echo "az group delete --name $resourceGroup --yes"
az group delete --name $resourceGroup --yes