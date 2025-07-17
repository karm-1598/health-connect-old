import 'package:dio/dio.dart';

class baseApi{
  static Dio _dio=Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2/api/',
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




// import 'dart:convert';
// import 'package:http/http.dart' as http;


// class baseApi{
//   var _baseurl='http://192.168.1.12/api/';
//   var client = http.Client();

//   Future<dynamic> post(String api , dynamic body) async{
//     Uri url =Uri.parse(_baseurl+api);

//     final response =await client.post(url,
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode(body)
//     );
//     return _handleResponce(response);
//   }

//   Future<dynamic> get(String api, {Map<String, String>?queryParams}) async{
//     Uri url =Uri.parse(_baseurl+api).replace(queryParameters: queryParams);

//     final response=await client.get(url);
//     return _handleResponce(response);
    
//   }
// }

// dynamic _handleResponce(http.Response response){
//    if (response.statusCode == 200 ) {
//       return jsonDecode(response.body);
//     } else {
      
//       throw Exception(
        
//           'Failed: ${response.statusCode} - ${response.reasonPhrase}');
//     }
// }