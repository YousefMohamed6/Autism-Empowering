import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  Future<dynamic> get({
    required String url,
    Map<String, String>? headers,
    String? token,
  }) async {
    Map<String, String> defaultHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    defaultHeaders.addAll(headers ?? {});
    if (token != null) {
      defaultHeaders.addAll(
        {
          'Authorization': 'Bearer $token',
        },
      );
    }
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: defaultHeaders,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('${response.reasonPhrase} ${response.statusCode}');
    }
  }

  Future<dynamic> post({
    required String url,
    required Map<String, dynamic> body,
    String? token,
    Map<String, String>? headers,
  }) async {
    Map<String, String> defaultHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    defaultHeaders.addAll(headers ?? {});
    if (token != null) {
      defaultHeaders.addAll({"Authorization": "Bearer $token"});
    }
    var response = await http.post(
      body: json.encode(body),
      Uri.parse(url),
      headers: defaultHeaders,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('${response.reasonPhrase} ${response.statusCode}');
    }
  }

  Future<dynamic> put({
    required String url,
    required Map<String, dynamic> body,
    String? token,
    Map<String, String>? headers,
  }) async {
    Map<String, String> defaultHeaders = {
      'Content-Type': 'application/json',
      "Accept": "application/json"
    };
    defaultHeaders.addAll(headers ?? {});
    if (token != null) {
      defaultHeaders.addAll({'Authorization': 'Bearer $token'});
    }
    http.Response response = await http.put(
      Uri.parse(url),
      body: json.encode(body),
      headers: defaultHeaders,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('${response.reasonPhrase} ${response.statusCode}');
    }
  }
}
