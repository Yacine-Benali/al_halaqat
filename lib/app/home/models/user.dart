import 'student.dart';

abstract class User {
  User();

  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    final bool isGloabalAdmin = data['isGlobalAdmin'];
    final bool isAdmin = data['isAdmin'];
    final bool isTeacher = data['isTeacher'];
    final bool isStudent = data['isStudent'];
    User user;
    if (isGloabalAdmin) {}
    if (isAdmin) {}
    if (isTeacher) {}
    if (isStudent) user = Student.fromMap(data, documentId);

    return user;
  }
}
