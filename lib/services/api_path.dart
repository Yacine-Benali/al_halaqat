class APIPath {
  static String usersCollection() => 'users';
  static String userDocument(String uid) => 'users/$uid';
  static String globalConfigurationDoc() =>
      'globalConfiguration/globalConfiguration';

  static String centersCollection() => 'centers/';

  static String centerDocument(String uid) => 'centers/$uid';

  static String adminRequestsCollection() => 'adminRequestsCollection/';
  static String adminRequestsDocument(String uid) =>
      'adminRequestsCollection/$uid';
}
