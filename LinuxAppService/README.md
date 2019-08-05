## Microsoft Bot Framework running on Linux App Service

The Azure portal provides mechanisms for creating bot services easily. By default, if you select a web app bot, it will provision a Bot Service resource and an Azure App Service to host the bot code itself. 
The process is seamless and creates a run running on a windows app service. If you have a need for running a nodejs or .net core application on a Linux App service, then you would have to provision a Linux App Service and configure it. This walkthrough explains how to do that.

### Bot Service variants

* Web App Bot: A bot that is automatically configured to use an App Service (Windows) backend.

* Channel Registration Bot: A bot service that allows you to use channels and allows you to specify any public endpoint for the bot's backend api.

In this walkthrough we're going to create a Registration Bot and configure it to use a Linux App Service to host our NodeJs bot.

For more information on 
https://docs.microsoft.com/en-us/azure/bot-service/bot-service-quickstart-registration?view=azure-bot-service-3.0&viewFallbackFrom=azure-bot-service-4.0

## Echo Bot
In the root of this repo is a [src/echo-bot](../src/echo-bot) folder which contains a simple bot that does one of 3 things.

* Grab a Joke from an API.
* Echo back an environment variable called RunningEnvironment.
* Echo back any other content the user enters that is a request for a joke or whereami command.

## Azure Portal
To go through a walkthrough of creating a Linux App Service and deploying the sample echo-bot using the Azure Portal. See the [Portal Walkthrough](./CreatePortal.md)

## Azure CLI 
To go through a walkthrough of creating a Linux App Service and deploying the sample echo-bot using the Azure CLI. See the [CL:I Walkthrough](./CreateCli.md)