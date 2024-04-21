// import 'dart:ui';

// ignore_for_file: avoid_print

import 'package:DesignCredit/api/isprofilecompleted.dart';
import 'package:DesignCredit/api/userapi.dart';
import 'package:DesignCredit/models/usermodel.dart';
import 'package:DesignCredit/screens/adminoptions/allapplications.dart';
import 'package:DesignCredit/screens/adminoptions/alldesigncredits.dart';
import 'package:DesignCredit/screens/adminoptions/alluser.dart';
import 'package:DesignCredit/screens/auth/loginscreen.dart';
// import 'package:DesignCredit/screens/professoroptions.dart/floatdesigncredits.dart';
import 'package:DesignCredit/screens/professoroptions.dart/adddesigncredit.dart';
import 'package:DesignCredit/screens/professoroptions.dart/viewdesigncredit.dart';
import 'package:DesignCredit/screens/studentoptions/designcredits.dart';
import 'package:DesignCredit/screens/studentoptions/results.dart';
import 'package:DesignCredit/screens/studentoptions/userapplications.dart';
import 'package:DesignCredit/widgets/constants.dart';
import 'package:DesignCredit/widgets/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

// ignore: must_be_immutable
class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  List<UserModelDesignCredit>? userFuture;
  @override
  void initState() {
    super.initState();
    getUserDetails();
    checkProfileCompleteness();
  }

  void getUserDetails() async {
    Tuple2<List<UserModelDesignCredit>, int> result = await fetchUserData();
    setState(() {
      userFuture = result.item1;
    });
  }

  void checkProfileCompleteness() async {
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
    final userEmail =
        userFuture?.isNotEmpty == true ? userFuture![0].email : 'Unknown';
    // print(widget.userFuture?[0].email);
    return userFuture == null
        ? Container(
            width: 320,
            color: const Color.fromARGB(111, 0, 0, 0),
            child: const SpinKitWave(
              color: Colors.white,
              size: 30,
            ),
          )
        : Container(
            height: size.height,
            width: 320,
            color: const Color.fromARGB(111, 0, 0, 0),
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  const LogoContainer(),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '$userEmail',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const OptionContainer(
                    text: 'Profile',
                    screen: UpdateProfilePage(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  userFuture?[0].userType == 'Admin'
                      ? const AdminOptions()
                      : userFuture?[0].userType == 'Student'
                          ? StudentOptions(
                              userName: userFuture?[0].name ?? '',
                              userEmail: userFuture?[0].email ?? '',
                            )
                          : const ProfessorOptions(),
                  const SizedBox(
                    height: 20,
                  ),
                  const OptionContainer(screen: LoginScreen(), text: 'Logout'),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
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
    return const Column(
      children: [
        OptionContainer(screen: AllUser(), text: 'Get All User'),
        SizedBox(
          height: 20,
        ),
        OptionContainer(screen: AllApplications(), text: 'All Applications'),
        SizedBox(
          height: 20,
        ),
        OptionContainer(screen: AllDesignCredits(), text: 'All DesignCredits'),
      ],
    );
  }
}

class StudentOptions extends StatefulWidget {
  final String userEmail;
  final String userName;
  const StudentOptions(
      {required this.userEmail, required this.userName, super.key});

  @override
  State<StudentOptions> createState() => _StudentOptionsState();
}

class _StudentOptionsState extends State<StudentOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OptionContainer(
          screen: DesignCredits(
            userEmail: widget.userEmail,
          ),
          text: 'All Design Credits',
        ),
        SizedBox(
          height: 20,
        ),
        OptionContainer(screen: UserApplication(), text: 'My Applications'),
        SizedBox(
          height: 20,
        ),
        OptionContainer(screen: Results(), text: 'Check Results'),
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
    return const Column(
      children: [
        OptionContainer(
          screen: AddDesignCredits(),
          text: 'Float Design-Credits',
        ),
        SizedBox(
          height: 20,
        ),
        OptionContainer(
          screen: ViewYourDesignCredits(),
          text: 'View your Design Credits',
        ),
      ],
    );
  }
}

class LogoContainer extends StatelessWidget {
  const LogoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 140,
      width: 140,
      child: Image(
        image: AssetImage(logo),
        fit: BoxFit.fill,
      ),
    );
  }
}

class OptionContainer extends StatefulWidget {
  final String text;
  final Widget screen;
  const OptionContainer({required this.screen, required this.text, super.key});

  @override
  State<OptionContainer> createState() => _OptionContainerState();
}

class _OptionContainerState extends State<OptionContainer> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        widget.text == 'Logout'
            ? logout()
            : Navigator.push(context,
                MaterialPageRoute(builder: (context) => widget.screen));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        padding: const EdgeInsets.all(10),
        height: 80,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(255, 12, 44, 43),
        ),
        child: Center(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Text(
              widget.text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void logout() async {
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
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
