import 'package:flutter/foundation.dart';

class GaConfig {
  GaConfig({
    @required this.autoAccept,
    @required this.id,
  });
  bool autoAccept;
  final String id;

  factory GaConfig.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    String id = documentId;
    bool autoAccept = data['autoAccept'];

    return GaConfig(
      id: id,
      autoAccept: autoAccept,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'autoAccept': autoAccept,
    };
  }
}
