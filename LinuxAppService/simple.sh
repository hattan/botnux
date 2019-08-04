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

# Create a new Resource Group
az group create -n $resourceGroup -l $resoureGroupLocation

# Create a Service Principal
az ad app create --display-name $spName --password $spPassword --available-to-other-tenants

# Get Service Principal App Id
spId=$(az ad app list --display-name $spName --query [].appId --out tsv)

# Create a linux App Service Plan
az appservice plan create --name $appName --is-linux --sku S1 --resource-group $resourceGroup 

# Create a Linux App Service with Node10.14 run time
az webapp create --name $appName --plan $appName  -g $resourceGroup --runtime "NODE|10.14"

# Configure Application Settings
az webapp config appsettings set -g $resourceGroup -n $appName --settings MicrosoftAppId=$spId
az webapp config appsettings set -g $resourceGroup -n $appName --settings MicrosoftAppPassword=$spPassword

# Optional used by the Bot Demo Code to display the environment it's running in.
az webapp config appsettings set -g $resourceGroup -n $appName --settings RunningEnvironment=LinuxAppService

# Get the Public Url of the Linux App Service
appServiceUrl=$(az webapp show --name $appName --resource-group $resourceGroup --query hostNames[0] --out tsv)

# Get the Git Remote url for local git deployment.
gitUrl=$(az webapp deployment source config-local-git --name $appName --resource-group $resourceGroup --query url --output tsv)

# Create a git repo in the echo-bot code to only push that to the app service and not this entire folder structure
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

# Create the Bot Service
az bot create -k registration  -n $botName -g $resourceGroup --appid $spId --password '$spPassword' --endpoint "https://$appServiceUrl/api/messages" --sku S1




