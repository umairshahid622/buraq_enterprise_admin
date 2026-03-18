import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextHeading extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  const AppTextHeading({
    super.key,
    required this.text,
    this.fontSize = 24.0,
    this.fontWeight = FontWeight.bold,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final colors = context.appColors;
      return Text(
        text,
        style: GoogleFonts.quicksand(
          fontSize: fontSize,
          height: 1,
          fontWeight: fontWeight,
          color: color ?? colors.text,
        ),
      );
    });
  }
}

class AppTextBody extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  const AppTextBody({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w400,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final colors = context.appColors;
      return Text(
        text,
        textAlign: textAlign,
        style: GoogleFonts.inter(        
          fontSize: fontSize,
          height: 1.5,
          fontWeight: fontWeight,
          color: color ?? colors.secondary,
        ),
      );
    });
  }
}


class AppRichText extends StatelessWidget {
  final String text1;
  final String text2;
  final Color? text1Color;
  final Color? text2Color;
  const AppRichText({
    super.key,
    required this.text1,
    required this.text2,
    this.text1Color,
    this.text2Color,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final colors = context.appColors;
      return RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: text1,
              style: GoogleFonts.quicksand(color: text1Color ?? colors.text),
            ),
            TextSpan(
              text: text2,
              style: GoogleFonts.inter(color: text2Color ?? colors.text),
            ),
          ],
        ),
      );
    });
  }
}
