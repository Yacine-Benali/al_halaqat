const admin = require('firebase-admin')
const functions = require('firebase-functions');
const db = admin.firestore();

exports.onHalaqaUpdated = functions.firestore
    .document('halaqat/{halaqaId}')
    .onUpdate(async (change, context) => {
        const halaqaId = context.params.halaqaId;
        const halaqaDocBefore = change.before.data();
        const halaqaDocAfter = change.after.data();

        if (halaqaDocBefore.name != halaqaDocAfter.name) {
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

            try {
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

                return batch2.commit();
            } catch (error) {
                console.error('Error:', error);
            }
        } else {
            return null;
        }
    });