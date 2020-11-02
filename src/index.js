var Botkit = require('botkit');

var controller = Botkit.slackbot();

var bot = controller.spawn({

  token: "<your token>"

})
