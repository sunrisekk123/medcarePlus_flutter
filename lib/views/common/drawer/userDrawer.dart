import 'package:flutter/material.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({Key? key}) : super(key: key);

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
                'Welcome guest',
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
            leading: Icon(Icons.login),
            title: Text('Login'),
          ),
        ],
      ),
    );
  }
}
