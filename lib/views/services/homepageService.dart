import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fyp/constants/httpResponseHandle.dart';
import 'package:fyp/views/member/viewPersonalProfile.dart';
import 'package:http/http.dart' as http;
import 'package:fyp/constants/globalVariables.dart';
import 'package:fyp/views/common/component.dart';
import 'package:fyp/models/clinic.dart';
import 'package:fyp/models/doctor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/models/user.dart';

class HomepageService {

  Future<List<ClinicInfo>> getHomepageData(
    BuildContext context,
  ) async {
    List<ClinicInfo> clinicList = [];
    try {
        http.Response homepageRes = await http.get(
          Uri.parse('$uri/homepage'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );

        httpResponseHandle(
          response: homepageRes,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(homepageRes.body)["data"].length; i++) {
              final temp = jsonDecode(homepageRes.body)["data"][i];
              clinicList.add(
                ClinicInfo(
                    id: temp["_id"],
                    walletAddress: temp["WALLET_ADDRESS"],
                    email: temp["EMAIL"],
                    name: temp["NAME"],
                    password: temp["PASSWORD"],
                    area: temp["AREA"],
                    district: temp["DISTRICT"],
                    address: temp["ADDRESS"],
                    phoneNo: temp["PHONE_NO"],
                    openingHrs: temp["OPENING_HRS"],
                    active: temp["ACTIVE"],
                    verified: temp["VERIFIED"],
                    imagePath: temp["IMAGE_PATH"],
                    token: "",
                    doctorInfo: temp["DOCTOR_INFO"].map((e) => Doctor(
                        id: e["_id"],
                        clinicId: e["CLINIC_ID"],
                        name: e["NAME"],
                        services: jsonDecode(e["SERVICES"]).cast<String>(),
                        qualifications: jsonDecode(e["QUALIFICATIONS"]).cast<String>(),
                        imagePath: e["IMAGE_PATH"])
                    ).toList().cast<Doctor>()
                )
              );
            }
          },
        );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return clinicList;
  }

  Future<List<User>> getUserDataByEmail(
    BuildContext context,
  ) async {
    List<User> result = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      String? email = prefs.getString('u-email');
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      var tokenRes = await http.post(
        Uri.parse('$uri/auth/verify_token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );
      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response res = await http.get(
          Uri.parse('$uri/homepage/user/$email'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );
        httpResponseHandle(
          response: res,
          context: context,
          onSuccess: () {
            final temp = jsonDecode(res.body)["data"][0];
            result.add(
                User(
                    id: temp["_id"],
                    lname: temp["LNAME"],
                    fname: temp["FNAME"],
                    phoneNo: temp["PHONE_NO"],
                    email: email != null ? email : "",
                    token: token,
                    hkid: temp["HKID_NO"],
                    address: temp["ADDRESS"],
                    walletAddress: temp["WALLET_ADDRESS"],
                    password: temp["PASSWORD"],
                    birthDate: temp["BIRTH_DATE"],
                    pin: temp["PIN"],
                    key: temp["KEY"]
                )
            );
          },
        );
      }

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return result;
  }

  Future<bool> updateUserInfo({
    required BuildContext context,
    required String password,
    required String birth,
    required String hkid,
    required String address,
    required String phone,
    required String fname,
    required String lname,
  }) async {
    bool isTrue = false;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      String? email = prefs.getString('u-email');
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      var tokenRes = await http.post(
        Uri.parse('$uri/auth/verify_token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );
      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response res = await http.post(
          Uri.parse('$uri/homepage/user'),
          body: jsonEncode({
            "email": email,
            "password": password,
            "birth": birth,
            "hkid": hkid,
            "address": address,
            "phone": phone,
            "lname": lname,
            "fname": fname
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        httpResponseHandle(
          response: res,
          context: context,
          onSuccess: () {
            isTrue = true;
          },
        );
      }

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return isTrue;
  }

  Future<bool> updateClinicInfo({
    required BuildContext context,
    required String password,
    required String openingHrs,
    required String area,
    required String district,
    required String address,
    required String phone,
    required String name,
  }) async {
    bool isTrue = false;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('u-email');

        http.Response res = await http.post(
          Uri.parse('$uri/homepage/clinic'),
          body: jsonEncode({
            "email": email,
            "password": password,
            "openingHrs": openingHrs,
            "area": area,
            "district": district,
            "address": address,
            "phone": phone,
            "name": name
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );

        httpResponseHandle(
          response: res,
          context: context,
          onSuccess: () {
            isTrue = true;
          },
        );


    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return isTrue;
  }

  void setPin({
    required BuildContext context,
    required String pin
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      String? email = prefs.getString('u-email');
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      var tokenRes = await http.post(
        Uri.parse('$uri/auth/verify_token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );
      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response res = await http.post(
          Uri.parse('$uri/homepage/user/set_pin'),
          body: jsonEncode(
            {"email": email.toString(), "pin": pin.toString()}
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        httpResponseHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Set PIN successfully");
            Navigator.pushNamedAndRemoveUntil(context, PersonalProfileArea.routeName, (route) => false);
          },
        );
      }

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  Future<bool> verifyUserPin({
    required BuildContext context,
    required String pin
  }) async {
    bool isValid = false;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      String? email = prefs.getString('u-email');
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      var tokenRes = await http.post(
        Uri.parse('$uri/auth/verify_token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );
      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response res = await http.get(
          Uri.parse('$uri/homepage/user/verify_pin/$email/$pin'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        httpResponseHandle(
          response: res,
          context: context,
          onSuccess: () {
            isValid = jsonDecode(res.body);
          },
        );
      }

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return isValid;
  }

  Future<List<ClinicInfo>> getClinicDataByEmail(
      BuildContext context,
      ) async {
    List<ClinicInfo> result = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('u-email');
        http.Response res = await http.get(
          Uri.parse('$uri/homepage/clinic/$email'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );
        httpResponseHandle(
          response: res,
          context: context,
          onSuccess: () {
            final temp = jsonDecode(res.body)["data"][0];
            result.add(
                ClinicInfo(
                    id: temp["_id"],
                    walletAddress: temp["WALLET_ADDRESS"],
                    email: temp["EMAIL"],
                    name: temp["NAME"],
                    password: temp["PASSWORD"],
                    area: temp["AREA"],
                    district: temp["DISTRICT"],
                    address: temp["ADDRESS"],
                    phoneNo: temp["PHONE_NO"],
                    openingHrs: temp["OPENING_HRS"],
                    active: temp["ACTIVE"],
                    verified: temp["VERIFIED"],
                    imagePath: temp["IMAGE_PATH"],
                    token: "",
                    doctorInfo: temp["DOCTOR_INFO"].map((e) => Doctor(
                        id: e["_id"],
                        clinicId: e["CLINIC_ID"],
                        name: e["NAME"],
                        services: jsonDecode(e["SERVICES"]).cast<String>(),
                        qualifications: jsonDecode(e["QUALIFICATIONS"]).cast<String>(),
                        imagePath: e["IMAGE_PATH"])
                    ).toList().cast<Doctor>()
                )
            );
          },
        );

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return result;
  }
}
