import 'package:flutter/material.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/views/basePage.dart';

class BottomNavBarClinic extends StatelessWidget {


  const BottomNavBarClinic({
    Key? key,
    this.fabLocation = FloatingActionButtonLocation.centerDocked,
    this.shape = const CircularNotchedRectangle(),
  }) : super(key: key);

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Styles.primaryColor,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            IconButton(
              tooltip: 'Home',
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, BasePage.routeName, (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}