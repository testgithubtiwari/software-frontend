import 'dart:convert';
import 'package:DesignCredit/widgets/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkProfileCompletion(String? userId) async {
  const String url = '$baseUrlMobileLocalhost/user/isProfileCompleted';

  Map<String, dynamic> requestBody = {
    'userId': userId,
  };
  String jsonBody = json.encode(requestBody);

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('profileCompleted') &&
          jsonResponse['profileCompleted'] == true) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', jsonResponse['username']);
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception('Failed to check profile completion');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}
