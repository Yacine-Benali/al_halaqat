import 'dart:async';

import 'package:meta/meta.dart';

import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/firestore_service.dart';

abstract class Database {}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
}
