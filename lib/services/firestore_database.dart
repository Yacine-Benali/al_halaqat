import 'dart:io';

import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreDatabase implements Database {
  @override
  Future<dynamic> uploadFile({
    @required String path,
    @required File file,
  }) async {
    // StorageReference storageReference =
    //     FirebaseStorage.instance.ref().child(path);
    // StorageUploadTask uploadTask = storageReference.putFile(file);
    // StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

    // var result = await storageTaskSnapshot.ref.getDownloadURL();
    // return result;
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
  Stream<T> userDocumentStream<T>({
    @required String uid,
    @required T builder(Map<String, dynamic> data),
    @required String collection,
  }) {
    final query = Firestore.instance
        .collectionGroup(collection)
        .where('uid', isEqualTo: uid)
        .limit(1);
    //print('firestoreService');
    Stream<QuerySnapshot> querySnapshotStream = query.snapshots();
    Stream<DocumentSnapshot> documentSnapshotStream =
        querySnapshotStream.map((querySnapshot) {
      if (querySnapshot.documents.length == 0) {
        return null;
      } else {
        return querySnapshot.documents.elementAt(0);
      }
    });

    Stream<T> userStream = documentSnapshotStream.map((documentSnapshot) {
      return builder(documentSnapshot?.data);
    });

    return userStream;
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
}
