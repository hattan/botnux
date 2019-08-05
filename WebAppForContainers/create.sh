#configuration variables
uniqId=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)  #Unique ID for all resource names
prefix="botnux"
appName=$prefix$uniqId
resourceGroup=$appName"RG"
resoureGroupLocation="westus"
botName=$appName"BOT"
spName=$appName"SP"
spPassword=$(</dev/urandom tr -dc 'A-Za-z0-9!#$%&()*+,-./:;<=>?@[\]^_' | head -c 20  ; echo)"!2"
dockerImage="hattan/echo-joke-bot" 
# Docker image for the Bot from docker hub
# For a custom registry please see https://docs.microsoft.com/en-us/azure/app-service/containers/tutorial-custom-docker-image

echo "\n***************************  Web App for Containers Bot Example******************************************************************"
echo "Creating the following resources:\n"
echo "  Resource Group: $resourceGroup"
echo "  Service Plan: $appName"
echo "  App Service: $appName"
echo "  Bot Service: $botName"
echo "  Service Principal: $spName"
echo "  Service Principal Password: $spPassword"
echo "  Docker Image: $dockerImage"
echo "******************************************************************************************************************************"

currentDate=`date`
#Save Configs to Local File
echo  "\n***************************  Web App for Containers Bot Example******************************************************************"> "configs.dat"
echo "Date: $currentDate" >> "configs.dat"
echo "resourceGroup=$resourceGroup" >> "configs.dat"
echo "appName=$appName" >> "configs.dat"
echo "botName=$botName" >> "configs.dat"
echo "spName=$spName" >> "configs.dat"
echo "spPassword=$spPassword" >> "configs.dat"
echo "  Docker Image: $dockerImage" >> "configs.dat"

echo "\n************* Creating Resource Group ************* "
echo "az group create -n $resourceGroup -l $resoureGroupLocation"
az group create -n $resourceGroup -l $resoureGroupLocation

echo "\n************* Creating Service Principal ************* "
echo "az ad app create --display-name $spName --password $spPassword --available-to-other-tenants"
az ad app create --display-name $spName --password $spPassword --available-to-other-tenants

echo "\n************* Getting Service Principal  ID ************* "
spId=$(az ad app list --display-name $spName --query [].appId --out tsv)
echo "App Id = $spId"
echo "spId=$spId" >> "configs.dat"

echo "\n************* Creating App Service Plan ************* "
echo "az appservice plan create --name $appName --is-linux --sku S1 --resource-group $resourceGroup "
az appservice plan create --name $appName --is-linux --sku S1 --resource-group $resourceGroup 

echo "\n************* Creating Linux App Service ************* "
echo "az webapp create --resource-group $resourceGroup --plan $appName --name $appName --deployment-container-image-name $dockerImage"
az webapp create --resource-group $resourceGroup --plan $appName --name $appName --deployment-container-image-name $dockerImage

echo "\n************* Writing Application Settings for App Service ************* "
az webapp config appsettings set -g $resourceGroup -n $appName --settings MicrosoftAppId=$spId
az webapp config appsettings set -g $resourceGroup -n $appName --settings MicrosoftAppPassword=$spPassword
az webapp config appsettings set -g $resourceGroup -n $appName --settings RunningEnvironment=DockerContainer

echo "\n************* Fetching App Service Url ************* "
appServiceUrl=$(az webapp show --name $appName --resource-group $resourceGroup --query hostNames[0] --out tsv)
echo "App Service Url: $appServiceUrl"
echo "appServiceUrl=$appServiceUrl" >> "configs.dat"

echo "\n************* Creating Bot Service ************* "
echo "az bot create -k registration  -n $botName -g $resourceGroup --appid $spId --password '$spPassword' --endpoint "https://$appServiceUrl/api/messages" --sku S1"
az bot create -k registration  -n $botName -g $resourceGroup --appid $spId --password '$spPassword' --endpoint "https://$appServiceUrl/api/messages" --sku S1




