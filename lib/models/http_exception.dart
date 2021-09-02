class HttpException implements Exception{
  // we are defining our own exceptions
  final String message;
  HttpException(this.message);

  @override
  String toString() {
    // TODO: implement toString
    return message;
  }



}