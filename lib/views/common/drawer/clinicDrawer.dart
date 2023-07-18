import 'package:flutter/material.dart';
import 'package:fyp/views/basePage.dart';
import 'package:fyp/views/homepage.dart';

import '../../clinic/clinicInfoPage.dart';
import '../../clinic/viewClinicAppointment.dart';
import '../../clinic/viewClinicAppointmentAll.dart';

class ClinicDrawer extends StatelessWidget {
  ClinicDrawer({Key? key}) : super(key: key);
  final HomepageDetailsState home = HomepageDetailsState();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
              height: 110.0,
              child: const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFFe68453),
                  ),
                  child: Text(
                      'Welcome clinic',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )
                  )
              )
          ),
          ListTile(
            leading: Icon(Icons.home_filled),
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, BasePage.routeName, (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, ClinicInfoArea.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Upcoming Appointment'),
            onTap: () {
              Navigator.pushNamed(context, MyAppointmentClinicArea.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('All Past Appointment'),
            onTap: () {
              Navigator.pushNamed(context, MyAppointmentAllClinicArea.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              home.logoutConfirmPopupWindow(context);
            },
          ),
        ],
      ),
    );
  }
}
