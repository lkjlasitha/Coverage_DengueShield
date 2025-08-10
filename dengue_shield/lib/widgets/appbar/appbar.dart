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
    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            Container(
              width: screenWidth,
              height: screenWidth*0.6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff4338CA),
                    Color(0xff211C64)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff006496).withOpacity(0.25),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ]
              ),
              child: Padding(
                padding: EdgeInsets.only(top: screenWidth * 0.165 , right: screenWidth * 0.05, left: screenWidth * 0.05 , bottom: screenWidth * 0.05),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: screenWidth * 0.065,
                              backgroundImage: NetworkImage(
                                'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'
                              ),
                            ),
                            SizedBox(
                              width: screenWidth*0.04,
                            ),
                            Text(
                              'Hi, ${"Venuka"}!',
                              style: TextStyle(
                                fontSize: screenWidth*0.04,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          child: Stack(
                            children: [
                              Icon(
                                Icons.notifications,
                                color: Colors.white,
                                size: screenWidth * 0.07,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: screenWidth * 0.03,
                                  height: screenWidth * 0.03,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenWidth*0.125,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}