import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const TextStyle h1 = TextStyle(
      color: AppColors.white, fontSize: 20, fontFamily: "NeutralFace");

  static const TextStyle hintStyle = TextStyle(
      color: AppColors.grey200, fontSize: 14, fontFamily: "SF Pro Display");

  static const TextStyle titleStyle = TextStyle(
      color: AppColors.white,
      fontSize: 18,
      fontFamily: "SF Pro Display",
      fontWeight: FontWeight.w500);

  static const TextStyle subtitleStyle = TextStyle(
      color: AppColors.lightGrey, fontSize: 12, fontFamily: "SF Pro Display");

  static const TextStyle inputStyle = TextStyle(
      color: AppColors.lightGrey, fontSize: 14, fontFamily: "SF Pro Display");
}
