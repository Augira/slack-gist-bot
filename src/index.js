'use strict'

exports.handler = function (event, context, callback) {
  var response = {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: '{"text": "Thanks"}',
  }
  callback(null, response)
}
