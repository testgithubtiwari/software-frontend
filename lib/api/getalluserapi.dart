import 'dart:convert';

import 'package:DesignCredit/models/usermodel.dart';
import 'package:DesignCredit/widgets/constants.dart';

import 'package:http/http.dart' as http;

Future<List<UserModel>> getAllUsers() async {
  final response = await http.get(Uri.parse('$baseUrlMobileLocalhost/user/allUsers'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body)['users'];
    return jsonResponse.map((user) => UserModel.fromJson(user)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}
