import 'package:flutter/material.dart';







const seedColor = Color(0xFFbee4cf);
//
// const textColor = Color(0xFFe7f4ed);
// const backgroundColor = Color(0xFF010403);
// const primaryColor = Color(0xFFbee4cf);
// const primaryFgColor = Color(0xFF010403);
// const secondaryColor = Color(0xFF3e5649);
// const secondaryFgColor = Color(0xFFe7f4ed);
// const accentColor = Color(0xFF145732);
// const accentFgColor = Color(0xFFe7f4ed);
//   
// const lightTextColor = Color(0xFF0b1811);
// const lightBackgroundColor = Color(0xFFfbfefd);
// const lightPrimaryColor = Color(0xFF1b412c);
// const lightPrimaryFgColor = Color(0xFFfbfefd);
// const lightSecondaryColor = Color(0xFFa9c1b4);
// const lightSecondaryFgColor = Color(0xFF0b1811);
// const lightAccentColor = Color(0xFFa8ebc6);
// const lightAccentFgColor = Color(0xFF0b1811);

final darkColorScheme = ColorScheme.fromSeed(
  seedColor: seedColor,
  brightness: Brightness.dark
).copyWith(
  surfaceTint: Colors.transparent
);
// const darkColorScheme = ColorScheme(
//   brightness: Brightness.dark,
//   primary: primaryColor,
//   onPrimary: primaryFgColor,
//   secondary: secondaryColor,
//   onSecondary: secondaryFgColor,
//   tertiary: accentColor,
//   onTertiary: accentFgColor,
//   surface: backgroundColor,
//   onSurface: textColor,
//   error: Brightness.dark == Brightness.light ? Color(0xffB3261E) : Color(0xffF2B8B5),
//   onError: Brightness.dark == Brightness.light ? Color(0xffFFFFFF) : Color(0xff601410),
// );
final lightColorScheme = ColorScheme.fromSeed(
  seedColor: seedColor,
  brightness: Brightness.light
).copyWith(
  surfaceTint: Colors.transparent
);
// const lightColorScheme = ColorScheme(
//   brightness: Brightness.light,
//   primary: lightPrimaryColor,
//   onPrimary: lightPrimaryFgColor,
//   secondary: lightSecondaryColor,
//   onSecondary: lightSecondaryFgColor,
//   tertiary: lightAccentColor,
//   onTertiary: lightAccentFgColor,
//   surface: lightBackgroundColor,
//   onSurface: lightTextColor,
//   error: Brightness.light == Brightness.light ? Color(0xffB3261E) : Color(0xffF2B8B5),
//   onError: Brightness.light == Brightness.light ? Color(0xffFFFFFF) : Color(0xff601410),
// );

// Gradient 
/*
--linearPrimarySecondary: linear-gradient(#bee4cf, #3e5649);
--linearPrimaryAccent: linear-gradient(#bee4cf, #145732);
--linearSecondaryAccent: linear-gradient(#3e5649, #145732);
--radialPrimarySecondary: radial-gradient(#bee4cf, #3e5649);
--radialPrimaryAccent: radial-gradient(#bee4cf, #145732);
--radialSecondaryAccent: radial-gradient(#3e5649, #145732);
*/

// Shades

/*
:root[data-theme="light"] {
  --text-50: hsl(147, 36%, 95%);
  --text-100: hsl(148, 37%, 90%);
  --text-200: hsl(148, 37%, 80%);
  --text-300: hsl(148, 37%, 70%);
  --text-400: hsl(148, 37%, 60%);
  --text-500: hsl(148, 37%, 50%);
  --text-600: hsl(148, 37%, 40%);
  --text-700: hsl(148, 37%, 30%);
  --text-800: hsl(148, 37%, 20%);
  --text-900: hsl(148, 37%, 10%);
  --text-950: hsl(147, 36%, 5%);

  --background-50: hsl(160, 60%, 95%);
  --background-100: hsl(161, 61%, 90%);
  --background-200: hsl(160, 61%, 80%);
  --background-300: hsl(160, 59%, 70%);
  --background-400: hsl(160, 60%, 60%);
  --background-500: hsl(160, 60%, 50%);
  --background-600: hsl(160, 60%, 40%);
  --background-700: hsl(160, 59%, 30%);
  --background-800: hsl(160, 61%, 20%);
  --background-900: hsl(161, 61%, 10%);
  --background-950: hsl(160, 60%, 5%);

  --primary-50: hsl(150, 38%, 95%);
  --primary-100: hsl(146, 41%, 90%);
  --primary-200: hsl(147, 41%, 80%);
  --primary-300: hsl(147, 41%, 70%);
  --primary-400: hsl(147, 41%, 60%);
  --primary-500: hsl(147, 41%, 50%);
  --primary-600: hsl(147, 41%, 40%);
  --primary-700: hsl(147, 41%, 30%);
  --primary-800: hsl(147, 41%, 20%);
  --primary-900: hsl(146, 41%, 10%);
  --primary-950: hsl(144, 38%, 5%);

  --secondary-50: hsl(150, 15%, 95%);
  --secondary-100: hsl(147, 18%, 90%);
  --secondary-200: hsl(146, 16%, 80%);
  --secondary-300: hsl(149, 16%, 70%);
  --secondary-400: hsl(148, 16%, 60%);
  --secondary-500: hsl(148, 16%, 50%);
  --secondary-600: hsl(148, 16%, 40%);
  --secondary-700: hsl(149, 16%, 30%);
  --secondary-800: hsl(146, 16%, 20%);
  --secondary-900: hsl(147, 18%, 10%);
  --secondary-950: hsl(150, 15%, 5%);

  --accent-50: hsl(146, 62%, 95%);
  --accent-100: hsl(147, 65%, 90%);
  --accent-200: hsl(147, 63%, 80%);
  --accent-300: hsl(147, 63%, 70%);
  --accent-400: hsl(147, 63%, 60%);
  --accent-500: hsl(147, 63%, 50%);
  --accent-600: hsl(147, 63%, 40%);
  --accent-700: hsl(147, 63%, 30%);
  --accent-800: hsl(147, 63%, 20%);
  --accent-900: hsl(147, 65%, 10%);
  --accent-950: hsl(146, 62%, 5%);

}
:root[data-theme="dark"] {
  --text-50: hsl(147, 36%, 5%);
  --text-100: hsl(148, 37%, 10%);
  --text-200: hsl(148, 37%, 20%);
  --text-300: hsl(148, 37%, 30%);
  --text-400: hsl(148, 37%, 40%);
  --text-500: hsl(148, 37%, 50%);
  --text-600: hsl(148, 37%, 60%);
  --text-700: hsl(148, 37%, 70%);
  --text-800: hsl(148, 37%, 80%);
  --text-900: hsl(148, 37%, 90%);
  --text-950: hsl(147, 36%, 95%);

  --background-50: hsl(160, 60%, 5%);
  --background-100: hsl(161, 61%, 10%);
  --background-200: hsl(160, 61%, 20%);
  --background-300: hsl(160, 59%, 30%);
  --background-400: hsl(160, 60%, 40%);
  --background-500: hsl(160, 60%, 50%);
  --background-600: hsl(160, 60%, 60%);
  --background-700: hsl(160, 59%, 70%);
  --background-800: hsl(160, 61%, 80%);
  --background-900: hsl(161, 61%, 90%);
  --background-950: hsl(160, 60%, 95%);

  --primary-50: hsl(144, 38%, 5%);
  --primary-100: hsl(146, 41%, 10%);
  --primary-200: hsl(147, 41%, 20%);
  --primary-300: hsl(147, 41%, 30%);
  --primary-400: hsl(147, 41%, 40%);
  --primary-500: hsl(147, 41%, 50%);
  --primary-600: hsl(147, 41%, 60%);
  --primary-700: hsl(147, 41%, 70%);
  --primary-800: hsl(147, 41%, 80%);
  --primary-900: hsl(146, 41%, 90%);
  --primary-950: hsl(150, 38%, 95%);

  --secondary-50: hsl(150, 15%, 5%);
  --secondary-100: hsl(147, 18%, 10%);
  --secondary-200: hsl(146, 16%, 20%);
  --secondary-300: hsl(146, 16%, 30%);
  --secondary-400: hsl(146, 16%, 40%);
  --secondary-500: hsl(146, 16%, 50%);
  --secondary-600: hsl(146, 16%, 60%);
  --secondary-700: hsl(146, 16%, 70%);
  --secondary-800: hsl(146, 16%, 80%);
  --secondary-900: hsl(147, 18%, 90%);
  --secondary-950: hsl(150, 15%, 95%);

  --accent-50: hsl(146, 62%, 5%);
  --accent-100: hsl(147, 65%, 10%);
  --accent-200: hsl(147, 63%, 20%);
  --accent-300: hsl(147, 63%, 30%);
  --accent-400: hsl(147, 63%, 40%);
  --accent-500: hsl(147, 63%, 50%);
  --accent-600: hsl(147, 63%, 60%);
  --accent-700: hsl(147, 63%, 70%);
  --accent-800: hsl(147, 63%, 80%);
  --accent-900: hsl(147, 65%, 90%);
  --accent-950: hsl(146, 62%, 95%);

}
*/





