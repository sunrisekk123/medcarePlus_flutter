import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fyp/views/clinic/clinicBookingPage.dart';
import 'package:fyp/views/login.dart';
import 'package:gap/gap.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/style/app_layout.dart';
import 'package:fyp/models/clinic.dart';
import 'package:fyp/views/common/bottomNavBar/bottomNavBar.dart';
import 'package:fyp/views/common/drawer/patientDrawer.dart';
import 'package:fyp/views/common/drawer/userDrawer.dart';
import 'package:fyp/models/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/views/common/component.dart';

class ClinicDetailsArea extends StatefulWidget {
  static const String routeName = '/clinic_details';
  const ClinicDetailsArea({Key? key, required this.clinic}) : super(key: key);
  final ClinicInfo clinic;

  @override
  State<ClinicDetailsArea> createState() => _ClinicDetailsAreaState();
}

class _ClinicDetailsAreaState extends State<ClinicDetailsArea> {
  bool isExistPref = false;
  bool isExistWallet = false;

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

  List<TextValue> areaList = [
    TextValue("Hong Kong Island", "HK"),
    TextValue("Kowloon", "KL"),
    TextValue("New Territories", "NT")
  ];

  String getAreaName(String area){
    TextValue result = areaList.firstWhere((element) => element.value==area);
    return result.text;
  }

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
                                  widget.clinic.imagePath.isNotEmpty ? widget.clinic.imagePath : 'assets/images/clinic_sample.png',
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
                                            widget.clinic.name,
                                            style: Styles.cardDetailsTextStyleTitle,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Gap(5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.locationDot,
                                                size: 14,
                                                color: Colors.red,
                                              ),
                                              Text(widget.clinic.district,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis),
                                            ],
                                          ),
                                          Gap(5),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                onPrimary: Colors.grey[100],
                                                primary: Styles.primaryColor,
                                                minimumSize: Size(88, 36),
                                                padding: EdgeInsets.symmetric(horizontal: 16),
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(2)),
                                                )),
                                            onPressed: () {
                                              if(isExistPref) {
                                                Navigator.pushNamed(context, ClinicBookingPageArea.routeName,
                                                    arguments: {"clinic": widget.clinic});
                                              } else {
                                                if(isExistWallet){
                                                  showSnackBar(
                                                    context,
                                                    'Please connect wallet first.',
                                                  );
                                                }else{
                                                  showSnackBar(
                                                    context,
                                                    'Please login first.',
                                                  );
                                                  Navigator.pushNamed(context, LoginPageDetails.routeName);
                                                }
                                              }
                                            },
                                            child: const Text('Make an appointment'),
                                          )
                                        ],
                                      )
                                  )
                              )
                            ],
                          ),
                        )
                    )
                )
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 20, 10),
                child: SizedBox(
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(children: [
                              ListTile(
                                title: Text("Address", style: TextStyle(fontWeight: FontWeight.w500),),
                                subtitle: Text(
                                    "\n${widget.clinic.address}, ${widget.clinic.district},  ${getAreaName(widget.clinic.area)}, Hong Kong",
                                    style: TextStyle(height: 1.3)),
                                dense: true,
                                visualDensity: VisualDensity(vertical: -3),
                              ),
                              Divider(),
                              ListTile(
                                title: Text("Open Hours", style: TextStyle(fontWeight: FontWeight.w500)),
                                subtitle: Text(
                                    widget.clinic.openingHrs.isNotEmpty ? widget.clinic.openingHrs : "\nSample Mon - Fri: 10:00am - 20:00pm\nSat - Sun: 12:00pm - 18:00pm",
                                    style: TextStyle(height: 1.3)),
                                dense: true,
                                visualDensity: VisualDensity(vertical: -3),
                              )
                            ])
                        )
                    )
                )
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 20, 10),
                child: SizedBox(
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(
                                children: [
                                  ListTile(
                                      dense: true,
                                      visualDensity: VisualDensity(vertical: -3),
                                      title: Text("Our Doctors", style: TextStyle(fontWeight: FontWeight.w500)),
                                      shape: Border(bottom: BorderSide(width: 1, color: Colors.black12, style: BorderStyle.solid))),
                                  for(int i=0; i<widget.clinic.doctorInfo.length; i++)
                                    ListTile(
                                      dense: true,
                                      visualDensity: VisualDensity(vertical: -3),
                                      title: Padding(
                                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  height: 100,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              widget.clinic.doctorInfo[i].imagePath.isNotEmpty ?
                                                              widget.clinic.doctorInfo[i].imagePath :
                                                              'assets/images/doctor_1.webp'),
                                                          fit: BoxFit.fill)),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: Padding(
                                                      padding: EdgeInsets.fromLTRB(20, 0, 2, 0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Dr. ${widget.clinic.doctorInfo[i].name}",
                                                            style: Styles.cardDetailsTextStyleTitle,
                                                            maxLines: 2,
                                                          ),
                                                          Gap(10),
                                                          Text("Qualifications", style: Styles.cardDetailsTextStyleSubtitle1),
                                                          for(int j=0; j<widget.clinic.doctorInfo[i].qualifications.length; j++)
                                                            Text(widget.clinic.doctorInfo[i].qualifications[j], style: Styles.cardDetailsTextStyleSubtitle2),
                                                          Gap(5),
                                                          Text("Specialties", style: Styles.cardDetailsTextStyleSubtitle1),
                                                          for(int j=0; j<widget.clinic.doctorInfo[i].services.length; j++)
                                                            Text(widget.clinic.doctorInfo[i].services[j], style: Styles.cardDetailsTextStyleSubtitle2),
                                                        ],
                                                      )
                                                  )
                                              )

                                            ]
                                        ),
                                      )

                                    ),
                              ]
                            )
                        )
                    )
                )
            ),
          ])),
        ]),
        drawer: !isExistPref ? UserDrawer() : PatientDrawer(),
        floatingActionButton: (isExistPref)? CustomFloatingActionButton() : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavBar(),
    );

  }
}
