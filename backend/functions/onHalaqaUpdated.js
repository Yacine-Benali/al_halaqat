const admin = require('firebase-admin')
const functions = require('firebase-functions');
const db = admin.firestore();

exports.onHalaqaUpdated = functions.firestore
    .document('halaqat/{halaqaId}')
    .onWrite(async (change, context) => {
        const halaqaId = context.params.halaqaId;
        const halaqaDocBefore = change.before.data();
        const halaqaDocAfter = change.after.data();
        const centerId = halaqaDocAfter.centerId;

        if (!change.before.exists && change.after.exists) {
            // create
            promises = []
            const admins = await db.collection('users').where('centers', 'array-contains',
                centerId).where('isAdmin', '==', true).get();

            if (admins.docs.length > 0) {
                admins.forEach((adminDoc) => {
                    if (adminDoc.data().pushToken != null) {
                        const payload = {
                            notification: {
                                title: 'تم إنشاء حلقة جديدة',
                                body: ' ',
                            },
                            token: adminDoc.data().pushToken,
                        }
                        console.log('payload sent to');
                        console.log(adminDoc.data().pushToken);
                        const p = admin.messaging().send(payload);
                        promises.push(p);
                    } else {
                        console.log('pushtoken null');
                    }
                });
                const finalPromise = Promise.all(promises)
                return finalPromise;
            } else {
                return null;
            }
        } else if (halaqaDocBefore.name != halaqaDocAfter.name) {
            try {
                const batch = db.batch();
                const instancesList = await db.collection('instances').where('halaqaId', '==', halaqaId).get();
                // created instance
                instancesList.forEach((instanceDoc) => {
                    batch.update(instanceDoc.ref, { 'halaqaName': halaqaDocAfter.name });
                });

                return batch.commit();
            } catch (error) {
                console.error('Error:', error);
            }
        } else if (halaqaDocBefore.state != 'deleted' && halaqaDocAfter.state == 'deleted') {
            promises = [];
            try {
                const admins = await db.collection('users').where('centers', 'array-contains',
                    centerId).where('isAdmin', '==', true).get();

                if (admins.docs.length > 0) {
                    admins.forEach((adminDoc) => {
                        if (adminDoc.data().pushToken != null) {
                            const payload = {
                                notification: {
                                    title: 'تم حذف حلقة',
                                    body: ' ',
                                },
                                token: adminDoc.data().pushToken,
                            }
                            const p = admin.messaging().send(payload);
                            promises.push(p);
                        }
                    });
                }
                const batch2 = db.batch();
                const students = await db.collection('users').where('halaqatLearningIn', 'array-contains',
                    halaqaId).get();
                const teachers = await db.collection('users').where('halaqatTeachingIn', 'array-contains',
                    halaqaId).get();

                students.forEach((studentDoc) => {
                    batch2.update(studentDoc.ref, { 'halaqatLearningIn': admin.firestore.FieldValue.arrayRemove(halaqaId) });
                });

                teachers.forEach((teacherDoc) => {
                    batch2.update(teacherDoc.ref, { 'halaqatTeachingIn': admin.firestore.FieldValue.arrayRemove(halaqaId) });
                });

                const p2 = batch2.commit();
                promises.push(p2);

                const finalPromise = Promise.all(promises)
                return finalPromise;
            } catch (error) {
                console.error('Error:', error);
            }
        } else {
            return null;
        }
    });