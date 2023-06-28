import 'package:flutter/material.dart';
import 'package:fyp/views/basePage.dart';
import 'package:fyp/views/common/bottomNavBar/bottomNavBar.dart';
import 'package:fyp/views/homepage.dart';
import 'package:fyp/views/login.dart';
import 'package:fyp/views/register.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    // case AuthScreen.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => const AuthScreen(),
    //   );


    case LoginPageDetails.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginPageDetails(),
      );

    case RegisterPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const RegisterPage(),
      );

    case BasePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BasePage(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
