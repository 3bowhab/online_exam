class BaseResponse<T> {

  final bool status;
  final String? message;
  final T? data;


  BaseResponse({
    required this.status,
    this.message,
    this.data,
  });


  factory BaseResponse.fromJson(
      Map<String,dynamic> json,
      T Function(dynamic json) fromJson,
      ){
    return BaseResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? fromJson(json['data'])
          : null,
    );
  }

}