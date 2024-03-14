// ignore_for_file: use_build_context_synchronously, avoid_print, use_key_in_widget_constructors

import 'package:DesignCredit/api/userapi.dart';
import 'package:DesignCredit/models/usermodel.dart';
import 'package:DesignCredit/screens/auth/loginscreen.dart';
import 'package:DesignCredit/screens/auth/signupscreen.dart';
import 'package:DesignCredit/widgets/constants.dart';
import 'package:DesignCredit/widgets/desktopappbar.dart';
import 'package:DesignCredit/widgets/mobileappbar.dart';
import 'package:DesignCredit/widgets/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key});

  @override
  State<UpdateProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<UpdateProfilePage> {
  List<UserModelDesignCredit>? _userFuture;
  String? _email; // Make _email nullable
  String? _name;
  String? _userType;
  String? _selectedBranch;
  String? _rollNumber;
  List<String> branchName = ['CSE', 'AI', 'EE', 'MT', 'CH', 'ES', 'BB', 'CIE'];

  @override
  void initState() {
    super.initState();
    checkValidToken();
  }

  void checkValidToken() async {
    Tuple2<List<UserModelDesignCredit>, int> result = await fetchUserData();
    int statusCode = result.item2;
    if (statusCode == 401) {
      showToast(
          'Invalid token, Please Log In again. Redirecting you to Login Page');
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', '');
      prefs.setString('refreshToken', '');
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else if (statusCode == 404) {
      showToast(
          'User not found! Please register first.Redirecting you to SignUp Page');
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', '');
      prefs.setString('refreshToken', '');
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const SignUp()));
    } else if (statusCode == 500) {
      showToast('Internal Server Error! Please try after sometime');
    } else {
      _userFuture = result.item1;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', _userFuture?[0].sId ?? '');
      _email =
          _userFuture?[0].email ?? ''; // Update _email with the fetched email
      _name = _userFuture?[0].name ?? '';
      _userType = _userFuture?[0].userType ?? '';
      _selectedBranch = _userFuture?[0].branch ?? '';
      _rollNumber = _userFuture?[0].rollNumber ?? '';

      setState(() {});
    }
  }

  void updateProfile(
    String name,
    String email,
    String branch,
    String rollnumber,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Updating.."),
            ],
          ),
        );
      },
    );
    final prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString('userId');
    try {
      // Construct the request body
      Map<String, dynamic> requestBody = {
        'userId': userid,
        'name': name,
        'email': email,
        'branch': branch,
        'rollnumber': rollnumber,
      };
      print(requestBody);

      // Make the POST request
      var response = await http.post(
        Uri.parse('$baseUrlMobileLocalhost/user/update-profile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);

        await Future.delayed(const Duration(seconds: 2));
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', name);
        Navigator.of(context).pop();

        showToast('Profile Updated Successfully!!');
        checkValidToken();
      } else {
        await Future.delayed(const Duration(seconds: 2));

        Navigator.of(context).pop();

        showToast('Failed to update profile');
        throw Exception('Failed to update profile: ${response.reasonPhrase}');
      }
    } catch (e) {
      await Future.delayed(const Duration(seconds: 2));

      Navigator.of(context).pop();

      showToast('Network Error! Try again after sometime');
      print('Error updating profile: $e');
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const NavDrawer(),
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(iitjCampus),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                size.width > 1200
                    ? const DeskTopAppBar()
                    : const MobileAppBar(),
                size.width > 1200
                    ? const SizedBox(
                        height: 15,
                      )
                    : const SizedBox(
                        height: 25,
                      ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                  height: 550,
                  width: size.width > 1200 ? 700 : size.width * 0.90,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.amberAccent),
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(111, 0, 0, 0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: size.width > 1200 ? 200 : size.width * 0.30,
                          width: size.width > 1200 ? 200 : size.width * 0.30,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(logo),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        _email != null
                            ? CustomTextField(
                                labelText: 'Email',
                                value: _email!,
                                onChanged: (value) {
                                  setState(() {
                                    _email = value;
                                  });
                                },
                                backgroundColor:
                                    const Color.fromARGB(255, 12, 44, 43),
                              )
                            : Container(),
                        // SizedBox(
                        //   height: 15,
                        // ),
                        _name != null
                            ? CustomTextField(
                                labelText: 'Name',
                                value: _name!,
                                onChanged: (value) {
                                  setState(() {
                                    _name = value;
                                  });
                                },
                                backgroundColor:
                                    const Color.fromARGB(255, 12, 44, 43),
                              )
                            : Container(),
                        _rollNumber != null && _rollNumber != ''
                            ? CustomTextField(
                                labelText: 'RollNumber',
                                value: _rollNumber!,
                                onChanged: (value) {
                                  setState(() {
                                    _rollNumber = value;
                                  });
                                },
                                backgroundColor:
                                    const Color.fromARGB(255, 12, 44, 43),
                              )
                            : Container(),
                        _userType != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                child: TextFormField(
                                  initialValue:
                                      _userType, // Display the user type as plain text
                                  readOnly:
                                      true, // Make the text field read-only
                                  decoration: InputDecoration(
                                    labelText: 'User Type',
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                    fillColor:
                                        const Color.fromARGB(255, 12, 44, 43),
                                    filled: true, // Apply fill color
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            : Container(),
                        _selectedBranch != null && _selectedBranch != ''
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedBranch,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedBranch = value!;
                                    });
                                  },
                                  menuMaxHeight: 300,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                  iconSize: 25,
                                  dropdownColor:
                                      const Color.fromARGB(255, 12, 44, 43),
                                  items: branchName
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  borderRadius: BorderRadius.circular(20),
                                  decoration: InputDecoration(
                                    labelText: 'Branch',
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                    fillColor:
                                        const Color.fromARGB(255, 12, 44, 43),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            updateProfile(
                              _name!,
                              _email!,
                              _selectedBranch!,
                              _rollNumber!,
                            );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: 50,
                              width:
                                  size.width > 1200 ? 300 : size.width * 0.45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color.fromARGB(255, 12, 44, 43),
                              ),
                              child: Center(
                                child: Text(
                                  'Update',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String value;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final Color? backgroundColor;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.value,
    this.onChanged,
    this.validator,
    this.suffixIcon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextFormField(
        initialValue: value,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: backgroundColor ??
              Colors.transparent, // Set default background color
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
