import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/home.dart';
import 'package:flutter_chat/login.dart';
import 'package:flutter_chat/route_generator.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final ThemeData defaultTheme = ThemeData(
    primaryColor: const Color(0xff03a9f4),
    primarySwatch: Colors.lightBlue,
  );
  final ThemeData iosTheme = ThemeData(
    primaryColor: Colors.grey[200],
    primarySwatch: Colors.grey,
  );

  runApp(
    MaterialApp(
      home: Login(),
      theme: Platform.isIOS ? iosTheme : defaultTheme,
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    ),
  );
}
