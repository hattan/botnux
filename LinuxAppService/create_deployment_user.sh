#!/bin/bash

#configuration variables
uniqId=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)  #Unique ID for all resource names
prefix="botnux"
appName=$prefix$uniqId
deploymentUser=$appName"Deploy"
deploymentUserPassword=$(</dev/urandom tr -dc 'A-Za-z0-9!#$%&()*+,-./:;<=>?@[\]^_' | head -c 20  ; echo)"!2"

echo "This will create a new Deployment User and Update existing configuration."
echo "If you have an existing deployment user, proceeding will overwrite that user credentials!! Use the existing deployment credentials if you have them."
read -p "Are you sure you would like to proceed (Y/n)? " confirm
if [ "$confirm" == "Y" ];
then
  echo "************* Create Deployment User ************* "
  echo "az webapp deployment user set --user-name $deploymentUser --password $deploymentUserPassword"
  az webapp deployment user set --user-name $deploymentUser --password $deploymentUserPassword

  echo "***************************  Linux App Service Bot Create App Service Deployment User******************************************************************"
  echo "Creating the following deployment user:\n"
  echo "  UserName: $deploymentUser"
  echo "  Password: $deploymentUserPassword\n"
  echo "**************************************************************************************************************************************************************"

  currentDate=`date`
  echo "***************************  Linux App Service Bot Create App Service Deployment User******************************************************************" > "deploy_user.dat"
  echo "Date: $currentDate" >> "deploy_user.dat"
  echo "deploymentUser=\"$deploymentUser\"" >> "deploy_user.dat"
  echo "deploymentUserPassword=\"$deploymentUserPassword\"" >> "deploy_user.dat"
else
  exit 1
fi


