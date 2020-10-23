const admin = require('firebase-admin')
const functions = require('firebase-functions');
const db = admin.firestore();

exports.onAdminRequestCreated = functions.firestore
    .document('globalAdminRequests/{requestId}')
    .onWrite(async (snap, context) => {
        const requestData = snap.after.data();
        const userId = requestData.adminId;
        if (!snap.before.exists && snap.after.exists) {
            const gadmins = await db.collection('users').where('isGlobalAdmin', '==', true).get();
            promises = [];
            if (gadmins.docs.length > 0) {
                gadmins.forEach((adminDoc) => {
                    if (adminDoc.data().pushToken != null) {
                        const payload = {
                            notification: {
                                title: 'لديك طلب إنشاء مركز جديد',
                                body: ' ',
                            },
                            token: adminDoc.data().pushToken,
                        }
                        const p = admin.messaging().send(payload);
                        promises.push(p);
                    }
                    const finalPromise = Promise.all(promises)
                    return finalPromise;
                });
            };
        }
        else if (snap.before.exists && snap.after.exists) {
            if (snap.after.data().state != snap.before.data().state) {
                const adminDoc = await db.collection('users').doc(userId).get();
                if (adminDoc.data().pushToken != null) {
                    var payload;
                    if (requestData.state == 'approved') {
                        payload = {
                            notification: {
                                title: 'تمت الموافقة على طلبك',
                                body: ' ',
                            },
                            token: adminDoc.data().pushToken,
                        }

                    } else if (requestData.state == 'disapproved') {
                        payload = {
                            notification: {
                                title: 'تم رفض طلبك',
                                body: ' ',
                            },
                            token: adminDoc.data().pushToken,
                        }
                    }
                    return admin.messaging().send(payload);
                }
            }
        }
        return null;
    });