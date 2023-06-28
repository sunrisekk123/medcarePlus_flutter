import 'package:flutter/material.dart';
import 'package:fyp/style/app_style.dart';

class BottomNavBar extends StatelessWidget {


  const BottomNavBar({
    Key? key,
    this.fabLocation = FloatingActionButtonLocation.centerDocked,
    this.shape = const CircularNotchedRectangle(),
  }) : super(key: key);

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;

  static final List<Widget> _widgetOptions = <Widget>[
    const Text("Home"),
    const Text("Search"),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Styles.primaryColor,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            const Spacer(flex: 1),
            IconButton(
              tooltip: 'Home',
              icon: const Icon(Icons.home),
              onPressed: () {},
            ),
            const Spacer(flex: 3),
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      tooltip: 'Medical Record',
      child: const Icon(Icons.medical_information_rounded),
    );
  }
}
