import 'package:flutter/foundation.dart';

class Quran {
  Quran({
    @required this.data,
  });
  Map<String, int> data;

  factory Quran.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    List<dynamic> temp = data['quran'];

    Map<String, int> map = Map.fromIterable(
      temp,
      key: (item) => item['soura'],
      value: (item) => item['numberOfAyat'],
    );

    return Quran(
      data: map,
    );
  }
}
