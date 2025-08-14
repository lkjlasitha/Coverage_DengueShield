import 'dart:math';
import 'package:dengue_shield/config/theme.dart';
import 'package:dengue_shield/widgets/button/button.dart';
import 'package:dengue_shield/widgets/environment_data_widget/environment_data_widget.dart';
import 'package:flutter/material.dart';
import '../../widgets/appbar/appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isFabOpen = false;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _toggleFabMenu() {
    setState(() {
      _isFabOpen = !_isFabOpen;
      if (_isFabOpen) {
        _fabController.forward();
      } else {
        _fabController.reverse();
      }
    });
  }

  Widget _buildRadialFab(IconData icon, Color color, double angle, double distance, VoidCallback onTap) {
    final double rad = angle * pi / 180;
    return AnimatedBuilder(
      animation: _fabController,
      builder: (_, __) {
        final double progress = _fabController.value;
        final double dx = cos(rad) * distance * progress;
        final double dy = -sin(rad) * distance * progress;
        return Positioned(
          bottom: 16 + dy,
          right: 16 + dx,
          child: Opacity(
            opacity: progress,
            child: FloatingActionButton(
              mini: true,
              onPressed: onTap,
              backgroundColor: Colors.white,
              child: Icon(icon, color: color),
              elevation: 4,
            ),
          ),
        );
      },
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
            top: screenWidth * 0.325,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            child: SizedBox(
              height: MediaQuery.of(context).size.height - (screenWidth * 0.325),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Current Risk Level',
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w700,
                                      height: 1),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                  decoration: BoxDecoration(
                                      color: Color(0xffFBBC05).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 1,
                                          color: Color(0xffFBBC05).withOpacity(0.32))),
                                  child: Text(
                                    'Medium',
                                    style: TextStyle(
                                      color: Color(0xffFBBC05),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Color(0xff818181),
                                  size: screenWidth * 0.04,
                                ),
                                Text(
                                  'Molabe',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600], height: 1),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  '45/100',
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87,
                                      height: 1),
                                ),
                              ],
                            ),
                            Text(
                              'increasing in last 24h',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xffFFA0A0),
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 12),
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
                                  color: Color(0xffEB4335),
                                  minHeight: 8,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: screenWidth * 0.015,
                                ),
                                Text(
                                  'updated 1hr ago',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xff7D848D),
                                      height: 1),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Recommended Actions',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  height: 1),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '• Use Mosquito Repellent When Outdoors\n• Keep Surroundings',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenWidth * 0.04,
                    ),
                    Text(
                      "Today's Environmental Data",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: screenWidth * 0.04,
                    ),
                    EnvironmentDataWidget(
                        title: "Temperature",
                        img_path: 'assets/icons/temp.png',
                        value: "32 C"),
                    EnvironmentDataWidget(
                        title: "Rainfall",
                        img_path: 'assets/icons/wether.png',
                        value: "32 mm"),
                    EnvironmentDataWidget(
                        title: "New Cases",
                        img_path: 'assets/icons/wave.png',
                        value: "22"),
                    SizedBox(
                      height: screenWidth * 0.04,
                    ),
                    SharedButton(screenWidth: screenWidth*0.475, 
                    content: Column(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.white,
                        ),
                        Text(
                          'View Map',
                          style: TextStyle(
                            fontSize: screenWidth*0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                          ),
                        )
                      ],
                     )
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          _buildRadialFab(Icons.warning, Colors.redAccent, 90, -80, () => debugPrint("Alert clicked")),
          _buildRadialFab(Icons.image, Colors.indigoAccent, 140, -80, () => debugPrint("Gallery clicked")),
          _buildRadialFab(Icons.cloud, Colors.deepPurple, 185, -80, () => debugPrint("Cloud clicked")),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: mainColor,
              shape: const CircleBorder(),
              onPressed: _toggleFabMenu,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(_isFabOpen ? Icons.close : Icons.add, key: ValueKey(_isFabOpen), color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
