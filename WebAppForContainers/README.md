## Microsoft Bot Framework running on Web App for Containers 

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

## Scripts

* create.sh : This is the main script used to spin up resources for your. It doesn't take any parameters, and creates unique resources everytime you run it. 
When complete it will output a file called configs.dat , which contains the resource names as well credentials that were created for you.
This script will perform the following operations:
  
  * Create a new Resource Group with a random name.
  * Create a new Service Principal.
  * Create a Linux App Service Plan.
  * Create a Linux App Service using a docker image from dockerhub
  * Add App settings for newly created App Service.
  * Create a Channels Registration Bot Service.

* simple.sh : This is the same as create.sh, but without the echo/debug information making it easier to read. This should be used mainly as a reference.

* cleanup.sh : This script reads in configs.dat (the file that gets created when you run create.sh) and removes resources generated in this walktrhough. The steps it takes are :

  * Deletes the created Resource Group and resources inside it (App Service Plan, App Service, Bot Service.)
  * Deletes the AD App (Service Principal.)