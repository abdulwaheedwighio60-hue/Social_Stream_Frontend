import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {

  final String text;

  final double? fontSize;

  final FontWeight? fontWeight;

  final Color? color;

  final TextAlign? textAlign;

  final int? maxLines;

  final TextOverflow? overflow;

  final double? height;

  const CustomTextWidget({

    super.key,

    required this.text,

    this.fontSize,

    this.fontWeight,

    this.color,

    this.textAlign,

    this.maxLines,

    this.overflow,

    this.height,
  });

  @override
  Widget build(BuildContext context) {

    return Text(

      text,

      textAlign: textAlign,

      maxLines: maxLines,

      overflow: overflow,

      style: TextStyle(

        fontSize: fontSize ?? 14,

        fontWeight:
        fontWeight ?? FontWeight.w400,

        color: color ?? Colors.black,

        height: height,
      ),
    );
  }
}