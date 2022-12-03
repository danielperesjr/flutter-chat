import 'package:flutter/material.dart';
import 'package:flutter_chat/configurations.dart';
import 'package:flutter_chat/home.dart';
import 'package:flutter_chat/login.dart';
import 'package:flutter_chat/register.dart';

class RouteGenerator {

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => Login(),
        );
      case "/login":
        return MaterialPageRoute(
          builder: (_) => Login(),
        );
      case "/register":
        return MaterialPageRoute(
          builder: (_) => Register(),
        );
      case "/home":
        return MaterialPageRoute(
          builder: (_) => Home(),
        );
      case "/configurations":
        return MaterialPageRoute(
          builder: (_) => Configurations(),
        );
      default:
        _routeError();
    }
  }

  static Route<dynamic> _routeError() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Tela não encontrada!"),
          ),
          body: Center(
            child: Text("Tela não encontrada!"),
          ),
        );
      },
    );
  }
}
