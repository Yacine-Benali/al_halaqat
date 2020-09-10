import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreDatabase implements Database {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  @override
  String getUniqueId() {
    String _randomId = FirebaseFirestore.instance.collection(' ').doc().id;
    return _randomId;
  }

  @override
  Future<void> setData(
      {@required String path,
      @required Map<String, dynamic> data,
      @required bool merge}) async {
    final dcumentReference = FirebaseFirestore.instance.doc(path);
    print('set $path: $data');
    await dcumentReference.set(data, SetOptions(merge: merge));
  }

  Future<void> addDocument({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(path);
    print('created ${collectionReference.path}: $data');
    await collectionReference.add(data);
  }

  @override
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String id),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final List<T> result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .toList();

      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  @override
  Future<List<T>> fetchCollection<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String id),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) async {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final QuerySnapshot snapshot = await query.get();

    final List<T> result = snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList();

    if (sort != null) {
      result.sort(sort);
    }

    return result;
  }

  @override
  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String id),
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  @override
  Future<T> fetchDocument<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String id),
  }) async {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final DocumentSnapshot snapshot = await reference.get();
    return builder(snapshot.data(), snapshot.id);
  }

  @override
  Future<T> fetchQueryDocument<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String id),
    @required Query queryBuilder(Query query),
  }) async {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final QuerySnapshot snapshot = await query.limit(1).getDocuments();
    if (snapshot.docs.isEmpty) {
      return null;
    } else
      return builder(
          snapshot.docs?.elementAt(0)?.data(), snapshot.docs.elementAt(0).id);
  }

  @override
  Stream<T> queryDocument<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String id),
    @required Query queryBuilder(Query query),
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.limit(1).snapshots();
    return snapshots.map(
      (snapshot) => builder(
        snapshot?.docs?.first?.data(),
        snapshot?.docs?.first?.id,
      ),
    );
  }

  @override
  Future<void> deleteDocument({String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }
}
