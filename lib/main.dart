import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:damri/pages/splash.dart';
import 'package:damri/firebase_options.dart';

import 'Route.dart';

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
    home: SplashScreenPage(),
    theme: defaultTheme,
    initialRoute: "/",
    onGenerateRoute: Routes.generateRoutes,
    debugShowCheckedModeBanner: false,
  ));
}
