// ignore_for_file: avoid_print

import 'package:DesignCredit/api/isprofilecompleted.dart';
import 'package:DesignCredit/screens/adminoptions/allapplications.dart';
import 'package:DesignCredit/screens/adminoptions/alldesigncredits.dart';
import 'package:DesignCredit/screens/adminoptions/alluser.dart';
import 'package:DesignCredit/screens/homepage/homepage.dart';
import 'package:DesignCredit/screens/professoroptions.dart/adddesigncredit.dart';
import 'package:DesignCredit/screens/professoroptions.dart/viewdesigncredit.dart';
import 'package:DesignCredit/screens/studentoptions/designcredits.dart';
import 'package:DesignCredit/screens/studentoptions/userapplications.dart';
import 'package:DesignCredit/widgets/constants.dart';
import 'package:DesignCredit/widgets/profilepage.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

import '../api/userapi.dart';
import '../models/usermodel.dart';
import '../screens/auth/loginscreen.dart';

class DeskTopAppBar extends StatefulWidget {
  const DeskTopAppBar({super.key});

  @override
  State<DeskTopAppBar> createState() => _DeskTopAppBarState();
}

class _DeskTopAppBarState extends State<DeskTopAppBar> {
  List<UserModelDesignCredit>? userFuture;
  @override
  void initState() {
    super.initState();
    initializePage();
  }

  void initializePage() async {
    await Future.wait([
      getUserDetails(),
      checkProfileCompleteness(),
    ]);

    setState(() {});
  }

  Future<void> getUserDetails() async {
    Tuple2<List<UserModelDesignCredit>, int> result = await fetchUserData();
    setState(() {
      userFuture = result.item1;
    });
  }

  Future<void> checkProfileCompleteness() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      bool isProfileComplete = await checkProfileCompletion(userId);
      if (isProfileComplete) {
        print('Profile is complete');
      } else {
        showToast(
          'Profile is not completed! Please Complete it before go ahead!',
        );

        await Future.delayed(const Duration(seconds: 2));
        showToast(
          'Navigating to Update Profile Page!',
        );
        await Future.delayed(const Duration(seconds: 2));
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const UpdateProfilePage()));
        print('Profile is not complete');
      }
    } catch (error) {
      // Handle any errors that occurred during the profile completeness check
      print('Error checking profile completeness: $error');
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
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
    return userFuture == null
        ? Container(
            width: size.width,
            height: 60,
            color: const Color.fromARGB(111, 0, 0, 0),
            child: const SpinKitWave(
              color: Colors.white,
              size: 30,
            ),
          )
        : Container(
            height: 60,
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Color.fromARGB(113, 0, 0, 0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  },
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: SizedBox(
                      width: 40,
                      height: 60,
                      child: Image(
                        image: AssetImage(reduceLogo),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                // ignore: sized_box_for_whitespace
                Container(
                  width: 830,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClickableText(
                        text: 'Profile',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UpdateProfilePage()));
                        },
                      ),
                      // const SizedBox(
                      //   width: 30,
                      // ),
                      userFuture?[0].userType == 'Admin'
                          ? const AdminOptions()
                          : userFuture?[0].userType == 'Student'
                              ? StudentOption(
                                  userEmail: userFuture?[0].email ?? '',
                                )
                              : const ProfessorOptions(),
                      GestureDetector(
                        onTap: () {
                          logout();
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: 100,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.blue,
                            ),
                            child: Center(
                              child: Text(
                                'LogOut',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }

  Future<void> logout() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 10),
              Text("Logging you out. Please wait..."),
            ],
          ),
        );
      },
    );
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', '');
    prefs.setString('refreshToken', '');

    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}

class AdminOptions extends StatefulWidget {
  const AdminOptions({super.key});

  @override
  State<AdminOptions> createState() => _AdminOptionsState();
}

class _AdminOptionsState extends State<AdminOptions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClickableText(
          text: 'Get All User',
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AllUser()));
          },
        ),
        const SizedBox(
          width: 30,
        ),
        ClickableText(
          text: 'All Applications',
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AllApplications()));
          },
        ),
        const SizedBox(
          width: 30,
        ),
        ClickableText(
          text: 'All DesignCredits',
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AllDesignCredits()));
          },
        ),
      ],
    );
  }
}

class ProfessorOptions extends StatefulWidget {
  const ProfessorOptions({super.key});

  @override
  State<ProfessorOptions> createState() => _ProfessorOptionsState();
}

class _ProfessorOptionsState extends State<ProfessorOptions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClickableText(
          text: 'Float-Design Credits',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddDesignCredits()),
            );
          },
        ),
        const SizedBox(
          width: 30,
        ),
        ClickableText(
          text: 'View Design Credit',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ViewYourDesignCredits(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class StudentOption extends StatefulWidget {
  final String userEmail;

  const StudentOption({required this.userEmail, super.key});

  @override
  State<StudentOption> createState() => _StudentOptionState();
}

class _StudentOptionState extends State<StudentOption> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClickableText(
          text: 'All Design Credits',
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DesignCredits(
                          userEmail: widget.userEmail,
                        )));
          },
        ),
        const SizedBox(
          width: 30,
        ),
        ClickableText(
          text: 'My Applications',
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserApplication()));
          },
        ),
        const SizedBox(
          width: 30,
        ),
        ClickableText(
          text: 'Check Results',
          onTap: () {},
        ),
      ],
    );
  }
}

class ClickableText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final SystemMouseCursor cursor;

  // ignore: use_key_in_widget_constructors
  const ClickableText({
    required this.text,
    required this.onTap,
    this.color = Colors.white,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w500,
    this.cursor = SystemMouseCursors.click,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: cursor,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
