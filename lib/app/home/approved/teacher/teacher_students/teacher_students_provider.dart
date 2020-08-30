import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/quran.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class TeacherStudentsProvider {
  TeacherStudentsProvider({@required this.database});

  final Database database;

  Stream<List<Student>> fetchStudents(List<String> halaqatId) =>
      database.collectionStream(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Student.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('halaqatLearningIn', arrayContainsAny: halaqatId)
            .where('state', isEqualTo: 'approved'),
      );

  Future<void> createStudent(Student student) async {
    final DocumentReference postRef =
        Firestore.instance.document('/globalConfiguration/globalConfiguration');

    Firestore.instance.runTransaction((Transaction tx) async {
      if (student.readableId == null) {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        await tx.update(postRef, <String, dynamic>{
          'nextUserReadableId': postSnapshot.data['nextUserReadableId'] + 1,
        });
        student.readableId = postSnapshot['nextUserReadableId'].toString();
      }
      await tx.set(
        Firestore.instance.document(APIPath.userDocument(student.id)),
        student.toMap(),
      );
    }, timeout: Duration(seconds: 10));
  }

  Stream<List<Halaqa>> fetchHalaqat(List<String> halaqatId) =>
      database.collectionStream(
        path: APIPath.halaqatCollection(),
        builder: (data, documentId) => Halaqa.fromMap(data),
        queryBuilder: (query) => query
            .where('state', isEqualTo: 'approved')
            .where('id', whereIn: halaqatId),
      );

  Future<Quran> fetchQuran() => database.fetchDocument(
        path: APIPath.globalConfigurationDoc(),
        builder: (data, documentId) => Quran.fromMap(data, documentId),
      );

  Future<List<Student>> fetchStudentById(String id, String centerId) =>
      database.fetchCollection(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Student.fromMap(data, documentId),
        queryBuilder: (Query query) => query
            .where('readableId', isEqualTo: id)
            .where('state', isEqualTo: 'approved')
            .where('center', isEqualTo: centerId),
      );

//TODO what if a user in archived
  Future<List<Student>> fetchStudentByName(String name, String centerId) =>
      database.fetchCollection(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Student.fromMap(data, documentId),
        queryBuilder: (Query query) => query
            .where('name', isEqualTo: name)
            .where('state', isEqualTo: 'approved')
            .where('center', isEqualTo: centerId),
      );

  String getUniqueId() => database.getUniqueId();
}
