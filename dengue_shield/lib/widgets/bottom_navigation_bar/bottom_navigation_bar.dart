import 'dart:io';
import 'package:dengue_shield/config/theme.dart';
import 'package:dengue_shield/screens/main/action_page.dart';
import 'package:dengue_shield/screens/main/home_page.dart';
import 'package:dengue_shield/screens/main/inform_page.dart';
import 'package:dengue_shield/screens/main/map_page.dart';
import 'package:dengue_shield/screens/main/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animations/animations.dart';
import '../alret_dialog/alert_dialog.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({Key? key}) : super(key: key);

  @override
  CustomBottomNavState createState() => CustomBottomNavState();
}

class CustomBottomNavState extends State<CustomBottomNav> {
  int _selectedIndex = 0;
  bool _isLoading = false;

  final List<_NavItem> _navItems = [
    _NavItem(label: 'Home', iconPath: 'assets/navigation_bar/home.svg'),
    _NavItem(label: 'Inform', iconPath: 'assets/navigation_bar/inform.svg'),
    _NavItem(label: 'Map', iconPath: 'assets/navigation_bar/map.svg'),
    _NavItem(label: 'Action', iconPath: 'assets/navigation_bar/action.svg'),
    _NavItem(label: 'Profile', iconPath: 'assets/navigation_bar/profile.svg'),
  ];

  // Your pages
  final List<Widget> _pages = const [
    HomeScreen(),
    InformScreen(),
    MapScreen(),
    ActionScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
    }
  }

  void navigateTo(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildNavItem(int index) {
    final isSelected = index == _selectedIndex;
    final screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: screenWidth * 0.03),
            AnimatedScale(
              scale: isSelected ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 300),
              child: SvgPicture.asset(
                _navItems[index].iconPath,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isSelected ? mainColor : Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.01),
            Text(
              _navItems[index].label,
              style: TextStyle(
                fontSize: screenWidth * 0.03,
                color: isSelected ? mainColor : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            SizedBox(height: screenWidth * 0.025),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Exit App',
        message: 'Are you sure you want to exit the app?',
        confirmText: 'OK',
        cancelText: 'Cancel',
        onConfirmed: () {
          Navigator.of(context).pop(true);
        },
      ),
    );

    if (result == true) {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation, secondaryAnimation) => FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(screenWidth * 0.04)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: List.generate(
              _navItems.length,
              (index) => _buildNavItem(index),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String iconPath;
  _NavItem({required this.label, required this.iconPath});
}
