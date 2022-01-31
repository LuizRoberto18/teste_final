class ErrorResponse {
  late int errorCode;
  late String errorMessage;


  ErrorResponse({
    required this.errorCode,
    required this.errorMessage,
  });

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['errorCode'] = errorCode;
    data['errorMessage'] = errorMessage;
    return data;
  }
}
