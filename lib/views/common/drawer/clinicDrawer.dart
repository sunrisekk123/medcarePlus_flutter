import 'package:flutter/material.dart';

class ClinicDrawer extends StatelessWidget {
  const ClinicDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          const SizedBox(
              height: 90.0,
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
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Appointment'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
