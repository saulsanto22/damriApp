// import 'dart:html';

// import 'package:damri/model/API/Information.dart';
import 'package:flutter/material.dart';

import 'package:damri/Pages/splash.dart';
import 'package:damri/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'routes.dart';

final ThemeData defaultTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xff37474f),
    secondary: const Color(0xff546e7a),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    title: "Damri Tracking",
    home: const SplashScreenPage(),
    theme: defaultTheme,
    initialRoute: "/",
    onGenerateRoute: Routes.generateRoutes,
    debugShowCheckedModeBanner: false,
  ));
}
