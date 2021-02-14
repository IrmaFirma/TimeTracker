class APIPath {
  static String record(String uid, String recordId) => 'users/$uid/records/$recordId';
  static String records(String uid) => 'users/$uid/records';
}