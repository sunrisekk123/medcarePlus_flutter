import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fyp/constants/httpResponseHandle.dart';
import 'package:fyp/models/appointment.dart';
import 'package:fyp/models/clinic.dart';
import 'package:http/http.dart' as http;
import 'package:fyp/constants/globalVariables.dart';
import 'package:fyp/views/common/component.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/views/member/viewMyAppointment.dart';
import 'package:fyp/views/clinic/viewClinicAppointment.dart';

class AppointmentService {

  Future<bool> handleBookAppointment({
    required BuildContext context,
    required ClinicInfo clinic,
    required String doctor,
    required String date,
    required String time
  }) async {
    bool bookSuccessful = false;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      var user = prefs.getString('user-address');
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
          Uri.parse('$uri/appointment/booking'),
          body: jsonEncode({'user': user, 'clinic': clinic.walletAddress, 'doctor': doctor, 'date': date.toString().substring(0, 10), 'time': time.toString(), 'status': "A"}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );
        httpResponseHandle(
          response: res,
          context: context,
          onSuccess: () {
            bookSuccessful = true;
          },
        );
      }
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return bookSuccessful;
  }

  void cancelAppointmentByClinicAddress({
    required BuildContext context,
    required AppointmentInfo appointment,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user-address');

        http.Response res = await http.post(
          Uri.parse('$uri/appointment/status'),
          body: jsonEncode({'id': appointment.appointmentId, 'clinicAddress': appointment.clinicAddress, 'date':appointment.date, 'time':appointment.time,  'address': user, 'accountType':'C', 'status': "C"}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );
        httpResponseHandle(
          response: res,
          context: context,
          onSuccess: () {
            Navigator.popAndPushNamed(context, MyAppointmentClinicArea.routeName);
            showSnackBar(context, "Cancel Successfully");
          },
        );

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  void completeAppointmentByClinicAddress({
    required BuildContext context,
    required AppointmentInfo appointment,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user-address');

        http.Response res = await http.post(
          Uri.parse('$uri/appointment/status'),
          body: jsonEncode({'id': appointment.appointmentId, 'clinicAddress': appointment.clinicAddress, 'date':appointment.date, 'time':appointment.time,  'address': appointment.userAddress, 'accountType':'C', 'status': "D"}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );
        httpResponseHandle(
          response: res,
          context: context,
          onSuccess: () {
            Navigator.pop(context);
            Navigator.popAndPushNamed(context, MyAppointmentClinicArea.routeName);
            showSnackBar(context, "Mark as completed successfully");
          },
        );

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  Future<List<AppointmentInfo>> handleGetAppointment({
    required BuildContext context
  }) async {
    List<AppointmentInfo> result = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      var user = prefs.getString('user-address');
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
          Uri.parse('$uri/appointment/booking/address/$user'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );
        httpResponseHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body)["data"].length; i++) {
              final temp = jsonDecode(res.body)["data"][i];
              result.add(
                  AppointmentInfo(
                      appointmentId: temp["appointmentId"],
                      userAddress: temp["userAddress"],
                      userFName: temp["userFName"],
                      userLName: temp["userLName"],
                      userEmail: temp["userEmail"],
                      userHKID: temp["userHKID"],
                      userPhone: temp["userPhone"],
                      userHomeAddress: temp["userHomeAddress"],
                      userBirthDate: temp["userBirthDate"],
                      clinicAddress: temp["clinicAddress"],
                      clinicName: temp["clinicName"],
                      clinicLocation: temp["clinicLocation"],
                      clinicDistrict: temp["clinicDistrict"],
                      clinicArea: temp["clinicArea"],
                      clinicImage: temp["clinicImage"],
                      index: temp["index"].toString(),
                      doctor: temp["doctor"],
                      date: temp["date"],
                      time: temp["time"],
                      status: temp["status"]
                  )
              );
            }
          },
        );
      }
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return result;
  }

  Future<List<AppointmentInfo>> handleGetAppointmentClinic({
    required BuildContext context
  }) async {
    List<AppointmentInfo> result = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user-address');
        http.Response res = await http.get(
          Uri.parse('$uri/appointment/booking/clinic_address/$user'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );
        httpResponseHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body)["data"].length; i++) {
              final temp = jsonDecode(res.body)["data"][i];
              result.add(
                  AppointmentInfo(
                      appointmentId: temp["appointmentId"],
                      userAddress: temp["userAddress"],
                      userFName: temp["userFName"],
                      userLName: temp["userLName"],
                      userEmail: temp["userEmail"],
                      userHKID: temp["userHKID"],
                      userPhone: temp["userPhone"],
                      userHomeAddress: temp["userHomeAddress"],
                      userBirthDate: temp["userBirthDate"],
                      clinicAddress: temp["clinicAddress"],
                      clinicName: temp["clinicName"],
                      clinicLocation: temp["clinicLocation"],
                      clinicDistrict: temp["clinicDistrict"],
                      clinicArea: temp["clinicArea"],
                      clinicImage: temp["clinicImage"],
                      index: temp["index"].toString(),
                      doctor: temp["doctor"],
                      date: temp["date"],
                      time: temp["time"],
                      status: temp["status"]
                  )
              );
            }
          },
        );

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return result;
  }

  void cancelAppointmentByUserAddress({
    required BuildContext context,
    required AppointmentInfo appointment,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user-address');

      http.Response res = await http.post(
        Uri.parse('$uri/appointment/status'),
        body: jsonEncode({'id': appointment.appointmentId,'clinicAddress': appointment.clinicAddress,'date': appointment.date, 'time': appointment.time,'address': user, 'accountType':'C', 'status': "C"}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      httpResponseHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Cancel Successfully");
          Navigator.pop(context);
          Navigator.pushNamed(context, MyAppointmentUserArea.routeName);
        },
      );

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  Future<List<String>> handleGetAppointmentByDateAndClinicAddress({
    required BuildContext context,
    required String date,
    required String clinicAddress,
  }) async {
    List<String> occupiedList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/appointment/booking/check_ava_date/$date/$clinicAddress'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      httpResponseHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body)["data"].length; i++) {
            final temp = jsonDecode(res.body)["data"][i];
            occupiedList.add(temp);
          }
        },
      );

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return occupiedList;
  }
}
