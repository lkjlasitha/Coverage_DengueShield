import 'package:flutter/material.dart';

class SharedButton extends StatefulWidget {
  final double screenWidth;
  final Widget content;
  const SharedButton({super.key, required this.screenWidth, required this.content});

  @override
  State<SharedButton> createState() => _SharedButtonState();
}

class _SharedButtonState extends State<SharedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.screenWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff4338CA),
            Color(0xff211C64)
          ],
          begin: Alignment(0 , 1),
          end: Alignment(2,10)
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3.3,
            color: Colors.black.withOpacity(0.25)
          )
        ]
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: widget.content,
      ),
    );
  }
}