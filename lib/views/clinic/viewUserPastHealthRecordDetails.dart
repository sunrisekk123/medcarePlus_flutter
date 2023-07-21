import 'package:flutter/material.dart';
import 'package:fyp/models/healthRecord.dart';
import 'package:fyp/views/services/healthRecordService.dart';

class ViewUserHealthRecordDetailsArea extends StatefulWidget {
  static const String routeName = '/health_record_details_view_clinic';
  const ViewUserHealthRecordDetailsArea({Key? key, required this.healthRecordData}) : super(key: key);
  final HealthRecord healthRecordData;
  @override
  State<ViewUserHealthRecordDetailsArea> createState() => _ViewUserHealthRecordDetailsAreaState();
}

class _ViewUserHealthRecordDetailsAreaState extends State<ViewUserHealthRecordDetailsArea> {
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
                              subtitle: Text("\n${widget.healthRecordData.datetime.substring(0,4)}-${widget.healthRecordData.datetime.substring(4,6)}-${widget.healthRecordData.datetime.substring(6,8)}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Clinic",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text("\n ${widget.healthRecordData.clinicName}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            ListTile(
                              title: Text("Doctor",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text("\nDr. ${widget.healthRecordData.doctor}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Time",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  "\n ${widget.healthRecordData.datetime.substring(8,10)}:${widget.healthRecordData.datetime.substring(10,12)}",
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
                                  "\n ${widget.healthRecordData.services}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Diagnosis",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  "\n ${widget.healthRecordData.diagnosis}",
                                  style: TextStyle(height: 1.3)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Treatments",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  "\n ${widget.healthRecordData.treatment}",
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
                                  "\n ${widget.healthRecordData.medications}",
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
