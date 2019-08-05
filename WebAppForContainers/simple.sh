#configuration variables
uniqId=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)  #Unique ID for all resource names
prefix="botnux"
appName=$prefix$uniqId
resourceGroup=$appName"RG"
resoureGroupLocation="westus"
botName=$appName"BOT"
spName=$appName"SP"
spPassword=$(</dev/urandom tr -dc 'A-Za-z0-9!#$%&()*+,-./:;<=>?@[\]^_' | head -c 20  ; echo)"!2"
dockerImage="hattan/echo-joke-bot" #Docker image for the Bot

az group create -n $resourceGroup -l $resoureGroupLocation

az ad app create --display-name $spName --password $spPassword --available-to-other-tenants

spId=$(az ad app list --display-name $spName --query [].appId --out tsv)

az appservice plan create --name $appName --is-linux --sku S1 --resource-group $resourceGroup 

az webapp create --resource-group $resourceGroup --plan $appName --name $appName --deployment-container-image-name $dockerImage

az webapp config appsettings set -g $resourceGroup -n $appName --settings MicrosoftAppId=$spId
az webapp config appsettings set -g $resourceGroup -n $appName --settings MicrosoftAppPassword=$spPassword
az webapp config appsettings set -g $resourceGroup -n $appName --settings RunningEnvironment=LinuxAppService

appServiceUrl=$(az webapp show --name $appName --resource-group $resourceGroup --query hostNames[0] --out tsv)

az bot create -k registration  -n $botName -g $resourceGroup --appid $spId --password '$spPassword' --endpoint "https://$appServiceUrl/api/messages" --sku S1




