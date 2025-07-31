import 'package:dio/dio.dart';

class baseApi{
  static Dio _dio=Dio(BaseOptions(
    baseUrl: 'http://192.168.1.7/api/',
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    headers: {"Content-Type": "application/json"},
  ));

  Future<dynamic> post(String api, dynamic body)async{
    try{
      final response= await _dio.post(api,data:body);
      return _handleResponce(response);
    }catch(e){
      return _handleError(e);
    }
  }

  Future<dynamic> get(String api, {Map<String,String>?queryParams}) async{
    try{
      final response= await _dio.get(api, queryParameters: queryParams);
      return _handleResponce(response);
    }catch(e){
      return _handleError(e);
    }
  }

  _handleResponce(Response response){
    if(response.statusCode==200){
      return response.data;
    }else{
      throw Exception('Failed:${response.statusMessage}');
    }
  }

  _handleError(dynamic error){
    if(error is DioException){
      return Exception('Dio error: ${error.message}');
    }else{
      return Exception('Unknown error: $error');
    }
  }
}




