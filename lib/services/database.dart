import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'package:al_halaqat/services/api_path.dart';

abstract class Database {
  Future<dynamic> uploadFile({
    @required String path,
    @required File file,
  });
  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
    @required bool merge,
  });

  Future<void> addDocument({
    @required String path,
    @required Map<String, dynamic> data,
  });
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  });

  Future<List<T>> fetchCollection<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  });

  Stream<T> userDocumentStream<T>({
    @required String uid,
    @required T builder(Map<String, dynamic> data),
    @required String collection,
  });

  Stream<T> documentStream<T>({
    @required
        String path,
    @required
        T builder(
      Map<String, dynamic> data,
      String documentID,
    ),
  });
}
