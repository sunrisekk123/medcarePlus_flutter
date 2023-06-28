import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import '../common/drawer/patientDrawer.dart';
import '../common/bottomNavBar/bottomNavBar.dart';
import 'package:fyp/style/app_style.dart';
import '../../style/app_layout.dart';
import 'clinicBookingPage.dart';

class ClinicDetails extends StatelessWidget {
  const ClinicDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedCare Plus',
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      home: const ClinicDetailsArea(),
    );
  }
}

class ClinicDetailsArea extends StatefulWidget {
  const ClinicDetailsArea({Key? key}) : super(key: key);

  @override
  State<ClinicDetailsArea> createState() => _ClinicDetailsAreaState();
}

class _ClinicDetailsAreaState extends State<ClinicDetailsArea> {
  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);

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
                padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: SizedBox(
                          height: 110,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1.0,
                                child: Image.asset(
                                  'assets/images/clinic_1.png',
                                  fit: BoxFit.fill,
                                  width: size.width * 0.35,
                                  height: 120,
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(20, 0, 2, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Cheng Hing Chung Clinic ClinicClinicClinic",
                                            style: Styles
                                                .cardDetailsTextStyleTitle,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Gap(5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.locationDot,
                                                size: 14,
                                                color: Colors.red,
                                              ),
                                              Text("Tsuen Wan",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ],
                                          ),
                                          Gap(5),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                onPrimary: Colors.grey[100],
                                                primary: Styles.primaryColor,
                                                minimumSize: Size(88, 36),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(2)),
                                                )),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ClinicBookingPageArea()),
                                              );
                                            },
                                            child: const Text(
                                                'Make a appointment'),
                                          )
                                        ],
                                      )))
                            ],
                          ),
                        )))),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 20, 10),
                child: SizedBox(
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(children: [
                              ListTile(
                                title: Text(
                                  "Address",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                    "\nUnit 2008B, 20/F, New World Tower 1, 16-18 Queen's Road Central, Hong Kong",
                                    style: TextStyle(height: 1.3)),
                                dense: true,
                                visualDensity: VisualDensity(vertical: -3),
                              ),
                              Divider(),
                              ListTile(
                                title: Text(
                                  "Open Hours",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                    "\nMon - Fri: 10:00am - 20:00pm\nSat - Sun: 12:00pm - 18:00pm",
                                    style: TextStyle(height: 1.3)),
                                dense: true,
                                visualDensity: VisualDensity(vertical: -3),
                              )
                            ]))))),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 20, 10),
                child: SizedBox(
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(children: [
                              ListTile(
                                  dense: true,
                                  visualDensity: VisualDensity(vertical: -3),
                                  title: Text("Our Doctors",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  shape: Border(
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Colors.black12,
                                          style: BorderStyle.solid))),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: SizedBox(
                                    height: 110,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1.0,
                                          child: Image.asset(
                                            'assets/images/doctor_1.webp',
                                            fit: BoxFit.fill,
                                            width: size.width * 0.30,
                                            height: 100,
                                          ),
                                        ),
                                        Expanded(
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 0, 2, 0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Dr. Cheng Hing Chung",
                                                      style: Styles
                                                          .cardDetailsTextStyleTitle,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Gap(10),
                                                    Text("Qualifications",
                                                        style: Styles
                                                            .cardDetailsTextStyleSubtitle1),
                                                    Text("MBBS (HK) 1957",
                                                        style: Styles
                                                            .cardDetailsTextStyleSubtitle2),
                                                    Gap(5),
                                                    Text("Specialties",
                                                        style: Styles
                                                            .cardDetailsTextStyleSubtitle1),
                                                    Text("General Practice",
                                                        style: Styles
                                                            .cardDetailsTextStyleSubtitle2),
                                                  ],
                                                )))
                                      ],
                                    ),
                                  ))
                            ]))))),
          ])),
        ]),
        drawer: const PatientDrawer(),
        floatingActionButton: const CustomFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const BottomNavBar());
  }
}
