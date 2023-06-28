import 'package:flutter/material.dart';
import 'package:fyp/style/app_style.dart';

class PersonalProfilePage extends StatelessWidget {
  const PersonalProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedCare Plus',
      home: const PersonalProfilePageDetails(title: 'MedCare Plus'),
    );
  }
}

class PersonalProfilePageDetails extends StatefulWidget {
  const PersonalProfilePageDetails({Key? key, required this.title})
      : super(key: key);
  final String title;

  @override
  State<PersonalProfilePageDetails> createState() =>
      _PersonalProfilePageDetailsState();
}

class _PersonalProfilePageDetailsState
    extends State<PersonalProfilePageDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0x00000000),
        title: const Text(
          "Register an account",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Color(0xFF303030)),
        ),
        leading: IconButton(
          icon: IconStyles.blackCross,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
