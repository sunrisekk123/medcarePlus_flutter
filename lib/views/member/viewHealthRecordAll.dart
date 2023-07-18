import 'package:flutter/material.dart';
import 'package:fyp/views/member/viewHealthRecordDetails.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/style/app_layout.dart';
import 'package:fyp/views/services/healthRecordService.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/models/healthRecord.dart';

class HealthRecordViewAllUserArea extends StatefulWidget {
  static const String routeName = '/health_record_all_user';

  const HealthRecordViewAllUserArea({Key? key}) : super(key: key);

  @override
  State<HealthRecordViewAllUserArea> createState() => _HealthRecordViewAllUserAreaState();
}

class _HealthRecordViewAllUserAreaState extends State<HealthRecordViewAllUserArea> with SingleTickerProviderStateMixin{
  final HealthRecordService healthRecordService = HealthRecordService();
  bool isExistPref = false;
  bool isExistWallet = false;
  List<HealthRecord> recordList = [];
  late TabController _tabController = TabController(length: 3, vsync: this);
  late ScrollController _scrollController = ScrollController();
  late bool fixedScroll = true;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    _tabController.addListener(_smoothScrollToTop);
    super.initState();
    getSharePref();
    getHealthRecord();
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

  getHealthRecord() async {
    List<HealthRecord> temp = await healthRecordService.getHealthRecordDataUser(context);
      setState(() {
        recordList = temp;
      });
 
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (fixedScroll) {
      _scrollController.jumpTo(0);
    }
  }

  _smoothScrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(microseconds: 300),
      curve: Curves.ease,
    );
    setState(() {
      fixedScroll = _tabController.index == 2;
    });
  }

  _buildTabContext(int lineCount, List<HealthRecord> list) => Container(
    child: ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: lineCount,
      itemBuilder: (BuildContext context, int index) {
        return
          Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
            for(int i=0;i<list.length; i++)
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
                              title: Text(list[i].datetime, style: TextStyle(color: Colors.white)),
                              subtitle: Text(list[i].services, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18)),
                            ),
                          ListTile(
                              contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
                            title: Text(list[i].diagnosis, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Gap(5),
                                Text("Scheduled at time${list[i].datetime}", style: TextStyle(fontWeight: FontWeight.w500)),
                                Gap(3),
                                Text("Dr. ${list[i].doctor}", style: TextStyle(fontWeight: FontWeight.w500))
                              ],
                            ),
                            trailing: Icon(Icons.arrow_right_rounded),
                              onTap: (){
                                Navigator.pushNamed(context, HealthRecordViewDetailsUserArea.routeName, arguments: {"healthRecordData": list[i]});
                              }
                          )
                        ]
                    )
                )
                )
            ],
          ),
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              expandedHeight: 0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("My Health Records",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Image.asset(
                    'assets/images/bg_or1.jpg',
                    fit: BoxFit.cover,
                  )
              ),
            ),
            SliverAppBar(
              expandedHeight: 0,
              floating: false,
              pinned: true,
              centerTitle: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: "This year"),
                      Tab(text: "Last Year"),
                      Tab(text: "All"),
                    ],
                  ),
                ),
              ),

            ),
          ];
        },
        body: Container(
          child: TabBarView(
            controller: _tabController,
            children: [_buildTabContext(1,recordList), _buildTabContext(1,recordList), _buildTabContext(1,recordList)],
          ),
        ),
      ),
    );
  }
}
