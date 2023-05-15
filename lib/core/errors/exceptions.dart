class ServerException implements Exception {
  String? message;
  int? statusCode;

  ServerException({this.message, this.statusCode});
}

class UnexpectedException implements Exception {
  String? message;

  UnexpectedException({this.message});
}
