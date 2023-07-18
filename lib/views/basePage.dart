import 'package:flutter/material.dart';
import 'package:fyp/views/common/drawer/clinicDrawer.dart';
import 'package:fyp/views/common/drawer/userDrawer.dart';
import 'package:fyp/views/homepage.dart';
import 'package:fyp/views/common/bottomNavBar/bottomNavBar.dart';
import 'package:fyp/views/common/drawer/patientDrawer.dart';
import 'package:fyp/views/homepageClinic.dart';
import 'package:fyp/views/services/homepageService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/bottomNavBar/bottomNavBarClinic.dart';

class BasePage extends StatefulWidget {
  static const String routeName = '/base';
  const BasePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final HomepageService homeService = HomepageService();
  bool isExistPref = false;
  String accountType = "";

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      getSharePref();
    });
  }

  getSharePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("x-auth-token");
    String? typeAc = prefs.getString("x-account");
    if(token != null && token.isNotEmpty && typeAc != null && typeAc.isNotEmpty){
      setState(() {
        isExistPref = true;
        accountType = typeAc;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: isExistPref && accountType == "C" ? HomepageClinic(isLogin: isExistPref, accountType: accountType) : Homepage(isLogin: isExistPref, accountType: accountType) ,
      drawer: (!isExistPref ? UserDrawer() : (accountType == 'MB' ? PatientDrawer() : ClinicDrawer())),
      floatingActionButton: (isExistPref && accountType == 'MB')? CustomFloatingActionButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: isExistPref && accountType == "C" ? BottomNavBarClinic() : BottomNavBar()
    );
  }
}
