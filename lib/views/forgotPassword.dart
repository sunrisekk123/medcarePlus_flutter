import 'package:flutter/material.dart';
import 'package:fyp/style/app_style.dart';
import 'package:gap/gap.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedCare Plus',
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      home: const ForgotPasswordPageDetails(title: 'MedCare Plus'),
    );
  }
}

class ForgotPasswordPageDetails extends StatefulWidget {
  const ForgotPasswordPageDetails({Key? key, required this.title})
      : super(key: key);
  final String title;

  @override
  State<ForgotPasswordPageDetails> createState() =>
      _ForgotPasswordPageDetailsState();
}

class _ForgotPasswordPageDetailsState extends State<ForgotPasswordPageDetails> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Forgot password", style: Styles.appBarStyle1),
          leading: IconButton(
            icon: IconStyles.blackCross,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Form(
            key: _formKey,
            onChanged: () {
              Form.of(primaryFocus!.context!)!.save();
            },
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Please enter the email address to reset the password",
                style: Styles.textStyle,
              ),
              TextFormField(
                autofocus: false,
                decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 7),
                    labelText: 'Email *'),
                validator: (v) {
                  return v!.trim().isNotEmpty ? null : "Email cannot be empty";
                },
              ),
              const Gap(10),
              Row(children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                          //TODO: change route
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                )
              ]),
            ]),
          ),
        ));
  }
}
