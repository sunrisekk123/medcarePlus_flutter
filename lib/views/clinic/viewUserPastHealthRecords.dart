
import 'package:flutter/material.dart';
import 'package:fyp/models/clinic.dart';
import 'package:fyp/views/services/appointmentService.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/views/basePage.dart';
import 'package:fyp/views/services/healthRecordService.dart';

class ViewUserHealthRecordArea extends StatefulWidget {
  static const String routeName = '/health_record_view_clinic';
  const ViewUserHealthRecordArea({Key? key, required this.userAddress}) : super(key: key);
  final String userAddress;

  @override
  State<ViewUserHealthRecordArea> createState() => _ViewUserHealthRecordAreaState();
}

class _ViewUserHealthRecordAreaState extends State<ViewUserHealthRecordArea> {
  final HealthRecordService healthRecordService =  HealthRecordService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(shrinkWrap: true, slivers: [
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
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              /**/
              Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 20, 10),
                  child: Card(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(children: [
                            ListTile(
                              title: Text("Health Records",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            ListTile(
                              title: Text("Date",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text("\ndate",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Clinic",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text("\nClinic ",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            ListTile(
                              title: Text("Doctor",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text("\nDr. ",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Time",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  "\n time",
                                  // "${widget.date.toString().substring(0, 10)}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Services",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  "\n time",
                                  // "${widget.date.toString().substring(0, 10)}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Diagnosis",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  "\n time",
                                  // "${widget.date.toString().substring(0, 10)}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("treatments",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  "\n time",
                                  // "${widget.date.toString().substring(0, 10)}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Medication",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  "\n time",
                                  // "${widget.date.toString().substring(0, 10)}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            )
                          ])))),
            ])),
      ]),
    );
  }
}
