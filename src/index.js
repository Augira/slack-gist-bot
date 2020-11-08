exports.handler = (event, context, callback) => {
  const response = {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: '{"text": "Thanks!"}',
  };
  callback(null, response);
};
