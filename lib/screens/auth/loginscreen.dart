// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:DesignCredit/screens/homepage/homepage.dart';
import 'package:DesignCredit/widgets/constants.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:DesignCredit/screens/auth/signupscreen.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';
  // String _userType = 'Student';
  bool _passwordVisible = false;
  bool isLoading = false;

  // googleLogin() async {
  //   print('Google login method called');
  //   GoogleSignIn googleSignIn = GoogleSignIn(
  //       clientId:
  //           '1081628182897-dd3r43jv7goulerln5oo8ai71ujkjvi8.apps.googleusercontent.com');
  //   await googleSignIn.signOut();
  //   try {
  //     var result = await googleSignIn.signIn();
  //     print(result);
  //   } catch (err) {
  //     print(err);
  //   }
  // }

  // @override
  // void initState() {
  //   checkSignInStatus();
  //   super.initState();
  // }

  // void checkSignInStatus() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   bool isSignedIn = await GoogleSignIn(
  //           clientId:
  //               '1081628182897-dd3r43jv7goulerln5oo8ai71ujkjvi8.apps.googleusercontent.com')
  //       .isSignedIn();
  //   if (isSignedIn) {
  //     print('User Signed in');
  //   } else {
  //     print('User not signed iN');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _checkforLoogedIn();
  }

  void _checkforLoogedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accesstoken = prefs.getString('accessToken');
    final String? refreshtoken = prefs.getString('refreshToken');
    if (accesstoken != '' && refreshtoken != '') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }

  void login(String email, String password, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Logging you in. Please wait..."),
            ],
          ),
        );
      },
    );
    if (email.isEmpty || password.isEmpty) {
      Navigator.of(context).pop();
      showToast('Please fill the required fields');
    } else if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email)) {
      Navigator.of(context).pop();
      showToast('Invalid email address');
    } else {
      try {
        final response = await http.post(
          Uri.parse(
            '$baseUrlMobileLocalhost/user/login',
          ),
          body: {
            'email': email,
            'password': password,
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);

          final String accessToken = responseData['accessToken'];
          final String refreshToken = responseData['refreshToken'];

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', accessToken);
          await prefs.setString('refreshToken', refreshToken);

          await Future.delayed(const Duration(seconds: 2));

          Navigator.of(context).pop();

          showToast('Login Successful');

          await Future.delayed(const Duration(seconds: 2));

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else if (response.statusCode == 401) {
          // print(response);
          Navigator.of(context).pop();
          showToast('Email or password is wrong!');
        }
      } catch (e) {
        print("Error occurred: $e");
        Navigator.of(context).pop();
        showToast("Error occurred! Please try again later.");
      }
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: size.width <= 1200
              ? Container(
                  height: size.height,
                  width: size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(iitjCampus),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                        width: size.width * 0.85,
                        height: size.height * 0.60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(164, 0, 0, 0),
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
                                height: size.width * 0.30,
                                width: size.width * 0.30,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(logo),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                labelText: 'Email',
                                onChanged: (value) {
                                  setState(() {
                                    _email = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                labelText: 'Password',
                                obscureText: !_passwordVisible,
                                onChanged: (value) {
                                  setState(() {
                                    _password = value;
                                  });
                                },
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  login(_email, _password, context);
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Container(
                                    height: 50,
                                    width: size.width * 0.50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.blue,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Login',
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
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Not have an account?',
                                    style: GoogleFonts.poppins(
                                      fontSize: size.width >= 400 ? 15 : 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUp()));
                                    },
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Text(
                                        'SignUp',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(
                                  //   height: 20,
                                  // )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Row(
                  children: [
                    Container(
                      height: size.height,
                      width: size.width * 0.50,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(loginBackgroundImage),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      height: size.height,
                      width: size.width * 0.50,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(iitjCampus),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 600,
                            width: 500,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(125, 0, 0, 0),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(logo),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  labelText: 'Email',
                                  onChanged: (value) {
                                    setState(() {
                                      _email = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  labelText: 'Password',
                                  obscureText: !_passwordVisible,
                                  onChanged: (value) {
                                    setState(() {
                                      _password = value;
                                    });
                                  },
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    login(_email, _password, context);
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Container(
                                      height: 50,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.blue,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Login',
                                          style: GoogleFonts.poppins(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Not have an account?',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignUp()));
                                      },
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Text(
                                          'SignUp',
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
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
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        onChanged: onChanged,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          hoverColor: Colors.black,
          labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}
