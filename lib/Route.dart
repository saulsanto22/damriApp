// ignore: file_names
import 'package:damri/Profile/profilePage.dart';
import 'package:damri/presentation/screens/main.dart';
import 'package:damri/presentation/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:damri/pages/AuthSignUp.dart';
import 'package:damri/pages/Track.dart';
import 'package:damri/pages/AuthLogin.dart';
import 'package:damri/pages/PanelPengemudi.dart';
import 'package:damri/pages/PanelPenumpang.dart';

class Routes {
  static Route<dynamic>? generateRoutes(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const Login());
      case "/SignUp":
        return MaterialPageRoute(builder: (_) => const Cadastro());
      case "/panel-pengemudi":
        return MaterialPageRoute(builder: (_) => const PanelPengemudi());
      case "/panel-penumpang":
        return MaterialPageRoute(builder: (_) => const PanelPenumpang());
      case "/lacak":
        return MaterialPageRoute(builder: (_) => Track(args as String));
      case "/userProfile":
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case "/informasi":
        return MaterialPageRoute(builder: (_) => Information());
      default:
        _errorRoute();
    }
    return null;
  }

  static Route<dynamic>? _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("screen not found!"),
        ),
        body: Center(
          child: Text("screen not found!"),
        ),
      );
    });
  }
}
