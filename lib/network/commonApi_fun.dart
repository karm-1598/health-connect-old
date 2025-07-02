import 'dart:convert';
import 'package:http/http.dart' as http;


class baseApi{
  var _baseurl='http://192.168.1.2/api/';
  var client = http.Client();

  Future<dynamic> post(String api , dynamic body) async{
    Uri url =Uri.parse(_baseurl+api);

    final response =await client.post(url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(body)
    );
    return _handleResponce(response);
  }

  Future<dynamic> get(String api, {Map<String, String>?queryParams}) async{
    Uri url =Uri.parse(_baseurl+api).replace(queryParameters: queryParams);

    final response=await client.get(url);
    return _handleResponce(response);
    
  }
}

dynamic _handleResponce(http.Response response){
   if (response.statusCode == 200 ) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed: ${response.statusCode} - ${response.reasonPhrase}');
    }
}