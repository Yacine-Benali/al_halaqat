const admin = require('firebase-admin')
const functions = require('firebase-functions');
const db = admin.firestore();

exports.onInstanceCreated = functions.firestore
    .document('instances/{instanceId}')
    .onCreate(async (snap, context) => {
        const centerId = snap.data().centerId

        promises = [];

        const admins = await db.collection('users').where('centers', 'array-contains',
            centerId).where('isAdmin', '==', true).get();

        if (admins.docs.length > 0) {
            admins.forEach((adminDoc) => {
                if (adminDoc.data().pushToken != null) {
                    const payload = {
                        notification: {
                            title: 'تم حفظ جلسة جديدة',
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
        return null;

    });