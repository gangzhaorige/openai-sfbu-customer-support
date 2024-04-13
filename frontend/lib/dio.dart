import 'package:dio/dio.dart';
import 'package:flutter_front_end/constant.dart';

class DioApi {

  static Dio dio() {
    BaseOptions options = BaseOptions(
      baseUrl: url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Access-Control-Allow-Origin': '*'
      },
    );
    return Dio(options);
  }

  static Future<Response<dynamic>> postRequest({required String path, Object? data}) async {
    return dio().post(
      path,
      data: data,
    );
  }

  static Future<Response<dynamic>> getRequest({required String path, Object? data}) async {
    return dio().get(
      path,
      data: data,
    );
  }

  static Future<Response<dynamic>> putRequest({required String path, Object? data}) async {
    return dio().put(
      path,
      data: data,
    );
  }

  static Future<Response<dynamic>> patchRequest({required String path, Object? data}) async {
    return dio().patch(
      path,
      data: data,
    );
  }

}