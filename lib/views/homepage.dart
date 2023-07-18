import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fyp/views/services/homepageService.dart';
import 'package:fyp/views/services/loginService.dart';
import 'package:gap/gap.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/views/nearestClinicView.dart';
import 'package:fyp/views/topRatedDoctorsView.dart';
import 'package:fyp/views/login.dart';
import 'package:fyp/views/clinic/clinicDetails.dart';
import 'package:fyp/models/clinic.dart';
import 'package:fyp/views/common/loader.dart';
import 'package:fyp/views/member/healthRecordOverview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'clinic/scanQrcodePage.dart';

class Homepage extends StatefulWidget {
  static const String routeName = '/home';
  const Homepage({Key? key, required this.isLogin, required this.accountType}) : super(key: key);

  final bool isLogin;
  final String accountType;

  @override
  State<Homepage> createState() => HomepageDetailsState();
}

class HomepageDetailsState extends State<Homepage> {
  final HomepageService homeService = HomepageService();
  final LoginService loginService = LoginService();

  List<ClinicInfo> clinicList = [];
  String accountIs = "";
  bool isExistPref = false;
  bool isExistWallet = false;

  @override
  void initState(){
    //TODO: check if login or not, if login: change drawer and show e-health record
    super.initState();
    getSharePref();
    fetchHomeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchHomeData() async {
    List<ClinicInfo> list = await homeService.getHomepageData(context);
    if (mounted) {
      setState(() {
        clinicList = list;
      });
    }
  }

  getSharePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("x-auth-token");
    String? address = prefs.getString("user-address");
    String? accountType = prefs.getString("x-account");
    if (token != null && token.isNotEmpty && accountType != null) {
      setState(() {
        isExistPref = true;
        accountIs = accountType;
      });
    }
    if (address != null && address.isNotEmpty) {
      setState(() {
        isExistWallet = true;
      });
    }
  }

  logout() async {
    await loginService.logoutUser(context: context);
  }

  @override
  Widget build(BuildContext context) {

    return CustomScrollView(
        shrinkWrap: true,
        slivers: [
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
              )
            ),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if(widget.isLogin)
                  OutlinedButton.icon(
                    icon: Icon(Icons.logout_rounded),
                    label: Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.black54,
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      side: const BorderSide(
                        width: 5.0,
                        color: Colors.transparent,
                        style: BorderStyle.solid,
                      ),
                    ),
                    onPressed: () {
                      logoutConfirmPopupWindow(context);
                    },
                  )
                else
                  OutlinedButton.icon(
                    icon: Icon(Icons.login),
                    label: Text('Login'),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.black54,
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      side: const BorderSide(
                        width: 5.0,
                        color: Colors.transparent,
                        style: BorderStyle.solid,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPageDetails.routeName);
                    },
                  )
              ],
            )
          ),
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: HomepageHeaderPersistentDelegate(),
          ),
          !clinicList.isNotEmpty ? SliverList(delegate: SliverChildListDelegate(<Widget>[const Loader()]))
          : SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                if(widget.isLogin && accountIs == "MB")
                /* Medical Record */
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, HealthRecordOverviewUserArea.routeName);
                                },
                                child: Card(
                                  color: Color(0xFFF8F7F3),
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(30, 10, 20, 10),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                              'assets/images/medical_record_icon.png',
                                              height: 70,
                                              fit: BoxFit.fill),
                                          Text("View\nMedical Record",
                                              style: Styles.headLineStyle4,
                                              textAlign: TextAlign.center),
                                        ],
                                      )),
                                )
                              )
                            ])
                      ],
                    ),
                  ),
            /* Slider(Nearest Clinic) */
            Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nearest Clinic",
                          style: Styles.headLineStyle3,
                        ),
                        /* TODO: rotate map icon + current position */
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "View all",
                            style: Styles.headLineStyle5,
                          ),
                        )
                      ]),
                  Gap(10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        for(int i=0; i<clinicList.length; i++)
                          Container(
                            padding: const EdgeInsets.only(right: 20),
                            child: InkWell(
                              onTap: (){
                                Navigator.pushNamed(context, ClinicDetailsArea.routeName,
                                    arguments: {"clinic": clinicList[i]});
                              },
                                child: NearestClinicView(clinicData: clinicList[i])
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            /* Slider(Highest Rating Doctors) */
            Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Top Rated Doctors",
                          style: Styles.headLineStyle3,
                        ),
                        /* TODO: rotate map icon + current position */
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "View all",
                            style: Styles.headLineStyle5,
                          ),
                        )
                      ]),
                  Gap(10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 20),
                          child: TopRatedDoctorsView(),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 20),
                          child: TopRatedDoctorsView(),
                        ),
                        TopRatedDoctorsView(),
                      ],
                    ),
                  )
                ],
              ),
            ),
            /* Health News */
            Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: Column(
                children: [
                  ListTile(

                  ),
                  ListTile(

                  ),
                ],
              ),
            ),
          ]))
        ],
      );
  }

  Future<void> logoutConfirmPopupWindow(BuildContext context) async {
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
                              child: Icon(Icons.logout_rounded, size: 50.0),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text(
                                "Are you sure you want to logout?",
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
                                      logout();
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

class HomepageHeaderPersistentDelegate extends SliverPersistentHeaderDelegate {
  // void navigateToSearchScreen(String query) {
  //   Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  // }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    double shrinkPercentage = min(1, shrinkOffset / (maxExtent - minExtent));

    return Material(
      elevation: 0,
      shadowColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Stack(
              fit: StackFit.loose,
              alignment: Alignment.bottomCenter,
              children: [
                if (shrinkPercentage != 1)
                  Opacity(
                    opacity: 1 - shrinkPercentage,
                    child: _buildInformationWidget(context),
                  ),
                // if (shrinkPercentage != 0)
                //   Opacity(
                //     opacity: shrinkPercentage,
                //     child: Padding(
                //        padding: const EdgeInsets.symmetric(horizontal: 8),
                //        child: _buildCollapsedInformationWidget(),
                //      ),
                //   ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              height: max(
                80,
                100 * (1 - shrinkPercentage)-20,
              ),
            ),
            child: FittedBox(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                width: 350,
                child:
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            // onFieldSubmitted: navigateToSearchScreen,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 5),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none),
                                hintText: 'Search',
                                hintStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 13),
                                prefixIcon: Container(
                                  padding: const EdgeInsets.all(3),
                                  width: 18,
                                  child: const Icon(Icons.search),
                                )),
                          ),
                        ),
                      ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationWidget(BuildContext context) => ClipRect(
        child: OverflowBox(
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 55),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Find your nearest \nClinic",
                    style: Styles.headLineStyle1,
                  )
                ],
              ),
            ),
          ),
        ),
      );

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
