import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final String number;
  final String title;
  final Color numberColor;
  final Color titleColor;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;
  final double? width;
  final double? height;

  const StatsCard({
    Key? key,
    required this.number,
    required this.title,
    this.numberColor = const Color(0xFFD2593C), 
    this.titleColor = const Color(0xFF8E8E93), 
    this.backgroundColor = Colors.white,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.all(5.0),
    this.width = 110,
    this.height = 70,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      width: 100,
      height: 70,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              number,
              style: TextStyle(
                fontSize: (width != null && width! < 100) ? 16 : 20,
                fontWeight: FontWeight.w700,
                color: numberColor,
                height: 1.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: (height != null && height! < 80) ? 2 : 4),
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (width != null && width! < 100) ? 8 : 10,
                fontWeight: FontWeight.w500,
                color: titleColor,
                height: 1.1,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
