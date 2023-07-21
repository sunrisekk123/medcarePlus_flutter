import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fyp/models/clinic.dart';
import 'package:fyp/views/clinic/clinicDetails.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/views/services/homepageService.dart';

class SearchAllView extends StatefulWidget {
  static const String routeName = '/search';
  const SearchAllView({Key? key}) : super(key: key);

  @override
  State<SearchAllView> createState() => _SearchAllViewState();
}

class _SearchAllViewState extends State<SearchAllView> {
  final HomepageService homeService = HomepageService();
  List<ClinicInfo> clinicList = [];
  List<ClinicInfo> filteredClinicList = [];
  TextEditingController _searchController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  void initState(){
    super.initState();
    fetchHomeData();
  }

  fetchHomeData() async {
    List<ClinicInfo> list = await homeService.getHomepageData(context);
    if (mounted) {
      setState(() {
        clinicList = list;
        filteredClinicList = list;
      });
    }
  }


  getFilterList(String text){
    print(text);
    List<ClinicInfo> tempList = clinicList;
    var tempNameFiltered = tempList.where((e) => (e.name.contains(text)) ||  e.district.contains(text) );

    setState(() {
      filteredClinicList = tempNameFiltered.toList();
    });
  }

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
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: TextFormField(
                      controller: _searchController,
                        cursorColor: Colors.grey,
                        autofocus: true,
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
                        onChanged: (String c) {
                          getFilterList(c);
                        },
                    onTap:(){

                        }
                    ),
                  ),
                ],
              ),
              for(int i=0; i<filteredClinicList.length; i++)
                ListTile(
                  leading: Image.asset(filteredClinicList[i].imagePath.isNotEmpty? filteredClinicList[i].imagePath : 'assets/images/clinic_sample.png', fit: BoxFit.fill),
                  title: Text(filteredClinicList[i].name),
                  subtitle: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.locationDot,
                        size: 14,
                        color: Colors.red,
                      ),
                      Text(filteredClinicList[i].district, style: Styles.boxTextStyle2),
                    ],
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, ClinicDetailsArea.routeName, arguments: {"clinic": filteredClinicList[i]});
                  },
                )
            ])),
      ]),
    );
  }
}
