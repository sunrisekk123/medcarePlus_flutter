import 'package:flutter/material.dart';
import 'package:fyp/models/appointment.dart';
import 'package:fyp/models/clinic.dart';
import 'package:fyp/views/services/healthRecordService.dart';
import 'package:fyp/models/user.dart';
import 'package:fyp/views/common/component.dart';

class HealthRecordInputArea extends StatefulWidget {
  static const String routeName = '/insert_health_record';
  const HealthRecordInputArea({Key? key, this.appointmentId, this.appointmentData, this.userAddress}) : super(key: key);
  final String? appointmentId;
  final AppointmentInfo? appointmentData;
  final String? userAddress;

  @override
  State<HealthRecordInputArea> createState() => _HealthRecordInputAreaState();
}

class _HealthRecordInputAreaState extends State<HealthRecordInputArea> {
  final _healthRecordFormKey = GlobalKey<FormState>();
  final HealthRecordService healthRecordService = HealthRecordService();
  final _treatmentsController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _servicesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _remarksController = TextEditingController();
  List<ClinicInfo> clinicDataThis = [];
  List<User> userDataThis = [];
  String _doctor = "";


  @override
  void dispose() {
    super.dispose();
    _treatmentsController.dispose();
    _diagnosisController.dispose();
    _servicesController.dispose();
    _medicationsController.dispose();
    _remarksController.dispose();
    _doctor = "";
  }

  @override
  void initState() {
    super.initState();
    fetchClinicData();
    fetchUserData();
  }

  fetchClinicData() async {
    List<ClinicInfo> clinicData = await healthRecordService.getClinicInfo(context: context);
    setState(() {
      clinicDataThis = clinicData;
    });
  }

  fetchUserData() async {
    List<User> userDate = await healthRecordService.getUserInfo(context: context,userWalletAddress: widget.userAddress);
    setState(() {
      userDataThis = userDate;
    });
  }

  void insertHealthRecords() {
    healthRecordService.insertHealthRecord(
        context: context,
        appointmentId: widget.appointmentId,
        clinicWalletAddress: widget.appointmentData?.clinicAddress,
        userWalletAddress: widget.appointmentData?.userAddress,
        doctor: widget.appointmentData?.doctor != null ? widget.appointmentData!.doctor: _doctor,
        services: _servicesController.text,
        diagnosis: _diagnosisController.text,
        treatment: _treatmentsController.text,
        medications: _medicationsController.text,
        remarks: _remarksController.text,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: CustomScrollView(shrinkWrap: true, slivers: [
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
          SliverList(delegate: SliverChildListDelegate(<Widget>[
            Form(
              key: _healthRecordFormKey,
              child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container(
                      child: Column(
                        children: [
                          // is appointment?
                          ListTile(
                            title: Row(
                              children: [
                                Text("Appointment:   "),
                                widget.appointmentId != null? Icon(Icons.check_rounded) : Icon(Icons.clear_rounded)
                              ],
                            ),
                          ),
                          ListTile(
                            title: Text("Name"),
                            subtitle: Text(userDataThis.isNotEmpty? userDataThis[0].fname + " " + userDataThis[0].lname :""),
                          ),
                          ListTile(
                            title: Text("Birth Date"),
                            subtitle: Text(userDataThis.isNotEmpty? userDataThis[0].birthDate.substring(0,10) :""),
                          ),
                          ListTile(
                            title: Text("Clinic Name"),
                            subtitle: Text(clinicDataThis.isNotEmpty? clinicDataThis[0].name :""),
                          ),
                          ListTile(
                            title: Text("Doctor"),
                            subtitle: widget.appointmentData?.doctor != null ? Text(widget.appointmentData!.doctor) :
                            DropdownButtonFormField(
                                value: clinicDataThis[0].doctorInfo[0] != null ? clinicDataThis[0].doctorInfo[0].name
                                    : "No available doctor",
                                icon: const Icon(Icons.arrow_downward),
                                style: TextStyle(fontSize: 13, color: Colors.black),
                                elevation: 12,
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _doctor = value.toString();
                                  });
                                },
                                items: clinicDataThis[0].doctorInfo.map((e) =>
                                    DropdownMenuItem<String>(
                                        value: e.name,
                                        child: Row(
                                          children: [
                                            Text(e.name)
                                          ],
                                        ))).toList()),
                          ),
                          ListTile(
                            title: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              autofocus: false,
                              controller: _servicesController,
                              decoration: const InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 5),
                                labelStyle: TextStyle(
                                    fontSize: 14
                                ),
                                labelText: 'Services',
                              ),
                              validator: (v) {
                                return v!.trim().isNotEmpty ? null : "Services cannot be empty";
                              },
                            ),
                          ),
                          ListTile(
                            title: TextFormField(
                              autofocus: false,
                              controller: _diagnosisController,
                              decoration: const InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 5),
                                labelStyle: TextStyle(
                                    fontSize: 14
                                ),
                                labelText: 'Diagnosis',
                              ),
                              validator: (v) {
                                return v!.trim().isNotEmpty ? null : "Diagnosis cannot be empty";
                              },
                            ),
                          ),
                          ListTile(
                            title: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              autofocus: false,
                              minLines:3,
                              controller: _treatmentsController,
                              decoration: const InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 5),
                                labelStyle: TextStyle(
                                    fontSize: 14
                                ),
                                labelText: 'Treatments',
                              ),
                              validator: (v) {
                                return v!.trim().isNotEmpty ? null : "Treatments cannot be empty";
                              },
                            ),
                          ),
                          ListTile(
                            title: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              autofocus: false,
                              minLines:3,
                              controller: _medicationsController,
                              decoration: const InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 5),
                                labelStyle: TextStyle(
                                    fontSize: 14
                                ),
                                labelText: 'Medications',
                              ),
                              validator: (v) {
                                return v!.trim().isNotEmpty ? null : "Medications cannot be empty";
                              },
                            ),
                          ),
                          ListTile(
                            title: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              autofocus: false,
                              minLines:3,
                              controller: _remarksController,
                              decoration: const InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 5),
                                labelStyle: TextStyle(
                                    fontSize: 14
                                ),
                                labelText: 'Remarks',
                              ),
                              validator: (v) {
                                return null;
                              },
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: ElevatedButton(
                                          onPressed: (){
                                            if (_healthRecordFormKey.currentState!.validate()) {
                                              showSnackBar(context, "Processing Data");
                                              insertHealthRecords();
                                            }
                                          },
                                          child: Text("Insert", style: TextStyle(color: Colors.white),)
                                      )
                                  )
                                ],
                              )
                          )
                        ]
                      )
                  )
              ),
            )
          ]))
        ])
    );
  }

}
