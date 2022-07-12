import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:markett_app/services/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? expiryDate;
  String? _userId;

  static const apiKey = 'AIzaSyALjD8MMpFIICnYDgTtuTTrIMTMAtVcr8U';

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey');
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final data = jsonDecode(response.body);
      if(data['error'] != null) {
        throw HttpException(data['error']['message']);
      }
      print(jsonDecode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
