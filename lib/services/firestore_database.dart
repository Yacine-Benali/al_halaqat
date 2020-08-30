import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreDatabase implements Database {
  Firestore instance = Firestore.instance;
  @override
  String getUniqueId() {
    String _randomId = Firestore.instance.collection(' ').document().documentID;
    return _randomId;
  }

  @override
  Future<void> setData(
      {@required String path,
      @required Map<String, dynamic> data,
      @required bool merge}) async {
    final dcumentReference = Firestore.instance.document(path);
    print('set $path: $data');
    await dcumentReference.setData(data, merge: merge);
  }

  Future<void> addDocument({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final CollectionReference collectionReference =
        Firestore.instance.collection(path);
    print('created ${collectionReference.path}: $data');
    await collectionReference.add(data);
  }

  @override
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) {
    Query query = Firestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final List<T> result = snapshot.documents
          .map((snapshot) => builder(snapshot.data, snapshot.documentID))
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
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) async {
    Query query = Firestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final QuerySnapshot snapshot = await query.getDocuments();

    final List<T> result = snapshot.documents
        .map((snapshot) => builder(snapshot.data, snapshot.documentID))
        .toList();

    if (sort != null) {
      result.sort(sort);
    }

    return result;
  }

  @override
  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = Firestore.instance.document(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots
        .map((snapshot) => builder(snapshot.data, snapshot.documentID));
  }

  @override
  Future<T> fetchDocument<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) async {
    final DocumentReference reference = Firestore.instance.document(path);
    final DocumentSnapshot snapshot = await reference.get();
    return builder(snapshot.data, snapshot.documentID);
  }

  @override
  Future<T> fetchQueryDocument<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    @required Query queryBuilder(Query query),
  }) async {
    Query query = Firestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final QuerySnapshot snapshot = await query.limit(1).getDocuments();
    if (snapshot.documents.isEmpty) {
      return null;
    } else
      return builder(snapshot.documents?.elementAt(0)?.data,
          snapshot.documents.elementAt(0).documentID);
  }

  @override
  Stream<T> queryDocument<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    @required Query queryBuilder(Query query),
  }) {
    Query query = Firestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.limit(1).snapshots();
    return snapshots.map(
      (snapshot) => builder(
        snapshot?.documents?.first?.data,
        snapshot?.documents?.first?.documentID,
      ),
    );
  }

  @override
  Future<void> deleteDocument({String path}) async {
    final reference = Firestore.instance.document(path);
    print('delete: $path');
    await reference.delete();
  }
}
