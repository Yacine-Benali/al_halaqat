class APIPath {
  static String usersCollection() => 'users';
  static String userDocument(String uid) => 'users/$uid';
  static String globalConfigurationDoc() =>
      'globalConfiguration/globalConfiguration';
}
