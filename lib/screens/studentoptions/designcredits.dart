import 'package:DesignCredit/api/designcreditapi.dart';
import 'package:DesignCredit/models/designcreditmodel.dart';
import 'package:DesignCredit/screens/studentoptions/widgets/applydesigncredit.dart';
import 'package:DesignCredit/widgets/constants.dart';
import 'package:DesignCredit/widgets/desktopappbar.dart';
import 'package:DesignCredit/widgets/mobileappbar.dart';
import 'package:DesignCredit/widgets/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignCredits extends StatefulWidget {
  final String userName;
  final String userEmail;
  const DesignCredits(
      {required this.userEmail, required this.userName, super.key});

  @override
  State<DesignCredits> createState() => _DesignCreditsState();
}

class _DesignCreditsState extends State<DesignCredits> {
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
                              userName: widget.userName,
                              email: widget.userEmail,
                              designCreditId: designCredit.sId ?? '',
                              desc: designCredit.description ?? '',
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
  final String userName;
  final String email;
  final String designCreditId;
  final List<String> eligibleBranches;
  final String professorName;
  final String offeredBy;
  final String desc;
  const DesignCreditContainer(
      {required this.offeredBy,
      required this.userName,
      required this.email,
      required this.designCreditId,
      required this.desc,
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
        mainAxisAlignment: MainAxisAlignment.center,
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
            height: 1,
            color: Colors.white,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomText(
            text: widget.desc,
            textType: 'Description:',
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 1,
            color: Colors.white,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomText(
            text: widget.professorName,
            textType: 'Professor-Name:',
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 1,
            color: Colors.white,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomText(
            text: widget.offeredBy,
            textType: 'Offered-By:',
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 1,
            color: Colors.white,
          ),
          const SizedBox(
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApplyDesignCredit(
                    userName: widget.userName,
                    email: widget.email,
                    projectName: widget.projectName,
                    prfessorName: widget.professorName,
                    designCreditId: widget.designCreditId,
                  ),
                ),
              );
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,
                  ),
                  child: const Center(
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
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
