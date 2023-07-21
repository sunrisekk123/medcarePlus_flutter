import 'package:flutter/material.dart';
import 'package:fyp/models/common.dart';
import 'package:fyp/views/member/viewMyAppointmentDetails.dart';
import 'package:fyp/views/services/appointmentService.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/models/appointment.dart';
import 'package:fyp/style/app_layout.dart';
import 'package:fyp/views/common/loader.dart';

class MyAppointmentUserArea extends StatefulWidget {
  static const String routeName = '/my_appointment_user';

  const MyAppointmentUserArea({Key? key}) : super(key: key);

  @override
  State<MyAppointmentUserArea> createState() => _MyAppointmentUserAreaState();
}

class _MyAppointmentUserAreaState extends State<MyAppointmentUserArea> with SingleTickerProviderStateMixin{
  final AppointmentService appointmentService = AppointmentService();
  bool isExistPref = false;
  bool isExistWallet = false;
  List<AppointmentInfo> appointmentUpcomingList = [];
  List<AppointmentInfo> appointmentCompletedList = [];
  List<AppointmentInfo> appointmentCancelList = [];
  late TabController _tabController = TabController(length: 3, vsync: this);
  late ScrollController _scrollController = ScrollController();
  late bool fixedScroll = true;
  int allowCancelDate = 10000000;

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
    List<AppointmentInfo> appointmentAllList = await appointmentService.handleGetAppointment(context: context);
    int nowDateRecord = int.parse(nowDate.substring(0,4) + nowDate.substring(5,7) + nowDate.substring(8,10) + now.toString().substring(11, 13) + now.toString().substring(14, 16));
    setState(() {
      // C = Cancel, A = Active, D = Complete
      for(int i=0; i<appointmentAllList.length; i++){
        String date = appointmentAllList[i].date;
        String time = appointmentAllList[i].time;
        int thisRecord = int.parse(date.substring(0,4) + date.substring(5,7)+date.substring(8,10) + time.substring(0,2)+time.substring(3,5));
        if(appointmentAllList[i].status == "C"){
          print(appointmentAllList[i].status);
          appointmentCancelList.add(appointmentAllList[i]);
        }else if(appointmentAllList[i].status == "D"){
          appointmentCompletedList.add(appointmentAllList[i]);
        }else{
          appointmentUpcomingList.add(appointmentAllList[i]);
        }

      }
      String tempDateAllowed = DateTime.now().add(Duration(days: 2)).toString();
      allowCancelDate = int.parse(tempDateAllowed.substring(0,4)+tempDateAllowed.substring(5,7)+tempDateAllowed.substring(8,10));

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

  updateAppointmentStatus(AppointmentInfo appointment) async {
    appointmentService.cancelAppointmentByUserAddress(appointment: appointment ,context: context);
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
                        controller: _tabController,
                        labelColor: Colors.black87,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: "Upcoming"),
                          Tab(text: "Completed"),
                          Tab(text: "Canceled"),
                        ],
                      ),
                    ),),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              (appointmentUpcomingList.isNotEmpty ? _buildTabUpcoming(1)
                  : (appointmentUpcomingList.length == 0 ? Center(child: Text("No data")) : const Loader() )),
              (appointmentCompletedList.isNotEmpty ? _buildTabCompleted(1)
                  : (appointmentCompletedList.length == 0 ? Center(child: Text("No data")) : const Loader() )),
              (appointmentCancelList.isNotEmpty ? _buildTabCancel(1)
                  : (appointmentCancelList.length == 0 ? Center(child: Text("No data")) : const Loader() ))
            ],
          )
        ),
    );
  }


  _buildTabUpcoming(int lineCount) => Container(
    child: ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: lineCount,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: [
              for(int i=0;i<appointmentUpcomingList.length; i++)
                Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text("Dr. ${appointmentUpcomingList[i].doctor}"),
                                ),
                                subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${appointmentUpcomingList[i].clinicName}"),
                                      Gap(5),
                                      Text("${appointmentUpcomingList[i].clinicLocation}, ${appointmentUpcomingList[i].clinicDistrict}, ${appointmentUpcomingList[i].clinicArea}"),
                                    ]
                                ),
                                trailing:
                                CircleAvatar(
                                    radius:30,
                                    backgroundImage: AssetImage(appointmentUpcomingList[i].clinicImage.isNotEmpty ? appointmentUpcomingList[i].clinicImage : 'assets/images/clinic_sample.png')
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
                                            label: Text('${appointmentUpcomingList[i].date}'),
                                            labelStyle: TextStyle(fontSize: 12),
                                            backgroundColor: Color(0xfff7decd)
                                        )
                                    ),
                                    Expanded(
                                        child: Chip(
                                            avatar: const Icon(Icons.access_time_rounded),
                                            label: Text('${appointmentUpcomingList[i].time}'),
                                            labelStyle: TextStyle(fontSize: 12),
                                            backgroundColor: Color(0xfff7decd)
                                        )
                                    ),
                                    Expanded(
                                        child: Chip(
                                            avatar: const Icon(Icons.circle, color: Colors.green,),
                                            label: Text('${appointmentUpcomingList[i].status == 'A'? 'Confirmed' : appointmentUpcomingList[i].status == "D" ? "Completed" : "Canceled"}'),
                                            labelStyle: TextStyle(fontSize: 12),
                                            backgroundColor: Color(0xfff7decd)
                                        )
                                    ),
                                  ],
                                )
                            ),
                            if(int.parse(appointmentUpcomingList[i].date.substring(0,4)+appointmentUpcomingList[i].date.substring(5,7)+appointmentUpcomingList[i].date.substring(8,10)) > allowCancelDate)
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                                            onPressed: () {
                                              updateAppointmentStatus(appointmentUpcomingList[i]);
                                            }
                                        ),
                                      ),
                                      Gap(10),
                                      Expanded(
                                          child: ElevatedButton(
                                              child: const Text('Details', style: TextStyle(color: Colors.white)),
                                              onPressed: () {
                                                Navigator.pushNamed(context, MyAppointmentDetailsUserArea.routeName, arguments: {"appointmentData":appointmentUpcomingList[i]});
                                              }
                                          )
                                      )
                                    ],
                                  )
                              )
                            else
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: ElevatedButton(
                                              child: const Text('Details', style: TextStyle(color: Colors.white)),
                                              onPressed: () {
                                                Navigator.pushNamed(context, MyAppointmentDetailsUserArea.routeName, arguments: {"appointmentData":appointmentUpcomingList[i]});
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

  _buildTabCompleted(int lineCount) => Container(
    child: ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: lineCount,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            children: [
              for(int i=0;i<appointmentCompletedList.length; i++)
                Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text("Dr. ${appointmentCompletedList[i].doctor}"),
                                ),
                                subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${appointmentCompletedList[i].clinicName}"),
                                      Gap(5),
                                      Text("${appointmentCompletedList[i].clinicLocation}, ${appointmentCompletedList[i].clinicDistrict}, ${appointmentCompletedList[i].clinicArea}"),
                                    ]
                                ),
                                trailing:
                                CircleAvatar(
                                    radius:30,
                                    backgroundImage: AssetImage(appointmentCompletedList[i].clinicImage.isNotEmpty ? appointmentCompletedList[i].clinicImage : 'assets/images/clinic_sample.png')
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
                                            label: Text('${appointmentCompletedList[i].date}'),
                                            labelStyle: TextStyle(fontSize: 12),
                                            backgroundColor: Color(0xfff7decd)
                                        )
                                    ),
                                    Expanded(
                                        child: Chip(
                                            avatar: const Icon(Icons.access_time_rounded),
                                            label: Text('${appointmentCompletedList[i].time}'),
                                            labelStyle: TextStyle(fontSize: 12),
                                            backgroundColor: Color(0xfff7decd)
                                        )
                                    ),
                                    Expanded(
                                        child: Chip(
                                            avatar: const Icon(Icons.circle, color: Colors.blue,),
                                            label: Text('${appointmentCompletedList[i].status == 'A'? 'Confirmed' : appointmentCompletedList[i].status == 'D'? "Completed" : "Canceled"}'),
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                        child: ElevatedButton(
                                            child: const Text('Details', style: TextStyle(color: Colors.white)),
                                            onPressed: () {
                                              Navigator.pushNamed(context, MyAppointmentDetailsUserArea.routeName, arguments: {"appointmentData":appointmentCompletedList[i]});
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
                )
            ],
          ),
        );
      },
    ),
  );

  _buildTabCancel(int lineCount) => Container(
    child: ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: lineCount,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            children: [
              for(int i=0;i<appointmentCancelList.length; i++)
                Center(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text("Dr. ${appointmentCancelList[i].doctor}"),
                                  ),
                                  subtitle: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${appointmentCancelList[i].clinicName}"),
                                        Text("${appointmentCancelList[i].clinicLocation}, ${appointmentCancelList[i].clinicDistrict}, ${appointmentCancelList[i].clinicArea}"),
                                      ]
                                  ),
                                  trailing:
                                  CircleAvatar(
                                      radius:30,
                                      backgroundImage: AssetImage(appointmentCancelList[i].clinicImage.isNotEmpty ? appointmentCancelList[i].clinicImage : 'assets/images/clinic_sample.png')
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
                                              label: Text('${appointmentCancelList[i].date}'),
                                              labelStyle: TextStyle(fontSize: 12),
                                              backgroundColor: Color(0xfff7decd)
                                          )
                                      ),
                                      Expanded(
                                          child: Chip(
                                              avatar: const Icon(Icons.access_time_rounded),
                                              label: Text('${appointmentCancelList[i].time}'),
                                              labelStyle: TextStyle(fontSize: 12),
                                              backgroundColor: Color(0xfff7decd)
                                          )
                                      ),
                                      Expanded(
                                          child: Chip(
                                              avatar: const Icon(Icons.circle, color: Colors.red,),
                                              label: Text('${appointmentCancelList[i].status == 'A'? 'Confirmed' : appointmentCancelList[i].status == 'D'? "Completed" : "Canceled"}'),
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
                                              child: const Text('Details', style: TextStyle(color: Colors.white)),
                                              onPressed: () {
                                                Navigator.pushNamed(context, MyAppointmentDetailsUserArea.routeName, arguments: {"appointmentData":appointmentCancelList[i]});
                                              }
                                          )
                                      )
                                    ],)
                              )
                            ],
                          ),
                        )
                    )
                )
            ],
          ),
        );
      },
    ),
  );


}