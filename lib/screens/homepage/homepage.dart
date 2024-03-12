// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:DesignCredit/api/userapi.dart';
import 'package:DesignCredit/models/usermodel.dart';
// import 'package:DesignCredit/models/allapplicationusermodel.dart';
import 'package:DesignCredit/screens/auth/loginscreen.dart';
import 'package:DesignCredit/screens/auth/signupscreen.dart';
// import 'package:DesignCredit/screens/studentoptions/userapplications.dart';
import 'package:DesignCredit/widgets/desktopappbar.dart';
import 'package:DesignCredit/widgets/mobileappbar.dart';
import 'package:DesignCredit/widgets/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserModelDesignCredit>? _userFuture;
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
      print(_userFuture?[0].email);
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
              image: AssetImage('assets/images/iitjcampus.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              size.width <= 1200 ? const MobileAppBar() : const DeskTopAppBar(),
              const SizedBox(
                height: 20,
              ),
              Text(
                'My Applications',
                style: GoogleFonts.orbitron(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // _userFuture![0].userType == 'Student'
              //     ? const UserApplication()
              //     : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
