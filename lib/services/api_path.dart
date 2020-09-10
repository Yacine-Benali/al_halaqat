class APIPath {
  static String globalConfigurationDoc() =>
      'globalConfiguration/globalConfiguration';

  static String usersCollection() => 'users';
  static String userDocument(String uid) => 'users/$uid';

  static String centersCollection() => 'centers/';
  static String centerDocument(String uid) => 'centers/$uid';

  static String centerRequestsCollection(String centerId) =>
      'centers/$centerId/requests';
  static String centerRequestsDocument(String centerId, String requestId) =>
      'centers/$centerId/requests/$requestId';

  static String globalAdminRequestsCollection() => 'globalAdminRequests';
  static String globalAdminRequestsDocument(String requestId) =>
      'globalAdminRequests/$requestId';

  static String halaqatCollection() => 'halaqat';
  static String halaqaDocument(String halaqaId) => 'halaqat/$halaqaId';

  static String instancesCollection() => 'instances';
  static String instanceDocument(String instanceId) => 'instances/$instanceId';

  static String reportCardDocument(String reportcardId) =>
      'reportCards/$reportcardId/';

  static String reportCardsCollection() => 'reportCards';

  static String evaluationsCollection(String reportcardId) =>
      'reportCards/$reportcardId/evaluations';
  static String evaluationDocument(String reportcardId, String evaluationId) =>
      'reportCards/$reportcardId/evaluations/$evaluationId';

  static String conversationsCollection() => 'conversations';
  static String conversationDocument(String groupChatId) =>
      'conversations/$groupChatId';

  static String messagesCollection(String groupChatId) =>
      'conversations/$groupChatId/messages';

  static String messageDocument(String groupChatId, String messageId) =>
      'conversations/$groupChatId/messages/$messageId';

  static String centerLogsCollection(String centerId) =>
      'centers/$centerId/logs';

  static String adminLogsCollection() => 'adminLogs';
}
