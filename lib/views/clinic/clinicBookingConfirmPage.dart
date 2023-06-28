import 'package:flutter/material.dart';
import '../common/drawer/patientDrawer.dart';
import '../common/bottomNavBar/bottomNavBar.dart';
import 'package:fyp/style/app_style.dart';

class ClinicBookingConfirmPageArea extends StatefulWidget {
  const ClinicBookingConfirmPageArea({Key? key}) : super(key: key);

  @override
  State<ClinicBookingConfirmPageArea> createState() =>
      _ClinicBookingConfirmPageAreaState();
}

class _ClinicBookingConfirmPageAreaState
    extends State<ClinicBookingConfirmPageArea> {
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
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            dense: true,
                            visualDensity: VisualDensity(vertical: -3),
                          ),
                          ListTile(
                            title: Text("Clinic",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            subtitle: Text("\nCheng Hing Chung Clinic",
                                style: TextStyle(height: 1.3)),
                            dense: true,
                            visualDensity: VisualDensity(vertical: -3),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("Doctor",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            subtitle: Text("\nDr. Cheng Hing Chung",
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
                                "",
                                style: TextStyle(height: 1.3)),
                            dense: true,
                            visualDensity: VisualDensity(vertical: -3),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("Doctor",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            subtitle: Text("\nSelection",
                                style: TextStyle(height: 1.3)),
                            dense: true,
                            visualDensity: VisualDensity(vertical: -3),
                          ),
                        ])))),
          ])),
        ]),
        drawer: const PatientDrawer(),
        floatingActionButton: const CustomFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const BottomNavBar());
  }
}
