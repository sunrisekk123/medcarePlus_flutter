import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:fyp/constants/httpResponseHandle.dart';
import 'package:http/http.dart' as http;
import 'package:fyp/constants/globalVariables.dart';
import 'package:fyp/views/common/component.dart';

class HomepageService {

  void getHomepageData(
    BuildContext context,
  ) async {
    try {
        http.Response homepageRes = await http.get(
          Uri.parse('$uri/homepage'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );


    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }


}
