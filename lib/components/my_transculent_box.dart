import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTransculentBox extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final Function()? onTap;
  final TextStyle? textStyle;
  final double? iconSize;
  final double? width;
  final double? height;
  final Color? iconColor;
  final Color? textColor;
  final BoxDecoration? decoration;

  const MyTransculentBox({
    super.key,
    this.icon,
    this.text,
    this.onTap,
    this.textStyle,
    this.iconSize,
    this.iconColor,
    this.textColor,
    this.decoration,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: width ?? 100,
          height: height ?? 100,
          decoration: decoration ??
              BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Icon(
                  icon ?? Icons.home,
                  color: iconColor ?? Colors.white,
                  size: iconSize ?? 40,
                ),
              ),
              const SizedBox(height: 5),
              // Text below the box
              Text(
                text ?? 'Home',
                style: textStyle ??
                    TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor ?? Colors.black87,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          )),
    );
  }
}
