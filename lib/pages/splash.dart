import 'package:damri/pages/AuthLogin.dart';
import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
        logo: Image.network(
            'https://cdn1.iconfinder.com/data/icons/smart-eco-city-1/512/city_0024-128.png'),
        title: Text(
          "Damri Tracking",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        showLoader: true,
        loadingText: const Text(
          "Loading...",
          style: TextStyle(color: Colors.white),
        ),
        loaderColor: Colors.white,
        navigator: Login(),
        durationInSeconds: 5);
  }
}
