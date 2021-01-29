const admin = require('firebase-admin')
const functions = require('firebase-functions');
const db = admin.firestore();

exports.autoAccept = functions.firestore
    .document('globalAdminRequests/{gaRequestId}')
    .onCreate(async (change, context) => {
        const gaRequestId = context.params.gaRequestId;
        const gaRequestData = change.data();
        try {

            const gAConfigDoc = await db.collection('globalConfiguration').doc('globalAdminConfiguration').get();
            const gAConfigData = gAConfigDoc.data()
            if (gAConfigData.autoAccept != true) {
                return;

            }
            if (gaRequestData.action == 'join-new') {
                const requestDocRef = db.collection('globalAdminRequests').doc(gaRequestId)
                const key1 = `admin.centerState.${gaRequestData.centerId}`
                await requestDocRef.update({ state: 'approved', [key1]: 'approved', "center.state": 'approved' })


                // update the center if the action is join-new
                const centerDocRef = db.collection('centers').doc(gaRequestData.centerId)
                await centerDocRef.update({ state: 'approved' });

                // update the admin
                const adminDocRef = db.collection('users').doc(gaRequestData.adminId)

                const key2 = `centerState.${gaRequestData.centerId}`
                return adminDocRef.update({ [key2]: 'approved' })
              
            }

        } catch (error) {
            console.error('Error:', error);
        }

    });