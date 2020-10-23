const admin = require('firebase-admin')
const functions = require('firebase-functions');
const db = admin.firestore();

exports.onRequestApproved = functions.firestore
    .document('centers/{centerId}/requests/{requestId}')
    .onUpdate(async (snap, context) => {
        const requestData = snap.after.data();
        const userId = requestData.userId;
        if (snap.before.exists && snap.after.exists) {
            if (snap.after.data().state != snap.before.data().state) {
                const student = await db.collection('users').doc(userId).get();
                if (student.data().pushToken != null) {
                    var payload;
                    if (requestData.state == 'approved') {
                        payload = {
                            notification: {
                                title: 'تمت الموافقة على طلبك',
                                body: ' ',
                            },
                            token: student.data().pushToken,
                        }

                    } else if (requestData.state == 'disapproved') {
                        payload = {
                            notification: {
                                title: 'تم رفض طلبك',
                                body: ' ',
                            },
                            token: student.data().pushToken,
                        }
                    }
                    return admin.messaging().send(payload);
                }
            }
        }
        return null;
    });