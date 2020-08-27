import 'package:al_halaqat/app/models/conversation_user.dart';
import 'package:al_halaqat/app/models/message.dart';
import 'package:meta/meta.dart';

class Conversation {
  Conversation({
    @required this.groupChatId,
    @required this.latestMessage,
    @required this.student,
    @required this.teacher,
    @required this.isMessagingEnabled,
    @required this.centerId,
  });

  //
  bool isMessagingEnabled;
  String centerId;
  String groupChatId;
  final Message latestMessage;
  //
  ConversationUser teacher;
  //
  ConversationUser student;

  factory Conversation.fromMap(
    Map<String, dynamic> data,
    String documentId,
  ) {
    if (data == null) {
      return null;
    } else {
      final String groupChatId = documentId;
      Message latestMessage =
          Message.fromMap(data['latestMessage'], documentId);

      //
      ConversationUser teacher = ConversationUser.fromMap(data['teacher']);
      ConversationUser student = ConversationUser.fromMap(data['student']);
      //
      bool isMessagingEnabled = data['isMessagingEnabled'];
      String centerId = data['centerId'];

      return Conversation(
        groupChatId: groupChatId,
        latestMessage: latestMessage,
        student: student,
        teacher: teacher,
        isMessagingEnabled: isMessagingEnabled,
        centerId: centerId,
      );
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latestMessage': latestMessage.toMap(),
      'teacher': teacher.toMap(),
      'student': student.toMap(),
      'isMessagingEnabled': isMessagingEnabled,
      'centerId': centerId,
    };
  }

  // @override
  // String toString() =>
  //     '{ uid= ${this.groupChatId}, teacherUid = ${this.teacher['uid']}, studentUid = ${this.student['uid']} }';
}