import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/style/app_layout.dart';
import 'package:fyp/models/common.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/models/user.dart';
import 'package:fyp/views/services/homepageService.dart';
import 'package:fyp/views/common/loader.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/views/common/component.dart';

class PersonalProfileArea extends StatefulWidget {
  static const String routeName = '/personal_profile_user';
  const PersonalProfileArea({Key? key, this.restorationId}) : super(key: key);
  final String? restorationId;
  @override
  State<PersonalProfileArea> createState() => _PersonalProfileAreaState();
}

class _PersonalProfileAreaState extends State<PersonalProfileArea> with RestorationMixin{
  static final GlobalKey<FormState> personalInfoFormKey = GlobalKey<FormState>();
  final HomepageService homeService = HomepageService();
  bool isExistPref = false;
  bool isExistWallet = false;
  List<User> userList = [];
  bool _passwordEdit = false;
  bool _nameEdit = false;
  bool _phoneEdit = false;
  bool _hkidEdit = false;
  bool _birthEdit = false;
  bool _addressEdit = false;
  bool _showPassword = false;
  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _lnameController = TextEditingController();
  final _fnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _hkidController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthController = TextEditingController();
  String selectDate = "";
  final _pinController = TextEditingController();

  @override
  String? get restorationId => widget.restorationId;

  @override
  void initState(){
    super.initState();
    getSharePref();
    fetchUserData();
  }

  fetchUserData() async {
    List<User> userInfo = await homeService.getUserDataByEmail(context);
    setState(() {
      userList = userInfo;
    });
  }

  getSharePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("x-auth-token");
    String? address = prefs.getString("user-address");
    if(token != null && token.isNotEmpty ){
      setState(() {
        isExistPref = true;
      });
    }
    if(address != null && address.isNotEmpty){
      setState(() {
        isExistWallet = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _lnameController.dispose();
    _fnameController.dispose();
    _phoneController.dispose();
    _hkidController.dispose();
    _addressController.dispose();
    _birthController.dispose();
    _pinController.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

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

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        selectDate = "${_selectedDate.value.year.toString()}-${_selectedDate.value.month.toString().length==2? _selectedDate.value.month.toString(): "0"+_selectedDate.value.month.toString()}-${_selectedDate.value.day.toString().length==2? _selectedDate.value.day.toString(): "0"+_selectedDate.value.day.toString()}";
        _birthController.text = selectDate;
      });
    }
  }

  List<TextValue> areaList = [
    TextValue("Hong Kong Island", "HK"),
    TextValue("Kowloon", "KL"),
    TextValue("New Territories", "NT")
  ];

  String getAreaName(String area){
    TextValue result = areaList.firstWhere((element) => element.value==area);
    return result.text;
  }

  Future<bool> updatePersonalInfoCall() {
    return homeService.updateUserInfo(
        context: context,
        password: _passwordEdit ? _passwordController.text : "",
        birth: _birthEdit ? _birthController.text : "",
        hkid: _hkidEdit ? _hkidController.text : "",
        address: _addressEdit ? _addressController.text : "",
        phone: _phoneEdit ? _phoneController.text : "",
        fname: _nameEdit ? _fnameController.text : "",
        lname: _nameEdit ? _lnameController.text : ""
    );
  }


  Future<bool> updatePersonalInfo() async {
    bool isSuccessful = await updatePersonalInfoCall();
    return isSuccessful;
  }

  setPinAlone() async {
    homeService.setPin(
        context: context,
        pin: _pinController.text
    );
  }


  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);

    return Scaffold(
      body: CustomScrollView(shrinkWrap: true, slivers: [
        SliverAppBar(
          pinned: true,
          floating: false,
          elevation: 0,
          expandedHeight: 130,
          backgroundColor: Colors.transparent,
          flexibleSpace:
          ClipPath(
            clipper: CurveClipper(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xFFe68453),
                      Color(0xFFe68453),
                      Color(0xFFFFFFFF)
                    ]),
              ),
              height: 130.0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                child: Column(
                  children: [
                    Text("Personal Info", style: TextStyle(
                      color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      fontFamily: "RobotoMono"
                    ))
                  ],
                )
              )
            )
          )
        ),
        !userList.isNotEmpty ?  SliverList(delegate: SliverChildListDelegate(<Widget>[const Loader()])) :
          SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                Form(
                    key: personalInfoFormKey,
                    child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Container(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text("Wallet Address"),
                              subtitle: Text(userList[0].walletAddress),
                              trailing: TextButton(
                                child: Icon(Icons.copy),
                                onPressed: () async {
                                  await Clipboard.setData(ClipboardData(text: userList[0].walletAddress));
                                },
                              ),
                            ),
                            ListTile(
                              title: Text("PIN"),
                              subtitle: userList[0].pin.isEmpty ? TextButton(
                                  onPressed: (){
                                    _setPinWindow();
                                  },
                                  child: Text("Set PIN here")) : Text("PIN has been set"),
                            ),
                            ListTile(
                              title: Text("Email Address"),
                              subtitle: Text(userList[0].email),
                            ),
                            ListTile(
                                title: Text("Password"),
                                subtitle: ((!_passwordEdit) ? Text("***"):
                                TextFormField(
                                  autocorrect: false,
                                  obscureText: !_showPassword,
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: UnderlineInputBorder(),
                                      labelText: 'Enter new password',
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
                                  )
                                ),
                                trailing: IconButton(
                                  icon: (!_passwordEdit) ? Icon(Icons.create_outlined) : Icon(Icons.check_rounded),
                                  onPressed: () {
                                    if(_passwordEdit){
                                      if(_passwordController.text.isNotEmpty && passwordValidator(_passwordController.text) == null){
                                        setState(() {
                                          _passwordEdit = !_passwordEdit;
                                        });
                                      }else{
                                        showSnackBar(context, "Please enter valid password");
                                      }
                                    }else{
                                      setState(() {
                                        _passwordEdit = !_passwordEdit;
                                      });
                                    }
                                  },
                                )
                            ),
                            ListTile(
                                title: Text("Name"),
                                subtitle: ((!_nameEdit) ? (_fnameController.text.isNotEmpty ? Text('${_fnameController.text} ${_lnameController.text}') : Text('${userList[0].fname} ${userList[0].lname}')) :
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _fnameController,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: 'First name',
                                        ),
                                        validator: (v) {
                                          return v!.trim().isNotEmpty ? null : "Cannot be empty";
                                        },
                                      ),
                                    ),
                                    Gap(10),
                                    Expanded(
                                        child: TextFormField(
                                          controller: _lnameController,
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                            labelText: 'Last name',
                                          ),
                                          validator: (v) {
                                            return v!.trim().isNotEmpty ? null : "Cannot be empty";
                                          },
                                        )
                                    )
                                  ],
                                )
                                ),
                                trailing: IconButton(
                                  icon: (!_nameEdit) ? Icon(Icons.create_outlined) : Icon(Icons.check_rounded),
                                  onPressed: () {
                                    if(_nameEdit){
                                      if(_fnameController.text.isNotEmpty && _lnameController.text.isNotEmpty){
                                        setState(() {
                                          _nameEdit = !_nameEdit;
                                        });
                                      }else{
                                        showSnackBar(context, "Please enter valid password");
                                      }
                                    }else{
                                      setState(() {
                                        _nameEdit = !_nameEdit;
                                      });
                                    }
                                  },
                                )
                            ),
                            ListTile(
                                title: Text("Phone Number"),
                                subtitle: (!_phoneEdit) ? (_phoneController.text.isNotEmpty ? Text('+852 ${_phoneController.text}') : Text('+852 ${userList[0].phoneNo}'))  :
                                TextFormField(
                                    controller: _phoneController,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: 'Enter new phone number',
                                      prefixText: '+852 ',
                                    ),
                                    validator: (v) {
                                      return v!.trim().isNotEmpty ? null : "Cannot be empty";
                                    },
                                  ),
                                trailing: IconButton(
                                  icon: (!_phoneEdit) ? Icon(Icons.create_outlined) : Icon(Icons.check_rounded),
                                  onPressed: () {
                                    if(_phoneEdit){
                                      if(_phoneController.text.isNotEmpty){
                                        setState(() {
                                          _phoneEdit = !_phoneEdit;
                                        });
                                      }else{
                                        showSnackBar(context, "Please enter phone number before saved");
                                      }
                                    }else{
                                      setState(() {
                                        _phoneEdit = !_phoneEdit;
                                      });
                                    }

                                  },
                                )
                            ),
                            ListTile(
                                title: Text("HKID Number"),
                                subtitle: (!_hkidEdit) ? (_hkidController.text.isNotEmpty ? Text(' ${_hkidController.text}') : Text('${userList[0].hkid}')) :
                                TextFormField(
                                    controller: _hkidController,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: 'Enter new HKID number',
                                    ),
                                  validator: (v) {
                                    return v!.trim().isNotEmpty ? null : "Cannot be empty";
                                  },
                                ),
                                trailing: IconButton(
                                  icon: (!_hkidEdit) ? Icon(Icons.create_outlined) : Icon(Icons.check_rounded),
                                  onPressed: () {
                                    if(_hkidEdit){
                                      if(_hkidController.text.isNotEmpty){
                                        setState(() {
                                          _hkidEdit = !_hkidEdit;
                                        });
                                      }else{
                                        showSnackBar(context, "Please enter HKID No before saved");
                                      }
                                    }else{
                                      setState(() {
                                        _hkidEdit = !_hkidEdit;
                                      });
                                    }
                                  },
                                )
                            ),
                            ListTile(
                                title: Text("Birth Date"),
                                subtitle: (!_birthEdit) ? (_birthController.text.isNotEmpty ? Text('${_birthController.text}') : Text('${userList[0].birthDate.substring(0,10)}')) :
                                TextFormField(
                                    controller: _birthController,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: 'Enter new birth date',
                                  ),
                                  onTap: () {_restorableDatePickerRouteFuture.present();},
                                  validator: (v) {
                                    return v!.trim().isNotEmpty ? null : "Cannot be empty";
                                  },
                                ),
                                trailing: IconButton(
                                  icon: (!_birthEdit) ? Icon(Icons.create_outlined) : Icon(Icons.check_rounded),
                                  onPressed: () {
                                    if(_birthEdit){
                                      if(_birthController.text.isNotEmpty){
                                        setState(() {
                                          _birthEdit = !_birthEdit;
                                        });
                                      }else{
                                        showSnackBar(context, "Please enter birth date before saved");
                                      }
                                    }else{
                                      _restorableDatePickerRouteFuture.present();
                                      setState(() {
                                        _birthEdit = !_birthEdit;
                                      });
                                    }
                                  },
                                )
                            ),
                            ListTile(
                                title: Text("Address"),
                                subtitle: (!_addressEdit) ? (_addressController.text.isNotEmpty ? Text('${_addressController.text}') : Text('${userList[0].address}')) :
                                TextFormField(
                                    controller: _addressController,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: 'Enter new address',
                                  ),
                                  validator: (v) {
                                    return v!.trim().isNotEmpty ? null : "Cannot be empty";
                                  },
                                ),
                                trailing: IconButton(
                                  icon: (!_addressEdit) ? Icon(Icons.create_outlined) : Icon(Icons.check_rounded),
                                  onPressed: () {
                                    if(_addressEdit){
                                      if(_addressController.text.isNotEmpty){
                                        setState(() {
                                          _addressEdit = !_addressEdit;
                                        });
                                      }else{
                                        showSnackBar(context, "Please enter address before saved");
                                      }
                                    }else{
                                      setState(() {
                                        _addressEdit = !_addressEdit;
                                      });
                                    }
                                  },
                                )
                            ),
                            ListTile(
                                subtitle: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                  child: TextFormField(
                                    controller: _oldPasswordController,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: 'Enter old password to confirm',
                                    ),
                                  ),
                                )
                            ),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Row(children: <Widget>[
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (((_passwordEdit && _passwordController.text.isNotEmpty)
                                            || (_nameEdit && _lnameController.text.isNotEmpty && _fnameController.text.isNotEmpty)
                                            || (_phoneEdit && _phoneController.text.isNotEmpty)
                                            || (_addressEdit && _addressController.text.isNotEmpty)
                                            || (_hkidEdit && _hkidController.text.isNotEmpty)
                                            || (_birthEdit && _birthController.text.isNotEmpty))
                                        ) {
                                          updatePersonalInfo();
                                        }else{
                                          showSnackBar(context, "Please enter valid old password");
                                        }
                                      },
                                      child: const Text('Submit', style: TextStyle(color: Colors.white)),
                                    ),
                                  )
                                ])
                            )
                          ],
                        )
                    ),
                  )
                )
              ])),
      ]),
    );

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

  Future<void> _setPinWindow() async {
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
                                      setPinAlone();
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

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

String? passwordValidator(v) {
  String? temp;
  if (v!.trim().isNotEmpty) {
    if (v!.trim().length < 8 || v!.trim().length > 16) {
      temp = "(Password should be within 8-16 characters and contain at least one number , one uppercase letter and one lowercase letter)";
    } else {
      final check = RegExp(r"(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])");
      if (check.hasMatch(v)) {
        temp = null;
      } else {
        temp = "(Password should be within 8-16 characters and contain at least one number , one uppercase letter and one lowercase letter)";
      }
    }
  } else {
    temp = "Password cannot be empty";
  }
  return temp;
}