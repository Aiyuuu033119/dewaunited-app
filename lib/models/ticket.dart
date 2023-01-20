import 'package:http/http.dart';
import 'dart:convert';

class TicketModel {
  late Map data;
  late String msg;

  String ticketBaseUrl = 'https://dev.dwunss.com/api/ticket/v2';

  Future<void> getSignature(accessToken, ticket) async {
    try {
      var url = Uri.parse('$ticketBaseUrl/check-ticket');
      Response response = await post(url, body: {
        'auth_key': '$accessToken',
        "code": ticket,
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

  Future<void> ticketUpdate(accessToken, ticket) async {
    try {
      var url = Uri.parse('$ticketBaseUrl/claim-ticket');
      Response response = await post(url, body: {
        'auth_key': '$accessToken',
        "code": ticket,
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
