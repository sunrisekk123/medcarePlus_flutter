import 'package:flutter/material.dart';
import 'package:fyp/models/common.dart';
import 'package:fyp/views/member/viewHealthRecordDetails.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/style/app_layout.dart';
import 'package:fyp/views/common/loader.dart';
import 'package:fyp/views/services/healthRecordService.dart';
import 'package:fyp/style/app_style.dart';

class TrustedHealthProviderAllArea extends StatefulWidget {
  static const String routeName = '/health_record_trusted_provider_user';

  const TrustedHealthProviderAllArea({Key? key}) : super(key: key);

  @override
  State<TrustedHealthProviderAllArea> createState() => _TrustedHealthProviderAllAreaState();
}

class _TrustedHealthProviderAllAreaState extends State<TrustedHealthProviderAllArea>{
  final HealthRecordService healthRecordService = HealthRecordService();
  bool isExistPref = false;
  bool isExistWallet = false;

  @override
  void initState() {
    super.initState();
    getSharePref();
  }

  getSharePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("x-auth-token");
    String? address = prefs.getString("user-address");
    if (token != null && token.isNotEmpty) {
      setState(() {
        isExistPref = true;
      });
    }
    if (address != null && address.isNotEmpty) {
      setState(() {
        isExistWallet = true;
      });
    }
  }

  _buildTabContext(int lineCount) => Container(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListTile(
                          tileColor: Styles.primaryColor,
                          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          leading: Icon(Icons.medical_services, color: Colors.white, size: 35,),
                          title: Text("Date", style: TextStyle(color: Colors.white)),
                          subtitle: Text("Services", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18)),
                        ),
                        ListTile(
                            contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
                            title: Text("Date", style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Gap(5),
                                Text("Scheduled at time", style: TextStyle(fontWeight: FontWeight.w500)),
                                Gap(3),
                                Text("Dr. ", style: TextStyle(fontWeight: FontWeight.w500))
                              ],
                            ),
                            trailing: Icon(Icons.arrow_right_rounded),
                            onTap: (){
                              Navigator.pushNamed(context, HealthRecordViewDetailsUserArea.routeName);
                            }
                        )
                      ]
                  )
              )
          )
        ],
      ),
    )
  );

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);

    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true, slivers: [
        SliverAppBar(
          expandedHeight: 0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text("Trusted Health Provider",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),
              background: Image.asset(
                'assets/images/bg_or1.jpg',
                fit: BoxFit.cover,
              )),
        ),
        SliverList(
            delegate: SliverChildListDelegate(
              [_buildTabContext(200), _buildTabContext(200), _buildTabContext(2)]
            ),
          ),
          ]
      )
    );
  }
}
