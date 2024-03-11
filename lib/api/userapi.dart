// ignore_for_file: avoid_print

import 'package:DesignCredit/models/userModel.dart';
import 'package:DesignCredit/widgets/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:io';

import 'package:tuple/tuple.dart';

String? accessToken;
String? refreshToken;

Future<void> _getTokensFromSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  accessToken = prefs.getString('accessToken');
  refreshToken = prefs.getString('refreshToken');
  if (accessToken != null && refreshToken != null) {
    // Tokens are available, you can use them as needed
    print('Access Token: $accessToken');
    print('Refresh Token: $refreshToken');
  } else {
    // Tokens are not available, handle this case accordingly
    print('Tokens not found in SharedPreferences');
  }
}

Future<Tuple2<List<UserModel>, int>> fetchUserData() async {
  await _getTokensFromSharedPreferences();

  String url = '$baseUrlMobileLocalhost/user/user';
  http.Response response = await http.get(
    Uri.parse('$url?accessToken=$accessToken&refreshToken=$refreshToken'),
  );

  int statusCode = response.statusCode;

  // Check if request was successful (status code 200)
  if (statusCode == 200) {
    Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData.containsKey('user')) {
      UserModel user = UserModel.fromJson(responseData['user']);
      List<UserModel> userList = [user];
      // print(userList[0].email);
      return Tuple2<List<UserModel>, int>(userList, statusCode);
    } else {
      print('No user data found in response.');
    }

    // Update access token in SharedPreferences if new token is present in response
    String? newAccessToken = response.headers['Authorization'];
    if (newAccessToken != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', newAccessToken);
    }
  } else {
    // Request failed with non-200 status code
    print('Request failed with status code: $statusCode');
  }
  return Tuple2<List<UserModel>, int>([], statusCode);
}
