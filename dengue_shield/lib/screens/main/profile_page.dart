import 'package:dengue_shield/widgets/appbar/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/alret_dialog/alert_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isClicked = false;
  bool _isDarkMode = false;

  Widget _profileWidget(IconData icon , String content , Color textColor , bool isLogOut , {required VoidCallback onTap} ) {
    final double screenWidth = MediaQuery.of(context).size.width; 
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
              width: 1.5,
              color: Color(0xff000000).withOpacity(0.13),
            ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child : Padding(
          padding: const EdgeInsets.symmetric(vertical: 15 , horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: screenWidth * 0.07,
                    color: textColor,
                  ),
                  SizedBox(
                    width: screenWidth*0.03,
                  ),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              !isLogOut ? 
              Icon(
                Icons.keyboard_arrow_right,
                size: screenWidth * 0.07,
                color: textColor,
              ) : SizedBox()
            ],
          ),
        )
      ),
    );
  }

  Widget _settingContent() {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        _settingWidget(
          'Language',
          Row(
            children: [
              Text(
                "English",
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: screenWidth*0.02,
              ),
              Icon(
                Icons.keyboard_arrow_right,
                size: screenWidth * 0.06,
              )
            ],
          )
         ),
         _settingWidget(
          'Location',
          Row(
            children: [
              Text(
                "Isurupura, Malabe",
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: screenWidth*0.02,
              ),
              Icon(
                Icons.keyboard_arrow_right,
                size: screenWidth * 0.06,
              )
            ],
          )
         ),
         _settingWidget(
            'Dark mode',
            Switch(
              value: _isDarkMode,
              onChanged: (val) {
                setState(() {
                  _isDarkMode = val;
                });
              },
              activeColor: Color(0xFF120F4B), 
              inactiveThumbColor: Color(0xFFFBBC05),
              inactiveTrackColor: Color(0xFF4285F4),
              activeTrackColor: Color(0xFF120F4B),
              thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return Color(0xFF6B7280);
                }
                return Color(0xFFFBBC05); 
              }),
            ),
          ),
         _settingWidget(
          'Privacy Policy',
          SizedBox()
         ),
         _settingWidget(
          'Term and Conditions',
          SizedBox()
         )
      ],
    );
  }

  Widget _settingWidget(String content , Widget childWidget) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return  Padding(
      padding: const EdgeInsets.only( bottom: 10.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
              width: 1.5,
              color: Color(0xff000000).withOpacity(0.13),
            ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child : Padding(
          padding: const EdgeInsets.symmetric(vertical: 15 , horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                content,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Color(0xff6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
              childWidget
            ],
          ),
        )
      ),
    );
  }

  Widget _profileContents() {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        _profileWidget(
          Icons.person, 
          "My Details", 
          Colors.black, 
          false,
          onTap: () {
          },
        ),
        SizedBox(
          height: screenWidth*0.03,
        ),
        _profileWidget(
          Icons.settings_outlined, 
          "Setting", 
          Colors.black, 
          false,
          onTap: () {
            setState(() {
              isClicked = !isClicked;
            });
          },
        ),
        SizedBox(
          height: screenWidth*0.03,
        ),
        _profileWidget(
          Icons.logout, 
          "Logout", 
          Color(0xffB3B7C1), 
          true,
          onTap: () {
            _logout(context);
          },
        ),
      ],
    );
  }

  Future _logout(BuildContext context) async {
   await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Logout',
        message: 'Are you sure you want to logout the app?',
        confirmText: 'OK',
        cancelText: 'Cancel',
        onConfirmed: () {
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Appbar(
            nameShow: !isClicked,
          ),
          Positioned(
            top: isClicked ? screenWidth * 0.35 : screenWidth * 0.3 ,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            child: SizedBox(
              height: MediaQuery.of(context).size.height - (screenWidth * 0.325),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !isClicked ?
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                    radius: screenWidth * 0.1,
                                    backgroundImage: NetworkImage(
                                      'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'
                                    ),
                                                                  ),
                                                                  SizedBox(
                                    width: screenWidth*0.02,
                                                                  ),
                                                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Venuka Rasanjith',
                                        style: TextStyle(
                                          fontSize: screenWidth*0.05,
                                          fontWeight: FontWeight.w500,
                                           height: 1
                                        ),
                                      ),
                                      Text(
                                        'venuka123@gmail.com',
                                        style: TextStyle(
                                          fontSize: screenWidth*0.035,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff9C9C9C),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_pin,
                                            color: Color(0xff898989),
                                            size: screenWidth * 0.04,
                                          ),
                                          Text(
                                            'Molabe',
                                            style: TextStyle(
                                                fontSize: 14, color: Color(0xff898989), height: 1),
                                          ),
                                        ],
                                      ),
                                    ],
                                   ),
                                  ],
                                ),
                              Image.asset(
                                'assets/icons/tier.png'
                              )
                             ],
                            ),
                            SizedBox(
                              height: screenWidth*0.04,
                            ),
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                  color: Color(0xffF5F5F5),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0.4, 0.5),
                                        blurRadius: 1,
                                        color: Colors.white.withOpacity(0.25))
                                  ]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: 0.60,
                                  backgroundColor: Color(0xffF5F5F5),
                                  color: Color(0xffFBBC05),
                                  minHeight: 8,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '232 Gradient Points',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xff7D848D),),
                              ),
                            ),
                            SizedBox(
                              height: screenWidth*0.01,
                            )
                          ],
                        ),
                      ),
                    ) : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Settings",
                          style: TextStyle(
                            fontSize: screenWidth * 0.055,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Version 0.1",
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenWidth*0.06,
                    ),
                    isClicked ? _settingContent() : _profileContents()
                  ],
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}