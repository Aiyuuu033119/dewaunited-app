import 'package:http/http.dart';
import 'dart:convert';

class TicketModel {
  late Map data;
  late String msg;

  String ticketBaseUrl = 'https://dev.dwunss.com/api/ticket/v2';

  Future<void> getSignature(accessToken, tokenType, ticket) async {
    try {
      var url = Uri.parse('$ticketBaseUrl/check-ticket');
      Response response = await post(url, body: {
        "code": ticket,
      }, headers: {
        'Authorization':
            '${tokenType[0].toString().toUpperCase()}${tokenType.toString().substring(1).toLowerCase()} $accessToken'
      });
      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        data = json;
      } else {
        data = {'error': true, 'msg': 'ERROR ${response.statusCode}'};
      }
    } catch (e) {
      msg = e.toString();
      data = {'error': true, 'msg': e.toString()};
      // time = 'No Connection';
    }
  }

  Future<void> ticketUpdate(accessToken, tokenType, ticket) async {
    try {
      var url = Uri.parse('$ticketBaseUrl/claim-ticket');
      Response response = await post(url, body: {
        "code": ticket,
      }, headers: {
        'Authorization':
            '${tokenType[0].toString().toUpperCase()}${tokenType.toString().substring(1).toLowerCase()} $accessToken'
      });
      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        data = json;
      } else {
        data = {'error': true, 'msg': 'ERROR ${response.statusCode}'};
      }
    } catch (e) {
      msg = e.toString();
      data = {'error': true, 'msg': e.toString()};
      // time = 'No Connection';
    }
  }
}
