import 'package:dengue_shield/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../widgets/button/button.dart';

class ActionScreen extends StatefulWidget {
  const ActionScreen({super.key});

  @override
  State<ActionScreen> createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen> {
  bool showBreedingSitesContainer = false;
  bool showMosquitoReportsContainer = false;

  Widget _container(Color containerColor, Color textColor, String content,
      {required VoidCallback onTap, required bool showArrowUp}) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: containerColor,
          border: Border.all(
            width: 0.5,
            color: Color(0xff000000).withOpacity(0.13),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Stack(
            children: [
              Center(
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  showArrowUp
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                  color: textColor,
                  size: screenWidth * 0.07,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _dottedContainer(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, bottom: 12.0),
      child: DottedBorder(
        color: Color(0xffC1C0C5),
        strokeWidth: 1.6,
        borderType: BorderType.RRect,
        radius: Radius.circular(14),
        dashPattern: [6, 6],
        child: Container(
          height: screenWidth * 0.26,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Icon(
              Icons.add,
              color: Color(0xffC1C0C5),
              size: screenWidth * 0.09,
            ),
          ),
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
            top: screenWidth * 0.35,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "What would you like to report?",
                    style: TextStyle(
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.1),
                  Text(
                    "Help us fight mosquito-borne diseases by reporting \nbreeding sites or mosquito activity in your area. \nSelect the type of case below and submit \nyour report to alert our control teams.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.0325,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff6B7280),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.065),
                  _container(
                    Color(0xffEB4335).withOpacity(0.21),
                    Color(0xffEB4335),
                    "Breeding Sites",
                    onTap: () {
                      setState(() {
                        showBreedingSitesContainer = !showBreedingSitesContainer;
                      });
                    },
                    showArrowUp: showBreedingSitesContainer,
                  ),
                  if (showBreedingSitesContainer) _dottedContainer(context),
                  SizedBox(height: screenWidth * 0.04),
                  _container(
                    Color(0xffDDDDDD),
                    Color(0xff6B7280),
                    "Mosquito Activity Reports",
                    onTap: () {
                      setState(() {
                        showMosquitoReportsContainer = !showMosquitoReportsContainer;
                      });
                    },
                    showArrowUp: showMosquitoReportsContainer,
                  ),
                  if (showMosquitoReportsContainer) _dottedContainer(context),
                  SizedBox(height: screenWidth * 0.08),
                  SharedButton(
                    screenWidth: screenWidth,
                    content: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Suspected Cases',
                          style: TextStyle(
                            fontSize: screenWidth * 0.0425,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
