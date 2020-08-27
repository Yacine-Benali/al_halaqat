// import 'package:meta/meta.dart';
// import 'package:b1_parent/app/conversation/conversations_provider.dart';
// import 'package:b1_parent/app/conversation/conversation_model.dart';
// import 'package:b1_parent/app/conversation/message_model.dart';
// import 'package:b1_parent/app/conversation/teacher_model.dart';
// import 'package:b1_parent/app/student_model.dart';

// class ConversationsBloc {
//   ConversationsBloc({
//     @required this.conversationsProvider,
//     @required this.student,
//   });

//   final ConversationsProvider conversationsProvider;
//   final StudentModel student;

//   Stream getConversationStream() {
//     Stream<List<TeacherModel>> listOfTeachersStream = conversationsProvider
//         .teachersStream(student.schoolName, student.classroom);

//     Stream<List<ConversationModel>> listOfConversationsStream =
//         conversationsProvider.conversationStream(
//             student.schoolName, student.uid);

//     listOfTeachersStream.listen((listOfTeachers) {
//       for (TeacherModel teacher in listOfTeachers) {
//         bool isCreatConversation = true;

//         listOfConversationsStream.first.then((listOfConversation) async {
//           if (listOfConversation.length != 0) {
//             for (ConversationModel conversation in listOfConversation) {
//               // print(
//               //     'comapring ${teacher.uid} and ${conversation.teacher['uid']}');

//               if (conversation.teacher['uid'] == teacher.uid) {
//                 isCreatConversation = false;
//                 // print('${teacher.uid} teacher  have convo ');
//               }
//             }
//             if (isCreatConversation) {
//               //print('${teacher.uid} teacher  does not have convo');
//               await creatConversation(teacher);
//             }
//           } else {
//             //print('list equals to zero');
//             if (isCreatConversation) {
//               await creatConversation(teacher);
//             }
//           }
//         });
//       }
//     });

//     return listOfConversationsStream;
//   }

//   Future<void> creatConversation(TeacherModel teacher) async {
//     print('creating conversation for ${teacher.uid}');
//     String groupChatId = calculateGroupeChatId(teacher.uid, student.uid);

//     Map<String, dynamic> teacherMap = {
//       'uid': teacher.uid,
//       'firstName': teacher.firstName,
//       'lastName': teacher.lastName,
//       'photoUrl': teacher.photoUrl,
//       'subjects': teacher.subjects,
//       'pushToken': teacher.pushToken,
//     };
//     Map<String, String> studentMap = {
//       'uid': this.student.uid,
//       'firstName': this.student.firstName,
//       'lastName': this.student.lastName,
//       'photoUrl': this.student.photoUrl,
//       'classroom': this.student.classroom,
//       'pushToken': this.student.pushToken,
//     };

//     MessageModel emptyMessage = MessageModel(
//       uid: DateTime.now().millisecondsSinceEpoch.toString(),
//       content: '',
//       type: 0,
//       receiverId: teacher.uid,
//       seen: true,
//       senderId: student.uid,
//       timestamp: DateTime.now().millisecondsSinceEpoch,
//     );

//     ConversationModel emptyConversation = ConversationModel(
//       latestMessage: emptyMessage,
//       student: studentMap,
//       teacher: teacherMap,
//     );

//     await conversationsProvider.creatConversation(
//         student.schoolName, emptyConversation, groupChatId);
//   }

//   String calculateGroupeChatId(String teacherUid, String studentUid) {
//     String groupChatId;

//     if (studentUid.hashCode <= teacherUid.hashCode) {
//       groupChatId = '$studentUid-$teacherUid';
//     } else {
//       groupChatId = '$teacherUid-$studentUid';
//     }
//     return groupChatId;
//   }
// }
