class ApiResponse<T> {
  final Status _status;
  Object? exception;
  T? data;

  ApiResponse.idle() : _status = Status.idle;
  ApiResponse.loading() : _status = Status.loading;
  ApiResponse.completed(this.data) : _status = Status.completed;
  ApiResponse.error(this.exception) : _status = Status.error;

  Status get status => _status;
}

enum Status { idle, loading, completed, error }
