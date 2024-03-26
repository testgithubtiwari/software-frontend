// ignore_for_file: deprecated_member_use, avoid_print

import 'package:DesignCredit/api/allapplicationsapi.dart';
import 'package:DesignCredit/models/allapplicationusermodel.dart';
import 'package:DesignCredit/widgets/constants.dart';
import 'package:DesignCredit/widgets/mobileappbar.dart';
import 'package:DesignCredit/widgets/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserApplication extends StatefulWidget {
  const UserApplication({super.key});

  @override
  State<UserApplication> createState() => _UserApplicationState();
}

class _UserApplicationState extends State<UserApplication> {
  List<MapEntry<String, AllApplicationUserModel>> _applications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchApplications();
  }

  Future<void> _fetchApplications() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      final List<MapEntry<String, AllApplicationUserModel>> applications =
          await fetchAllApplicationsUserDesignCredit(userId!);
      setState(() {
        _applications = applications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
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
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(iitjCampus),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const MobileAppBar(),
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
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : Wrap(
                            spacing: 10,
                            runSpacing: 20,
                            children: _applications.map(
                              (MapEntry<String, AllApplicationUserModel>
                                  entry) {
                                final AllApplicationUserModel application =
                                    entry.value;
                                return ApplicationContainer(
                                  resumeLink: application.resumeLink ?? '',
                                  description:
                                      application.designCreditId?.description ??
                                          '',
                                  projectName:
                                      application.designCreditId?.projectName ??
                                          '',
                                );
                              },
                            ).toList(),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ApplicationContainer extends StatefulWidget {
  final String projectName;
  final String description;
  final String resumeLink;

  const ApplicationContainer({
    required this.resumeLink,
    required this.description,
    required this.projectName,
    super.key,
  });

  @override
  State<ApplicationContainer> createState() => _DesignCreditContainerState();
}

class _DesignCreditContainerState extends State<ApplicationContainer> {
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
      padding: const EdgeInsets.all(15),
      // height: 250,
      width: size.width >= 400 ? 400 : 350,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(255, 12, 44, 43),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: widget.projectName,
            textType: 'Project-Name:',
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: Colors.white,
            height: 1,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomText(
            text: widget.description,
            textType: 'Description:',
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: Colors.white,
            height: 1,
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: _openResumeLink,
            child: Row(
              children: [
                Text(
                  'ResumeLink:',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Icon(
                  Icons.link,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
              fontWeight: FontWeight.w400,
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
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
