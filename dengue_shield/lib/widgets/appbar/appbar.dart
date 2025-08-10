import 'package:flutter/material.dart';
class Appbar extends StatefulWidget {
  const Appbar({super.key});

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(screenWidth * 0.1),
          bottomRight: Radius.circular(screenWidth * 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xff86B3E4).withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 19.6,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ]
      ),
      child: Padding(
        padding: EdgeInsets.only(top: screenWidth * 0.165 , right: screenWidth * 0.05, left: screenWidth * 0.05 , bottom: screenWidth * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello ${"Venuka"}!',
                  style: TextStyle(
                    fontSize: screenWidth*0.09,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: <Color>[
                          Color(0xff2D3C57),
                          Color(0xff6282BD),
                        ],
                      ).createShader(
                        Rect.fromLTWH(0.0, 0.0,300.0,0.0),
                      ),
                  ),
                ),
                Text(
                  'Weekend loading… plans ready?',
                  style: TextStyle(
                    fontSize: screenWidth*0.04,
                    fontWeight: FontWeight.w300,
                    color: Color(0xff7A7A7A),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}