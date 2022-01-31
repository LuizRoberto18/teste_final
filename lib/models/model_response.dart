class ApiResponse<T, D> {
  bool hasError;
  T? response;
  D? error;

  ApiResponse({this.hasError = false, this.response, this.error});
}
