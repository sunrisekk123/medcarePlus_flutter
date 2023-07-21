import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fyp/models/clinic.dart';
import 'package:fyp/models/doctorClinic.dart';
import 'package:fyp/views/clinic/clinicDetails.dart';
import 'package:fyp/views/services/homepageService.dart';
import 'package:fyp/style/app_style.dart';

class DoctorAllView extends StatefulWidget {
  static const String routeName = '/view_doctor_all';
  const DoctorAllView({Key? key, required this.doctorList}) : super(key: key);
  final List<DoctorClinic> doctorList;

  @override
  State<DoctorAllView> createState() => _DoctorAllViewState();
}

class _DoctorAllViewState extends State<DoctorAllView> {
  final HomepageService homeService = HomepageService();
  List<ClinicInfo> clinicList = [];

  @override
  void initState(){
    super.initState();
    fetchHomeData();
  }

  fetchHomeData() async {
    List<ClinicInfo> list = await homeService.getHomepageData(context);
    if (mounted) {
      setState(() {
        clinicList = list;
      });
    }
  }

  ClinicInfo getClinicByDoctorId(String clinicId){
    ClinicInfo temp = ClinicInfo(id: clinicList[0].id ,
        walletAddress: clinicList[0].walletAddress ,
        email: clinicList[0].email, name: clinicList[0].name, password: clinicList[0].password,
        area: clinicList[0].area, district: clinicList[0].district,
        address: clinicList[0].address, phoneNo: clinicList[0].phoneNo, openingHrs: clinicList[0].openingHrs,
        active: clinicList[0].active, verified: clinicList[0].verified, imagePath: clinicList[0].imagePath,
        token: "", doctorInfo: []);
    for(int i=0; i<clinicList.length; i++){
      if(clinicList[i].id == clinicId){
        temp = clinicList[i];
      }
    }
    return temp;
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
              for(int i=0; i<widget.doctorList.length; i++)
                ListTile(
                  leading: Image.asset(widget.doctorList[i].imagePath.isNotEmpty? widget.doctorList[i].imagePath : 'assets/images/doctor_1.webp', fit: BoxFit.fill),
                  title: Text(widget.doctorList[i].name),
                  subtitle: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.locationDot,
                        size: 14,
                        color: Colors.red,
                      ),
                      Text(widget.doctorList[i].district, style: Styles.boxTextStyle2),
                    ],
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, ClinicDetailsArea.routeName,
                        arguments: {"clinic": getClinicByDoctorId(widget.doctorList[i].clinicId)});
                  },
                )
            ])),
      ]),
    );
  }
}
