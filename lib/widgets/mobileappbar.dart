import 'package:DesignCredit/screens/homepage/homepage.dart';
import 'package:DesignCredit/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MobileAppBar extends StatefulWidget {
  const MobileAppBar({super.key});

  @override
  State<MobileAppBar> createState() => _MobileAppBarState();
}

class _MobileAppBarState extends State<MobileAppBar> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: 60,
      padding: const EdgeInsets.all(10),
      width: size.width,
      decoration: const BoxDecoration(
        color: Color.fromARGB(113, 0, 0, 0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            child: const SizedBox(
              height: 50,
              width: 40,
              child: Image(
                image: AssetImage(reduceLogo),
                fit: BoxFit.fill,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 25,
            ),
          )
        ],
      ),
    );
  }
}
