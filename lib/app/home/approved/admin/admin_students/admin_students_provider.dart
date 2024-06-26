import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/quran.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminStudentsProvider {
  AdminStudentsProvider({@required this.database});

  final Database database;

  Stream<List<Student>> fetchStudents(List<String> centerIds) =>
      database.collectionStream(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Student.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('isStudent', isEqualTo: true)
            .where('center', whereIn: centerIds),
        sort: (a, b) => a.createdAt.compareTo(b.createdAt),
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
    });
  }

  Stream<List<Halaqa>> fetchHalaqat(List<String> centerIds) =>
      database.collectionStream(
        path: APIPath.halaqatCollection(),
        builder: (data, documentId) => Halaqa.fromMap(data),
        queryBuilder: (query) => query
            .where('state', isEqualTo: 'approved')
            .where('centerId', whereIn: centerIds),
        sort: (a, b) => a.createdAt.compareTo(b.createdAt),
      );

  Future<Quran> fetchQuran() => database.fetchDocument(
        path: APIPath.globalConfigurationDoc(),
        builder: (data, documentId) => Quran.fromMap(data, documentId),
      );

  String getUniqueId() => database.getUniqueId();
}
