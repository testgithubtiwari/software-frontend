// import 'dart:ffi';

import 'package:DesignCredit/api/designcreditapi.dart';
import 'package:DesignCredit/models/designcreditmodel.dart';
import 'package:DesignCredit/widgets/constants.dart';
import 'package:DesignCredit/widgets/mobileappbar.dart';
import 'package:DesignCredit/widgets/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllDesignCredits extends StatefulWidget {
  const AllDesignCredits({super.key});

  @override
  State<AllDesignCredits> createState() => _AllDesignCreditsState();
}

class _AllDesignCreditsState extends State<AllDesignCredits> {
  late Future<List<DesignCreditModel>> designCreditList;

  @override
  void initState() {
    super.initState();
    designCreditList = fetchDesignCredits();
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
                FutureBuilder<List<DesignCreditModel>>(
                  future: designCreditList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        color: Colors.blue,
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No design credits found',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    } else {
                      return Wrap(
                        spacing: 10,
                        runSpacing: 20,
                        children: snapshot.data!.map(
                          (designCredit) {
                            return DesignCreditContainer(
                              offeredBy: designCredit.offeredBy ?? '',
                              professorName: designCredit.professorName ?? '',
                              projectName: designCredit.projectName ?? '',
                              eligibleBranches:
                                  designCredit.eligibleBranches ?? [],
                            );
                          },
                        ).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DesignCreditContainer extends StatefulWidget {
  final String projectName;
  // final
  final List<String> eligibleBranches;
  final String professorName;
  final String offeredBy;
  const DesignCreditContainer(
      {required this.offeredBy,
      required this.professorName,
      required this.projectName,
      required this.eligibleBranches,
      super.key});

  @override
  State<DesignCreditContainer> createState() => _DesignCreditContainerState();
}

class _DesignCreditContainerState extends State<DesignCreditContainer> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 5,
      child: Container(
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
            SizedBox(
              height: 10,
            ),
            const Divider(
              height: 1,
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            CustomText(
              text: widget.professorName,
              textType: 'Professor-Name:',
            ),
            SizedBox(
              height: 10,
            ),
            const Divider(
              height: 1,
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            CustomText(
              text: widget.offeredBy,
              textType: 'Offered-By:',
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            const Divider(
              height: 1,
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            const Text(
              'Eligible Branches:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: widget.eligibleBranches.map(
                (branches) {
                  return CustomText1(text: branches);
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomText1 extends StatelessWidget {
  final String text;

  const CustomText1({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            textType,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
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
