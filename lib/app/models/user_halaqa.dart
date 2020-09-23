import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:flutter/foundation.dart';

class UserHalaqa<T> {
  UserHalaqa({
    @required this.usersList,
    @required this.halaqatList,
  });

  final List<T> usersList;
  final List<Halaqa> halaqatList;
}
