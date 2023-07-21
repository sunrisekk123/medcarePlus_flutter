import 'package:flutter/material.dart';
import 'package:fyp/models/common.dart';
import 'package:fyp/views/clinic/scanQrcodePage.dart';
import 'package:fyp/views/clinic/viewClinicAppointmentDetails.dart';
import 'package:fyp/views/services/appointmentService.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/models/appointment.dart';
import 'package:fyp/style/app_layout.dart';
import 'package:fyp/views/common/loader.dart';
import 'package:fyp/style/app_style.dart';

class MyAppointmentClinicArea extends StatefulWidget {
  static const String routeName = '/my_appointment_clinic';

  const MyAppointmentClinicArea({Key? key}) : super(key: key);

  @override
  State<MyAppointmentClinicArea> createState() => _MyAppointmentClinicAreaState();
}

class _MyAppointmentClinicAreaState extends State<MyAppointmentClinicArea> with SingleTickerProviderStateMixin{
  final AppointmentService appointmentService = AppointmentService();
  bool isExistPref = false;
  bool isExistWallet = false;
  List<AppointmentInfo> appointmentTodayList = [];
  List<AppointmentInfo> appointmentTomorrowList = [];
  List<AppointmentInfo> appointmentPlus2List = [];
  List<AppointmentInfo> appointmentPlus3List = [];
  List<AppointmentInfo> appointmentPlus4List = [];
  List<AppointmentInfo> appointmentPlus5List = [];
  late TabController _tabController = TabController(length: 6, vsync: this);
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
    List<AppointmentInfo> appointmentAllList = await appointmentService.handleGetAppointmentClinic(context: context);
    int nowDateRecord = int.parse(nowDate.substring(0,4) + nowDate.substring(5,7) + nowDate.substring(8,10) + now.toString().substring(11, 13) + now.toString().substring(14, 16));
    print(appointmentAllList);
    setState(() {
      for(int i=0; i<appointmentAllList.length; i++){
        String date = appointmentAllList[i].date;
        String time = appointmentAllList[i].time;
        int thisRecord = int.parse(date.substring(0,4) + date.substring(5,7)+date.substring(8,10) + time.substring(0,2)+time.substring(3,5));
        String thisRecordDate = date.substring(0,10);
        if(appointmentAllList[i].status == "A"){
          if(thisRecordDate == nowDate){
            appointmentTodayList.add(appointmentAllList[i]);
          }else if(thisRecordDate == DateTime.now().add(Duration(days: 1)).toString().substring(0, 10)){
            appointmentTomorrowList.add(appointmentAllList[i]);
          }else if(thisRecordDate == DateTime.now().add(Duration(days: 2)).toString().substring(0, 10)){
            appointmentPlus2List.add(appointmentAllList[i]);
          }else if(thisRecordDate == DateTime.now().add(Duration(days: 3)).toString().substring(0, 10)){
            appointmentPlus3List.add(appointmentAllList[i]);
          }else if(thisRecordDate == DateTime.now().add(Duration(days: 4)).toString().substring(0, 10)){
            appointmentPlus4List.add(appointmentAllList[i]);
          }else if(thisRecordDate == DateTime.now().add(Duration(days: 5)).toString().substring(0, 10)){
            appointmentPlus5List.add(appointmentAllList[i]);
          }
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

  updateAppointmentStatus(appointment){
    appointmentService.cancelAppointmentByClinicAddress(appointment: appointment, context: context);
  }

  String getDayPlus2() {
    String now = DateTime.now().add(Duration(days: 2)).toString().substring(0, 10);
    return "${now.substring(8,10)}/${now.substring(5,7)}";
  }

  String getDayPlus3() {
    String now = DateTime.now().add(Duration(days: 3)).toString().substring(0, 10);
    return "${now.substring(8,10)}/${now.substring(5,7)}";
  }

  String getDayPlus4() {
    String now = DateTime.now().add(Duration(days: 4)).toString().substring(0, 10);
    return "${now.substring(8,10)}/${now.substring(5,7)}";
  }

  String getDayPlus5() {
    String now = DateTime.now().add(Duration(days: 5)).toString().substring(0, 10);
    return "${now.substring(8,10)}/${now.substring(5,7)}";
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
                    title: Text("My Appointment",
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
                      isScrollable: true,
                      controller: _tabController,
                      labelColor: Colors.black87,
                      labelStyle: TextStyle(fontSize: 13),
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "Today"),
                        Tab(text: "Tomorrow"),
                        Tab(text: "${getDayPlus2()}"),
                        Tab(text: "${getDayPlus3()}"),
                        Tab(text: "${getDayPlus4()}"),
                        Tab(text: "${getDayPlus5()}"),
                      ],
                    ),
                  ),),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              (appointmentTodayList.isNotEmpty ? _buildTaContext(1, appointmentTodayList) : (appointmentTodayList.length == 0 ? Center(child: Text("No data")) : const Loader() )),
              (appointmentTomorrowList.isNotEmpty ? _buildTaContext(1, appointmentTomorrowList) : (appointmentTomorrowList.length == 0 ? Center(child: Text("No data")) : const Loader() )),
              (appointmentPlus2List.isNotEmpty ? _buildTaContext(1, appointmentPlus2List) : (appointmentPlus2List.length == 0 ? Center(child: Text("No data")) : const Loader() )),
              (appointmentPlus3List.isNotEmpty ? _buildTaContext(1, appointmentPlus3List) : (appointmentPlus3List.length == 0 ? Center(child: Text("No data")) : const Loader() )),
              (appointmentPlus4List.isNotEmpty ? _buildTaContext(1, appointmentPlus4List) : (appointmentPlus4List.length == 0 ? Center(child: Text("No data")) : const Loader() )),
              (appointmentPlus5List.isNotEmpty ? _buildTaContext(1, appointmentPlus5List) : (appointmentPlus5List.length == 0 ? Center(child: Text("No data")) : const Loader() )),
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
                                              if (states.contains(MaterialState.pressed)) { return Color(0xff646669); }
                                              return Color(0xff646669);
                                            }),
                                          ),
                                          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                                          onPressed: () {
                                            cancelAppointmentConfirmPopupWindow(context, list[i]);
                                          }
                                      ),
                                    ),
                                    Gap(10),
                                    Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                                            if (states.contains(MaterialState.disabled)) { return Colors.grey; }
                                            if (states.contains(MaterialState.pressed)) { return Styles.primaryColor; }
                                            return Styles.primaryColor;
                                          }),
                                        ),
                                          child: const Text('Scan QR Code', style: TextStyle(color: Colors.white)),
                                          onPressed: () {
                                            pushOtherPageAppointmentConfirmPopupWindow(context, "Are you sure to go to scan the patient QR code for insert electronic health record?", ScanQrCodeClinicArea.routeName, list[i]);
                                          }
                                      ),
                                    ),
                                    Gap(10),
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
                                              Navigator.pushNamed(context, MyAppointmentDetailsClinicArea.routeName,
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

  Future<void> pushOtherPageAppointmentConfirmPopupWindow(BuildContext context, String msg, String routeNamePush, AppointmentInfo appointmentData) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AlertDialog(
                      scrollable: true,
                      content: Column(children: <Widget>[
                        const Padding(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Color(0xFFF5F8FF),
                              child: Icon(Icons.gpp_maybe_outlined, size: 50.0),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text(
                                msg,
                                textAlign: TextAlign.center,
                                style: Styles.headLineStyle6)),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                                            if (states.contains(MaterialState.disabled)) { return Colors.grey; }
                                            if (states.contains(MaterialState.pressed)) { return const Color(0xff65ba79); }
                                            return Color(0xff70cf86);
                                          }),
                                        ),
                                        child: Text('Yes', style: Styles.buttonTextStyle1),
                                        onPressed: () {
                                          Navigator.popAndPushNamed(context, routeNamePush, arguments: {"appointmentId": appointmentData.appointmentId, "appointmentData":appointmentData});
                                        },
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                                            if (states.contains(MaterialState.disabled)) { return Colors.grey; }
                                            if (states.contains(MaterialState.pressed)) { return const Color(0xffb56d5e); }
                                            return Color(0xffd68272);
                                          }),
                                        ),
                                        child: Text('No',
                                            style: Styles.buttonTextStyle1),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  )

                              )
                            ]))
                      ]))
                ],
              ));
        });
  }


  Future<void> cancelAppointmentConfirmPopupWindow(BuildContext context, AppointmentInfo appointment) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AlertDialog(
                      scrollable: true,
                      content: Column(children: <Widget>[
                        const Padding(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Color(0xFFF5F8FF),
                              child: Icon(Icons.gpp_maybe_outlined, size: 50.0),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text(
                                "Are you sure you want to cancel this appointment?",
                                textAlign: TextAlign.center,
                                style: Styles.headLineStyle6)),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                                            if (states.contains(MaterialState.disabled)) { return Colors.grey; }
                                            if (states.contains(MaterialState.pressed)) { return const Color(0xff65ba79); }
                                            return Color(0xff70cf86);
                                          }),
                                        ),
                                        child: Text('Yes', style: Styles.buttonTextStyle1),
                                        onPressed: () {
                                          updateAppointmentStatus(appointment);
                                        },
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                                            if (states.contains(MaterialState.disabled)) { return Colors.grey; }
                                            if (states.contains(MaterialState.pressed)) { return const Color(0xffb56d5e); }
                                            return Color(0xffd68272);
                                          }),
                                        ),
                                        child: Text('No',
                                            style: Styles.buttonTextStyle1),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  )

                              )
                            ]))
                      ]))
                ],
              ));
        });
  }

}