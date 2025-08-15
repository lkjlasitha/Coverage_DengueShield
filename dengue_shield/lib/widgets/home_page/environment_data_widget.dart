import 'package:flutter/material.dart';

class EnvironmentDataWidget extends StatefulWidget {
  final String title;
  final String img_path;
  final String value;
  const EnvironmentDataWidget({super.key, required this.title, required this.img_path, required this.value});

  @override
  State<EnvironmentDataWidget> createState() => _EnvironmentDataWidgetState();
}

class _EnvironmentDataWidgetState extends State<EnvironmentDataWidget> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 0.5,
            color: Colors.black.withOpacity(0.13),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              color: Colors.black.withOpacity(0.25),
              blurRadius: 3.3
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xff4338CA).withOpacity(0.22),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Image.asset(
                      widget.img_path
                    )
                  ),
                  SizedBox(
                    width: screenWidth*0.05,
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: screenWidth*0.04,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff6B7280),
                      height: 1
                    ),
                  ),
                ],
              ),
              Text(
                widget.value,
                style: TextStyle(
                  fontSize: screenWidth*0.04,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 1
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}