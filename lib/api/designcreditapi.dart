import 'dart:convert';
import 'package:DesignCredit/models/designcreditmodel.dart';
import 'package:DesignCredit/widgets/constants.dart';
import 'package:http/http.dart' as http;

Future<List<DesignCreditModel>> fetchDesignCredits() async {
  final response = await http.get(
    Uri.parse(
      '$baseUrlMobileLocalhost/design/all-design-credits',
    ),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((data) => DesignCreditModel.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load design credits');
  }
}

Future<List<DesignCreditModel>> filterDesignCredits(
    String professorName) async {
  // final encodedProfessorName = Uri.encodeQueryComponent(professorName);

  final Uri uri = Uri.parse(
    '$baseUrlMobileLocalhost/design/filter-design-credit?byProfessorName=$professorName',
  );

  print(uri);

  final response = await http.post(uri);

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((data) => DesignCreditModel.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load design credits');
  }
}
