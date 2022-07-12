class HttpException implements Exception{
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    // ignore: todo
    // TODO: implement toString
    // return super.toString(); // Instance of HttpException
    return message;
  }
}