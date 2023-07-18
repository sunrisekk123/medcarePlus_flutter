import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp/views/common/component.dart';
import 'package:http/http.dart' as http;
import 'package:fyp/constants/globalVariables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/constants/httpResponseHandle.dart';
import 'package:fyp/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:fyp/models/user.dart';
import 'package:fyp/models/clinic.dart';
import 'package:fyp/models/common.dart';
import 'package:fyp/views/basePage.dart';

class LoginService {

  Future<bool> loginUser({
    required BuildContext context,
      required String email,
      required String password
  }) async {
    bool loginSuccessful = false;
    try {
      http.Response res = await http.post(Uri.parse('$uri/auth/login'),
          body: jsonEncode({'email': email, 'password': password}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });
      httpResponseHandle(
          response: res,
          context: context,
          onSuccess: () async {
            loginSuccessful = true;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            print( jsonDecode(res.body)['token']);
            await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
            await prefs.setString('x-account', jsonDecode(res.body)['accountType']);
            await prefs.setString('user-address', jsonDecode(res.body)['data']['WALLET_ADDRESS']);
            await prefs.setString('u-email', jsonDecode(res.body)['data']['EMAIL']);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return loginSuccessful;
  }

  Future<void> logoutUser({
    required BuildContext context
  })async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
      Navigator.pushNamedAndRemoveUntil(context, BasePage.routeName, (route) => false,);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void registerUser({
    required BuildContext context,
    required String email,
    required String walletAddress,
    required String password,
    required String fname,
    required String lname,
    required String hkidNo,
    required String phoneNo,
    required String birthDate,
    required String pin,
  }) async {
    try {
      User user = User(
          id: '',
          walletAddress: walletAddress,
          fname: fname,
          lname: lname,
          password: password,
          email: email,
          address: '',
          hkid: hkidNo,
          phoneNo: phoneNo,
          birthDate: birthDate,
          pin: pin,
          key: "",
          token: ''
      );
      print(user.pin);
      print("hi1");
      http.Response res = await http.post(
        Uri.parse('$uri/auth/register'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpResponseHandle(
        response: res,
        context: context,
        onSuccess: () {
          print("hi2");
          showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            BasePage.routeName,
                (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void registerClinic({
    required BuildContext context,
    required String area,
    required String district,
    required String address,
    required String email,
    required String walletAddress,
    required String password,
    required String name,
    required String phoneNo
  }) async {
    try {
      // check email exist
      // check wallet address exist
      ClinicInfo clinicInfo = ClinicInfo(
          id: '',
          walletAddress: walletAddress,
          name: name,
          password: password,
          email: email,
          area: area,
          district: district,
          address: address,
          phoneNo: phoneNo,
          openingHrs: '',
          token: '',
          doctorInfo: [],
          imagePath: '',
          active: 'N',
          verified: 'N'
      );
      http.Response res = await http.post(
        Uri.parse('$uri/auth/register_clinic'),
        body: clinicInfo.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpResponseHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Please verified the account via email and login with the same credentials!',
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            BasePage.routeName,
                (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<District>> getDistrictOptions(BuildContext context) async{
    List<District> districtItems = [];
    try {
        http.Response res = await http.get(
          Uri.parse('$uri/auth/district_options'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          }
        );
        httpResponseHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body)["data"].length; i++) {
              final temp = jsonDecode(res.body)["data"][i];
              districtItems.add(
                District(id: temp["_id"], area: temp["AREA"], district: temp["DISTRICT"])
              );
            }
          }
        );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return districtItems;
  }

  void getUser(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
