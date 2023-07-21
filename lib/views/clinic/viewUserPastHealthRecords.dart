import 'package:flutter/material.dart';
import 'package:fyp/views/clinic/viewUserPastHealthRecordDetails.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/views/services/healthRecordService.dart';
import 'package:fyp/models/healthRecord.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/views/common/loader.dart';

class ViewUserHealthRecordArea extends StatefulWidget {
  static const String routeName = '/health_record_view_clinic';
  const ViewUserHealthRecordArea({Key? key, required this.userAddress}) : super(key: key);
  final String userAddress;

  @override
  State<ViewUserHealthRecordArea> createState() => _ViewUserHealthRecordAreaState();
}

class _ViewUserHealthRecordAreaState extends State<ViewUserHealthRecordArea> with SingleTickerProviderStateMixin{
  final HealthRecordService healthRecordService =  HealthRecordService();

  bool isExistPref = false;
  bool isExistWallet = false;
  List<HealthRecord> recordList = [];
  List<HealthRecord> recordThisYrList = [];
  List<HealthRecord> recordLastYrList = [];
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
    int nowYear = int.parse(DateTime.now().toString().substring(0, 4));

    List<HealthRecord> temp = await healthRecordService.getHealthRecordDataClinic(context,widget.userAddress);
    print(temp);
    setState(() {
      recordList = temp;
      for(int i=0; i<temp.length; i++){
        int year = int.parse(temp[i].datetime.substring(0,4));
        if(year == nowYear){
          recordThisYrList.add(temp[i]);
        }else if(year == (nowYear+1)){
          recordLastYrList.add(temp[i]);
        }
      }
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
                                  title: Text("${list[i].datetime.substring(0,4)}-${list[i].datetime.substring(4,6)}-${list[i].datetime.substring(6,8)}", style: TextStyle(color: Colors.white)),
                                  subtitle: Text(list[i].services, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18)),
                                ),
                                ListTile(
                                    contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
                                    title: Text(list[i].diagnosis, style: TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Gap(5),
                                        Text("Scheduled at time ${list[i].datetime.substring(8,10)}:${list[i].datetime.substring(10,12)}", style: TextStyle(fontWeight: FontWeight.w500)),
                                        Gap(3),
                                        Text("Dr. ${list[i].doctor}", style: TextStyle(fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                    trailing: Icon(Icons.arrow_right_rounded),
                                    onTap: (){
                                      Navigator.pushNamed(context, ViewUserHealthRecordDetailsArea.routeName, arguments: {"healthRecordData": list[i]});
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
            children: [
              recordThisYrList.isNotEmpty ? _buildTabContext(1,recordThisYrList) : (recordThisYrList.length == 0 ? Center(child: Text("No data")) : const Loader()) ,
              recordLastYrList.isNotEmpty ? _buildTabContext(1,recordLastYrList) : (recordLastYrList.length == 0 ? Center(child: Text("No data")) : const Loader()) ,
              recordList.isNotEmpty ? _buildTabContext(1,recordList) : (recordList.length == 0 ? Center(child: Text("No data")) : const Loader())
            ],
          ),
        ),
      ),
    );
  }
}
