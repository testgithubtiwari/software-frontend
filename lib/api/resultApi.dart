import 'dart:convert';
import 'package:DesignCredit/models/resultmodel.dart';
import 'package:DesignCredit/widgets/constants.dart';
import 'package:http/http.dart' as http;

Future<List<MapEntry<String, ResultModel>>> fetchSpecificResults(
    String userId) async {
  try {
    print('userId is:');
    print(userId);
    final response = await http.get(
        Uri.parse('$baseUrlMobileLocalhost/results/get-result?userId=$userId'));

    // print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      // Ensure jsonData is a List with at least one element
      if (jsonData.isNotEmpty) {
        final List<MapEntry<String, ResultModel>> applicationsList = [];
        for (final data in jsonData) {
          if (data is Map<String, dynamic>) {
            final application = ResultModel.fromJson(data);
            applicationsList.add(MapEntry(application.sId ?? '', application));
          } else {
            throw Exception('Invalid JSON data');
          }
        }
        print(applicationsList.length);
        return applicationsList;
      } else {
        throw Exception('No data found');
      }
    } else {
      throw Exception('Failed to load applications: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching applications: $e');
  }
}
