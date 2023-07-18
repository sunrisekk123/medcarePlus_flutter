import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/models/clinic.dart';
import 'package:fyp/style/app_layout.dart';
import 'package:fyp/models/common.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/models/user.dart';
import 'package:fyp/views/services/homepageService.dart';
import 'package:fyp/views/common/loader.dart';
import 'package:fyp/style/app_style.dart';
import 'package:fyp/views/common/component.dart';
import 'package:fyp/views/services/loginService.dart';

class ClinicInfoArea extends StatefulWidget {
  static const String routeName = '/personal_profile_clinic';
  const ClinicInfoArea({Key? key}) : super(key: key);

  @override
  State<ClinicInfoArea> createState() => _ClinicInfoAreaState();
}

class _ClinicInfoAreaState extends State<ClinicInfoArea> {
  final HomepageService homeService = HomepageService();
  final LoginService loginService = LoginService();
  bool isExistPref = false;
  bool isExistWallet = false;
  List<ClinicInfo> clinicList = [];
  bool _passwordEdit = false;
  bool _nameEdit = false;
  bool _phoneEdit = false;
  bool _addressEdit = false;
  bool _areaEdit = false;
  bool _districtEdit = false;
  bool _openingHrsEdit = false;
  bool _showPassword = false;
  String _area = "";
  String _district = "";
  List<District> districtListOri = [];
  List<District> districtList = [];
  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String selectDate = "";
  String _monFromHr = "";
  String _monFromMin = "";
  String _monToHr = "";
  String _monToMin = "";
  String _tueFromHr = "";
  String _tueFromMin = "";
  String _tueToHr = "";
  String _tueToMin = "";
  String _wedFromHr = "";
  String _wedFromMin = "";
  String _wedToHr = "";
  String _wedToMin = "";
  String _thurFromHr = "";
  String _thurFromMin = "";
  String _thurToHr = "";
  String _thurToMin = "";
  String _friFromHr = "";
  String _friFromMin = "";
  String _friToHr = "";
  String _friToMin = "";
  String _satFromHr = "";
  String _satFromMin = "";
  String _satToHr = "";
  String _satToMin = "";
  String _sunFromHr = "";
  String _sunFromMin = "";
  String _sunToHr = "";
  String _sunToMin = "";
  String _openingHrsJson = "";

  @override
  void initState(){
    super.initState();
    getSharePref();
    fetchClinicData();
    fetchDistrictOptions();
  }

  fetchClinicData() async {
    List<ClinicInfo> clinicInfo = await homeService.getClinicDataByEmail(context);
    setState(() {
      clinicList = clinicInfo;
    });
  }

  fetchDistrictOptions() async {
    List<District> list = await loginService.getDistrictOptions(context);
    List<District> resultList = [];
    for (var element in list) {
      if (element.area == areaList[0].value) {
        resultList.add(element);
      }
    }
    setState(() {
      _area = areaList[0].value;
      _district = resultList[0].district;
      districtList = resultList;
      districtListOri = list;
    });
  }

  getSharePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("x-auth-token");
    String? address = prefs.getString("user-address");
    if(token != null && token.isNotEmpty ){
      setState(() {
        isExistPref = true;
      });
    }
    if(address != null && address.isNotEmpty){
      setState(() {
        isExistWallet = true;
      });
    }
  }

  void _toggleVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  List<TextValue> areaList = [
    TextValue("Hong Kong Island", "HK"),
    TextValue("Kowloon", "KL"),
    TextValue("New Territories", "NT")
  ];

  String getAreaName(String area){
    TextValue result = areaList.firstWhere((element) => element.value==area);
    return result.text;
  }

  Future<bool> updatePersonalInfoCall() {
    return homeService.updateClinicInfo(
        context: context,
        password: _passwordEdit ? _passwordController.text : "",
        openingHrs: _openingHrsEdit ? _openingHrsJson : "",
        area: _areaEdit ? _area : "",
        district: _districtEdit ? _district : "",
        address: _addressEdit ? _addressController.text : "",
        phone: _phoneEdit ? _phoneController.text : "",
        name: _nameEdit ? _nameController.text : ""
    );
  }


  Future<bool> updatePersonalInfo() async {
    bool isSuccessful = await updatePersonalInfoCall();
    return isSuccessful;
  }

  List<String> hourSelection = [
    "01","02","03","04","05","06","07","08",
    "09","10","11","12","13","14","15",
    "16","17","18","19","20","21","22","23","24"
  ];

  List<String> minSelection = [
    "00","15","30","45"
  ];
  List<String> weekdaySelection = [
    "Mon","Tue","Wed","Thur","Fri","Sat","Sun"
  ];

  getOpeningHrsText(){
    _openingHrsJson = jsonEncode([{
      "mon": "$_monFromHr$_monFromMin-$_monToHr$_monToMin",
      "tue": "$_tueFromHr$_tueFromMin-$_tueToHr$_tueToMin",
      "wed": "$_wedFromHr$_wedFromMin-$_wedToHr$_wedToMin",
      "thur": "$_thurFromHr$_thurFromMin-$_thurToHr$_thurToMin",
      "fri": "$_friFromHr$_friFromMin-$_friToHr$_friToMin",
      "sat": "$_satFromHr$_satFromMin-$_satToHr$_satToMin",
      "sun": "$_sunFromHr$_sunFromMin-$_sunToHr$_sunToMin"
    }]);
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    var personalInfoFormKey = GlobalKey();

    return Scaffold(
      body: CustomScrollView(shrinkWrap: true, slivers: [
        SliverAppBar(
            pinned: true,
            floating: false,
            elevation: 0,
            expandedHeight: 130,
            backgroundColor: Colors.transparent,
            flexibleSpace:
            ClipPath(
                clipper: CurveClipper(),
                child: Container(
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
                    height: 130.0,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                        child: Column(
                          children: [
                            Text("Clinic Info", style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: "RobotoMono"
                            ))
                          ],
                        )
                    )
                )
            )
        ),
        !clinicList.isNotEmpty ?  SliverList(delegate: SliverChildListDelegate(<Widget>[const Loader()])) :
        SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              Form(
                  key: personalInfoFormKey,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Container(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text("Wallet Address"),
                              subtitle: Text(clinicList[0].walletAddress),
                              trailing: TextButton(
                                child: Icon(Icons.copy),
                                onPressed: () async {
                                  await Clipboard.setData(ClipboardData(text: clinicList[0].walletAddress));
                                },
                              ),
                            ),
                            ListTile(
                              title: Text("Email Address"),
                              subtitle: Text(clinicList[0].email),
                            ),
                            ListTile(
                                title: Text("Password"),
                                subtitle: ((!_passwordEdit) ? Text("***"):
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: UnderlineInputBorder(),
                                    labelText: 'Enter new password',
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        _toggleVisibility();
                                      },
                                      child: Icon(
                                        _showPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ),
                                  validator: (v) {
                                    return passwordValidator(v);
                                  },
                                )
                                ),
                                trailing: IconButton(
                                  icon: (!_passwordEdit) ? Icon(Icons.create_outlined) : Icon(Icons.check_rounded),
                                  onPressed: () {
                                    if(_passwordEdit){
                                      if(_passwordController.text.isNotEmpty && passwordValidator(_passwordController.text) == null){
                                        setState(() {
                                          _passwordEdit = !_passwordEdit;
                                        });
                                      }else{
                                        showSnackBar(context, "Please enter valid password");
                                      }
                                    }else{
                                      setState(() {
                                        _passwordEdit = !_passwordEdit;
                                      });
                                    }
                                  },
                                )
                            ),
                            ListTile(
                                title: Text("Name"),
                                subtitle: ((!_nameEdit) ? (_nameController.text.isNotEmpty ? Text('${_nameController.text}') : Text('${clinicList[0].name}')) :
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _nameController,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: 'Name',
                                        ),
                                        validator: (v) {
                                          return v!.trim().isNotEmpty ? null : "Cannot be empty";
                                        },
                                      ),
                                    ),
                                  ],
                                )
                                ),
                                trailing: IconButton(
                                  icon: (!_nameEdit) ? Icon(Icons.create_outlined) : Icon(Icons.check_rounded),
                                  onPressed: () {
                                    if(_nameEdit){
                                      if(_nameController.text.isNotEmpty){
                                        setState(() {
                                          _nameEdit = !_nameEdit;
                                        });
                                      }else{
                                        showSnackBar(context, "Please enter valid password");
                                      }
                                    }else{
                                      setState(() {
                                        _nameEdit = !_nameEdit;
                                      });
                                    }
                                  },
                                )
                            ),
                            ListTile(
                                title: Text("Phone Number"),
                                subtitle: (!_phoneEdit) ? (_phoneController.text.isNotEmpty ? Text('+852 ${_phoneController.text}') : Text('+852 ${clinicList[0].phoneNo}'))  :
                                TextFormField(
                                  controller: _phoneController,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Enter new phone number',
                                    prefixText: '+852 ',
                                  ),
                                  validator: (v) {
                                    return v!.trim().isNotEmpty ? null : "Cannot be empty";
                                  },
                                ),
                                trailing: IconButton(
                                  icon: (!_phoneEdit) ? Icon(Icons.create_outlined) : Icon(Icons.check_rounded),
                                  onPressed: () {
                                    if(_phoneEdit){
                                      if(_phoneController.text.isNotEmpty){
                                        setState(() {
                                          _phoneEdit = !_phoneEdit;
                                        });
                                      }else{
                                        showSnackBar(context, "Please enter phone number before saved");
                                      }
                                    }else{
                                      setState(() {
                                        _phoneEdit = !_phoneEdit;
                                      });
                                    }

                                  },
                                )
                            ),
                            ListTile(
                                title: Text("Area"),
                                subtitle: (!_areaEdit) ? (_area.isNotEmpty ? Text('${_area}') : Text('${clinicList[0].area}')) :
                                DropdownButtonFormField(
                                    value: areaList[0].value,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 12,
                                    isExpanded: true,
                                    style: TextStyle(fontSize: 13, color: Colors.black),
                                    onChanged: (value) {
                                      List<District> oriList =
                                          districtListOri;
                                      List<District> resultList = [];
                                      for (var element in oriList) {
                                        if (element.area == value) {
                                          resultList.add(element);
                                        }
                                      }
                                      setState(() {
                                        _area = value.toString();
                                        _district = resultList[0].district;
                                        districtList = resultList;
                                      });
                                    },
                                    validator: (value) => value == null ? "Area cannot be empty" : null,
                                    items: areaList.map(
                                            (e) => DropdownMenuItem<String>(
                                            value: e.value,
                                            child: Row(children: [Text(e.text)],
                                            ))
                                    ).toList()),
                                trailing: IconButton(
                                  icon: (!_areaEdit) ? Icon(Icons.create_outlined) : Icon(Icons.check_rounded),
                                  onPressed: () {
                                    if(_areaEdit){
                                      if(_area.isNotEmpty){
                                        setState(() {
                                          _areaEdit = !_areaEdit;
                                        });
                                      }else{
                                        showSnackBar(context, "Please enter address before saved");
                                      }
                                    }else{
                                      setState(() {
                                        _areaEdit = !_areaEdit;
                                      });
                                    }
                                  },
                                )
                            ),
                            ListTile(
                                title: Text("District"),
                                subtitle: (!_districtEdit) ? (_district.isNotEmpty ? Text('${_district}') : Text('${clinicList[0].address}')) :
                                DropdownButtonFormField(
                                    value: _district.isNotEmpty ? _district : districtList[0].district,
                                    icon: const Icon(Icons.arrow_downward),
                                    style: TextStyle(fontSize: 13, color: Colors.black),
                                    elevation: 12,
                                    isExpanded: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _district =
                                            value.toString();
                                      });
                                    },
                                    items: districtList.map((e) =>
                                        DropdownMenuItem<String>(
                                            value: e.district,
                                            child: Row(
                                              children: [
                                                Text(e.district)
                                              ],
                                            ))).toList()),
                                trailing: IconButton(
                                  icon: (!_districtEdit) ? Icon(Icons.create_outlined) : Icon(Icons.check_rounded),
                                  onPressed: () {
                                    if(_districtEdit){
                                      if(_district.isNotEmpty){
                                        setState(() {
                                          _districtEdit = !_districtEdit;
                                        });
                                      }else{
                                        showSnackBar(context, "Please enter address before saved");
                                      }
                                    }else{
                                      setState(() {
                                        _districtEdit = !_districtEdit;
                                      });
                                    }
                                  },
                                )
                            ),
                            ListTile(
                                title: Text("Address"),
                                subtitle: (!_addressEdit) ? (_addressController.text.isNotEmpty ? Text('${_addressController.text}') : Text('${clinicList[0].address}')) :
                                TextFormField(
                                  controller: _addressController,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Enter new address',
                                  ),
                                  validator: (v) {
                                    return v!.trim().isNotEmpty ? null : "Cannot be empty";
                                  },
                                ),
                                trailing: IconButton(
                                  icon: (!_addressEdit) ? Icon(Icons.create_outlined) : Icon(Icons.check_rounded),
                                  onPressed: () {
                                    if(_addressEdit){
                                      if(_addressController.text.isNotEmpty){
                                        setState(() {
                                          _addressEdit = !_addressEdit;
                                        });
                                      }else{
                                        showSnackBar(context, "Please enter address before saved");
                                      }
                                    }else{
                                      setState(() {
                                        _addressEdit = !_addressEdit;
                                      });
                                    }
                                  },
                                )
                            ),
                            ListTile(
                                title: Text("Opening Hours"),
                                subtitle: (!_openingHrsEdit) ? (_openingHrsJson.isNotEmpty ? Text('${_openingHrsJson}') : Text('${clinicList[0].openingHrs}')) :
                                Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Text("Mon"),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "10",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _monFromHr = value.toString();
                                                    });
                                                  },
                                                  items: hourSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "10",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _monFromMin = value.toString();
                                                    });
                                                  },
                                                  items: minSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "18",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _monToHr = value.toString();
                                                    });
                                                  },
                                                  items: hourSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "00",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _monToMin = value.toString();
                                                    });
                                                  },
                                                  items: minSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text("Tue"),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "10",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _tueFromHr = value.toString();
                                                    });
                                                  },
                                                  items: hourSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "10",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _tueFromMin = value.toString();
                                                    });
                                                  },
                                                  items: minSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "18",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _tueToHr = value.toString();
                                                    });
                                                  },
                                                  items: hourSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "00",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _tueToMin = value.toString();
                                                    });
                                                  },
                                                  items: minSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text("Wed"),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "10",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _wedFromHr = value.toString();
                                                    });
                                                  },
                                                  items: hourSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "10",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _wedFromMin = value.toString();
                                                    });
                                                  },
                                                  items: minSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "18",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _wedToHr = value.toString();
                                                    });
                                                  },
                                                  items: hourSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "00",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _wedToMin = value.toString();
                                                    });
                                                  },
                                                  items: minSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text("Thur"),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "10",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _thurFromHr = value.toString();
                                                    });
                                                  },
                                                  items: hourSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "10",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _thurFromMin = value.toString();
                                                    });
                                                  },
                                                  items: minSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "18",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _thurToHr = value.toString();
                                                    });
                                                  },
                                                  items: hourSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "00",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _thurToMin = value.toString();
                                                    });
                                                  },
                                                  items: minSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text("Fri"),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "10",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _friFromHr = value.toString();
                                                    });
                                                  },
                                                  items: hourSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "10",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _friFromMin = value.toString();
                                                    });
                                                  },
                                                  items: minSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "18",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _friToHr = value.toString();
                                                    });
                                                  },
                                                  items: hourSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "00",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _friToMin = value.toString();
                                                    });
                                                  },
                                                  items: minSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text("Sat"),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "10",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _satFromHr = value.toString();
                                                    });
                                                  },
                                                  items: hourSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "10",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _satFromMin = value.toString();
                                                    });
                                                  },
                                                  items: minSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "18",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _satToHr = value.toString();
                                                    });
                                                  },
                                                  items: hourSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "00",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _satToMin = value.toString();
                                                    });
                                                  },
                                                  items: minSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text("Sun"),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "10",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _sunFromHr = value.toString();
                                                    });
                                                  },
                                                  items: hourSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "10",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _sunFromMin = value.toString();
                                                    });
                                                  },
                                                  items: minSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "18",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _sunToHr = value.toString();
                                                    });
                                                  },
                                                  items: hourSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                          Expanded(
                                              child: DropdownButtonFormField(
                                                  value: "00",
                                                  icon: const Icon(Icons.arrow_downward),
                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                  elevation: 12,
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _sunToMin = value.toString();
                                                    });
                                                  },
                                                  items: minSelection.map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Row(
                                                            children: [
                                                              Text(e)
                                                            ],
                                                          ))).toList())
                                          ),
                                        ],
                                      ),
                                    )
                                  ]
                                ),
                                trailing: IconButton(
                                  icon: (!_openingHrsEdit) ? Icon(Icons.create_outlined) : Icon(Icons.check_rounded),
                                  onPressed: () {
                                    if(_openingHrsEdit){
                                      if(_openingHrsJson.isNotEmpty){
                                        setState(() {
                                          _openingHrsEdit = !_openingHrsEdit;
                                        });
                                      }else{
                                        showSnackBar(context, "Please enter birth date before saved");
                                      }
                                    }else{
                                      setState(() {
                                        _openingHrsEdit = !_openingHrsEdit;
                                      });
                                    }
                                  },
                                )
                            ),
                            ListTile(
                                subtitle: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                  child: TextFormField(
                                    controller: _oldPasswordController,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: 'Enter old password to confirm',
                                    ),
                                  ),
                                )
                            ),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Row(children: <Widget>[
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        getOpeningHrsText();
                                        if ((_passwordEdit && _passwordController.text.isNotEmpty)
                                            && (_nameEdit && _nameController.text.isNotEmpty )
                                            && (_phoneEdit && _phoneController.text.isNotEmpty)
                                            && (_addressEdit && _addressController.text.isNotEmpty)
                                            && (_areaEdit && _area.isNotEmpty)
                                            && (_districtEdit && _district.isNotEmpty)
                                        && (_openingHrsEdit && _openingHrsJson.isNotEmpty)
                                        ) {
                                          updatePersonalInfo();
                                        }
                                      },
                                      child: const Text('Submit', style: TextStyle(color: Colors.white)),
                                    ),
                                  )
                                ])
                            )
                          ],
                        )
                    ),
                  )
              )
            ])),
      ]),
    );

  }

}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

String? passwordValidator(v) {
  String? temp;
  if (v!.trim().isNotEmpty) {
    if (v!.trim().length < 8 || v!.trim().length > 16) {
      temp = "(Password should be within 8-16 characters and contain at least one number , one uppercase letter and one lowercase letter)";
    } else {
      final check = RegExp(r"(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])");
      if (check.hasMatch(v)) {
        temp = null;
      } else {
        temp = "(Password should be within 8-16 characters and contain at least one number , one uppercase letter and one lowercase letter)";
      }
    }
  } else {
    temp = "Password cannot be empty";
  }
  return temp;
}