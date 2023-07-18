import 'package:flutter/material.dart';
import 'package:fyp/views/clinic/viewUserPastHealthRecords.dart';
import 'package:fyp/views/services/homepageService.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/views/clinic/healthRecordInputPage.dart';
import 'package:fyp/models/appointment.dart';

class InsertRecordOrViewRecordPage extends StatefulWidget {
  static const String routeName = '/health_record_selection';
  const InsertRecordOrViewRecordPage({Key? key, this.appointmentId, this.appointmentData, this.userAddress}) : super(key: key);

  final String? appointmentId;
  final AppointmentInfo? appointmentData;
  final String? userAddress;

  @override
  State<InsertRecordOrViewRecordPage> createState() => InsertRecordOrViewRecordPageState();
}

class InsertRecordOrViewRecordPageState extends State<InsertRecordOrViewRecordPage> {
  final HomepageService homeService = HomepageService();

  @override
  void initState() {
    super.initState();
    print("-----------------------");
    print(widget.appointmentId);
    print(widget.userAddress);
    print(widget.appointmentData);
    print("-----------------------");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
          ),
          SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                Container(
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Text(
                            "Patient ",
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
                              title: Text("View User Past e-Health Records",
                                  style: Styles.headLineStyle4,
                                  textAlign: TextAlign.center),
                              onTap: () {
                                Navigator.pushNamed(context, ViewUserHealthRecordArea.routeName, arguments: {"userAddress": widget.userAddress});
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
                              title: Text("Insert New e-Health Records",
                                  style: Styles.headLineStyle4,
                                  textAlign: TextAlign.center),
                              onTap: () {
                                Navigator.pushNamed(context, HealthRecordInputArea.routeName, arguments: {"userAddress": widget.userAddress, "appointmentId": widget.appointmentId, "appointmentData": widget.appointmentData});
                              },
                              trailing: Icon(Icons.arrow_right_rounded),
                            )),
                      )
                    ],
                  ),
                ),
              ]))
        ],
      )
    );
  }

  // Future<void> logoutConfirmPopupWindow(BuildContext context) async {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return Align(
  //             alignment: Alignment.center,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 AlertDialog(
  //                     scrollable: true,
  //                     content: Column(children: <Widget>[
  //                       const Padding(
  //                           padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
  //                           child: CircleAvatar(
  //                             radius: 50,
  //                             backgroundColor: Color(0xFFF5F8FF),
  //                             child: Icon(Icons.logout_rounded, size: 50.0),
  //                           )),
  //                       Padding(
  //                           padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
  //                           child: Text("Are you sure you want to logout?",
  //                               textAlign: TextAlign.center,
  //                               style: Styles.headLineStyle6)),
  //                       Padding(
  //                           padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
  //                           child: Row(children: <Widget>[
  //                             Expanded(
  //                                 child: Row(
  //                                   mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     ElevatedButton(
  //                                       style: ButtonStyle(
  //                                         backgroundColor:
  //                                         MaterialStateProperty.resolveWith(
  //                                                 (states) {
  //                                               if (states
  //                                                   .contains(MaterialState.disabled)) {
  //                                                 return Colors.grey;
  //                                               }
  //                                               if (states
  //                                                   .contains(MaterialState.pressed)) {
  //                                                 return const Color(0xff65ba79);
  //                                               }
  //                                               return Color(0xff70cf86);
  //                                             }),
  //                                       ),
  //                                       child: Text('Yes',
  //                                           style: Styles.buttonTextStyle1),
  //                                       onPressed: () {
  //                                         logout();
  //                                       },
  //                                     ),
  //                                     ElevatedButton(
  //                                       style: ButtonStyle(
  //                                         backgroundColor:
  //                                         MaterialStateProperty.resolveWith(
  //                                                 (states) {
  //                                               if (states
  //                                                   .contains(MaterialState.disabled)) {
  //                                                 return Colors.grey;
  //                                               }
  //                                               if (states
  //                                                   .contains(MaterialState.pressed)) {
  //                                                 return const Color(0xffb56d5e);
  //                                               }
  //                                               return Color(0xffd68272);
  //                                             }),
  //                                       ),
  //                                       child: Text('No',
  //                                           style: Styles.buttonTextStyle1),
  //                                       onPressed: () {
  //                                         Navigator.pop(context);
  //                                       },
  //                                     ),
  //                                   ],
  //                                 ))
  //                           ]))
  //                     ]))
  //               ],
  //             ));
  //       });
  // }
}
