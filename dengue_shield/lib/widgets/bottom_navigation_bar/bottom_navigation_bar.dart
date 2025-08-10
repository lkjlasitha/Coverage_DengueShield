import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../alret_dialog/alert_dialog.dart';
import '../appbar/appbar.dart';

//final GlobalKey<_CustomBottomNavState> bottomNavKey = GlobalKey();

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({Key? key}) : super(key: key);

  @override
  CustomBottomNavState createState() => CustomBottomNavState();
}

class CustomBottomNavState extends State<CustomBottomNav> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  bool _isLoading = false;


  final List<_NavItem> _navItems = [
    _NavItem(label: 'Home', iconPath: 'assets/bottom_nav_bar/home-2.svg'),
    _NavItem(label: 'My Deals', iconPath: 'assets/bottom_nav_bar/shop.svg'),
    _NavItem(label: 'Search', iconPath: 'assets/bottom_nav_bar/search-normal.svg'),
    _NavItem(label: 'Profile', iconPath: 'assets/bottom_nav_bar/frame.svg'),
  ];

  void navigateTo(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = index == _selectedIndex;
    final screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: GestureDetector(
        onTap: () => {
          _onItemTapped(index)
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          //padding: const EdgeInsets.symmetric(vertical: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected)
                Container(
                  //width: 100,
                  height: screenWidth*0.015,
                  decoration: BoxDecoration(
                    color: Color(0xff3AC2FF),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(screenWidth * 0.1),
                      bottomRight: Radius.circular(screenWidth * 0.1),
                    ),
                  ),
                ),
               SizedBox(height: screenWidth*0.03),
              AnimatedScale(
                scale: isSelected ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: SvgPicture.asset(
                  _navItems[index].iconPath,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    isSelected ? Color(0xff3AC2FF) : Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(height: screenWidth*0.015),
              Text(
                _navItems[index].label,
                style: TextStyle(
                  color: isSelected ? Color(0xff3AC2FF) : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              SizedBox(height: screenWidth*0.02),
            ],
          ),
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
          Navigator.of(context).pop(true);  // return true from dialog
        },
      ),
    );

    if (result == true) {
      if (Platform.isAndroid) {
        SystemNavigator.pop(); // Minimize/close app on Android
      } else if (Platform.isIOS) {
        exit(0); // Force exit app on iOS (use with caution)
      }
      return true; // WillPopScope can also return true to allow
    }

    return false; // Don't exit
  }
  
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: Column(
          children: [
            Appbar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // StudentHomePage(),
                  // isShopPage ? ShopPage(discount: _shopPageDiscount!,) : SavedDiscountsScreen(),
                  // AvailableDiscountsScreen(key: AppKeys.availableDiscountKey,),
                  // _currentUser != null
                  //   ? ProfileEditScreen(user: _currentUser!)
                  //   : Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:  BorderRadius.vertical(top: Radius.circular(screenWidth*0.04)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          //padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: List.generate(_navItems.length, (index) => _buildNavItem(index)),
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
