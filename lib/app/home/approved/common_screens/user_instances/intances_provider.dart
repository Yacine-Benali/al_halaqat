import 'package:alhalaqat/app/models/instance.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class InstancesProvider {
  InstancesProvider({@required this.database});
  final Database database;

  Stream<List<Instance>> fetchIlatestInstances(
    String halaqaId,
  ) =>
      database.collectionStream(
        path: APIPath.instancesCollection(),
        builder: (data, documentId) => Instance.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('halaqaId', isEqualTo: halaqaId)
            .orderBy('createdAt', descending: true)
            .limit(10),
      );

  Stream<List<Instance>> fetchAllInstances(
    String halaqaId,
  ) =>
      database.collectionStream(
        path: APIPath.instancesCollection(),
        builder: (data, documentId) => Instance.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('halaqaId', isEqualTo: halaqaId)
            .orderBy('createdAt', descending: true),
      );

  Future<List<Instance>> fetchMoreInstances(
    String halaqaId,
    Instance instance,
  ) =>
      database.fetchCollection(
        path: APIPath.instancesCollection(),
        builder: (data, documentId) => Instance.fromMap(data, documentId),
        //sort: (a, b) => a.createdAt.compareTo(b.createdAt),
        queryBuilder: (query) => query
            .where('halaqaId', isEqualTo: halaqaId)
            .orderBy('createdAt', descending: true)
            .startAfter([instance.createdAt]).limit(10),
      );

  Future<void> setInstance(Instance instance) async => await database.setData(
        path: APIPath.instanceDocument(instance.id),
        data: instance.toMap(),
        merge: true,
      );

  Future<void> deleteInstance(Instance instance) async =>
      await database.deleteDocument(
        path: APIPath.instanceDocument(instance.id),
      );
  String getUniqueId() => database.getUniqueId();
}
