import 'package:flutter/material.dart';
import 'package:fyp/models/common.dart';
import 'package:fyp/views/member/showQRcode.dart';
import 'package:fyp/views/member/viewHealthRecordAll.dart';
import 'package:fyp/views/services/appointmentService.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/models/appointment.dart';
import 'package:fyp/style/app_layout.dart';
import 'package:fyp/views/common/loader.dart';
import 'package:fyp/views/services/healthRecordService.dart';
import 'package:fyp/views/member/TrustedHealthProviderAll.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/views/common/component.dart';
import 'package:fyp/views/services/homepageService.dart';

class HealthRecordOverviewUserArea extends StatefulWidget {
  static const String routeName = '/my_health_record_user';

  const HealthRecordOverviewUserArea({Key? key}) : super(key: key);

  @override
  State<HealthRecordOverviewUserArea> createState() => _HealthRecordOverviewUserAreaState();
}

class _HealthRecordOverviewUserAreaState extends State<HealthRecordOverviewUserArea> {
  final HealthRecordService healthRecordService = HealthRecordService();
  final HomepageService homeService = HomepageService();
  bool isExistPref = false;
  bool isExistWallet = false;
  final _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSharePref();
  }

  @override
  void dispose() {
    _pinController.clear();
    _pinController.dispose();
    super.dispose();
  }

  getSharePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("x-auth-token");
    String? address = prefs.getString("user-address");
    if (token != null && token.isNotEmpty) {
      setState(() {
        isExistPref = true;
      });
    }
    if (address != null && address.isNotEmpty) {
      setState(() {
        isExistWallet = true;
      });
    }
  }

  Future<bool> verifyUserPin() async {

    return await homeService.verifyUserPin(context: context,pin: _pinController.text);
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 100.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text("Health Record Overview",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          )),
                      background: Image.asset(
                        'assets/images/bg_or2.jpg',
                        fit: BoxFit.cover,
                      )),
                ),
              ];
            },
            body: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    children: [
                        Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.medical_services),
                                        title: Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          child: Text("Your Health Records"),
                                        ),
                                        subtitle: Text("View all your health records here"),
                                        onTap: (){
                                          _enterPinWindow(HealthRecordViewAllUserArea.routeName);
                                      }
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ),
                        Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                        leading: Icon(Icons.qr_code_2_rounded),
                                        title: Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          child: Text("Show QR code"),
                                        ),
                                        subtitle: Text("Show your qr code to medical provider for access"),
                                        onTap: (){
                                          _enterPinWindow(ShowQRCodeUserArea.routeName);
                                        }
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ),
                        Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                        leading: Icon(Icons.people),
                                        title: Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          child: Text("My trusted health provider management"),
                                        ),
                                        subtitle: Text("View all your trusted health provider"),
                                        onTap: (){
                                          _enterPinWindow(TrustedHealthProviderAllArea.routeName);
                                        }
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ),
                    ],
                  ),
                )
        ),
      ),
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

  Future<void> _enterPinWindow(String routeNameIn) async {
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
                              child: Icon(Icons.fiber_pin_rounded, size: 50.0),
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
                                "Please enter the PIN",
                                textAlign: TextAlign.center,
                                style: Styles.headLineStyle6)),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(children: <Widget>[
                              Expanded(
                                child: ElevatedButton(
                                  child: Text('Enter PIN',
                                      style: Styles.buttonTextStyle1),
                                  onPressed: () {
                                    final check = RegExp(r"^[0-9]*$");
                                    if (_pinController.text.length == 6 && check.hasMatch(_pinController.text)) {
                                        verifyUserPin().then((value) =>{
                                          if(value){
                                            Navigator.popAndPushNamed(context, routeNameIn)
                                            ,_pinController.clear()
                                          }else{
                                            showSnackBar(context, "PIN not match")
                                          }
                                        });
                                    }
                                  }),
                              )
                            ]))
                      ]))
                ],
              ));
        });
  }
}
