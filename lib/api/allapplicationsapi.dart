import 'dart:convert';

import 'package:DesignCredit/models/allapplicationdesigncreditmodelnew.dart';
import 'package:DesignCredit/widgets/constants.dart';
import 'package:http/http.dart' as http;
import '../models/allapplicationsmodel.dart';
import '../models/allapplicationusermodel.dart';

Future<List<MapEntry<String, AllApplicationsModel>>>
    fetchAllApplications() async {
  try {
    final response = await http.get(
        Uri.parse('$baseUrlMobileLocalhost/application/get-all-applications'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<MapEntry<String, AllApplicationsModel>> applicationsList = [];
      for (var data in jsonData) {
        final application = AllApplicationsModel.fromJson(data);
        applicationsList.add(MapEntry(application.sId ?? '', application));
      }
      return applicationsList;
    } else {
      throw Exception('Failed to load applications: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching applications: $e');
  }
}

Future<List<MapEntry<String, AllApplicationDesignCreditModelNew>>>
    fetchAllApplicationsDesignCredit(String designCreditId) async {
  try {
    // print(designCreditId);
    final response = await http.get(Uri.parse(
        '$baseUrlMobileLocalhost/application/get-application-design-credit?id=$designCreditId'));

    // print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      // Ensure jsonData is a List with at least one element
      if (jsonData.isNotEmpty && jsonData[0] is Map<String, dynamic>) {
        final List<MapEntry<String, AllApplicationDesignCreditModelNew>>
            applicationsList = [];
        final application =
            AllApplicationDesignCreditModelNew.fromJson(jsonData[0]);
        applicationsList.add(MapEntry(application.sId ?? '', application));
        return applicationsList;
      } else {
        throw Exception('Invalid JSON data');
      }
    } else {
      throw Exception('Failed to load applications: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching applications: $e');
  }
}

Future<List<MapEntry<String, AllApplicationUserModel>>>
    fetchAllApplicationsUserDesignCredit(String userId) async {
  try {
    final response = await http.get(Uri.parse(
        '$baseUrlMobileLocalhost/application/get-application-user?id=$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty) {
        final List<MapEntry<String, AllApplicationUserModel>> usersList = [];
        for (var jsonEntry in jsonData) {
          if (jsonEntry is Map<String, dynamic>) {
            final application = AllApplicationUserModel.fromJson(jsonEntry);
            usersList.add(MapEntry(application.sId ?? '', application));
          }
        }
        return usersList;
      } else {
        throw Exception('Invalid JSON data');
      }
    } else {
      throw Exception('Failed to load applications: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching applications: $e');
  }
}
