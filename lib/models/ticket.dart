import 'package:http/http.dart';
import 'dart:convert';

class TicketModel {
  late Map data;
  late String msg;

  String ticketBaseUrl =
      'https://satellite.ticket.dewaunited.megaloman.xyz/api';

  Future<void> getSignature(accessToken, userId, ticket) async {
    try {
      print(userId.toString());
      print(accessToken);
      print(ticket);
      var url = Uri.parse('$ticketBaseUrl/devtool/V01/signaturegenerate');
      Response response = await post(url, body: {
        'platform': 'WEBSITE',
        'gtoken': 'PASSS',
        'userindex': userId.toString(),
        'loginsecretkey': '$accessToken',
        "tableticketindex": ticket,
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

  Future<void> ticketDetail(accessToken, userId, ticket, signature) async {
    try {
      var url = Uri.parse('$ticketBaseUrl/admin/V01/ticket/detail');
      Response response = await post(url, body: {
        'platform': 'WEBSITE',
        'gtoken': 'PASSS',
        'userindex': userId.toString(),
        'loginsecretkey': '$accessToken',
        "tableticketindex": ticket,
      }, headers: {
        'signature': signature
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

  Future<void> ticketUpdate(accessToken, userId, ticket, signature) async {
    try {
      var url = Uri.parse('$ticketBaseUrl/admin/V01/ticket/update');
      Response response = await post(url, body: {
        'platform': 'WEBSITE',
        'gtoken': 'PASSS',
        'userindex': userId.toString(),
        'loginsecretkey': '$accessToken',
        "tableticketindex": ticket,
      }, headers: {
        'signature': signature
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
