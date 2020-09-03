import 'package:al_halaqat/app/conversation_helper/conversation_helper_provider.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/conversation.dart';
import 'package:al_halaqat/app/models/conversation_user.dart';
import 'package:al_halaqat/app/models/message.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/services/database.dart';

class ConversationHelpeBloc {
  ConversationHelpeBloc({this.database});
  Database database;
  final Message latestMessage = Message(
    content: '',
    receiverId: '',
    seen: false,
    senderId: '',
    timestamp: null,
    id: '',
  );

  String _calculateGroupeChatId(String teacherUid, String studentUid) {
    String groupChatId;

    if (studentUid.hashCode <= teacherUid.hashCode) {
      groupChatId = '$studentUid-$teacherUid';
    } else {
      groupChatId = '$teacherUid-$studentUid';
    }
    return groupChatId;
  }

  Future<void> onStudentAcceptance(Student student) async {
    print('on student acceptance');
    final ConversationHelperProvide provider =
        ConversationHelperProvide(database: database);
    final List<Admin> adminsList =
        await provider.fetchCenterAdmins(student.center);

    for (Admin admin in adminsList) {
      print('foudn admin');
      String groupeChatId = _calculateGroupeChatId(student.id, admin.id);

      Conversation conversation = Conversation(
        groupChatId: groupeChatId,
        latestMessage: latestMessage,
        student: ConversationUser.fromUser(student),
        teacher: ConversationUser.fromUser(admin),
        isEnabled: true,
        centerId: student.center,
      );

      await provider.createConversation(conversation);
    }
  }

  Future<void> onStudentCreation(Student student) async {
    print('on student creation');
    await onStudentAcceptance(student);
    final ConversationHelperProvide provider =
        ConversationHelperProvide(database: database);
    if (student.halaqatLearningIn != null) {
      if (student.halaqatLearningIn.isNotEmpty) {
        final List<Teacher> teachersList =
            await provider.fetchHalaqaTeacher(student.halaqatLearningIn);
        for (Teacher teacher in teachersList) {
          print('foudn teacher');
          String groupeChatId = _calculateGroupeChatId(student.id, teacher.id);

          Conversation conversation = Conversation(
            groupChatId: groupeChatId,
            latestMessage: latestMessage,
            student: ConversationUser.fromUser(student),
            teacher: ConversationUser.fromUser(teacher),
            isEnabled: true,
            centerId: student.center,
          );

          await provider.createConversation(conversation);
        }
      }
    }
  }

  Future<void> onStudentModification(
      Student oldStudent, Student newStudent) async {
    final ConversationHelperProvide provider =
        ConversationHelperProvide(database: database);
    print('on student modification');
    // print('old: ${oldStudent.halaqatLearningIn}');

    // print('new:  ${newStudent.halaqatLearningIn}');

    List<String> oldHalaqat = oldStudent.halaqatLearningIn;
    List<String> newHalaqat = newStudent.halaqatLearningIn;
    if (oldHalaqat == newHalaqat) return;

    List<String> removedHalaqat = List();
    List<String> addedHalaqat = List();
    //removed halaqat
    for (String old in oldHalaqat) {
      bool isRemoved = true;
      for (String neww in newHalaqat) {
        if (old == neww) isRemoved = false;
      }
      if (isRemoved && old != null) removedHalaqat.add(old);
    }
    //added halaqat
    for (String neww in newHalaqat) {
      bool isAdded = true;
      for (String old in oldHalaqat) {
        if (neww == old) isAdded = false;
      }
      if (isAdded && neww != null) addedHalaqat.add(neww);
    }

    //disable
    if (removedHalaqat.isNotEmpty) {
      print('removing: $removedHalaqat');
      final List<Teacher> teachersList =
          await provider.fetchHalaqaTeacher(removedHalaqat);
      for (Teacher teacher in teachersList) {
        print('found teacher to remove with');
        String groupChatId = _calculateGroupeChatId(teacher.id, newStudent.id);
        await provider.disableConversation(groupChatId);
      }
    }
    //create
    if (addedHalaqat.isNotEmpty) {
      print('adding: $addedHalaqat');

      final List<Teacher> teachersList =
          await provider.fetchHalaqaTeacher(addedHalaqat);
      for (Teacher teacher in teachersList) {
        print('found teacher to creating conv with');

        String groupChatId = _calculateGroupeChatId(teacher.id, newStudent.id);
        Conversation conversation = Conversation(
          groupChatId: groupChatId,
          latestMessage: latestMessage,
          student: ConversationUser.fromUser(newStudent),
          teacher: ConversationUser.fromUser(teacher),
          isEnabled: true,
          centerId: newStudent.center,
        );

        await provider.createConversation(conversation);
      }
    }
  }

  Future<void> onTeacherCreation(Teacher teacher) async {
    print('on teacher creation');
    print(teacher.halaqatTeachingIn);
    final ConversationHelperProvide provider =
        ConversationHelperProvide(database: database);
    if (teacher.halaqatTeachingIn != null) {
      if (teacher.halaqatTeachingIn.isNotEmpty) {
        final List<Student> studentsList =
            await provider.fetchHalaqatStudent(teacher.halaqatTeachingIn);
        for (Student student in studentsList) {
          print('foudn student');
          String groupeChatId = _calculateGroupeChatId(student.id, teacher.id);

          Conversation conversation = Conversation(
            groupChatId: groupeChatId,
            latestMessage: latestMessage,
            student: ConversationUser.fromUser(student),
            teacher: ConversationUser.fromUser(teacher),
            isEnabled: true,
            centerId: student.center,
          );

          await provider.createConversation(conversation);
        }
      } else {
        // print('halaqatTeacheing in empty');
      }
    } else {
      // print('halaqatTeacheing is null');
    }
  }

  Future<void> onTeacherModification(
      Teacher oldTeacher, Teacher newTeacher) async {
    final ConversationHelperProvide provider =
        ConversationHelperProvide(database: database);
    print('on teacher  modification');

    List<String> oldHalaqat = oldTeacher.halaqatTeachingIn;
    List<String> newHalaqat = newTeacher.halaqatTeachingIn;
    if (oldHalaqat == newHalaqat) return;
    List<String> removedHalaqat = List();
    List<String> addedHalaqat = List();
    //removed halaqat
    for (String old in oldHalaqat) {
      bool isRemoved = true;
      for (String neww in newHalaqat) {
        if (old == neww) isRemoved = false;
      }
      if (isRemoved && old != null) removedHalaqat.add(old);
    }
    //added halaqat
    for (String neww in newHalaqat) {
      bool isAdded = true;
      for (String old in oldHalaqat) {
        if (neww == old) isAdded = false;
      }
      if (isAdded && neww != null) addedHalaqat.add(neww);
    }

    //disable
    if (removedHalaqat.isNotEmpty) {
      print('removing: $removedHalaqat');
      final List<Student> teachersList =
          await provider.fetchHalaqatStudent(removedHalaqat);
      for (Student student in teachersList) {
        print('found student to remove ');
        String groupChatId = _calculateGroupeChatId(newTeacher.id, student.id);
        await provider.disableConversation(groupChatId);
      }
    }
    // create
    if (addedHalaqat.isNotEmpty) {
      print('adding: $addedHalaqat');

      final List<Student> teachersList =
          await provider.fetchHalaqatStudent(addedHalaqat);
      for (Student student in teachersList) {
        print('found student to creating conv with');

        String groupChatId = _calculateGroupeChatId(newTeacher.id, student.id);
        Conversation conversation = Conversation(
          groupChatId: groupChatId,
          latestMessage: latestMessage,
          student: ConversationUser.fromUser(student),
          teacher: ConversationUser.fromUser(newTeacher),
          isEnabled: true,
          centerId: student.center,
        );

        await provider.createConversation(conversation);
      }
    }
  }

  Future<void> onAdminAcceptance(Admin admin, String centerId) async {
    print('on admin acceptance');
    final ConversationHelperProvide provider =
        ConversationHelperProvide(database: database);
    final List<Student> studentsList =
        await provider.fetchCenterStudents(centerId);

    for (Student student in studentsList) {
      print('foudn studnents');
      String groupeChatId = _calculateGroupeChatId(student.id, admin.id);

      Conversation conversation = Conversation(
        groupChatId: groupeChatId,
        latestMessage: latestMessage,
        student: ConversationUser.fromUser(student),
        teacher: ConversationUser.fromUser(admin),
        isEnabled: true,
        centerId: student.center,
      );

      await provider.createConversation(conversation);
    }
  }
}
