import 'package:flutter/material.dart';
import 'package:fyp/views/services/homepageService.dart';
import 'package:fyp/views/services/loginService.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/views/login.dart';
import 'package:fyp/models/clinic.dart';
import 'package:fyp/views/common/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/views/clinic/scanQrcodePage.dart';
import 'package:fyp/views/clinic/viewClinicAppointment.dart';
import 'package:fyp/views/clinic/viewClinicAppointmentAll.dart';

class HomepageClinic extends StatefulWidget {
  static const String routeName = '/home_clinic';

  const HomepageClinic(
      {Key? key, required this.isLogin, required this.accountType})
      : super(key: key);

  final bool isLogin;
  final String accountType;

  @override
  State<HomepageClinic> createState() => HomepageClinicDetailsState();
}

class HomepageClinicDetailsState extends State<HomepageClinic> {
  final HomepageService homeService = HomepageService();
  final LoginService loginService = LoginService();

  List<ClinicInfo> clinicList = [];
  String accountIs = "";
  bool isExistPref = false;
  bool isExistWallet = false;

  @override
  void initState() {
    //TODO: check if login or not, if login: change drawer and show e-health record
    super.initState();
    getSharePref();
    fetchHomeData();
  }

  fetchHomeData() async {
    List<ClinicInfo> list = await homeService.getHomepageData(context);
    setState(() {
      clinicList = list;
    });
  }

  getSharePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("x-auth-token");
    String? address = prefs.getString("user-address");
    String? accountType = prefs.getString("x-account");
    if (token != null && token.isNotEmpty && accountType != null) {
      setState(() {
        isExistPref = true;
        accountIs = accountType;
      });
    }
    if (address != null && address.isNotEmpty) {
      setState(() {
        isExistWallet = true;
      });
    }
  }

  logout() async {
    await loginService.logoutUser(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        SliverAppBar(
            pinned: true,
            floating: false,
            elevation: 0,
            flexibleSpace: Container(
                decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0xFFe68453),
                    Color(0xFFe68453),
                    Color(0xFFFFFFFF)
                  ]),
            )),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.isLogin)
                  OutlinedButton.icon(
                    icon: Icon(Icons.logout_rounded),
                    label: Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.black54,
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                      side: const BorderSide(
                        width: 5.0,
                        color: Colors.transparent,
                        style: BorderStyle.solid,
                      ),
                    ),
                    onPressed: () {
                      logoutConfirmPopupWindow(context);
                    },
                  )
                else
                  OutlinedButton.icon(
                    icon: Icon(Icons.login),
                    label: Text('Login'),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.black54,
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                      side: const BorderSide(
                        width: 5.0,
                        color: Colors.transparent,
                        style: BorderStyle.solid,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPageDetails.routeName);
                    },
                  )
              ],
            )),
        !clinicList.isNotEmpty
            ? SliverList(
                delegate: SliverChildListDelegate(<Widget>[const Loader()]))
            : SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                Container(
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Text(
                            "Clinic Management",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ))
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                  child: Column(
                    children: [
                      Card(
                        color: Color(0xFFF8F7F3),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: ListTile(
                              leading: Icon(
                                Icons.filter_frames_outlined,
                                size: 50,
                              ),
                              title: Text("View Upcoming Appointment",
                                  style: Styles.headLineStyle4,
                                  textAlign: TextAlign.center),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, MyAppointmentClinicArea.routeName);
                              },
                              trailing: Icon(Icons.arrow_right_rounded),
                            )),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                  child: Column(
                    children: [
                      Card(
                        color: Color(0xFFF8F7F3),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: ListTile(
                              leading: Icon(
                                Icons.qr_code_2_rounded,
                                size: 60,
                              ),
                              title: Text("Scan QR Code",
                                  style: Styles.headLineStyle4,
                                  textAlign: TextAlign.center),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ScanQrCodeClinicArea.routeName);
                              },
                              trailing: Icon(Icons.arrow_right_rounded),
                            )),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                  child: Column(
                    children: [
                      Card(
                        color: Color(0xFFF8F7F3),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: ListTile(
                              leading: Icon(
                                Icons.inventory_rounded,
                                size: 60,
                              ),
                              title: Text("View All Past Appointment",
                                  style: Styles.headLineStyle4,
                                  textAlign: TextAlign.center),
                              onTap: () {
                                Navigator.pushNamed(context,
                                    MyAppointmentAllClinicArea.routeName);
                              },
                              trailing: Icon(Icons.arrow_right_rounded),
                            )),
                      )
                    ],
                  ),
                ),
              ]))
      ],
    );
  }

  Future<void> logoutConfirmPopupWindow(BuildContext context) async {
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
                              child: Icon(Icons.logout_rounded, size: 50.0),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text("Are you sure you want to logout?",
                                textAlign: TextAlign.center,
                                style: Styles.headLineStyle6)),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return Colors.grey;
                                        }
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return const Color(0xff65ba79);
                                        }
                                        return Color(0xff70cf86);
                                      }),
                                    ),
                                    child: Text('Yes',
                                        style: Styles.buttonTextStyle1),
                                    onPressed: () {
                                      logout();
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return Colors.grey;
                                        }
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return const Color(0xffb56d5e);
                                        }
                                        return Color(0xffd68272);
                                      }),
                                    ),
                                    child: Text('No',
                                        style: Styles.buttonTextStyle1),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ))
                            ]))
                      ]))
                ],
              ));
        });
  }
}
