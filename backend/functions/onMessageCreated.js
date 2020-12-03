const admin = require('firebase-admin')
const functions = require('firebase-functions');
const db = admin.firestore();


exports.onMessageCreated = functions.firestore
    .document('conversations/{conversationId}/messages/{messageId}')
    .onCreate(async (snap, context) => {


        const doc = snap.data()
        const receiverId = doc.receiverId
        const receiverUser = await db.collection('users').doc(receiverId).get();
        const senderUser = await db.collection('users').doc(doc.receiverId).get();
        const conversationDoc = await db.collection('conversations').doc(context.params.conversationId).get();
        const conversationDocdata = conversationDoc.data();
        if (receiverUser.data().pushToken != null) {

            var payload = {
                notification: {
                    title: 'وصلتك رسالة جديدة',
                    body: ' ',
                    
                },
                data: {
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    centerId: conversationDocdata.centerId,
                    isEnabled: true,
                    latestMessage: {
                        content: conversationDocdata.latestMessage.content,
                        receiverId: conversationDocdata.latestMessage.receiverId,
                        seen: conversationDocdata.latestMessage.seen,
                        senderId: conversationDocdata.latestMessage.senderId,
                        timestamp: conversationDocdata.latestMessage.timestamp,
                    },
                    student: {
                        id: conversationDocdata.student.id,
                        name: conversationDocdata.student.name,
                    },

                    teacher: {
                        id: conversationDocdata.teacher.name,
                        name: conversationDocdata.teacher.id,
                    },
                },
                token: receiverUser.data().pushToken,
            }
            return admin.messaging().send(payload);
        } else
            return null;

    });

