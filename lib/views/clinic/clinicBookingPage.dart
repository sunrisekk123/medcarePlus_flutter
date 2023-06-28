import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../common/drawer/patientDrawer.dart';
import '../common/bottomNavBar/bottomNavBar.dart';
import 'package:fyp/style/app_style.dart';

import 'clinicBookingConfirmPage.dart';

// class ClinicBookingPage extends StatelessWidget {
//   const ClinicBookingPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MedCare Plus',
//       theme: ThemeData(
//         primarySwatch: colorCustom,
//       ),
//       home: const ClinicBookingPageArea(),
//     );
//   }
// }

class ClinicBookingPageArea extends StatefulWidget {
  const ClinicBookingPageArea({Key? key}) : super(key: key);

  @override
  State<ClinicBookingPageArea> createState() => _ClinicBookingPageAreaState();
}

class _ClinicBookingPageAreaState extends State<ClinicBookingPageArea> {
  bool _dateTileExpanded = true;
  bool _timeTileExpanded = false;
  DateTime selectedDate = DateTime.now();
  String selectedTime = "00:00";
  List<String> minsList = ["00", "15", "30", "45"];
  List<String> hoursList = [
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20"
  ];

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
            Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 20, 10),
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(children: [
                          ListTile(
                            title: Text("Reservation",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            dense: true,
                            visualDensity: VisualDensity(vertical: -3),
                          ),
                          ListTile(
                            title: Text("Clinic",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            subtitle: Text("\nCheng Hing Chung Clinic",
                                style: TextStyle(height: 1.3)),
                            dense: true,
                            visualDensity: VisualDensity(vertical: -3),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("Doctor",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            subtitle: Text("\nDr. Cheng Hing Chung",
                                style: TextStyle(height: 1.3)),
                            dense: true,
                            visualDensity: VisualDensity(vertical: -3),
                          ),
                          ExpansionTile(
                            key: GlobalKey(),
                            initiallyExpanded: _dateTileExpanded,
                            title: const Text('Date'),
                            subtitle: Text(
                                "Selected date: ${selectedDate.toString().substring(0, 10)}"),
                            trailing: Icon(_dateTileExpanded == true
                                ? Icons.arrow_drop_down_rounded
                                : Icons.arrow_left_rounded),
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _dateTileExpanded = expanded;
                              });
                            },
                            children: <Widget>[
                              ListTile(
                                  title: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.grey[100],
                                    primary: Styles.primaryColor,
                                    minimumSize: Size(88, 36),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2)),
                                    )),
                                onPressed: () {
                                  DatePicker.showDatePicker(
                                    context,
                                    showTitleActions: true,
                                    currentTime: selectedDate == DateTime.now()
                                        ? DateTime.now()
                                        : selectedDate,
                                    minTime: DateTime.now(),
                                    maxTime: (DateTime.now()
                                        .add(const Duration(days: 14))),
                                    onConfirm: (date) {
                                      setState(() {
                                        _dateTileExpanded = false;
                                        _timeTileExpanded = true;
                                        selectedDate = date;
                                      });
                                    },
                                    locale: LocaleType.en,
                                  );
                                },
                                child: Text(
                                    selectedDate.toString().substring(0, 10)),
                              )),
                            ],
                          ),
                          ExpansionTile(
                              key: GlobalKey(),
                              initiallyExpanded: _timeTileExpanded,
                              title: const Text('Time'),
                              subtitle: Text("Selected time: ${selectedTime}"),
                              trailing: Icon(_timeTileExpanded == true
                                  ? Icons.arrow_drop_down_rounded
                                  : Icons.arrow_left_rounded),
                              onExpansionChanged: (bool expanded) {
                                setState(() {
                                  _timeTileExpanded = expanded;
                                });
                              },
                              children: [
                                for (int a = 0; a < hoursList.length; a++) ...[
                                  Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                        child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5,
                                                                    vertical:
                                                                        10),
                                                            child: Text(
                                                                "${hoursList[a]}:00"))),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        for (int x = 0;
                                                            x < minsList.length;
                                                            x++) ...[
                                                          GestureDetector(
                                                              child: InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            onTap: () => {
                                                              // if not disable, then setStatus
                                                              setState(() {
                                                                selectedTime =
                                                                    "${hoursList[a]}:${minsList[x]}";
                                                                _timeTileExpanded =
                                                                    false;
                                                              }),
                                                            },
                                                            child: Card(
                                                              color: selectedTime ==
                                                                      "${hoursList[a]}:${minsList[x]}"
                                                                  ? Color(
                                                                      0xFFe68453)
                                                                  : Color(
                                                                      0xffffffff),
                                                              // color: Color(0xffe3e3e3),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                side:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade50,
                                                                  width: 1.0,
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          10),
                                                                  child:
                                                                      Container(
                                                                    child: Text(
                                                                        minsList[
                                                                            x],
                                                                        style: TextStyle(
                                                                            color: selectedTime == "${hoursList[a]}:${minsList[x]}"
                                                                                ? Color(0xffffffff)
                                                                                : Color(0xff000000))),
                                                                  )),
                                                            ),
                                                          ))
                                                        ],
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ]))),
                                ],
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                              ]),
                        ])))),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            backgroundColor: Color(0xFFe68453),
                            primary: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ClinicBookingConfirmPageArea()),
                          );
                        },
                        child: Text("Confirm"))
                  ],
                ))
          ])),
        ]),
        drawer: const PatientDrawer(),
        floatingActionButton: const CustomFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const BottomNavBar());
  }
}
