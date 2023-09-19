import 'package:http/http.dart';
import 'dart:convert';

class AuthModel {
  late Map data;
  late String msg;

  // String baseUrl = 'https://backend.dewaunited.com/api';
  String baseUrl = 'https://du-front-admin.woibayar.com/api';

  Future<void> login(email, password) async {
    try {
      var url = Uri.parse('$baseUrl/login');
      Map req = {'email': email, 'password': password};
      Response response = await post(url, body: req);
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

  Future<void> profile(accessToken, tokenType) async {
    try {
      var url = Uri.parse('$baseUrl/profile');
      Response response = await post(url,
          headers: {'Authorization': '${tokenType[0].toString().toUpperCase()}${tokenType.toString().substring(1).toLowerCase()} $accessToken'});
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

  Future<void> logout(accessToken, tokenType) async {
    try {
      var url = Uri.parse('$baseUrl/logout');
      Response response = await post(url,
          headers: {'Authorization': '${tokenType[0].toString().toUpperCase()}${tokenType.toString().substring(1).toLowerCase()} $accessToken'});
      Map json = jsonDecode(response.body);
      data = json;
    } catch (e) {
      msg = e.toString();
      // time = 'No Connection';
    }
  }
}
