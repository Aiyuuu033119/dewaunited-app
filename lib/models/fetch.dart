import 'package:dewaunited/components/toastError.dart';
import 'package:http/http.dart';
import 'dart:convert';

class FetchModel {
  late List items;
  late Map data;
  late String msg;

  String ticketBaseUrl = 'https://dwunss.com/api/ticket/v2';

  Future<void> getEvents(accessToken, tokenType, context) async {
    try {
      var url = Uri.parse('$ticketBaseUrl/assigned-events');
      Response response = await get(url, headers: {
        'Authorization':
            '${tokenType[0].toString().toUpperCase()}${tokenType.toString().substring(1).toLowerCase()} $accessToken'
      });
      if (response.statusCode == 200) {
        List json = await jsonDecode(response.body);
        items = json;
      } else {
        items = [];
        errorToast(context, 'Error ${response.statusCode}');
      }
    } catch (e) {
      msg = e.toString();
      items = [];
      errorToast(context, e.toString());
    }
  }

  Future<void> getTicket(accessToken, tokenType, ticketID, context) async {
    try {
      var url = Uri.parse('$ticketBaseUrl/fetch-ticket?ticketing_id=$ticketID');
      Response response = await get(url, headers: {
        'Authorization':
            '${tokenType[0].toString().toUpperCase()}${tokenType.toString().substring(1).toLowerCase()} $accessToken'
      });
      if (response.statusCode == 200) {
        List json = await jsonDecode(response.body);
        items = json;
      } else {
        items = [];
        errorToast(context, 'Error ${response.statusCode}');
      }
    } catch (e) {
      msg = e.toString();
      items = [];
      errorToast(context, e.toString());
    }
  }

  Future<void> syncTicket(accessToken, tokenType, context, tickets) async {
    try {
      var url = Uri.parse('$ticketBaseUrl/sync-ticket-transaction');
      Response response =
          await post(url, body: json.encode({"tickets": tickets}), headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            '${tokenType[0].toString().toUpperCase()}${tokenType.toString().substring(1).toLowerCase()} $accessToken'
      });
      if (response.statusCode == 200) {
        Map json = await jsonDecode(response.body);
        data = json;
      } else {
        data = {'error': true, 'msg': 'ERROR ${response.statusCode}'};
      }
    } catch (e) {
      msg = e.toString();
      data = {'error': true, 'msg': e.toString()};
    }
  }
}
