const functions = require("firebase-functions/v1");

const admin = require("firebase-admin");
admin.initializeApp();

exports.sendMessage = functions.https.onRequest(async (req, res) => {
  const token = req.query.token;
  const body = req.query.body;
  const title = req.query.title;

  try {
    await admin.messaging().send({
      token: token,
      notification: {
        body: body,
        title: title,
      },
    });

    res.json({token: token, title: title, body: body, result: `Everything ok`});
  } catch (error) {
    res.json({
      token: token || "", title: title || "", body: body || "", error: error,
    });
  }
});
