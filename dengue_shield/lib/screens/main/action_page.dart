import 'package:dengue_shield/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';
import '../../widgets/button/button.dart';

class ActionScreen extends StatefulWidget {
  const ActionScreen({super.key});

  @override
  State<ActionScreen> createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen> {

  Widget _container(Color containerColor , Color textColor , String content) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: containerColor,
        border: Border.all(
          width: 0.5,
          color: Color(0xff000000).withOpacity(0.13)
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 15),
        child: Stack(
          children: [
            Center(
              child: Text(
                content,
                style: TextStyle(
                  fontSize: screenWidth*0.04,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.keyboard_arrow_down_outlined,
                color: textColor,
                size: screenWidth*0.07,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Appbar(),
          Positioned(
            top: screenWidth * 0.375,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            child: SizedBox(
              height: MediaQuery.of(context).size.height - (screenWidth * 0.375),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "What would you like to report?",
                      style: TextStyle(
                        fontSize: screenWidth*0.055,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                      ),
                    ),
                    SizedBox(
                      height: screenWidth*0.1,
                    ),
                    Text(
                      "Help us fight mosquito-borne diseases by reporting \nbreeding sites or mosquito activity in your area. \nSelect the type of case below and submit \nyour report to alert our control teams.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth*0.0325,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff6B7280)
                      ),
                    ),
                    SizedBox(
                      height: screenWidth*0.075,
                    ),
                    _container(Color(0xffEB4335).withOpacity(0.21), Color(0xffEB4335), "Breeding Sites"),
                    SizedBox(
                      height: screenWidth*0.05,
                    ),
                    _container(Color(0xffDDDDDD), Color(0xff6B7280), "Mosquito Activity Reports"),
                    SizedBox(
                      height: screenWidth*0.065,
                    ),
                    SharedButton(screenWidth: screenWidth, 
                    content: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                            'Suspected Cases',
                            style: TextStyle(
                              fontSize: screenWidth*0.0425,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                            ),
                          ),
                        ),
                      )
                    )
                  ],
                ),
              ),
            )
          ),
        ],
      )
    );
  }
}