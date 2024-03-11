// ignore_for_file: avoid_print, use_build_context_synchronously

// import 'dart:io';

import 'dart:convert';

import 'package:DesignCredit/widgets/constants.dart';
import 'package:DesignCredit/widgets/mobileappbar.dart';
import 'package:DesignCredit/widgets/navdrawer.dart';
// import 'package:file_picker/_internal/file_picker_web.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApplyDesignCredit extends StatefulWidget {
  final String designCreditId;
  const ApplyDesignCredit({required this.designCreditId, super.key});

  @override
  State<ApplyDesignCredit> createState() => _ApplyDesignCreditState();
}

class _ApplyDesignCreditState extends State<ApplyDesignCredit> {
  PlatformFile? objFile;
  String? filename;

  void chooseFileUsingFilePicker() async {
    var result = await FilePicker.platform.pickFiles(
      withReadStream: true,
    );
    if (result != null) {
      setState(() {
        objFile = result.files.single;
        filename = objFile?.name;
      });
    }
  }

  void uploadSelectedFile(String designCreditId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Uploading. Please wait..."),
            ],
          ),
        );
      },
    );

    try {
      if (objFile != null) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('userId');
        print(userId);
        final request = http.MultipartRequest(
          "POST",
          Uri.parse("$baseUrlMobileLocalhost/application/get-link"),
        );

        request.files.add(
          http.MultipartFile(
            "file",
            objFile!.readStream!,
            objFile!.size,
            filename: objFile?.name,
          ),
        );

        var resp = await request.send();
        if (resp.statusCode == 400) {
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pop(context);
          await Future.delayed(const Duration(seconds: 1));
          showToast('Parameter passed is incorrect!', Colors.red);
        } else if (resp.statusCode == 404) {
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pop(context);
          await Future.delayed(const Duration(seconds: 1));
          showToast('Backend error', Colors.red);
        } else if (resp.statusCode == 200) {
          // Read and decode the response JSON
          var responseBody = await resp.stream.bytesToString();
          Map<String, dynamic> responseJson = jsonDecode(responseBody);

          // Extract the publicUrl from the response and replace backslashes with forward slashes
          String publicUrl = responseJson['publicUrl'].replaceAll('\\', '/');

          // Display or use the publicUrl as needed
          print('Public URL: $publicUrl');

          Map<String, dynamic> requestBody = {
            'resumeLink': publicUrl,
            'userId': userId,
            'designCreditId': designCreditId,
          };

          // Make the POST request
          var response = await http.post(
            Uri.parse(
                '$baseUrlMobileLocalhost/application/apply-design-credit'),
            body: requestBody,
          );

          // Check the status code of the response
          if (response.statusCode == 201) {
            // Request was successful
            print('Design credit added successfully');
            await Future.delayed(const Duration(seconds: 2));
            Navigator.pop(context);
            await Future.delayed(const Duration(seconds: 1));
            showToast('Upload Successful!', Colors.green);
            setState(() {
              objFile = null;
              filename = null;
            });
          } else if (response.statusCode == 403) {
            // Request faile
            await Future.delayed(const Duration(seconds: 2));
            Navigator.pop(context);
            await Future.delayed(const Duration(seconds: 1));
            showToast(
                'You have already applied for this design Credit', Colors.red);
            print(
                'Failed to add design credit. Status code: ${response.statusCode}');
            setState(() {
              objFile = null;
              filename = null;
            });
          }
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context);
        showToast(
            'File is not provided! Please choose a file first', Colors.red);
        print("objFile is null");
      }
    } catch (e) {
      setState(() {
        objFile = null;
        filename = null;
      });
      print('Error occurred during file upload: $e');
      showToast(
          'An error occurred during upload. Please try again.', Colors.red);
      Navigator.pop(context);
    }
  }

  // Future<void> addDesignCredit(
  //     String publicUrl, String? userId, String designCreditId) async {
  //   try {
  //     // Define the request body as a map
  //     Map<String, dynamic> requestBody = {
  //       'resumeLink': publicUrl,
  //       'userId': userId,
  //       'designCreditId': designCreditId,
  //     };

  //     // Make the POST request
  //     var response = await http.post(
  //       Uri.parse('$baseUrlMobileLocalhost/application/apply-design-credit'),
  //       body: requestBody,
  //     );

  //     // Check the status code of the response
  //     if (response.statusCode == 200) {
  //       // Request was successful
  //       print('Design credit added successfully');
  //       await Future.delayed(const Duration(seconds: 2));
  //       Navigator.pop(context);
  //       await Future.delayed(const Duration(seconds: 1));
  //       showToast('Upload Successful!', Colors.green);
  //       setState(() {
  //         objFile = null;
  //         filename = null;
  //       });
  //     } else {
  //       // Request failed
  //       showToast(
  //           'Design credit not added successfully! Try Again', Colors.red);
  //       print(
  //           'Failed to add design credit. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // An error occurred during the request
  //     print('Error adding design credit: $e');
  //   }
  // }

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
              image: AssetImage(
                iitjCampus,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const MobileAppBar(),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                  height: 550,
                  width: size.width * 0.90,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.amberAccent),
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(111, 0, 0, 0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: size.width * 0.30,
                          width: size.width * 0.30,
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
                        objFile == null
                            ? const Text(
                                'No file Selected',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              )
                            : Text(
                                'File Selected: $filename',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue,
                                ),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: chooseFileUsingFilePicker,
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                height: 50,
                                width: 120,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.blue,
                                ),
                                child: const Center(
                                  child: Text(
                                    'Choose File',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                uploadSelectedFile(widget.designCreditId);
                              },
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                height: 50,
                                width: 120,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.blue,
                                ),
                                child: const Center(
                                  child: Text(
                                    'Upload File',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
