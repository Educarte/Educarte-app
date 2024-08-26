
import 'package:http/http.dart';

import '../../Ui/global/global.dart' as globals;
import '../enum/request_type.dart';

const String apiUrl = 'http://64.225.53.11:5000';

class ApiConfig {

  static Future<Response> request({
    required String url,
    RequestType requestType = RequestType.search
  }) async{
    Response response = Response('', 404);

    switch(requestType){
      case RequestType.search:
        response = await get(
          Uri.parse('$apiUrl/$url'),
          headers: {
            "Authorization": "Bearer ${globals.token}"
          }
        );
        break;
      case RequestType.post:
        response = await post(
          Uri.parse('$apiUrl/$url'),
          headers: {
            "Authorization": "Bearer ${globals.token}"
          }
        );
        break;
      case RequestType.put:
        response = await put(
          Uri.parse('$apiUrl/$url'),
          headers: {
            "Authorization": "Bearer ${globals.token}"
          }
        );
        break;
      case RequestType.delete:
        response = await delete(
          Uri.parse('$apiUrl/$url'),
          headers: {
            "Authorization": "Bearer ${globals.token}"
          }
        );
        break;
    }

    return response;
  } 
}