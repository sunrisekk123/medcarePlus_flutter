import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp/views/common/component.dart';
import 'package:fyp/views/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:fyp/constants/globalVariables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/constants/httpResponseHandle.dart';
import 'package:fyp/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:fyp/models/user.dart';

class LoginService {
  void loginUser({
    required BuildContext context,
      required String email,
      required String password
  }) async {
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
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            await prefs.setString(
                'x-auth-token', jsonDecode(res.body)['token']);
            // Navigator.pushNamedAndRemoveUntil(
            //   context,
            //   BottomBar.routeName,
            //       (route) => false,
            // );
          });
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
          token: ''
      );
print(Uri.parse('$uri/auth/register'));
print(user.toJson());
      http.Response res = await http.post(
        Uri.parse('$uri/auth/register'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(res.statusCode);
      print(res.body);
      httpResponseHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            Homepage.routeName,
                (route) => false,
          );
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
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
