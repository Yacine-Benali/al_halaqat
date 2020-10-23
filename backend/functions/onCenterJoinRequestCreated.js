const admin = require('firebase-admin')
const functions = require('firebase-functions');
const db = admin.firestore();

exports.onCenterJoinRequestCreated = functions.firestore
    .document('centers/{centerId}/requests/{requestId}')
    .onCreate(async (snap, context) => {
        const centerId = context.params.centerId;
        const requestData = snap.data();
        const promises = [];

        // const isTeacher = requestData.user['isTeacher'];
        // const isStudent = requestData.user['isStudent'];
        // var gender;
        // if (requestData.user.gender == 'ذكر' && isTeacher) {
        //     gender = maleTeacher;
        // } else {

        // }

        if (requestData.action == 'join-existing' || requestData.action == 'join-existing-new') {
            console.log('this request needs a log');
            var logObject = {
                'createdAt': admin.firestore.FieldValue.serverTimestamp(),
                'teacher': {
                    'id': requestData.userId,
                    'name': requestData.user.name,
                },
                'action': 'join-existing',
                'object': {
                    'id': '',
                    'name': '',
                    'nature': '',
                },
            };

            await db.collection('centers').doc(centerId).collection('logs').add(logObject);
        }
        const admins = await db.collection('users').where('centers', 'array-contains',
            centerId).where('isAdmin', '==', true).get();

        if (admins.docs.length > 0) {
            admins.forEach((adminDoc) => {
                if (adminDoc.data().pushToken != null) {
                    const payload = {
                        notification: {
                            title: 'لديك طلب انتساب بحاجة للموافقة',
                            body: ' ',
                        },
                        token: adminDoc.data().pushToken,
                    }
                    const p = admin.messaging().send(payload);
                    promises.push(p);
                }
            });
            const finalPromise = Promise.all(promises)
            return finalPromise;
        } else
            return null;

    });