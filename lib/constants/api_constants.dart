class ApiConstants {
  // Base URL stuffz
  static String get _baseUrl => 'https://f6e5-195-199-217-115.eu.ngrok.io/api';
  static String get _usersUrl => '$_baseUrl/users';
  static String get _relationshipsUrl => '$_baseUrl/relationships';
  static String get _sketchesUrl => '$_baseUrl/sketches';

  // Users URL Endpoints
  static _UserEndpoints get users => _UserEndpoints();

  // Heartbeat URL Endpoint
  static String get heartbeat => '$_baseUrl/heartbeat';

  // Relationships URL Endpoints
  static _RelationshipEndpoints get relationships => _RelationshipEndpoints();

  // Sketches URL Endpoints
  static _SketchEndpoints get sketches => _SketchEndpoints();
  // TODO: API: No way of getting sketches??
}

class _UserEndpoints {
  // Users URL Endpoints
  String get loginEndpoint => '${ApiConstants._usersUrl}/login';
  String get registerEndpoint => '${ApiConstants._usersUrl}/register';
  String getUserByUsernameEndpoint(String username) =>
      '${ApiConstants._usersUrl}/$username';
  String getUserByUuidEndpoint(String uuid) =>
      '${ApiConstants._usersUrl}/uuid/$uuid';
}

class _RelationshipEndpoints {
  // Relationships URL Endpoints
  String get createRelationshipEndpoint =>
      '${ApiConstants._relationshipsUrl}/create';
  String get removeRelationshipEndpoint =>
      '${ApiConstants._relationshipsUrl}/remove';
  String get blockRelationshipEndpoint =>
      '${ApiConstants._relationshipsUrl}/block';
  String get unblockRelationshipEndpoint =>
      '${ApiConstants._relationshipsUrl}/unblock';
  String uuidRelationshipEndpoint(String uuid) =>
      '${ApiConstants._relationshipsUrl}/$uuid';
}

class _SketchEndpoints {
  // Sketches URL Endpoints
  String get createSketchEndpoint => '${ApiConstants._sketchesUrl}/create';
  String get deleteSketchEndpoint => '${ApiConstants._sketchesUrl}/delete';
  String get getSketchEndpoint => '${ApiConstants._sketchesUrl}/get';
}
