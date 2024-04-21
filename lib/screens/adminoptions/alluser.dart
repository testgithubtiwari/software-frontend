// ignore_for_file: avoid_print

import 'package:DesignCredit/api/getalluserapi.dart';
import 'package:DesignCredit/models/usermodel.dart';
import 'package:DesignCredit/widgets/constants.dart';
import 'package:DesignCredit/widgets/desktopappbar.dart';
import 'package:DesignCredit/widgets/mobileappbar.dart';
import 'package:DesignCredit/widgets/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllUser extends StatefulWidget {
  const AllUser({super.key});

  @override
  State<AllUser> createState() => _AllUserState();
}

class _AllUserState extends State<AllUser> {
  List<UserModelDesignCredit> allUsers = [];
  @override
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    try {
      List<UserModelDesignCredit> users = await getAllUsers();
      setState(() {
        allUsers = users;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const NavDrawer(),
      body: SafeArea(
        // ignore: avoid_unnecessary_containers
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(iitjCampus),
              fit: BoxFit.cover,
            ),
          ),
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                size.width > 1200
                    ? const DeskTopAppBar()
                    : const MobileAppBar(),
                const SizedBox(
                  height: 15,
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 20,
                  children: allUsers.map((user) {
                    return UserContainer(
                      email: user.email ?? "",
                      userType: user.userType ?? "",
                      rollNumber: user.rollNumber ?? "",
                      branch: user.branch ?? "",
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

class UserContainer extends StatefulWidget {
  final String email;
  final String userType;
  final String rollNumber;
  final String branch;
  const UserContainer(
      {required this.email,
      required this.userType,
      required this.rollNumber,
      required this.branch,
      super.key});

  @override
  State<UserContainer> createState() => _UserContainerState();
}

class _UserContainerState extends State<UserContainer> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: size.width > 1200
          ? const EdgeInsets.fromLTRB(5, 0, 10, 10)
          : const EdgeInsets.fromLTRB(0, 0, 0, 10),
      padding: const EdgeInsets.all(15),
      // height: 250,
      width: size.width >= 400 ? 400 : 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(160, 0, 0, 0),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email-Id : ${widget.email}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(
            height: 1,
            color: Colors.white,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'User-Type: ${widget.userType}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(
            height: 1,
            color: Colors.white,
          ),
          const SizedBox(
            height: 8,
          ),
          widget.userType == 'Student'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Roll-Number: ${widget.rollNumber}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                )
              : Container(),
          const SizedBox(
            height: 8,
          ),
          widget.userType == 'Student'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Branch: ${widget.branch}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                )
              : Container(),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
