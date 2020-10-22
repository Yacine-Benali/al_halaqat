const admin = require('firebase-admin')
const functions = require('firebase-functions');
const db = admin.firestore();

exports.onCenterUpdated = functions.firestore
    .document('centers/{centerId}')
    .onUpdate(async (change, context) => {
        const centerId = context.params.centerId;
        const centerDocAfter = change.after.data();
        const isEnabled = centerDocAfter.isMessagingEnabled;
        try {
            const batch = db.batch();
            const instancesList = await db.collection('conversations').where('centerId', '==', centerId).get();
            // created conversations
            instancesList.forEach((instanceDoc) => {
                batch.update(instanceDoc.ref, { 'isEnabled': isEnabled });
            });

            return batch.commit();
        } catch (error) {
            console.error('Error:', error);
        }

    });