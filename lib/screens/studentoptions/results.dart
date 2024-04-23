import 'package:DesignCredit/api/resultApi.dart';
import 'package:DesignCredit/models/resultmodel.dart';
import 'package:DesignCredit/widgets/constants.dart';
import 'package:DesignCredit/widgets/desktopappbar.dart';
import 'package:DesignCredit/widgets/mobileappbar.dart';
import 'package:DesignCredit/widgets/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Results extends StatefulWidget {
  final String userId;
  const Results({required this.userId, super.key});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  List<MapEntry<String, ResultModel>> _resultList = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchResult();
  }

  Future<void> _fetchResult() async {
    try {
      final List<MapEntry<String, ResultModel>> applications =
          await fetchSpecificResults(widget.userId);
      setState(() {
        _resultList = applications;
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
                    : _resultList.isEmpty
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
                            children: _resultList.map((entry) {
                              final result = entry.value;
                              return AllResultContainer(
                                projectName:
                                    result.designCreditId!.projectName ?? '',
                                status: result.status ?? '',
                                description:
                                    result.designCreditId!.description ?? '',
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

class AllResultContainer extends StatefulWidget {
  final String description;
  final String status;
  final String projectName;
  const AllResultContainer({
    required this.description,
    required this.status,
    required this.projectName,
    super.key,
  });

  @override
  State<AllResultContainer> createState() => _AllApplicationsContainerState();
}

class _AllApplicationsContainerState extends State<AllResultContainer> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width >= 400 ? 400 : 350,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 12, 44, 43),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          CustomText(
            text: widget.projectName,
            textType: 'Project Name :',
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
            text: widget.description,
            textType: 'Description :',
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
            text: widget.status,
            textType: 'Status :',
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
