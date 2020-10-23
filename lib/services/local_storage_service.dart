import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService({this.perfs});
  SharedPreferences perfs;
  Future<Directory> getLocalPath() async {
    if (Platform.isAndroid) {
      return await getExternalStorageDirectory();
    }

    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
  }

  Future<File> getLocalFile(String fileName) async {
    final dir = await getLocalPath();
    return File('${dir.path}/$fileName');
  }

  Future<File> writeData(String data, String fileName) async {
    final file = await getLocalFile(fileName);
    return file.writeAsString("$data");
  }

  Future<bool> addValue(MapEntry<String, String> map) async {
    return await perfs.setString(map.key, map.value);
  }

  String getValue(String key) {
    return perfs.getString(key);
  }
}
