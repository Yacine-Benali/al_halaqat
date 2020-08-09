class APIPath {
  static String globalConfigurationDoc() =>
      'globalConfiguration/globalConfiguration';

  static String usersCollection() => 'users/';
  static String userDocument(String uid) => 'users/$uid';

  static String centersCollection() => 'centers/';
  static String centerDocument(String uid) => 'centers/$uid';

  static String centerRequestsDocument(String centerId, String requestId) =>
      'centers/$centerId/ga_requests/$requestId';

  static String globalAdminRequestsCollection() => 'globalAdminRequests/';
  static String globalAdminRequestsDocument(String requestId) =>
      'globalAdminRequests/$requestId';
}
