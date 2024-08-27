
import 'dart:convert';

import 'package:http/http.dart';

import '../../Services/repositories/persistence_repository.dart';
import '../enum/persistence_enum.dart';
import '../enum/request_type.dart';

const String apiUrl = 'http://64.225.53.11:5000';

class ApiConfig {

  static Future<Response> request({
    required String url,
    RequestType requestType = RequestType.search,
    Map<String, dynamic>? body,
    Map<String, String>? headers
  }) async{
    Response response = Response('', 404);
    final String? token = await PersistenceRepository().read(key: SecureKey.token);

    switch(requestType){
      case RequestType.search:
        response = await get(
          Uri.parse('$apiUrl$url'),
          headers: {
            "Authorization": "Bearer $token"
          }
        );
        break;
      case RequestType.post:
        response = await post(
          Uri.parse('$apiUrl$url'),
          body: body != null ? jsonEncode(body) : null,
          headers: headers
        );
        break;
      case RequestType.put:
        response = await put(
          Uri.parse('$apiUrl$url'),
          headers: {
            "Authorization": "Bearer $token"
          }
        );
        break;
      case RequestType.delete:
        response = await delete(
          Uri.parse('$apiUrl$url'),
          headers: {
            "Authorization": "Bearer $token"
          }
        );
        break;
    }

    return response;
  } 
}