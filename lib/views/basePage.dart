import 'package:flutter/material.dart';
import 'package:fyp/views/common/drawer/userDrawer.dart';
import 'package:fyp/views/homepage.dart';
import 'package:fyp/views/common/bottomNavBar/bottomNavBar.dart';
import 'package:fyp/views/common/drawer/patientDrawer.dart';
import 'package:fyp/providers/userProvider.dart';
import 'package:fyp/views/services/homepageService.dart';
import 'package:fyp/views/services/loginService.dart';
import 'package:provider/provider.dart';

class BasePage extends StatefulWidget {
  static const String routeName = '/base';

  const BasePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final HomepageService homeService = HomepageService();
  final LoginService loginService = LoginService();

  int pageNo = 0;

  @override
  void initState(){
    //TODO: check if login or not, if login: change drawer and show e-health record
    homeService.getHomepageData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Homepage(isLogin: Provider.of<UserProvider>(context).user.token.isNotEmpty),
      // pagesChoice[pageNo],
      // TODO: if login as clinic, change clinic drawer
      drawer: !Provider.of<UserProvider>(context).user.token.isNotEmpty ? UserDrawer() : PatientDrawer(),
      floatingActionButton: (Provider.of<UserProvider>(context).user.token.isNotEmpty)? CustomFloatingActionButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
