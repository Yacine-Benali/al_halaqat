import 'package:alhalaqat/app/models/conversation_user.dart';
import 'package:alhalaqat/app/models/message.dart';
import 'package:meta/meta.dart';

class Conversation {
  Conversation({
    @required this.groupChatId,
    @required this.latestMessage,
    @required this.student,
    @required this.teacher,
    @required this.isEnabled,
    @required this.centerId,
  });

  //
  bool isEnabled;
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
      bool isEnabled = data['isEnabled'];
      String centerId = data['centerId'];

      return Conversation(
        groupChatId: groupChatId,
        latestMessage: latestMessage,
        student: student,
        teacher: teacher,
        isEnabled: isEnabled,
        centerId: centerId,
      );
    }
  }

  factory Conversation.fromNotificationData(
    dynamic notification,
  ) {
    dynamic data = notification['data'];
    if (data == null) {
      return null;
    } else {
      final String groupChatId = data['groupeChatId'];
      Message latestMessage = Message(
        content: data['latestMessagecontent'],
        id: data['latestMessagesenderId'],
        receiverId: data['latestMessagereceiverId'],
        seen: (data['latestMessageseen'] == 'true'),
        senderId: data['latestMessagesenderId'],
        timestamp: null,
      );

      //
      ConversationUser teacher =
          ConversationUser(id: data['teacherId'], name: data['teacherName']);
      ConversationUser student =
          ConversationUser(id: data['studentId'], name: data['studentName']);
      //
      bool isEnabled = (data['isEnabled'] == 'true');
      String centerId = data['centerId'];

      return Conversation(
        groupChatId: groupChatId,
        latestMessage: latestMessage,
        student: student,
        teacher: teacher,
        isEnabled: isEnabled,
        centerId: centerId,
      );
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latestMessage': latestMessage.toMap(),
      'teacher': teacher.toMap(),
      'student': student.toMap(),
      'isEnabled': isEnabled,
      'centerId': centerId,
    };
  }

  Map<String, dynamic> toMapMerge() {
    return <String, dynamic>{
      'latestMessage': latestMessage.toMapmerge(),
      'teacher': teacher.toMap(),
      'student': student.toMap(),
      'isEnabled': isEnabled,
      'centerId': centerId,
    };
  }

  // @override
  // String toString() =>
  //     '{ uid= ${this.groupChatId}, teacherUid = ${this.teacher['uid']}, studentUid = ${this.student['uid']} }';
}
