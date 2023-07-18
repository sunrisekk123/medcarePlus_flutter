import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
      id: '',
      walletAddress: '',
      fname: '',
      lname: '',
      email: '',
      password: '',
      hkid: '',
      phoneNo: '',
      birthDate: '',
      address: '',
      pin: '',
      key: '',
      token: ''
  );

  User get user => _user;

  void setUser(String user) {
    final data = jsonDecode(user);
    _user = User(id: data["data"]["_id"],
        walletAddress: data["data"]["WALLET_ADDRESS"],
        fname: data["data"]["FNAME"],
        lname: data["data"]["LNAME"],
        email: data["data"]["EMAIL"],
        password: data["data"]["PASSWORD"],
        hkid: data["data"]["HKID_NO"],
        phoneNo: data["data"]["PHONE_NO"],
        birthDate: data["data"]["BIRTH_DATE"],
        address: data["data"]["ADDRESS"],
        pin: data["data"]["PIN"],
        key: data["data"]["KEY"],
        token: data['token']);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
