import 'package:flutter/material.dart';
import '../../config/theme.dart';

class GifContainer extends StatefulWidget {
  final String gifPath;
  final String content;
  const GifContainer({super.key, required this.gifPath, required this.content});

  @override
  State<GifContainer> createState() => _GifContainerState();
}

class _GifContainerState extends State<GifContainer> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.275,
      height: screenWidth * 0.275,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            color: Colors.black.withOpacity(0.25),
            blurRadius: 9.8
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            widget.gifPath,
            width: screenWidth*0.15,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: screenWidth*0.02,
          ),
          Text(
            widget.content,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w700,
              color: mainColor
            ),
          ),
        ],
      ),
    );
  }
}