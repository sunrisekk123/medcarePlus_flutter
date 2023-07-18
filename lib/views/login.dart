import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/views/basePage.dart';
import 'package:fyp/views/forgotPassword.dart';
import 'package:fyp/views/services/loginService.dart';
import 'package:gap/gap.dart';
import 'common/component.dart';
import 'register.dart';

class LoginPageDetails extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPageDetails({Key? key}) : super(key: key);

  @override
  State<LoginPageDetails> createState() => _LoginPageDetailsState();
}

class _LoginPageDetailsState extends State<LoginPageDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(160.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFfaa87f),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(5, 25, 5, 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: IconStyles.blackCross,
                            onPressed: () => Navigator.pop(context),
                          ),
                    ])),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(children: <Widget>[
                      Container(
                        height: 50.0,
                        width: 200.0,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/logo_clear.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    ])),
                Padding(
                    padding: const EdgeInsets.fromLTRB(21, 15, 20, 0),
                    child: Row(children: const <Widget>[
                      Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF303030)),
                      )
                    ])),
              ],
            ),
          ),
        ),
        body: const LoginForm());
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginService loginService = LoginService();

  void _toggleVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Future<bool> getLoginStatus() {
    return loginService.loginUser(email: _emailController.text, password: _passwordController.text, context: context);
  }


  Future<bool> loginCheck() async {
    bool isSuccessful = await getLoginStatus();
    return isSuccessful;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child:
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end, children: [
                      TextFormField(
                        autofocus: false,
                        controller: _emailController,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Email',
                            icon: Icon(Icons.email)),
                        validator: (v) {
                          return v!.trim().isNotEmpty ? null : "Email cannot be empty";
                        },
                      ),
                      TextFormField(
                        autocorrect: false,
                        obscureText: !_showPassword,
                        enableSuggestions: false,
                        autofocus: false,
                        controller: _passwordController,
                        decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            labelText: 'Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _toggleVisibility();
                              },
                              child: Icon(
                                _showPassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.black38,
                              ),
                            ),
                            icon: const Icon(Icons.lock)),
                        validator: (v) {
                          return v!.trim().length > 5
                              ? null
                              : "Password must at least have 8 digits";
                        },
                      ),
                      TextButton(
                        child: const Text("Forgot password?"),
                        onPressed: () {
                          //TODO: go to forgot password page
                          Navigator.pushNamed(context, ForgotPasswordPageDetails.routeName);
                        },
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text("Login", style: Styles.buttonTextStyle1),
                              ),
                              onPressed: () async {
                                if ((_formKey.currentState as FormState).validate()) {
                                  bool isSuccessfulLogin = await loginCheck();
                                  print(isSuccessfulLogin);
                                  if(isSuccessfulLogin){
                                    _loginSuccessfulPopupWindow();
                                    showSnackBar(context, 'Success');
                                  }else{
                                    showSnackBar(context, 'Fail');
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const Gap(15),
                      Center(
                          child: RichText(
                        text: TextSpan(
                          text: "Don’t have an account? ",
                          style: Styles.headLineStyle6,
                          children: [
                            TextSpan(
                                text: " Sign Up",
                                style: const TextStyle(
                                  color: Color(0xFFE68453),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.pushNamed(context, RegisterPageDetails.routeName)
                            ),
                          ],
                        ),
                      )
                      )
            ])),
      )
    ]);
  }

  Future<void> _loginSuccessfulPopupWindow() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AlertDialog(
                      scrollable: true,
                      content: Column(children: <Widget>[
                        const Padding(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Color(0xFFF5F8FF),
                              child: Icon(Icons.check_rounded, size: 50.0),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: Text("Welcome Back",
                                style: Styles.headLineStyle2)),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text(
                                "Once again you login successfully into MedCare Plus app",
                                textAlign: TextAlign.center,
                                style: Styles.headLineStyle6)),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(children: <Widget>[
                              Expanded(
                                child: ElevatedButton(
                                  child: Text('Go to Home',
                                      style: Styles.buttonTextStyle1),
                                  onPressed: () {
                                    Navigator.of(context).popUntil(ModalRoute.withName(BasePage.routeName));
                                    Navigator.pushNamed(context, BasePage.routeName);
                                    // TODO: change route
                                  },
                                ),
                              )
                            ]))
                      ]))
                ],
              ));
        });
  }
}
