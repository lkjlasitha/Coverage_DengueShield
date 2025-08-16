import 'package:dengue_shield/config/theme.dart';
import 'package:dengue_shield/screens/onboard/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool isFromSettings; // To determine if called from settings or splash
  
  const LanguageSelectionScreen({
    Key? key,
    this.isFromSettings = false,
  }) : super(key: key);

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = 'English';
  
  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'සිංහල', 'code': 'si'},
    {'name': 'தமிழ்', 'code': 'ta'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('selected_language') ?? 'English';
    setState(() {
      selectedLanguage = savedLanguage;
    });
  }

  Future<void> _saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language);
  }

  Future<void> _onLanguageSelected(String language) async {
    setState(() {
      selectedLanguage = language;
    });
    await _saveLanguage(language);
    if (widget.isFromSettings) {
      Navigator.of(context).pop();
    } else {
      print('lanh');
      Navigator.push(context, MaterialPageRoute(builder: (_) => OnboardingScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight*0.1,
              ),
              Text(
                'Select Language',
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Select your language to Continue',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff7D848D),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Column(
                children: languages.map((language) {
                  final isSelected = selectedLanguage == language['name'];
                  return Container(
                    margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: GestureDetector(
                      onTap: () => _onLanguageSelected(language['name']!),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.02,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffF7F7FC),
                          borderRadius: BorderRadius.circular(45),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.check_circle : Icons.circle_outlined,
                              color: isSelected ? mainColor : Colors.black,
                              size: screenWidth * 0.06,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              language['name']!,
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w500,
                                color:  Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}