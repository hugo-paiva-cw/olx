import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:olx/route_generator.dart';
import 'package:olx/views/advertisement.dart';

// final ThemeData defaultThemeIOS = ThemeData(
//     colorScheme: const ColorScheme.light().copyWith(
//         primary: Colors.grey[200], secondary: const Color(0xff25D366)));

final ThemeData defaultThemeAndroid = ThemeData(
    colorScheme: const ColorScheme.light().copyWith(
        primary: const Color(0xff9c27b0),
        secondary: const Color(0xff7b1fa2)));


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: const Advertisement(),
    theme: defaultThemeAndroid,
    initialRoute: '/',
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
