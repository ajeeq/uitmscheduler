import 'package:flutter/widgets.dart';

// color pallettes generated from https://smart-swatch.netlify.app/#2A346A
// color-700 is the mid color
const basePallette = {
  50: Color(0xFFeceeff),
  100: Color(0xFFc7cdec),
  200: Color(0xFFa4acdb),
  300: Color(0xFF808bcb),
  400: Color(0xFF5c6abc),
  500: Color(0xFF4351a2),
  600: Color(0xFF343f7f),
  700: Color(0xFF242d5b),
  800: Color(0xFF151b39),
  900: Color(0xFF050918),
};


const hueUpPallette =  {
  50: Color(0xFFeeecff),
  100: Color(0xFFc9c7ec),
  200: Color(0xFFa5a4db),
  300: Color(0xFF8081cb),
  400: Color(0xFF5c61bc),
  500: Color(0xFF434ba2),
  600: Color(0xFF343d7f),
  700: Color(0xFF242d5b),
  800: Color(0xFF151839),
  900: Color(0xFF050618),
};


const hueDownPallette = {
  50: Color(0xFFecf2ff),
  100: Color(0xFFc7d4ec),
  200: Color(0xFFa4b5db),
  300: Color(0xFF8095cb),
  400: Color(0xFF5c74bc),
  500: Color(0xFF4358a2),
  600: Color(0xFF34427f),
  700: Color(0xFF242d5b),
  800: Color(0xFF151d39),
  900: Color(0xFF050b18),
};

class AppColor {
  AppColor._();

  // light theme
  static const Color lightBackground = Color(0xFFeceeff);
  static const Color lightPrimary = Color(0xFF242d5b);

  // dark theme
  static const Color darkBackgroundPrimary = Color(0xFFeceeff);

  // static const Gradient linearGradient = LinearGradient(
  //   begin: Alignment(0.0, 0.0),
  //   end: Alignment(0.707, -0.707),
  //   colors: [
  //     Color(0xffff9a9e),
  //     Color(0xfffad0c4),
  //     Color(0xfffad0c4),
  //    ],
  //  );
}