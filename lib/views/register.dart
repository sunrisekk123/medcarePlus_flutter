import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/views/registerClinic.dart';
import 'package:fyp/views/services/loginService.dart';
import 'package:pinput/pinput.dart';
import 'package:fyp/views/common/component.dart';

class RegisterPageDetails extends StatefulWidget {
  static const String routeName = '/register';
  const RegisterPageDetails({Key? key, this.restorationId}) : super(key: key);
  final String? restorationId;

  @override
  State<RegisterPageDetails> createState() => _RegisterPageDetailsState();
}

class _RegisterPageDetailsState extends State<RegisterPageDetails>
    with RestorationMixin {
  final _formKey = GlobalKey<FormState>();
  String selectDate = "";
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool isChecked = false;
  final LoginService loginService = LoginService();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _hkidNoController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(BuildContext context, Object? arguments) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        selectDate = "${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}";
        _birthDateController.text = selectDate;
      });
    }
  }

  void _toggleVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleConfirmVisibility() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneNoController.dispose();
    _emailController.dispose();
    _hkidNoController.dispose();
    _passwordController.dispose();
    _birthDateController.dispose();
    _pinController.dispose();
  }

  void registerMember() {
    loginService.registerUser(
        context: context,
        email: _emailController.text,
        walletAddress: "",
        password: _passwordController.text,
        fname: _firstNameController.text,
        lname: _lastNameController.text,
        hkidNo: _hkidNoController.text,
        phoneNo: _phoneNoController.text,
        birthDate: _birthDateController.text,
        pin: _pinController.text.toString()
    );
  }

  @override
  Widget build(BuildContext context) {
    Color checkboxColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return const Color(0xffD3D6DA);
      }
      return const Color(0xFFE68453);
    }

    return Scaffold(
        appBar: AppBar(
          title:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              const Text(
                "Register an account",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Color(0xFF303030)),
              )
            ]
          ),
          leading: IconButton(
            icon: const Icon(Icons.clear_rounded, color: Color(0xFF303030)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    // onChanged: () {
                    //   Form.of(primaryFocus!.context!)!.save();
                    // },
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: OutlinedButton(
                                    child:Row(
                                      children: [
                                        const Text('Apply for clinic account '),
                                        Icon(Icons.arrow_circle_right_rounded)
                                      ],
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      primary: Styles.primaryColor,
                                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      side: const BorderSide(
                                        width: 5.0,
                                        color: Colors.transparent,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, RegisterClinicArea.routeName);
                                    }
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 2),
                              child: Text(
                                "Please fill in your personal information",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xFF303030)),
                              )),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(20, 2, 20, 5),
                              child: Text(
                                "(*Mandatory field)",
                                style: TextStyle(
                                    fontSize: 13, color: Color(0xFFe34c32)),
                              )),
                          Row(
                            children: [
                              Flexible(
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 5, 0),
                                      child: TextFormField(
                                        autofocus: false,
                                        controller: _firstNameController,
                                        decoration: const InputDecoration(
                                            isDense: true,
                                            border: UnderlineInputBorder(),
                                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                                            labelStyle: TextStyle(
                                              fontSize: 14
                                            ),
                                            labelText: 'First Name *',
                                        ),
                                        validator: (v) {
                                          return v!.trim().isNotEmpty ? null : "First Name cannot be empty";
                                        },
                                      ))),
                              Flexible(
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          5, 0, 20, 0),
                                      child: TextFormField(
                                        autofocus: false,
                                        controller: _lastNameController,
                                        decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.symmetric(vertical: 7),
                                            labelText: 'Last Name *',
                                            labelStyle: TextStyle(
                                              fontSize: 14
                                            )
                                        ),
                                        validator: (v) {
                                          return v!.trim().isNotEmpty ? null : "Last Name cannot be empty";
                                        },
                                      )))
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TextFormField(
                                readOnly: true,
                                autofocus: false,
                                controller: _birthDateController,
                                // TextEditingController(text: selectDate),
                                decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 7),
                                    labelText: 'Date of Birth *',
                                    labelStyle: TextStyle(
                                        fontSize: 14
                                    )),
                                onTap: () {_restorableDatePickerRouteFuture.present();},
                                validator: (v) {
                                  if(v != null){
                                    return v.trim().isNotEmpty ? null : "Date of Birth cannot be empty";
                                  }
                                  return null;
                                },
                              )),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TextFormField(
                                autofocus: false,
                                controller: _hkidNoController,
                                decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 7),
                                    labelText: 'HKID Number *',
                                    labelStyle: TextStyle(
                                        fontSize: 14
                                    )),
                                validator: (v) {
                                  return (hkidValidator(v?.toUpperCase())!.length > 0)
                                      ? hkidValidator(v?.toUpperCase())
                                      : null;
                                },
                              )),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                              child: Text(
                                "(If HKID Number is A123456(7), Please enter A1234567)",
                                style: TextStyle(
                                    fontSize: 11, color: Color(0xFF303030)),
                              )),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TextFormField(
                                autocorrect: false,
                                controller: _phoneNoController,
                                enableSuggestions: false,
                                autofocus: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 7),
                                  labelText: 'Phone Number *',
                                    labelStyle: TextStyle(
                                        fontSize: 14
                                    ),
                                  prefixText: '+852 '
                                ),
                                validator: (v) {
                                  return phoneNumberValidator(v);
                                },
                              )),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TextFormField(
                                autofocus: false,
                                controller: _emailController,
                                decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 7),
                                    labelText: 'Email *',
                                    labelStyle: TextStyle(
                                        fontSize: 14
                                    )),
                                validator: (v) {
                                  return emailValidator(v);
                                },
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: TextFormField(
                              autocorrect: false,
                              obscureText: !_showPassword,
                              enableSuggestions: false,
                              autofocus: false,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                labelText: 'Password *',
                                labelStyle: TextStyle(
                                    fontSize: 14
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    _toggleVisibility();
                                  },
                                  child: Icon(
                                    _showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black38,
                                  ),
                                ),
                              ),
                              validator: (v) {
                                return passwordValidator(v);
                              },
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                              child: Text(
                                "(Password should be within 8-16 characters and contain at least one number , one uppercase letter and one lowercase letter)",
                                style: TextStyle(
                                    fontSize: 11, color: Color(0xFF303030)),
                              )),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                              child: TextFormField(
                                autocorrect: false,
                                obscureText: !_showConfirmPassword,
                                enableSuggestions: false,
                                autofocus: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  labelText: 'Confirm Password *',
                                  labelStyle: TextStyle(
                                      fontSize: 14
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _toggleConfirmVisibility();
                                    },
                                    child: Icon(
                                      _showConfirmPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ),
                                validator: (v) {
                                  return confirmPasswordValidator(v);
                                },
                              )),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                      checkColor: Colors.white,
                                      fillColor: MaterialStateProperty.resolveWith(
                                          checkboxColor),
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isChecked = value!;
                                        });
                                      },
                                    ),
                                    Flexible(
                                        child: RichText(
                                          maxLines: 10,
                                          softWrap: true,
                                          text: TextSpan(
                                            text: "I agree to the MedCare Plus",
                                            style: const TextStyle(
                                                color: Color(0xFF717784), fontSize: 14),
                                            children: [
                                              TextSpan(
                                                  text: " Terms of Service ",
                                                  style: const TextStyle(
                                                    color: Color(0xFFE68453),
                                                  ),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () => Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => const RegisterPageDetails()))),
                                              const TextSpan(
                                                text: " and ",
                                                style: TextStyle(
                                                  color: Color(0xFF717784)
                                                ),
                                              ),
                                              TextSpan(
                                                  text: "Privacy Policy",
                                                  style: const TextStyle(
                                                    color: Color(0xFFE68453),
                                                  ),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterPageDetails()))),
                                            ],
                                          ),
                                    ))
                              ])),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Row(children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _registerEnterPinWindow();
                                      }
                                    },
                                    child: const Text('Submit'),
                                  ),
                                )
                              ])),
                        ])))));
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  Future<void> _registerEnterPinWindow() async {
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
                            child: Pinput(
                              keyboardType: TextInputType.number,
                              length: 6,
                              defaultPinTheme: defaultPinTheme,
                              validator: (s) {
                                final check = RegExp(r"^[0-9]*$");
                                return s != null && s.length == 6 && check.hasMatch(s) ? null : 'Pin is incorrect';
                              },
                              enableSuggestions: false,
                              controller: _pinController,
                              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                              showCursor: true,
                              onCompleted: (pin) => print(pin),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text(
                                "Please set a 6 digit PIN for electronic health record",
                                textAlign: TextAlign.center,
                                style: Styles.headLineStyle6)),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(children: <Widget>[
                              Expanded(
                                child: ElevatedButton(
                                  child: Text('Set PIN',
                                      style: Styles.buttonTextStyle1),
                                  onPressed: () {
                                    final check = RegExp(r"^[0-9]*$");
                                    if(_pinController.text.length==6 && check.hasMatch(_pinController.text)){
                                      registerMember();
                                    }else{
                                      showSnackBar(context, "Please set a 6 digit PIN for electronic health record");
                                    }
                                  },
                                ),
                              )
                            ]))
                      ]))
                ],
              ));
        });
  }

  Map<String, int> hkidCharacter = {
    'A': 10,
    'B': 11,
    'C': 12,
    'D': 13,
    'E': 14,
    'F': 15,
    'G': 16,
    'H': 17,
    'I': 18,
    'J': 19,
    'K': 20,
    'L': 21,
    'M': 22,
    'N': 23,
    'O': 24,
    'P': 25,
    'Q': 26,
    'R': 27,
    'S': 28,
    'T': 29,
    'U': 30,
    'V': 31,
    'W': 32,
    'X': 33,
    'Y': 34,
    'Z': 35
  };

  String? hkidValidator(v) {
    String temp = "";
    if (v!.trim().isNotEmpty) {
      if (v!.trim().length == 8 || v!.trim().length == 9) {
        if (v!.trim().length == 8) {
          int sum = 58 * 9 +
              hkidCharacter[v[0]]! * 8 +
              int.parse(v[1]) * 7 +
              int.parse(v[2]) * 6 +
              int.parse(v[3]) * 5 +
              int.parse(v[4]) * 4 +
              int.parse(v[5]) * 3 +
              int.parse(v[6]) * 2;
          int remainder = sum % 11;
          if ((remainder == 0 && v[7] == "0") ||
              (remainder == 1 && v[7] == "A") ||
              ((remainder > 1 && remainder < 11) &&
                  (v[7] == (11 - remainder).toString()))) {
            temp = "";
          } else {
            temp = "Invalid HKID Number";
          }
        } else if (v!.trim().length == 9) {
          if (hkidCharacter[v[1]] == null) {
            temp = "Invalid HKID Number";
          } else {
            int sum = hkidCharacter[v[0]]! * 9 +
                hkidCharacter[v[1]]! * 8 +
                int.parse(v[2]) * 7 +
                int.parse(v[3]) * 6 +
                int.parse(v[4]) * 5 +
                int.parse(v[5]) * 4 +
                int.parse(v[6]) * 3 +
                int.parse(v[7]) * 2;
            int remainder = sum % 11;
            if ((remainder == 0 && v[7] == "0") ||
                (remainder == 1 && v[7] == "A") ||
                (remainder > 1 && remainder < 11) &&
                    (v[7] == (11 - remainder).toString())) {
              temp = "";
            } else {
              temp = "Invalid HKID Number";
            }
          }
        }
      } else {
        temp = "Invalid HKID Number";
      }
    } else {
      temp = "HKID Number cannot be empty";
    }
    return temp;
  }

  String? emailValidator(v) {
    String? temp;
    if (v!.trim().isNotEmpty) {
      final check = RegExp(
          r"^[a-z0-9!#$%&'*+-/=?^_`{|}~]+@[a-z0-9!#$%&'*+-/=?^_`{|}~]+$");
      if (check.hasMatch(v)) {
        temp = null;
      } else {
        temp = "Invalid email address";
      }
    } else {
      temp = "Email cannot be empty";
    }
    return temp;
  }

  String? passwordValidator(v) {
    String? temp;
    if (v!.trim().isNotEmpty) {
      if (v!.trim().length < 8 || v!.trim().length > 16) {
        temp = "Invalid password";
      } else {
        final check = RegExp(r"(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])");
        if (check.hasMatch(v)) {
          temp = null;
        } else {
          temp = "Invalid password";
        }
      }
    } else {
      temp = "Password cannot be empty";
    }
    return temp;
  }

  String? confirmPasswordValidator(v) {
    String? temp;
    if (v!.trim().isNotEmpty) {
      if (_passwordController.text.trim() != v.trim()) {
        temp = "Invalid password";
      } else {
        temp = null;
      }
    } else {
      temp = "Password cannot be empty";
    }

    return temp;
  }

  String? phoneNumberValidator(v) {
    String? temp;
    final check = RegExp(r"^[0-9]*$");
    if (v!.trim().isNotEmpty) {
      if (v!.trim().length == 8 && check.hasMatch(v)) {
        temp = null;
      } else {
        temp = "Invalid phone number format";
      }
    } else {
      temp = "Phone number cannot be empty";
    }
    return temp;
  }
}
