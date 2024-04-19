class HttpException_ implements Exception {
  final String msg;
  final int statusCode;

  HttpException_({
    required this.msg,
    required this.statusCode,
  });

  String toString() {
    return msg;
  }
}
