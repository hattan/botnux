# Simple script without the config file output and also no debug statements. 
# This was included to make it easier to see the steps needs to create a Linux App Service Bot and deploy the nodejs code.

#configuration variables
uniqId=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)  #Unique ID for all resource names
prefix="botnux"
appName=$prefix$uniqId
resourceGroup=$appName"RG"
resoureGroupLocation="westus"
botName=$appName"BOT"
spName=$appName"SP"
spPassword=$(</dev/urandom tr -dc 'A-Za-z0-9!#$%&()*+,-./:;<=>?@[\]^_' | head -c 20  ; echo)"!2"
deploymentUser=""
deploymentUserPassword=""

if [ -z "$deploymentUser"  ]
then
  echo "ERROR: Deployment username is blank."
  exit 1
fi

if [ -z "$deploymentUserPassword"  ]
then
  echo "ERROR: Deployment user password is blank."
  exit 1
fi

az group create -n $resourceGroup -l $resoureGroupLocation

az ad app create --display-name $spName --password $spPassword --available-to-other-tenants

spId=$(az ad app list --display-name $spName --query [].appId --out tsv)

az appservice plan create --name $appName --is-linux --sku S1 --resource-group $resourceGroup 

az webapp create --name $appName --plan $appName  -g $resourceGroup --runtime "NODE|10.14"

az webapp config appsettings set -g $resourceGroup -n $appName --settings WEBSITE_NODE_DEFAULT_VERSION=10.14.1 
az webapp config appsettings set -g $resourceGroup -n $appName --settings MicrosoftAppId=$spId
az webapp config appsettings set -g $resourceGroup -n $appName --settings MicrosoftAppPassword=$spPassword
az webapp config appsettings set -g $resourceGroup -n $appName --settings RunningEnvironment=LinuxAppService

appServiceUrl=$(az webapp show --name $appName --resource-group $resourceGroup --query hostNames[0] --out tsv)
gitUrl=$(az webapp deployment source config-local-git --name $appName --resource-group $resourceGroup --query url --output tsv)

cd ../src/echo-bot
git init
git add -A
git commit -m "initial"
git remote set-url azure $gitUrl
retVal=$?
if [ $retVal -ne 0 ]; then
    git remote add azure $gitUrl
fi
git push azure master

az bot create -k registration  -n $botName -g $resourceGroup --appid $spId --password '$spPassword' --endpoint "https://$appServiceUrl/api/messages" --sku S1




