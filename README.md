# botnux - Bot Framework deployed on Linux AppService & Azure WebApp for Containers

This project is a walkthrough of deploying a Microsoft Bot Framework Bot to Azure Linux App Servirce and Azure WebApp for Containers.

This project name a combination of bot and Linux.

## Echo Bot
In the root of this repo is a [src/echo-bot](../src/echo-bot) folder which contains a simple bot that does one of 3 things.

* Grab a Joke from an API.
* Echo back an environment variable called RunningEnvironment.
* Echo back any other content the user enters that is a request for a joke or whereami command.

### Requirements
* [NodeJs](https://nodejs.org/en/)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)


### References

* [az ad app - reference](https://docs.microsoft.com/en-us/cli/azure/ad/app?view=azure-cli-latest)
* [az webapp deployment](https://docs.microsoft.com/en-us/cli/azure/webapp/deployment?view=azure-cli-latest)
* [Create a Node.js web app in Azure](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-get-started-nodejs)
* [Local Git deployment to Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/deploy-local-git)
* [Create an App Service app and deploy code from a local Git repository using Azure CLI](https://docs.microsoft.com/en-us/azure/app-service/scripts/cli-deploy-local-git?toc=%2fcli%2fazure%2ftoc.json)
* [Tutorial: Build a custom image and run in App Service from a private registry](https://docs.microsoft.com/en-us/azure/app-service/containers/tutorial-custom-docker-image)
* [https://microsoft.github.io/AzureTipsAndTricks/blog/tip19.html](https://microsoft.github.io/AzureTipsAndTricks/blog/tip19.html)



