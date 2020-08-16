class APIPath {
  static String globalConfigurationDoc() =>
      'globalConfiguration/globalConfiguration';

  static String usersCollection() => 'users/';
  static String userDocument(String uid) => 'users/$uid';

  static String centersCollection() => 'centers/';
  static String centerDocument(String uid) => 'centers/$uid';

  static String centerRequestsDocument(String centerId, String requestId) =>
      'centerRequests/$requestId';

  static String globalAdminRequestsCollection() => 'globalAdminRequests/';
  static String globalAdminRequestsDocument(String requestId) =>
      'globalAdminRequests/$requestId';

  static String halaqatCollection() => 'halaqat/';
  static String halaqaDocument(String halaqaId) => 'halaqat/$halaqaId';

  static String instancesCollection() => 'instances/';
  static String instanceDocument(String instanceId) => 'instances/$instanceId';
}
