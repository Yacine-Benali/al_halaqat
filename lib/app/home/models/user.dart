import 'student.dart';

abstract class User {
  User();

  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) return null;
    final bool isGloabalAdmin =
        data.containsKey('isGlobalAdmin') ? data['isGlobalAdmin'] : false;
    final bool isAdmin = data['isAdmin'] ?? false;
    final bool isTeacher = data['isTeacher'] ?? false;
    final bool isStudent = data['isStudent'] ?? false;
    User user;
    if (isGloabalAdmin) {}
    if (isAdmin) {}
    if (isTeacher) {}
    if (isStudent) user = Student.fromMap(data, documentId);

    return user;
  }
}
