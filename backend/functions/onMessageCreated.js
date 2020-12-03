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
                    "click_action": "FLUTTER_NOTIFICATION_CLICK",
                    "centerId": `${conversationDocdata.centerId}`,
                    "isEnabled": `${conversationDocdata.isEnabled}`,
                    "groupeChatId":`${conversationDoc.id}`,
                    "latestMessagecontent": `${conversationDocdata.latestMessage.content}`,
                    "latestMessagereceiverId": `${conversationDocdata.latestMessage.receiverId}`,
                    "latestMessageseen": `${conversationDocdata.latestMessage.seen}`,
                    "latestMessagesenderId": `${conversationDocdata.latestMessage.senderId}`,
                    "latestMessagetimestamp": `${conversationDocdata.latestMessage.timestamp}`,
                    "studentId": `${conversationDocdata.student.id}`,
                    "studentName": `${conversationDocdata.student.name}`,
                    "teacherId": `${conversationDocdata.teacher.name}`,
                    "teacherName": `${conversationDocdata.teacher.id}`,
                },
                token: receiverUser.data().pushToken,
            }
            return admin.messaging().send(payload);
        } else
            return null;

    });

