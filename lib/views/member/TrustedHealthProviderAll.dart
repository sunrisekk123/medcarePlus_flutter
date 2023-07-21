import 'package:flutter/material.dart';
import 'package:fyp/models/healthProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/style/app_layout.dart';
import 'package:fyp/views/services/healthRecordService.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/views/common/component.dart';
import 'package:fyp/views/common/loader.dart';

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
  List<HealthProvider> providerList = [];

  @override
  void initState() {
    super.initState();
    getSharePref();
    fetchTrustHealthProvider();
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

  fetchTrustHealthProvider() async {
    List<HealthProvider> temp = await healthRecordService.getTrustHealthProviderUser(context);
    setState(() {
      providerList = temp;
    });
  }

  updateTrustedHealthProvider(HealthProvider providerData, String status) async{
    await healthRecordService.updateTrustHealthProviderStatusUser(context, providerData, status)
        .then((value) => {
          if(value){
            setState(() {
              fetchTrustHealthProvider();
            })
          }else{
            showSnackBar(context, "Revoke unsuccessful")
          }
        });
  }

  _buildTabContext(int lineCount) => Container(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          for(int i=0;i<providerList.length; i++)
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
                          leading: Icon(Icons.add_task_rounded , color: Colors.white, size: 35,),
                          title: Text("${providerList[i].clinicName}", style: TextStyle(color: Colors.white)),
                          subtitle: Text("Status: ${providerList[i].status == 'A' ? "Active": "Inactive"}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18)),
                        ),
                        ListTile(
                            contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                            title: Text("Updated at: ${providerList[i].date.substring(0,4)}-${providerList[i].date.substring(4,6)}-${providerList[i].date.substring(6,8)} ${providerList[i].time.substring(0,2)}:${providerList[i].time.substring(2,4)}", style: TextStyle(fontWeight: FontWeight.w500)),
                            subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if(providerList[i].status == "A")
                                      Expanded(
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                if (states.contains(MaterialState.disabled)) { return Colors.grey; }
                                                if (states.contains(MaterialState.pressed)) { return Colors.red; }
                                                return Colors.red;
                                              }),
                                            ),
                                            child: Text('Revoke', style: Styles.buttonTextStyle1),
                                            onPressed: () {
                                              updateTrustedHealthProvider(providerList[i], "N");
                                            },
                                          )
                                      )
                                  ],
                                )
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
              [providerList.isNotEmpty ? _buildTabContext(1) : (providerList.length == 0 ? Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20),child: Center(child: Text("No trust health provider"),)) : const Loader())]
            ),
          ),
          ]
      )
    );
  }
}
