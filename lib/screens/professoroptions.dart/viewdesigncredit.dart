import 'package:DesignCredit/api/designcreditapi.dart';
import 'package:DesignCredit/models/designcreditmodel.dart';
import 'package:DesignCredit/screens/professoroptions.dart/widgets/applications.dart';
import 'package:DesignCredit/widgets/constants.dart';
import 'package:DesignCredit/widgets/desktopappbar.dart';
import 'package:DesignCredit/widgets/mobileappbar.dart';
import 'package:DesignCredit/widgets/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewYourDesignCredits extends StatefulWidget {
  const ViewYourDesignCredits({super.key});

  @override
  State<ViewYourDesignCredits> createState() => _ViewYourDesignCreditsState();
}

class _ViewYourDesignCreditsState extends State<ViewYourDesignCredits> {
  late Future<List<DesignCreditModel>> yourDesignCreditList = Future.value([]);

  @override
  void initState() {
    super.initState();
    getProfessorName();
  }

  void getProfessorName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? professorName = prefs.getString('name');
    print(professorName);
    setState(() {
      yourDesignCreditList = filterDesignCredits(professorName!);
    });
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
                size.width > 1200
                    ? const DeskTopAppBar()
                    : const MobileAppBar(),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<DesignCreditModel>>(
                  future: yourDesignCreditList,
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
                            color: Colors.black,
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
                              designCreditId: designCredit.sId ?? '',
                              offeredBy: designCredit.offeredBy ?? '',
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
  final String designCreditId;
  final String projectName;
  final List<String> eligibleBranches;
  // final String professorName;
  final String offeredBy;
  const DesignCreditContainer(
      {required this.offeredBy,
      required this.designCreditId,
      // required this.professorName,
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
            text: widget.offeredBy,
            textType: 'Offered-By:',
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
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // GestureDetector(
              //   onTap: () {},
              //   child: MouseRegion(
              //     cursor: SystemMouseCursors.click,
              //     child: Container(
              //       height: 50,
              //       width: 120,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(15),
              //         color: Colors.blue,
              //       ),
              //       child: const Center(
              //         child: Text(
              //           'Update',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 18,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Applications(designCreditId: widget.designCreditId),
                    ),
                  );
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue,
                    ),
                    child: const Center(
                      child: Text(
                        'Applications',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
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
