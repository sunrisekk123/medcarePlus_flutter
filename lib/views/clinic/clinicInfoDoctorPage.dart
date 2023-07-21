import 'package:flutter/material.dart';
import 'package:fyp/models/appointment.dart';
import 'package:fyp/models/clinic.dart';
import 'package:fyp/views/services/healthRecordService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClinicInfoDoctorArea extends StatefulWidget {
  static const String routeName = '/personal_profile_doctor_clinic';
  const ClinicInfoDoctorArea({Key? key, required this.clinicData}) : super(key: key);
  final ClinicInfo clinicData;

  @override
  State<ClinicInfoDoctorArea> createState() => _ClinicInfoDoctorAreaState();
}

// class _ClinicInfoDoctorController {
//   final TextEditingController doctorNameControllers= TextEditingController();
//   final List<TextEditingController> doctorServiceControllers = [];
//   final List<TextEditingController> doctorQualificationControllers = [];
//
//   void dispose() {
//     doctorNameControllers.dispose();
//     for (final controller1 in doctorServiceControllers){
//       controller1.dispose();
//     }
//     for (final controller1 in doctorQualificationControllers){
//       controller1.dispose();
//     }
//   }
// }
//
// class _ClinicInfoDoctorTextField {
//   final TextField doctorNameTextField;
//   final List<TextField> doctorServiceTextField;
//   final List<TextField> doctorQualificationTextField;
//
//   _ClinicInfoDoctorTextField({
//     required this.doctorNameTextField,
//     required this.doctorServiceTextField,
//     required this.doctorQualificationTextField
//   });
// }

class _ClinicInfoDoctorController {
  final TextEditingController doctorNameControllers= TextEditingController();
  final TextEditingController doctorServiceControllers= TextEditingController();
  final TextEditingController doctorQualificationControllers= TextEditingController();

  void dispose() {
    doctorNameControllers.dispose();
    doctorServiceControllers.dispose();
    doctorQualificationControllers.dispose();
  }
}


class _ClinicInfoDoctorAreaState extends State<ClinicInfoDoctorArea> {
  static final GlobalKey<FormState> personalInfoClinicDoctorFormKey = GlobalKey<FormState>();

  bool isExistPref = false;
  bool isExistWallet = false;
  List<_ClinicInfoDoctorController> _doctorEditControllers = [];
  // List<_ClinicInfoDoctorTextField> _doctorEditTextFields = [];
  List<TextFormField> _nameFields = [];
  List<TextFormField> _serviceFields = [];
  List<TextFormField> _qualificationFields = [];

  @override
  void initState(){
    super.initState();
    getSharePref();
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
    for (final controller1 in _doctorEditControllers) {
      controller1.doctorNameControllers.dispose();
      controller1.doctorServiceControllers.dispose();
      controller1.doctorQualificationControllers.dispose();
      // for (final controller2 in controller1.doctorServiceControllers){
      //   controller2.dispose();
      // }
      // for (final controller3 in controller1.doctorQualificationControllers){
      //   controller3.dispose();
      // }
    }
    super.dispose();
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
              Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 20, 10),
                  child: Card(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(children: [
                            ListTile(
                              title: Text("Doctors Details",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -3),
                            ),
                            //Name services qualification image
                            for(int i=0; i<widget.clinicData.doctorInfo.length; i++)
                              Card(
                                color: Color(0xffe1f7fa),
                                child: Column(
                                  children: [

                                  ],
                                ),
                              ),
                            ListTile(
                              title: Icon(Icons.add),
                              onTap: (){
                                final group = _ClinicInfoDoctorController();

                                final nameField = _generateNameTextField(group.doctorNameControllers, "name");
                                final servicesField = _generateNameTextField(group.doctorNameControllers, "service");
                                final qualificationsField = _generateNameTextField(group.doctorNameControllers, "name");
                                // final servicesField = _generateNameTextField(group.doctorServiceControllers, "qualification");
                                // final qualificationsField = _generateNameTextField(group.doctorQualificationControllers, "qualification");
                                setState((){
                                  _doctorEditControllers.add(group);
                                  _nameFields.add(nameField);
                                  _serviceFields.add(servicesField);
                                  _qualificationFields.add(qualificationsField);

                                });
                                },
                            )
                          ])))),
            ])),
      ]),
    );
  }

  TextFormField _generateNameTextField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: hint,
      ),
      validator: (v) {
        return v!.trim().isNotEmpty ? null : "Cannot be empty";
      },
    );
  }

  // Column _generateGroupColumn(List<TextEditingController> controller, String hint) {
  //   return Column(
  //     children: [
  //       ListTile(
  //         title: _generatedGroupTextFields(controller., hint),
  //       ),
  //       ListTile(
  //         title: Icon(Icons.add),
  //         onTap: (){
  //
  //           final nameField = _generateNameTextField(group.doctorNameControllers, "name");
  //           setState((){
  //             // _doctorEditControllers.add(group);
  //           });
  //         },
  //       )
  //     ],
  //   );
  // }
  //
  // TextFormField _generatedGroupTextFields(TextEditingController controller, String hint){
  //   return TextFormField(
  //     controller: controller,
  //     decoration: InputDecoration(
  //       border: OutlineInputBorder(),
  //       labelText: hint,
  //     ),
  //     validator: (v) {
  //       return v!.trim().isNotEmpty ? null : "Cannot be empty";
  //     },
  //   );
  // }

}
