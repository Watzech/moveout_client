// ignore_for_file: prefer_const_constructors
import 'package:moveout1/services/notification_settings.dart';
import 'package:flutter/material.dart';
import 'package:moveout1/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    prepareDeviceForNotification(context);
    return MaterialApp(
      title: 'MoveOut',
      //Day Theme Prototype:
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          primary: Color(0xFF6fa8dc),
          //onPrimary: Color(0xFF7ca4b7),
          onPrimary: Color.fromARGB(255, 96, 130, 145),
          secondary: Color(0xFFf1c232),
          //onSecondary: Color(0xFFe4b82f),
          onSecondary: Color.fromARGB(255, 186, 149, 39),
          background: Color(0xFFffffff),
          onBackground: Color.fromARGB(255, 168, 168, 168),
          surface: Color(0xFFfbfbfb),
          onSurface: Color(0xFF000000),
          brightness: Brightness.light,
          error: Color(0xFFBA0027),
          onError: Color(0xFF000000),
          shadow: Color(0x11000000),
        ),
        fontFamily: 'Open Sans',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() { 
    super.initState();
    getNotification();
  }
  
  @override
  Widget build(BuildContext context) {
    return AuthScreen();
  }
}
