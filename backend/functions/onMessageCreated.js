const admin = require('firebase-admin')
const functions = require('firebase-functions');
const db = admin.firestore();


exports.onMessageCreated = functions.firestore
    .document('conversations/{conversationId}/messages/{messageId}')
    .onCreate(async (snap, context) => {


        const doc = snap.data()
        const receiverId = doc.receiverId
        const user = await db.collection('users').doc(receiverId).get();
        if (user.data().pushToken != null) {

            var payload = {
                notification: {
                    title: 'وصلتك رسالة جديدة',
                    body: ' ',
                },
                token: user.data().pushToken,
            }
            return admin.messaging().send(payload);
        } else
            return null;

    });

