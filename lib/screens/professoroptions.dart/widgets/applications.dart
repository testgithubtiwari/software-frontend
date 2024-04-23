// ignore_for_file: deprecated_member_use
import 'dart:convert';

import 'package:DesignCredit/widgets/constants.dart';
import 'package:DesignCredit/widgets/desktopappbar.dart';
import 'package:DesignCredit/widgets/mobileappbar.dart';
import 'package:DesignCredit/widgets/navdrawer.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/allapplicationsapi.dart';
import '../../../models/allapplicationdesigncreditmodelnew.dart';
import 'package:http/http.dart' as http;

class Applications extends StatefulWidget {
  final String designCreditId;
  final String projectName;
  final String professorName;
  const Applications(
      {required this.professorName,
      required this.projectName,
      required this.designCreditId,
      super.key});

  @override
  State<Applications> createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  List<MapEntry<String, AllApplicationDesignCreditModelNew>> _applications = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchApplications();
  }

  Future<void> _fetchApplications() async {
    try {
      final List<MapEntry<String, AllApplicationDesignCreditModelNew>>
          applications =
          await fetchAllApplicationsDesignCredit(widget.designCreditId);
      setState(() {
        _applications = applications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // ignore: avoid_print
      print('Error fetching applications: $e');
    }
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
                size.width <= 1200
                    ? const MobileAppBar()
                    : const DeskTopAppBar(),
                const SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.blue,
                      )
                    : _applications.isEmpty
                        ? Center(
                            child: Text(
                              'No applications found',
                              style: GoogleFonts.poppins(
                                color: Color.fromARGB(221, 0, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : Wrap(
                            spacing: 10,
                            runSpacing: 20,
                            children: _applications.map((entry) {
                              final application = entry.value;
                              return AllApplicationsContainer(
                                professorName: widget.professorName,
                                projectName: widget.projectName,
                                designCreditId: widget.designCreditId,
                                userId: application.userId?.sId ?? '',
                                rollNumber:
                                    application.userId?.rollNumber ?? '',
                                name: application.userId?.name ?? '',
                                resumeLink: application.resumeLink ?? '',
                                email: application.userId?.email ?? '',
                              );
                            }).toList(),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AllApplicationsContainer extends StatefulWidget {
  final String userId;
  final String projectName;
  final String professorName;
  final String name;
  final String designCreditId;
  final String email;
  final String resumeLink;
  final String rollNumber;
  // final String projectName;
  const AllApplicationsContainer({
    required this.name,
    required this.professorName,
    required this.projectName,
    required this.userId,
    required this.designCreditId,
    // required this.projectName,
    required this.resumeLink,
    required this.email,
    required this.rollNumber,
    super.key,
  });

  @override
  State<AllApplicationsContainer> createState() =>
      _AllApplicationsContainerState();
}

class _AllApplicationsContainerState extends State<AllApplicationsContainer> {
  bool isAccept = true;
  bool isReject = false;
  void _openResumeLink() async {
    if (await canLaunch(widget.resumeLink)) {
      await launch(widget.resumeLink);
    } else {
      throw 'Could not launch ${widget.resumeLink}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      // height: 200,
      width: size.width >= 400 ? 400 : 350,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 12, 44, 43),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: widget.name.toUpperCase(),
            textType: 'Applied By :',
          ),
          SizedBox(
            height: 10,
          ),
          const Divider(
            color: Colors.white,
            height: 1,
          ),
          SizedBox(
            height: 10,
          ),
          CustomText(
            text: widget.rollNumber.toUpperCase(),
            textType: 'Roll Number :',
          ),
          SizedBox(
            height: 10,
          ),
          const Divider(
            color: Colors.white,
            height: 1,
          ),
          SizedBox(
            height: 10,
          ),
          CustomText(
            text: widget.email,
            textType: 'Email-Id :',
          ),
          SizedBox(
            height: 10,
          ),
          const Divider(
            color: Colors.white,
            height: 1,
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: _openResumeLink,
            child: Row(
              children: [
                Text(
                  'Resume :',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: const Icon(
                    Icons.link,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          const Divider(
            color: Colors.white,
            height: 1,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isAccept,
                    onChanged: (bool? value) => {
                      setState(() {
                        isAccept = !isAccept;
                        isReject = false;
                      })
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Accept?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: isReject,
                    onChanged: (bool? value) => {
                      setState(() {
                        isReject = !isReject;
                        isAccept = false;
                      })
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Reject?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          const Divider(
            color: Colors.white,
            height: 1,
          ),
          SizedBox(
            height: 10,
          ),
          isAccept
              ? InkWell(
                  mouseCursor: SystemMouseCursors.click,
                  onTap: () {
                    _showConfirmationDialog(
                      'Accept',
                      widget.projectName,
                      widget.professorName,
                      widget.email,
                      widget.name,
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 150,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Text(
                        'Send Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              : isReject
                  ? InkWell(
                      mouseCursor: SystemMouseCursors.click,
                      onTap: () {
                        _showConfirmationDialog(
                          'Reject',
                          widget.projectName,
                          widget.professorName,
                          widget.email,
                          widget.name,
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 150,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Text(
                            'Send Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
        ],
      ),
    );
  }

  void _showConfirmationDialog(
    String action,
    String projectName,
    String professorName,
    String userEmail,
    String userName,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to $action?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();
                await Future.delayed(Duration(seconds: 1));
                _sendStatus(
                  widget.userId,
                  widget.designCreditId,
                  action,
                  projectName,
                  professorName,
                  userEmail,
                  userName,
                );
                print('Post request triggered for $action');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendStatus(
    String userId,
    String dessignCreditId,
    String value,
    String projectName,
    String professorName,
    String userEmail,
    String userName,
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
              Text("Sending Status. Please wait...."),
            ],
          ),
        );
      },
    );

    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrlMobileLocalhost/results/post-result',
        ),
        body: {
          'designCreditId': dessignCreditId,
          'userId': userId,
          'status': value,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        await Future.delayed(const Duration(seconds: 2));

        Navigator.of(context).pop();

        showToast('Status send successfully!', Colors.green);

        _sendEmailUser(
          userName,
          userEmail,
          professorName,
          projectName,
          value,
        );
      } else if (response.statusCode == 400) {
        Navigator.of(context).pop();
        showToast('All the fields is not provided', Colors.red);
      }
    } catch (error) {
      print("Error occurred: $error");
      Navigator.of(context).pop();
      showToast("Error occurred! Please try again later.", Colors.red);
    }
  }

  void _sendEmailUser(
    String userName,
    String receiverEmail,
    String professorName,
    String projectName,
    String status,
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
              Text("Sending email. Please wait..."),
            ],
          ),
        );
      },
    );
    try {
      Map<String, dynamic> requestBody = {};

      if (status == "Accept") {
        requestBody = {
          "from": adminEmail,
          "to": receiverEmail,
          "subject":
              "Regarding the update for the Design Credit - $projectName",
          "html": """
    <html>
    <body>
      <p>Dear $userName,</p>
      <p>Your application <strong>$projectName</strong> has been reviewed and your status is updated to <strong>$status</strong>.</p>
      <p>Please reach $professorName at the earliest during office hours ⏰, but first, please take confirmation from the professor ℹ️ for the time.</p>
    </body>
    </html>
  """
        };
      } else if (status == "Reject") {
        requestBody = {
          "from": adminEmail,
          "to": receiverEmail,
          "subject":
              "Regarding the update for the Design Credit - $projectName",
          "html": """
    <html>
    <body>
      <p>Dear $userName,</p>
      <p>We regret to inform you that your application <strong>$projectName</strong> has been reviewed and unfortunately, your status is updated to <strong>$status</strong>. 😞</p>
      <p>Sorry for the inconvenience. Please try again next time. 🙁</p>
    </body>
    </html>
  """
        };
      }

      String jsonBody = json.encode(requestBody);

      final response = await http.post(
        Uri.parse(
          '$baseUrlMobileLocalhost/email/send-email',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        await Future.delayed(Duration(seconds: 4));
        Navigator.pop(context);
        await Future.delayed(Duration(seconds: 2));
        showToast(
          'Mail successfully sent to the student',
          Colors.green,
        );
        print('Email sent successfully');
      } else {
        await Future.delayed(Duration(seconds: 2));
        Navigator.pop(context);
        await Future.delayed(Duration(seconds: 1));
        showToast(
          'There is error in mail send',
          Colors.red,
        );
        print('Failed to send email: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error sending email: $error');
    }
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

class CustomText extends StatelessWidget {
  final String textType;
  final String text;
  const CustomText({required this.text, required this.textType, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            textType,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
