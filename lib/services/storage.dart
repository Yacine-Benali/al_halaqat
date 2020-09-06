import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Storage {
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
}
