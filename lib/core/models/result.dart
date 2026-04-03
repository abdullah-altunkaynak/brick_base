import 'package:brick_base/brick_base.dart';

sealed class Result<S, E extends AppException> {
  const Result();

  // Yardımcı metodlar (isteğe bağlı ama hayat kurtarır)
  bool get isSuccess => this is Success<S, E>;
  bool get isFailure => this is Failure<S, E>;
}

final class Success<S, E extends AppException> extends Result<S, E> {
  final S value;
  const Success(this.value);
}

final class Failure<S, E extends AppException> extends Result<S, E> {
  final E exception;
  const Failure(this.exception);
}
