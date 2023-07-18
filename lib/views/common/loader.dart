import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Center(
          child: CircularProgressIndicator(),
        )
    );
  }
}