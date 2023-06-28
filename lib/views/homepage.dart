import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/views/nearestClinicView.dart';
import 'package:fyp/views/topRatedDoctorsView.dart';

import '../style/app_layout.dart';
import 'login.dart';

class Homepage extends StatefulWidget {
  static const String routeName = '/home';
  const Homepage({Key? key, required this.isLogin}) : super(key: key);

  final bool isLogin;

  @override
  State<Homepage> createState() => _HomepageDetailsState();
}

class _HomepageDetailsState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {

    return
      // Scaffold(
      // extendBodyBehindAppBar: true,
      // resizeToAvoidBottomInset: false,
      // body:
      CustomScrollView(
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
                ),
              ],
            )
          ),
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: HomepageHeaderPersistentDelegate(),
          ),
          SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                if(widget.isLogin)
                /* Medical Record */
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Card(
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
                        Container(
                          padding: const EdgeInsets.only(right: 20),
                          child: NearestClinicView(),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 20),
                          child: NearestClinicView(),
                        ),
                        NearestClinicView(),
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
                  Row(children: const [
                    Expanded(
                      flex: 2,
                      child: Icon(Icons.event_outlined),
                    ),
                    Expanded(
                      flex: 2,
                      child: Icon(Icons.event_outlined),
                    ),
                    Expanded(
                      flex: 2,
                      child: Icon(Icons.event_outlined),
                    ),
                  ]),
                  Row(children: [
                    Expanded(
                      flex: 2,
                      child: Icon(Icons.event_outlined),
                    ),
                    Expanded(
                      flex: 2,
                      child: Icon(Icons.event_outlined),
                    ),
                    Expanded(
                      flex: 2,
                      child: Icon(Icons.event_outlined),
                    ),
                  ])
                ],
              ),
            ),
          ]))
        ],
      );
      // drawer: const PatientDrawer(),
      // floatingActionButton: const CustomFloatingActionButton(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: const BottomNavBar(),
    // );
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
