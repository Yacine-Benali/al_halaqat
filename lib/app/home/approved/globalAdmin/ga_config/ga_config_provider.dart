import 'package:alhalaqat/app/models/ga_config.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class GaConfigProvider {
  GaConfigProvider({@required this.database});

  final Database database;

  Future<void> updateGaConfig(GaConfig gaConfig) async =>
      await database.setData(
        data: gaConfig.toMap(),
        path: APIPath.gaConfigDocument(),
        merge: true,
      );

  Future<GaConfig> readGaConfig() async => await database.fetchDocument(
        path: APIPath.gaConfigDocument(),
        builder: (data, documentId) => GaConfig.fromMap(data, documentId),
      );
}
