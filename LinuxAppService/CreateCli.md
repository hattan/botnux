# Create a Bot Service running on a a Linux App Service - Azure CLI Walkthrough

There are several bash scripts provided that use the Azure CLI to provision a Linux App Service and deploy the echo bot code to it.

* create.sh : This is the main script used to spin up resources for your. It doesn't take any parameters, and creates unique resources everytime you run it. 
When complete it will output a file called configs.dat , which contains the resource names as well credentials that were created for you.
This script will perform the following operations:
  
  * Create a new Resource Group with a random name.
  * Create a new Service Principal.
  * Create a Linux App Service Plan.
  * Create a Linux App Service (node 10.14)
  * Add App settings for newly created App Service.
  * Configure deployment to App Service via git remote.
  * Create a new git repo in src/echo-bot
  * Add the App Service deployment url as a Git Remote called Azure. 
  * Commit and push code to azure. 
  * Create a Channels Registration Bot Service.

* simple.sh : This is the same as create.sh, but without the echo/debug information making it easier to read. This should be used mainly as a reference.

* cleanup.sh : This script reads in configs.dat (the file that gets created when you run create.sh) and removes resources generated in this walktrhough. The steps it takes are :

  * Deletes the created Resource Group and resources inside it (App Service Plan, App Service, Bot Service.)
  * Deletes the AD App (Service Principal.)

* create_deploymnet_user.sh : Script that can be used to provision a deployment user for app services. This is the user you will use when pushing via git to the App Service remote. 

Note, for your subscription it is a single user for deployment. If you run this script, it will modify and override any existing users you might have. If you have a deployment user in your subscription that you are using to deploy to an app service to. Use that.

You can see which deployment users you have using

``` az webapp deployment user show ```

For more information on configuring the webapp deployment user see: https://docs.microsoft.com/bs-latn-ba/cli/azure/webapp/deployment/user?view=azure-cli-latest

https://docs.microsoft.com/en-us/azure/app-service/deploy-configure-credentials
