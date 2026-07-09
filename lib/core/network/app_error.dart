abstract class AppError {
  final String message;
  const AppError(this.message);
}

class TimeoutAppError extends AppError {
  const TimeoutAppError(super.message);
}

class ServerAppError extends AppError {
  const ServerAppError(super.message);
}

class NetworkAppError extends AppError {
  const NetworkAppError(super.message);
}

class UnknownAppError extends AppError {
  const UnknownAppError(super.message);
}
