import 'package:flutter/material.dart';
import 'package:fyp/providers/userProvider.dart';
import 'package:fyp/router.dart';
import 'package:fyp/views/basePage.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/views/homepage.dart';
import 'package:fyp/views/member/viewMyAppointment.dart';
import 'package:fyp/views/member/viewPersonalProfile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());

  GoogleFonts.config.allowRuntimeFetching = false;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedCare Plus',
      theme: ThemeData(
        primarySwatch: colorCustom
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: BasePage()
      // const BasePage(),

    );
  }
}