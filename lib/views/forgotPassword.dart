import 'package:flutter/material.dart';
import 'package:fyp/style/app_style.dart';
import 'package:gap/gap.dart';

class ForgotPasswordPageDetails extends StatefulWidget {
  static const String routeName = '/forget_password';
  const ForgotPasswordPageDetails({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPageDetails> createState() => _ForgotPasswordPageDetailsState();
}

class _ForgotPasswordPageDetailsState extends State<ForgotPasswordPageDetails> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
