import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fyp/models/clinic.dart';
import 'package:fyp/views/clinic/clinicDetails.dart';
import 'package:fyp/views/nearestClinicView.dart';
import 'package:fyp/style/app_style.dart';

class ClinicAllView extends StatefulWidget {
  static const String routeName = '/view_clinic_all';
  const ClinicAllView({Key? key, required this.clinicList}) : super(key: key);
  final List<ClinicInfo> clinicList;

  @override
  State<ClinicAllView> createState() => _ClinicAllViewState();
}

class _ClinicAllViewState extends State<ClinicAllView> {

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
              for(int i=0; i<widget.clinicList.length; i++)
                  ListTile(
                    leading: Image.asset(widget.clinicList[i].imagePath.isNotEmpty? widget.clinicList[i].imagePath : 'assets/images/clinic_sample.png', fit: BoxFit.fill),
                    title: Text(widget.clinicList[i].name),
                    subtitle: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.locationDot,
                          size: 14,
                          color: Colors.red,
                        ),
                        Text(widget.clinicList[i].district, style: Styles.boxTextStyle2),
                      ],
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, ClinicDetailsArea.routeName, arguments: {"clinic": widget.clinicList[i]});
                    },
                  )
            ])),
      ]),
    );
  }
}
