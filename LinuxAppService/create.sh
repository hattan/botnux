#configuration variables
uniqId=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)  #Unique ID for all resource names
prefix="botnux"
appName=$prefix$uniqId
resourceGroup=$appName"RG"
resoureGroupLocation="westus"
botName=$appName"BOT"
spName=$appName"SP"
spPassword=$(</dev/urandom tr -dc 'A-Za-z0-9!#$%&()*+,-./:;<=>?@[\]^_' | head -c 20  ; echo)"!2"
deploymentUser="botnuxu0xgHDeploy"
deploymentUserPassword="NE3+*;=BD#!SL;<kVKzg!2"

if [ -z "$deploymentUser"  ]
then
echo "\n***************************  Linux App Service Bot Example******************************************************************"
  echo "ERROR: Deployment username is blank."
  echo "If you have a deployment username/password for any app service in your subscription. Use that!"
  echo "You can create a deployment username/password using the create_deployment_user.sh script."
  echo "!! Note: This applies for all app services in your subscription. If you have an existing deployment user exit this script and add the values above !!"
  exit 1
  echo "\n***************************  Linux App Service Bot Example******************************************************************"
fi

if [ -z "$deploymentUserPassword"  ]
then
echo "\n***************************  Linux App Service Bot Example******************************************************************"
  echo "ERROR: Deployment user password is blank."
  echo "If you have a deployment username/password for any app service in your subscription. Use that!"
  echo "You can create a deployment username/password using the create_deployment_user.sh script."
  echo "!! Note: This applies for all app services in your subscription. If you have an existing deployment user exit this script and add the values above !!"
  exit 1
  echo "\n***************************  Linux App Service Bot Example******************************************************************"
fi

echo "\n***************************  Linux App Service Bot Example******************************************************************"
echo "Creating the following resources:\n"
echo "  Resource Group: $resourceGroup"
echo "  Service Plan: $appName"
echo "  App Service: $appName"
echo "  Bot Service: $botName"
echo "  Service Principal: $spName"
echo "  Service Principal Password: $spPassword"
echo "  Deploy UserName: $deploymentUser"
echo "  Deploy Password: $deploymentUserPassword\n"
echo "******************************************************************************************************************************"

currentDate=`date`
#Save Configs to Local File
echo  "\n***************************  Linux App Service Bot Example******************************************************************"> "configs.dat"
echo "Date: $currentDate" >> "configs.dat"
echo "resourceGroup=$resourceGroup" >> "configs.dat"
echo "appName=$appName" >> "configs.dat"
echo "botName=$botName" >> "configs.dat"
echo "spName=$spName" >> "configs.dat"
echo "spPassword=$spPassword" >> "configs.dat"
echo "deploymentUser=$deploymentUser" >> "configs.dat"
echo "deploymentUserPassword=$deploymentUserPassword" >> "configs.dat"

echo "\n************* Creating Resource Group ************* "
echo "az group create -n $resourceGroup -l $resoureGroupLocation"
az group create -n $resourceGroup -l $resoureGroupLocation

echo "\n************* Creating Service Principal ************* "
echo "az ad app create --display-name $spName --password $spPassword --available-to-other-tenants"
az ad app create --display-name $spName --password $spPassword --available-to-other-tenants

echo "\n************* Getting Service Princial ID ************* "
spId=$(az ad app list --display-name $spName --query [].appId --out tsv)
echo "App Id = $spId"
echo "spId=$spId" >> "configs.dat"

echo "\n************* Creating App Service Plan ************* "
echo "az appservice plan create --name $appName --is-linux --sku S1 --resource-group $resourceGroup "
az appservice plan create --name $appName --is-linux --sku S1 --resource-group $resourceGroup 

echo "\n************* Creating Linux App Service ************* "
echo "az webapp create --name $appName --plan $appName  -g $resourceGroup --runtime NODE|10.14"
az webapp create --name $appName --plan $appName  -g $resourceGroup --runtime "NODE|10.14"

echo "\n************* Writing Application Settings for App Service ************* "
az webapp config appsettings set -g $resourceGroup -n $appName --settings WEBSITE_NODE_DEFAULT_VERSION=10.14.1 
az webapp config appsettings set -g $resourceGroup -n $appName --settings MicrosoftAppId=$spId
az webapp config appsettings set -g $resourceGroup -n $appName --settings MicrosoftAppPassword=$spPassword
az webapp config appsettings set -g $resourceGroup -n $appName --settings RunningEnvironment=LinuxAppService

echo "\n************* Fetching App Service Url ************* "
appServiceUrl=$(az webapp show --name $appName --resource-group $resourceGroup --query hostNames[0] --out tsv)
echo "App Service Url: $appServiceUrl"
echo "appServiceUrl=$appServiceUrl" >> "configs.dat"


echo "\n************* Configuring local git deployment ************* "
gitUrl=$(az webapp deployment source config-local-git --name $appName --resource-group $resourceGroup --query url --output tsv)
echo "Local Git Deployment Url: $gitUrl"
echo "gitUrl=$gitUrl" >> "configs.dat"

# We are initializing a new git repo to only push the bot source code to the app service
echo "\n************* Deploying Bot Code via local git ************* "
cd ../src/echo-bot
git init
git add -A
git commit -m "initial"
git remote set-url azure $gitUrl
retVal=$?
if [ $retVal -ne 0 ]; then
    git remote add azure $gitUrl
fi

echo "Remote Password: $deploymentUserPassword"
echo "Paste the above Password when prompted!"
git push azure master

echo "\n************* Creating Bot Service ************* "
echo "az bot create -k registration  -n $botName -g $resourceGroup --appid $spId --password '$spPassword' --endpoint "https://$appServiceUrl/api/messages" --sku S1"
az bot create -k registration  -n $botName -g $resourceGroup --appid $spId --password '$spPassword' --endpoint "https://$appServiceUrl/api/messages" --sku S1




