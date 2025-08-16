import 'package:dengue_shield/config/keys.dart';
import 'package:dengue_shield/config/theme.dart';
import 'package:dengue_shield/screens/apointment_screen/apointment.dart';
import 'package:dengue_shield/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class SecondOnboardScreen extends StatefulWidget {
  const SecondOnboardScreen({super.key});

  @override
  State<SecondOnboardScreen> createState() => _SecondOnboardScreenState();
}

class _SecondOnboardScreenState extends State<SecondOnboardScreen> {

  Widget _button(Color containerColor, Color textColor, String content, {required VoidCallback onTap}) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 248,
        decoration: BoxDecoration(
          color: containerColor,
          border: Border.all(
            width: 0.5,
            color: Color(0xff000000).withOpacity(0.13),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
          child: Center(
            child: Text(
              content,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
             child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Image.asset(
                  "assets/onboard_screens/screen2_1.png",
                  fit: BoxFit.contain,
                  width: 212,
                 ),
                 SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                   child: Text(
                    "Book an appointment at the nearest government hospital within arm’s reach.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.45,
                      color: mainColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                 ),
                 SizedBox(
                  height: 20,
                 ),
                 _button(mainColor, Colors.white, "find", 
                 onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => CustomBottomNav(key: AppKeys.bottomNavKey,)));
                  },)
               ],
             ),
           ),
          Stack(
            children: [
              Image.asset(
                "assets/onboard_screens/wave_2.png",
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                fit: BoxFit.fill,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/onboard_screens/screen2_2.png",
                      fit: BoxFit.contain,
                      width: 212,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Text(
                        "Book an appointment at the nearest government hospital within arm’s reach.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.45,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _button(Colors.white, mainColor, "Book", 
                    onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => AppointmentScreen()));
                      },)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}