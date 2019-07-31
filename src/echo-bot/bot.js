// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

const { ActivityHandler, MessageFactory  } = require('botbuilder');
const JokeService = require('./services/jokeservice');
const SimpleIntentRecognizer = require('./services/simpleintentrecognizer');

const recognizer = new SimpleIntentRecognizer();
const jokeService = new JokeService();

class MyBot extends ActivityHandler {
    constructor(runningEnv) {
        super();

        this.onMessage(async (context, next) => {
            let response = await recognizer.recognize(context);
            let intent = recognizer.topIntent(response);

            switch(intent){
                case 'telljoke':
                  const joke = await jokeService.getJoke();
                  await context.sendActivity(joke);
                  break;
                case 'whereami':
                    await context.sendActivity(`Currently running on ${runningEnv}`);
                    break;
                default:
                  await context.sendActivity(`You said '${ context.activity.text }'`);
            }

            await this.helpMessage(context);

            await next();
        });

        this.onMembersAdded(async (context, next) => {
            const membersAdded = context.activity.membersAdded;
            for (let cnt = 0; cnt < membersAdded.length; ++cnt) {
                if (membersAdded[cnt].id !== context.activity.recipient.id) {
                    await context.sendActivity(`Hello I'm Botnux, a chat bot running on ${runningEnv}`);
                    await this.helpMessage(context);
                }
            }
            await next();
        });
    }

    async helpMessage(context){
      var suggestedActions = MessageFactory.suggestedActions(['Tell Joke','Where am I?']);
      await context.sendActivity(suggestedActions);
    }
}

module.exports.MyBot = MyBot;
