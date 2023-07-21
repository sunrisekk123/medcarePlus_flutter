import 'package:flutter/material.dart';
import 'package:fyp/models/healthRecord.dart';
import 'package:fyp/views/services/appointmentService.dart';
import 'package:fyp/models/appointment.dart';
import 'package:fyp/views/services/healthRecordService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppointmentDetailsUserArea extends StatefulWidget {
  static const String routeName = '/my_appointment_details_user';
  const MyAppointmentDetailsUserArea({Key? key, required this.appointmentData}) : super(key: key);
  final AppointmentInfo appointmentData;
  @override
  State<MyAppointmentDetailsUserArea> createState() => _MyAppointmentDetailsUserAreaState();
}

class _MyAppointmentDetailsUserAreaState extends State<MyAppointmentDetailsUserArea> {
  final AppointmentService appointmentService = AppointmentService();
  final HealthRecordService healthRecordService = HealthRecordService();
  bool isExistPref = false;
  bool isExistWallet = false;
  String userAddress = "";

  @override
  void initState() {
    super.initState();
    // fetchAppointmentDetails();
  }

  fetchAppointmentDetails() async{
    String appointmentId = widget.appointmentData.appointmentId;
    List<HealthRecord> appointmentHealthRecordData = await healthRecordService.getHealthRecordDataByAppointmentId(context, appointmentId, userAddress);
    setState(() {
      // C = Cancel, A = Active, D = Complete

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
                              subtitle: Text("\n${widget.appointmentData.date}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Clinic",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text("\n ${widget.appointmentData.clinicName}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            ListTile(
                              title: Text("Doctor",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text("\nDr. ${widget.appointmentData.doctor}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Time",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  "\n ${widget.appointmentData.time}",
                                  // "${widget.date.toString().substring(0, 10)}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Status",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  "\n ${widget.appointmentData.status == 'C'? "Canceled" : widget.appointmentData.status == 'D'?"Completed" :"Confirmed"}",
                                  // "${widget.date.toString().substring(0, 10)}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            // appointment health record
                            // Container(
                            //   child: Column(
                            //     children: [
                            //       ListTile(
                            //         title: Text("Services",
                            //             style: TextStyle(fontWeight: FontWeight.w500)),
                            //         subtitle: Text(
                            //             "\n ${widget.appointmentData.services}",
                            //             style: TextStyle(height: 1.3)),
                            //         dense: true,
                            //         visualDensity: VisualDensity(vertical: -3),
                            //       ),
                            //       Divider(),
                            //       ListTile(
                            //         title: Text("Diagnosis",
                            //             style: TextStyle(fontWeight: FontWeight.w500)),
                            //         subtitle: Text(
                            //             "\n ${widget.healthRecordData.diagnosis}",
                            //             style: TextStyle(height: 1.3)),
                            //         dense: true,
                            //         visualDensity: VisualDensity(vertical: -3),
                            //       ),
                            //       Divider(),
                            //       ListTile(
                            //         title: Text("Treatments",
                            //             style: TextStyle(fontWeight: FontWeight.w500)),
                            //         subtitle: Text(
                            //             "\n ${widget.appointmentData.treatment}",
                            //             // "${widget.date.toString().substring(0, 10)}",
                            //             style: TextStyle(height: 1.3)),
                            //         dense: true,
                            //         visualDensity: VisualDensity(vertical: -3),
                            //       ),
                            //       Divider(),
                            //       ListTile(
                            //         title: Text("Medication",
                            //             style: TextStyle(fontWeight: FontWeight.w500)),
                            //         subtitle: Text(
                            //             "\n ${widget.appointmentData.medications}",
                            //             // "${widget.date.toString().substring(0, 10)}",
                            //             style: TextStyle(height: 1.3)),
                            //         dense: true,
                            //         visualDensity: VisualDensity(vertical: -3),
                            //       )
                            //     ],
                            //   ),
                            // )
                          ])))),
            ])),
      ]),
    );
  }
}
