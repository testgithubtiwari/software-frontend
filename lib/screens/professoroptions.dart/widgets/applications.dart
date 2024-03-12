// ignore_for_file: deprecated_member_use
import 'package:DesignCredit/widgets/constants.dart';
import 'package:DesignCredit/widgets/mobileappbar.dart';
import 'package:DesignCredit/widgets/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/allapplicationsapi.dart';
import '../../../models/allapplicationdesigncreditmodelnew.dart';

class Applications extends StatefulWidget {
  final String designCreditId;
  const Applications({required this.designCreditId, super.key});

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
                                name: application.userId?.name ?? '',
                                // projectName:
                                //     application.designCreditId?.projectName ??
                                //         '',
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
  final String name;
  final String email;
  final String resumeLink;
  // final String projectName;
  const AllApplicationsContainer({
    required this.name,
    // required this.projectName,
    required this.resumeLink,
    required this.email,
    super.key,
  });

  @override
  State<AllApplicationsContainer> createState() =>
      _AllApplicationsContainerState();
}

class _AllApplicationsContainerState extends State<AllApplicationsContainer> {
  void _openResumeLink() async {
    if (await canLaunch(widget.resumeLink)) {
      await launch(widget.resumeLink);
    } else {
      throw 'Could not launch ${widget.resumeLink}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      width: 350,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 12, 44, 43),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: widget.name,
            textType: 'Applied By:',
          ),
          CustomText(
            text: widget.email,
            textType: 'Email-Id:',
          ),
          // CustomText(
          //   // text: widget.projectName,
          //   textType: 'ProjectName:',
          // ),
          GestureDetector(
            onTap: _openResumeLink,
            child: Row(
              children: [
                Text(
                  'ResumeLink:',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Icon(
                  Icons.link,
                  color: Colors.white,
                  size: 24,
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
              fontWeight: FontWeight.w600,
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
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
