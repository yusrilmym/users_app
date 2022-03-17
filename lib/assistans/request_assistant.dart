import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> receiveRequest(String url) async {
    http.Response httpResponse = await http.get(Uri.parse(url));

    try {
      if (httpResponse.statusCode == 200) {
        //success
        String responseData = httpResponse.body; //json method

        var decodeResponseData = jsonDecode(responseData);

        return decodeResponseData;
      } else {
        return "Error Occured, failed. No Response";
      }
    } catch (exp) {
      return "Error Occured, failed. No Response";
    }
  }
}
