// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:DesignCredit/widgets/constants.dart';
import 'package:DesignCredit/widgets/desktopappbar.dart';
import 'package:DesignCredit/widgets/mobileappbar.dart';
import 'package:DesignCredit/widgets/navdrawer.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddDesignCredits extends StatefulWidget {
  const AddDesignCredits({super.key});

  @override
  State<AddDesignCredits> createState() => _AddDesignCreditsState();
}

class _AddDesignCreditsState extends State<AddDesignCredits> {
  String projectName = '';
  String elegibleBranches = '';
  String offeredBy = 'CSE';
  String description = '';
  List<String> branchName = ['CSE', 'AI', 'EE', 'MT', 'CH', 'ES', 'BB', 'CIE'];

  void addDesignCredit(String projectName, String eligibleBranches,
      String offeredBy, String desc) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(
                color: Colors.blue,
              ),
              SizedBox(width: 20),
              Text("Uploading.."),
            ],
          ),
        );
      },
    );
    if (projectName == '' ||
        eligibleBranches == '' ||
        offeredBy == '' ||
        desc == '') {
      print(eligibleBranches);
      print(offeredBy);
      print(desc);
      Navigator.of(context).pop();
      showToast('Please fill all the fields!', Colors.red);
      return;
    }

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? professorName = prefs.getString('name');
      eligibleBranches = eligibleBranches.replaceAll(' ', ',');

      var response = await http.post(
        Uri.parse('$baseUrlMobileLocalhost/design/add-design-credit'),
        headers: {
          'userType': 'Professor',
        },
        body: {
          'projectName': projectName,
          'eligibleBranches': eligibleBranches,
          'professorName': professorName,
          'offeredBy': offeredBy,
          'description': desc,
        },
      );

      if (response.statusCode == 201) {
        await Future.delayed(const Duration(seconds: 3));
        Navigator.of(context).pop();
        await Future.delayed(const Duration(seconds: 1));
        showToast('Design credit added successfully!', Colors.green);
      } else if (response.statusCode == 403) {
        await Future.delayed(const Duration(seconds: 3));
        Navigator.of(context).pop();
        await Future.delayed(const Duration(seconds: 1));
        showToast('Only Professor allowed to add design credit', Colors.red);
      } else {
        await Future.delayed(const Duration(seconds: 3));
        Navigator.of(context).pop();
        await Future.delayed(const Duration(seconds: 1));
        showToast(
          'Please try after some time.Network is busy this time!',
          Colors.red,
        );
      }
    } catch (e) {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pop();
      await Future.delayed(const Duration(seconds: 1));
      showToast('There is some backend error', Colors.red);
      print('Error occurred: $e');
      // Handle error here
    }
  }

  void showToast(String message, Color color) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
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
          child: Column(
            children: [
              size.width > 1200 ? const DeskTopAppBar() : const MobileAppBar(),
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
                      CustomTextField(
                        labelText: 'Project-Name',
                        // value: projectName!,
                        onChanged: (value) {
                          setState(() {
                            projectName = value;
                          });
                        },
                        backgroundColor: const Color.fromARGB(255, 12, 44, 43),
                      ),
                      CustomTextField(
                        // helpingtext:
                        //     'Write the branches with comma between them',
                        labelText: 'Eligible Branches',
                        // value: projectName!,
                        onChanged: (value) {
                          setState(
                            () {
                              elegibleBranches = value;
                            },
                          );
                        },
                        backgroundColor: const Color.fromARGB(255, 12, 44, 43),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: DropdownButtonFormField<String>(
                          value: offeredBy,
                          onChanged: (String? value) {
                            setState(() {
                              offeredBy = value!;
                            });
                          },
                          menuMaxHeight: 300,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          iconSize: 25,
                          dropdownColor: const Color.fromARGB(255, 12, 44, 43),
                          items: branchName
                              .map<DropdownMenuItem<String>>((String value) {
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
                            labelText: 'Offered-By',
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            fillColor: const Color.fromARGB(255, 12, 44, 43),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                      CustomTextField(
                        labelText: 'Description',
                        // value: projectName!,
                        onChanged: (value) {
                          setState(
                            () {
                              description = value;
                            },
                          );
                        },
                        backgroundColor: const Color.fromARGB(255, 12, 44, 43),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          print(projectName);
                          addDesignCredit(
                            projectName,
                            elegibleBranches,
                            offeredBy,
                            description,
                          );
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            height: 50,
                            width: size.width > 1200 ? 300 : size.width * 0.45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromARGB(255, 12, 44, 43),
                            ),
                            child: Center(
                              child: Text(
                                'Float-Design Credit',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  // final String value;
  final String? helpingtext;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final Color? backgroundColor;

  const CustomTextField({
    super.key,
    required this.labelText,
    // required this.value,
    this.onChanged,
    this.helpingtext,
    this.validator,
    this.suffixIcon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextFormField(
        // initialValue: value,
        maxLines: null,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          helperStyle: const TextStyle(
            color: Colors.grey,
          ),
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
          fontSize: 18,
        ),
      ),
    );
  }
}
