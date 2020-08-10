import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

abstract class Database {
  String getUniqueId();
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

  Stream<T> documentStream<T>({
    @required
        String path,
    @required
        T builder(
      Map<String, dynamic> data,
      String documentID,
    ),
  });

  Future<T> fetchDocument<T>({
    @required
        String path,
    @required
        T builder(
      Map<String, dynamic> data,
      String documentID,
    ),
  });

  Future<T> fetchQueryDocument<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    @required Query queryBuilder(Query query),
  });
}
