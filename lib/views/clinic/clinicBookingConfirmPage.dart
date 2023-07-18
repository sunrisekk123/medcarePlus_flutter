import 'package:flutter/material.dart';
import 'package:fyp/models/clinic.dart';
import 'package:fyp/views/services/appointmentService.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/views/basePage.dart';

class ClinicBookingConfirmPageArea extends StatefulWidget {
  static const String routeName = '/clinic_booking_confirm';
  const ClinicBookingConfirmPageArea({Key? key, required this.clinic, required this.doctor, required this.date, required this.time}) : super(key: key);

  final ClinicInfo clinic;
  final String doctor;
  final DateTime date;
  final String time;

  @override
  State<ClinicBookingConfirmPageArea> createState() =>
      _ClinicBookingConfirmPageAreaState();
}

class _ClinicBookingConfirmPageAreaState extends State<ClinicBookingConfirmPageArea> {
  final AppointmentService appointmentService =  AppointmentService();

  Future<bool> handleMakeAppointment() {
    return appointmentService.handleBookAppointment(context: context, clinic: widget.clinic, doctor: widget.doctor, date: widget.date.toString(), time: widget.time);
  }

  Future<bool> makeAppointment() {
    Future<bool> isSuccessful = handleMakeAppointment();
    return isSuccessful;
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
                            title: Text("Confirm Reservation",
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                            dense: true,
                            visualDensity: VisualDensity(vertical: -3),
                          ),
                          ListTile(
                            title: Text("Clinic",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            subtitle: Text("\n${widget.clinic.name}",
                                style: TextStyle(height: 1.3)),
                            dense: true,
                            visualDensity: VisualDensity(vertical: -3),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("Doctor",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            subtitle: Text("\nDr. ${widget.doctor}",
                                style: TextStyle(height: 1.3)),
                            dense: true,
                            visualDensity: VisualDensity(vertical: -3),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("Date",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            subtitle: Text(
                                "\n"
                                "${widget.date.toString().substring(0, 10)}",
                                style: TextStyle(height: 1.3)),
                            dense: true,
                            visualDensity: VisualDensity(vertical: -3),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("Time",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            subtitle: Text("\n${widget.time}",
                                style: TextStyle(height: 1.3)),
                            dense: true,
                            visualDensity: VisualDensity(vertical: -3),
                          ),
                          Divider(),
                          ListTile(
                            title: TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                    backgroundColor: Color(0xFFe68453),
                                    primary: Colors.white),
                                onPressed: () {
                                  makeAppointment().then((value) =>
                                  value ? bookingConfirmPopupWindow(context) : null
                                  );
                                },
                                child: Text("Confirm")),
                            dense: true,
                            visualDensity: VisualDensity(vertical: -3),
                          ),
                        ])))),
          ])),
        ]),
        );
  }

  Future<void> bookingConfirmPopupWindow(BuildContext context) async {
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
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text(
                                "You successfully create your booking",
                                textAlign: TextAlign.center,
                                style: Styles.headLineStyle6)),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                                            if (states.contains(MaterialState.disabled)) { return Colors.grey; }
                                            if (states.contains(MaterialState.pressed)) { return const Color(0xff65ba79); }
                                            return Color(0xff70cf86);
                                          }),
                                        ),
                                        child: Text('OK', style: Styles.buttonTextStyle1),
                                        onPressed: () {
                                          Navigator.pushNamedAndRemoveUntil(context, BasePage.routeName, (route) => false,);
                                        },
                                      )
                                    ],
                                  )
                              )
                            ]))
                      ]))
                ],
              ));
        });
  }
}
