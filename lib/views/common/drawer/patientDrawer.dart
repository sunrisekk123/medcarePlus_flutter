import 'package:flutter/material.dart';

class PatientDrawer extends StatelessWidget {
  const PatientDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
              height: 90.0,
              child: const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFFe68453),
                  ),
                  child: Text(
                      'Welcome member',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )
                  )
              )
          ),
          const ListTile(
            leading: Icon(Icons.home_filled),
            title: Text('Home'),
          ),
          const ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          const ListTile(
            leading: Icon(Icons.event),
            title: Text('My Appointment'),
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //     '/login', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
