import 'package:flutter/material.dart';
import 'package:fyp/models/appointment.dart';
import 'package:fyp/views/services/healthRecordService.dart';

class MyAppointmentDetailsClinicArea extends StatefulWidget {
  static const String routeName = '/my_appointment_details_clinic';
  const MyAppointmentDetailsClinicArea({Key? key, required this.data}) : super(key: key);
  final AppointmentInfo data;

  @override
  State<MyAppointmentDetailsClinicArea> createState() => _MyAppointmentDetailsClinicAreaState();
}

class _MyAppointmentDetailsClinicAreaState extends State<MyAppointmentDetailsClinicArea> {
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
              Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 20, 10),
                  child: Card(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(children: [
                            ListTile(
                              title: Text("Appointment Details",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            ListTile(
                              title: Text("Date",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text("\n${widget.data.date}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            ListTile(
                              title: Text("Time",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text("\n${widget.data.time}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Clinic",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text("\n${widget.data.clinicName}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            ListTile(
                              title: Text("Doctor",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text("\nDr. ${widget.data.doctor}",
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
