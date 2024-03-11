// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:DesignCredit/screens/auth/loginscreen.dart';
import 'package:DesignCredit/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // bool isLoading = false;
  String _email = '';
  String _password = '';
  String _userType = 'Student';
  String _selectedBranch = 'CSE';
  String _rollNumber = '';
  bool _passwordVisible = false;
  List<String> branchName = ['CSE', 'AI', 'EE', 'MT', 'CH', 'ES', 'BB', 'CIE'];

  // ignore: non_constant_identifier_names
  void SignUp(
    String email,
    String password,
    String userType,
    String rollNo,
    String selectedBranch,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: SizedBox(
            height: 90,
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Registration started. Please wait..."),
              ],
            ),
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
    } else if (userType == 'Student') {
      if (rollNo.isEmpty) {
        Navigator.of(context).pop();
        showToast('Please fill the required fields');
      } else {
        try {
          final response = await http.post(
            Uri.parse(
              '$baseUrlMobileLocalhost/user/register',
            ),
            body: {
              'email': email,
              'password': password,
              'userType': userType,
              'rollNumber': rollNo,
              'branch': selectedBranch,
            },
          );

          if (response.statusCode == 201) {
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('accessToken', '');
            prefs.setString('refreshToken', '');
            await Future.delayed(const Duration(seconds: 5));

            Navigator.of(context).pop();

            showToast('You have successfully registered');

            await Future.delayed(const Duration(seconds: 2));

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          } else if (response.statusCode == 409) {
            // print(response);
            // await Future.delayed(const Duration(seconds: 5));
            Navigator.of(context).pop();
            showToast('User this email already registered!');
          }
        } catch (e) {
          print("Error occurred: $e");
          Navigator.of(context).pop();
          showToast('Error occurred! Please try again later.');
        }
      }
    } else {
      try {
        final response = await http.post(
          Uri.parse(
            '$baseUrlMobileLocalhost/user/register',
          ),
          body: {
            'email': email,
            'password': password,
            'userType': userType,
            'rollNumber': rollNo,
            'branch': selectedBranch,
          },
        );

        if (response.statusCode == 201) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('accessToken', '');
          prefs.setString('refreshToken', '');
          await Future.delayed(const Duration(seconds: 5));
          Navigator.of(context).pop();
          showToast('You have successfully registered');

          await Future.delayed(const Duration(seconds: 2));

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        } else if (response.statusCode == 409) {
          Navigator.of(context).pop();
          // print(response);
          showToast('User this email already registered!');
        }
      } catch (e) {
        Navigator.of(context).pop();
        print("Error occurred: $e");
        showToast('Error occurred! Please try again later.');
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
                        height: size.height * 0.80,
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: DropdownButtonFormField<String>(
                                  value: _userType,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _userType = value!;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                  iconSize: 25,
                                  dropdownColor:
                                      const Color.fromARGB(134, 158, 158, 158),
                                  items: <String>[
                                    'Admin',
                                    'Student',
                                    'Professor'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  decoration: const InputDecoration(
                                    labelText: 'User Type',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              _userType == 'Student'
                                  ? Column(
                                      children: [
                                        CustomTextField(
                                          labelText: 'Roll Number',
                                          onChanged: (value) {
                                            setState(() {
                                              _rollNumber = value;
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child:
                                              DropdownButtonFormField<String>(
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
                                            dropdownColor: Colors.grey,
                                            items: branchName
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            decoration: const InputDecoration(
                                              labelText: 'Branch',
                                              labelStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    )
                                  : _userType == 'Admin'
                                      ? Container()
                                      : Container(),
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  SignUp(
                                    _email,
                                    _password,
                                    _userType,
                                    _rollNumber,
                                    _selectedBranch,
                                    context,
                                  );
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
                                        'SignUp',
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
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account?',
                                    style: GoogleFonts.poppins(
                                      fontSize: size.width >= 400 ? 15 : 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()));
                                    },
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Text(
                                        'Login',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                            ],
                          ),
                        ),
                      )
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
                          image: AssetImage(iitjCampus),
                          fit: BoxFit.fill,
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
                            child: SingleChildScrollView(
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: DropdownButtonFormField<String>(
                                      value: _userType,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _userType = value!;
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      // padding: EdgeInsets.all(10),
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),
                                      iconSize: 25,
                                      dropdownColor: Colors.grey,
                                      items: <String>[
                                        'Admin',
                                        'Student',
                                        'Professor'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        );
                                      }).toList(),
                                      decoration: const InputDecoration(
                                        labelText: 'User Type',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  _userType == 'Student'
                                      ? Column(
                                          children: [
                                            CustomTextField(
                                              labelText: 'Roll Number',
                                              onChanged: (value) {
                                                setState(() {
                                                  _rollNumber = value;
                                                });
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                              ),
                                              child: DropdownButtonFormField<
                                                  String>(
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
                                                dropdownColor: Colors.grey,
                                                items: branchName.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  );
                                                }).toList(),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Branch',
                                                  labelStyle: TextStyle(
                                                      color: Colors.white),
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                        )
                                      : _userType == 'Admin'
                                          ? Container()
                                          : Container(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SignUp(
                                        _email,
                                        _password,
                                        _userType,
                                        _rollNumber,
                                        _selectedBranch,
                                        context,
                                      );
                                    },
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Container(
                                        height: 50,
                                        width: 300,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.blue,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'SignUp',
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
                                        'Already have an account?',
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
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginScreen()));
                                        },
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: Text(
                                            'Login',
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
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
