import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/network/api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@LazySingleton()
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio) = _ApiClient;
}
