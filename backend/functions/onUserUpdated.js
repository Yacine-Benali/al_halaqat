const admin = require('firebase-admin')
const functions = require('firebase-functions');
const { user } = require('firebase-functions/lib/providers/auth');

const db = admin.firestore();
const auth = admin.auth();

exports.onUserUpdated = functions.firestore
    .document('users/{userId}')
    .onWrite(async (change, context) => {
        const userId = context.params.userId;
        var username;
        var password;
        var hasUsernameChanged = false;
        var haspasswordChanged = false

        if (change.before.exists && !change.after.exists) {
            //delete
            // const userDoc = change.after.data();
            // const userId = context.params.userId;
            // const isGloabalAdmin = userDoc['isGlobalAdmin'];
            // const isAdmin = userDoc['isAdmin'];
            // const isTeacher = userDoc['isTeacher'];
            // const isStudent = userDoc['isStudent'];

            // const claims = {};
            // if (isGloabalAdmin == true) {
            //     claims['role'] = 'GlobalAdmin';

            // } else if (isAdmin == true) {
            //     claims['role'] = 'Admin';


            // } else if (isTeacher == true) {
            //     claims['role'] = 'teacher';

            // } else if (isStudent == true) {
            //     claims['role'] = 'student';
            // }

            // return admin.auth().setCustomUserClaims(userId, claims);
        } else if (change.before.exists && change.after.exists) {
            //update
            const userDocBefore = change.before.data();
            const userDocAfter = change.after.data();
            //
            if (userDocBefore.username != userDocAfter.username) {
                hasUsernameChanged = true;

            } if (userDocBefore.password != userDocAfter.password) {
                haspasswordChanged = true;
            }
            username = userDocAfter.username;
            password = userDocAfter.password;

            if (hasUsernameChanged || haspasswordChanged) {
                await auth.updateUser(userId, {
                    email: username,
                    password: password,
                });
            }
            //! lets the shitty code begins 
            const isStudent = userDocAfter['isStudent'];
            if (isStudent == true && userDocBefore.name != userDocAfter.name) {
                // student name changed
                const batch = db.batch();
                // change name in conversation
                const conversationQuerySnapshot = await db.collection('conversations').where('student.id', '==', userId).get();
                conversationQuerySnapshot.forEach((conversationDoc) => {
                    batch.update(conversationDoc.ref, { 'student.name': userDocAfter.name });
                });
                //name in report card
                const reportCardQuerySnapshot = await db.collection('reportCards').where('studentId', '==', userId).get();
                for (var i in reportCardQuerySnapshot.docs) {
                    const reportcardDoc = reportCardQuerySnapshot.docs[i]
                    batch.update(reportcardDoc.ref, { 'studentName': userDocAfter.name });
                    // evaluations
                    const evaluationsQuerySnapshot = await db.collection(`reportCards/${reportcardDoc.id}/evaluations/`).get();
                    evaluationsQuerySnapshot.forEach((evalDoc) => {
                        batch.update(evalDoc.ref, { 'studentName': userDocAfter.name });
                    });
                }
                return batch.commit();
            } else if (userDocBefore.name != userDocAfter.name) {
                //ga or admin or teacher name change
                const batch = db.batch();
                // created users

                const usersQuerySnapshot = await db.collection('users').where('createdBy.id', '==', userId).get();
                const centersQuerySnapshot = await db.collection('centers').where('createdBy.id', '==', userId).get();
                const halaqatQuerySnapshot = await db.collection('halaqat').where('createdBy.id', '==', userId).get();
                const instanceQuerySnapshot = await db.collection('instances').where('createdBy.id', '==', userId).get();
                const conversationsQuerySnapshot = await db.collection('conversations').where('teacher.id', '==', userId).get();
                const instanceTeacherSummery = await db.collection('instances').where('teacherSummery.id', '==', userId).get();

                // created users
                usersQuerySnapshot.forEach((userDoc) => {
                    batch.update(userDoc.ref, { 'createdBy.name': userDocAfter.name });
                });
                //created centers
                centersQuerySnapshot.forEach((centerDoc) => {
                    batch.update(centerDoc.ref, { 'createdBy.name': userDocAfter.name });
                });
                //created halaqat
                halaqatQuerySnapshot.forEach((halaqaDoc) => {
                    batch.update(halaqaDoc.ref, { 'createdBy.name': userDocAfter.name });
                });
                //created instance
                instanceQuerySnapshot.forEach((instanceDoc) => {
                    batch.update(instanceDoc.ref, { 'createdBy.name': userDocAfter.name });
                });
                instanceTeacherSummery.forEach((teacherSummeryDoc) => {
                    batch.update(teacherSummeryDoc.ref, { 'teacherSummery.name': userDocAfter.name });
                });
                // created conversations 
                conversationsQuerySnapshot.forEach((conversationDoc) => {
                    batch.update(conversationDoc.ref, { 'teacher.name': userDocAfter.name });
                });

                return batch.commit();
            } else {
                return null;
            }

        } else if (!change.before.exists && change.after.exists) {
            //create
            const userDoc = change.after.data();
            username = userDoc.username;
            password = userDoc.password;
            const isGloabalAdmin = userDoc['isGlobalAdmin'];
            const isAdmin = userDoc['isAdmin'];
            const isTeacher = userDoc['isTeacher'];
            const isStudent = userDoc['isStudent'];

            const claims = {};
            if (isGloabalAdmin == true) {
                claims['role'] = 'GlobalAdmin';

            } else if (isAdmin == true) {
                claims['role'] = 'Admin';


            } else if (isTeacher == true) {
                claims['role'] = 'teacher';

            } else if (isStudent == true) {
                claims['role'] = 'student';
            }
            await auth.createUser(
                {
                    uid: userId,
                    email: username,
                    password: password,
                });
            return auth.setCustomUserClaims(userId, claims);
        }

        return null;
    });