import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle poppins({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: 'Roboto', // Используем системный шрифт
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle poppinsBold({
    double? fontSize,
    Color? color,
    double? height,
  }) {
    return poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
      height: height,
    );
  }

  static TextStyle poppinsSemiBold({
    double? fontSize,
    Color? color,
    double? height,
  }) {
    return poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
      height: height,
    );
  }

  static TextStyle poppinsMedium({
    double? fontSize,
    Color? color,
    double? height,
  }) {
    return poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
      height: height,
    );
  }
} 