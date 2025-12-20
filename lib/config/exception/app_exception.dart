// Handling custom exption
class AppException implements Exception {
  final message;
  final prefix;

  AppException({this.message, this.prefix});

  @override
  String toString() {
    return '$message$prefix';
  }
}

class NoInternetException extends AppException {
  NoInternetException({String? super.message}) : super(prefix: "");
}

class TimeOutException extends AppException {
  TimeOutException({String? super.message})
    : super(prefix: "Time out try again");
}

class FetchDataException extends AppException {
  FetchDataException({String? super.message}) : super(prefix: "");
}

class UnautherizedExeption extends AppException {
  UnautherizedExeption({String? super.message}) : super(prefix: "");
}

class TokenExpiredException extends AppException {
  TokenExpiredException({String? message}) : super();
}

class InvalidCredentialsException extends AppException {
  InvalidCredentialsException({String? super.message}) : super(prefix: "");
}
