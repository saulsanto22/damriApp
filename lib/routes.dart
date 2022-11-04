
import 'package:damri/Profile/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:damri/Pages/sign_up.dart';
import 'package:damri/Pages/track.dart';
import 'package:damri/Pages/Login.dart';
import 'package:damri/Pages/panel_supir.dart';
import 'package:damri/Pages/panel_penumpang.dart';

class Routes {
  static Route<dynamic>? generateRoutes(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case "/SignUp":
        return MaterialPageRoute(builder: (_) => const SignUp());
      case "/panel-pengemudi":
        return MaterialPageRoute(builder: (_) => const PanelSupir());
      case "/panel-penumpang":
        return MaterialPageRoute(builder: (_) => const PenumpangPage());
      case "/corrida":
        return MaterialPageRoute(builder: (_) => Monitoring(args as String));
      case "/userProfile":
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case "/information":
      // return MaterialPageRoute(builder: (_) => const TryAPI());
      default:
        _errorRoute();
    }
    return null;
  }

  static Route<dynamic>? _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("screen not found!"),
        ),
        body: const Center(
          child: Text("screen not found!"),
        ),
      );
    });
  }
}
