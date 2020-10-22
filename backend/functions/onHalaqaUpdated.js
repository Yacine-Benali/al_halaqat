const admin = require('firebase-admin')
const functions = require('firebase-functions');
const db = admin.firestore();

exports.onHalaqaUpdated = functions.firestore
    .document('halaqat/{halaqaId}')
    .onUpdate(async (change, context) => {
        const halaqaId = context.params.halaqaId;
        const halaqaDocAfter = change.after.data();
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

    });