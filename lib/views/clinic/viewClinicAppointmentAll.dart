import 'package:flutter/material.dart';
import 'package:fyp/models/common.dart';
import 'package:fyp/views/clinic/viewClinicAppointmentDetails.dart';
import 'package:fyp/views/services/appointmentService.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/models/appointment.dart';
import 'package:fyp/style/app_layout.dart';
import 'package:fyp/views/common/loader.dart';

class MyAppointmentAllClinicArea extends StatefulWidget {
  static const String routeName = '/my_appointment_all_clinic';

  const MyAppointmentAllClinicArea({Key? key}) : super(key: key);

  @override
  State<MyAppointmentAllClinicArea> createState() => _MyAppointmentAllClinicAreaState();
}

class _MyAppointmentAllClinicAreaState extends State<MyAppointmentAllClinicArea> with SingleTickerProviderStateMixin{
  final AppointmentService appointmentService = AppointmentService();
  bool isExistPref = false;
  bool isExistWallet = false;
  List<AppointmentInfo> appointmentAllList = [];
  List<AppointmentInfo> appointmentCompletedList = [];
  List<AppointmentInfo> appointmentCancelList = [];
  late TabController _tabController = TabController(length: 3, vsync: this);
  late ScrollController _scrollController = ScrollController();
  late bool fixedScroll = true;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    _tabController.addListener(_smoothScrollToTop);
    super.initState();
    getSharePref();
    fetchAppointment();
  }


  fetchAppointment() async{
    DateTime now = new DateTime.now();
    String nowDate = DateTime.now().toString().substring(0, 10);
    List<AppointmentInfo> fetchedAppointmentAllList = await appointmentService.handleGetAppointmentClinic(context: context);
    int nowDateRecord = int.parse(nowDate.substring(0,4) + nowDate.substring(5,7) + nowDate.substring(8,10) + now.toString().substring(11, 13) + now.toString().substring(14, 16));
    setState(() {
      appointmentAllList = fetchedAppointmentAllList;

      for(int i=0; i<fetchedAppointmentAllList.length; i++){
        String date = fetchedAppointmentAllList[i].date;
        String time = fetchedAppointmentAllList[i].time;
        int thisRecord = int.parse(date.substring(0,4) + date.substring(5,7)+date.substring(8,10) + time.substring(0,2)+time.substring(3,5));
        String thisRecordDate = date.substring(0,10);
        // C = Cancel, A = Active, D = Complete
        if(appointmentAllList[i].status == "C"){
          appointmentCancelList.add(appointmentAllList[i]);
        }else if(appointmentAllList[i].status == "D"){
          appointmentCompletedList.add(appointmentAllList[i]);
        }

      }
    });
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

  List<TextValue> areaList = [
    TextValue("Hong Kong Island", "HK"),
    TextValue("Kowloon", "KL"),
    TextValue("New Territories", "NT")
  ];

  String getAreaName(String area) {
    TextValue result = areaList.firstWhere((element) => element.value == area);
    return result.text;
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);

    return Scaffold(
      body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text("All Appointment",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                    background: Image.asset(
                      'assets/images/bg_or1.jpg',
                      fit: BoxFit.cover,
                    )),
              ),
              SliverAppBar(
                expandedHeight: 0,
                floating: false,
                pinned: true,
                centerTitle: true,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Container(
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "All"),
                        Tab(text: "Complete"),
                        Tab(text: "Cancel"),
                      ],
                    ),
                  ),),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              (appointmentAllList.isNotEmpty ? _buildTaContext(1,appointmentAllList) : (appointmentAllList.length == 0 ? Center(child: Text("No data")) : const Loader() )),
              (appointmentCompletedList.isNotEmpty ? _buildTaContext(1,appointmentCompletedList) : (appointmentCompletedList.length == 0 ? Center(child: Text("No data")) : const Loader() )),
              (appointmentCancelList.isNotEmpty ? _buildTaContext(1,appointmentCancelList) : (appointmentCancelList.length == 0 ? Center(child: Text("No data")) : const Loader() )),
            ],
          )
      ),
    );
  }

  _buildTaContext(int lineCount, List<AppointmentInfo> list) => Container(
    child: ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: lineCount,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              for(int i=0;i<list.length; i++)
                Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text("${list[i].userFName} ${list[i].userLName}"),
                                ),
                                subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("+852 ${list[i].userPhone}"),
                                      Gap(5),
                                      Text("${list[i].userBirthDate}"),
                                    ]
                                )
                            ),
                            Divider(
                              height: 4,
                              thickness: 2,
                              indent: 10,
                              endIndent: 10,
                              color: Colors.black12,
                            ),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Chip(
                                            avatar: const Icon(Icons.date_range_rounded),
                                            label: Text('${list[i].date}'),
                                            labelStyle: TextStyle(fontSize: 12),
                                            backgroundColor: Color(0xfff7decd)
                                        )
                                    ),
                                    Expanded(
                                        child: Chip(
                                            avatar: const Icon(Icons.access_time_rounded),
                                            label: Text('${list[i].time}'),
                                            labelStyle: TextStyle(fontSize: 12),
                                            backgroundColor: Color(0xfff7decd)
                                        )
                                    ),
                                    Expanded(
                                        child: Chip(
                                            avatar: const Icon(Icons.circle, color: Colors.green,),
                                            label: Text('${list[i].status == 'A'? 'Confirmed' : list[i].status == 'D'? 'Complete' : 'Cancel'}'),
                                            labelStyle: TextStyle(fontSize: 12),
                                            backgroundColor: Color(0xfff7decd)
                                        )
                                    ),
                                  ],
                                )
                            ),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                if (states.contains(MaterialState.disabled)) { return Colors.grey; }
                                                if (states.contains(MaterialState.pressed)) { return const Color(0xff1f5aa6); }
                                                return Color(0xff1f5aa6);
                                              }),
                                            ),
                                            child: const Text('Details', style: TextStyle(color: Colors.white)),
                                            onPressed: () {
                                              Navigator.popAndPushNamed(context, MyAppointmentDetailsClinicArea.routeName,
                                                  arguments: {"appointmentId": list[i]});
                                            }
                                        )
                                    )
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                    )
                ),
            ],
          ),
        );
      },
    ),
  );
}