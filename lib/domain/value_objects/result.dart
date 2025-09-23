// lib/domain/value_objects/result.dart
abstract class Result<T> {
  const Result();
  
  factory Result.success(T value) = Success<T>;
  factory Result.failure(Exception error) = Failure<T>;
  
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  
  T get value {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    throw StateError('Cannot get value from failure result');
  }
  
  Exception get error {
    if (this is Failure<T>) {
      return (this as Failure<T>).error;
    }
    throw StateError('Cannot get error from success result');
  }
  
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Exception error) onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).value);
    } else {
      return onFailure((this as Failure<T>).error);
    }
  }
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Failure<T> extends Result<T> {
  final Exception error;
  const Failure(this.error);
}
