import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/quran.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
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
    final DocumentReference postRef = FirebaseFirestore.instance
        .doc('/globalConfiguration/globalConfiguration');

    await FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      if (student.readableId == null) {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        tx.update(postRef, <String, dynamic>{
          'nextUserReadableId': postSnapshot.data()['nextUserReadableId'] + 1,
        });
        student.readableId =
            postSnapshot.data()['nextUserReadableId'].toString();
      }
      tx.set(
        FirebaseFirestore.instance.doc(APIPath.userDocument(student.id)),
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
