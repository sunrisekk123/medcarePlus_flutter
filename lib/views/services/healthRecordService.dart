import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fyp/constants/httpResponseHandle.dart';
import 'package:fyp/models/healthProvider.dart';
import 'package:fyp/models/healthRecord.dart';
import 'package:fyp/views/member/viewPersonalProfile.dart';
import 'package:http/http.dart' as http;
import 'package:fyp/constants/globalVariables.dart';
import 'package:fyp/views/common/component.dart';
import 'package:fyp/models/clinic.dart';
import 'package:fyp/models/doctor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fyp/models/user.dart';
import 'package:fyp/views/basePage.dart';

class HealthRecordService {

  Future<List<HealthRecord>> getHealthRecordDataUser(
      BuildContext context,
      ) async {
    List<HealthRecord> recordList = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      var user = prefs.getString('user-address');

        http.Response homepageRes = await http.get(
          Uri.parse('$uri/health_record/view_user/$user'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );

        httpResponseHandle(
          response: homepageRes,
          context: context,
          onSuccess: () {
            for (int i = 0; i <
                jsonDecode(homepageRes.body)["data"].length; i++) {
              final temp = jsonDecode(homepageRes.body)["data"][i];
              recordList.add(
                  HealthRecord(
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
                    doctor: temp["doctor"],
                    datetime: temp["datetime"],
                    services: temp["services"],
                    diagnosis: temp["diagnosis"],
                    treatment: temp["treatment"],
                    medications: temp["medications"],
                    remarks: temp["remarks"],

                  )
              );
            }
          },
        );

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return recordList;
  }

  Future<List<HealthRecord>> getHealthRecordDataClinic(
      BuildContext context,
      String patientAddress
      ) async {
    List<HealthRecord> recordList = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');


        http.Response homepageRes = await http.get(
          Uri.parse('$uri/health_record/view_user/$patientAddress'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );

        httpResponseHandle(
          response: homepageRes,
          context: context,
          onSuccess: () {
            for (int i = 0; i <
                jsonDecode(homepageRes.body)["data"].length; i++) {
              final temp = jsonDecode(homepageRes.body)["data"][i];
              recordList.add(
                  HealthRecord(
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
                    doctor: temp["doctor"],
                    datetime: temp["datetime"],
                    services: temp["services"],
                    diagnosis: temp["diagnosis"],
                    treatment: temp["treatment"],
                    medications: temp["medications"],
                    remarks: temp["remarks"],

                  )
              );
            }
          },
        );

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return recordList;
  }

  Future<List<HealthRecord>> getHealthRecordDataByAppointmentId(
      BuildContext context,
      String appointmentId,
      String userAddress
      ) async {
    List<HealthRecord> recordList = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');


        http.Response homepageRes = await http.get(
          Uri.parse('$uri/health_record/appointment/$appointmentId/$userAddress'),
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
              recordList.add(
                  HealthRecord(
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
                    doctor: temp["doctor"],
                    datetime: temp["datetime"],
                    services: temp["services"],
                    diagnosis: temp["diagnosis"],
                    treatment: temp["treatment"],
                    medications: temp["medications"],
                    remarks: temp["remarks"],

                  )
              );
            }
          },
        );

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return recordList;
  }

  Future<String> getQrCode(
      BuildContext context,
      ) async {
    String code = "";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      var email = prefs.getString('u-email');
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
          Uri.parse('$uri/health_record/qr_code/$email'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        httpResponseHandle(
          response: res,
          context: context,
          onSuccess: () {
            code = jsonDecode(res.body)["data"];
          },
        );
      }
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return code;
  }

  Future<bool> checkScannedQrCodeWithId({
    required BuildContext context,
    required String? id,
    required String? code,
    required String? userAddress
  }) async {
    bool isTrue = false;
    if(userAddress == code) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var user = prefs.getString('user-address');

        http.Response res = await http.post(
          Uri.parse('$uri/health_record/appointment_check'),
          body: jsonEncode({
            "id": id,
            "code": code,
            "clinicAddress": user
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );

        httpResponseHandle(
          response: res,
          context: context,
          onSuccess: () {
            isTrue = jsonDecode(res.body)["data"];
          },
        );
      } catch (e) {
        print(e.toString());
        showSnackBar(context, e.toString());
      }
    }else{
      showSnackBar(context, "QR code does not match the appointment");
    }
    return isTrue;
  }

  Future<bool> checkScannedQrCodeWithoutId({
    required BuildContext context,
    required String? code
  }) async {
    bool isTrue = false;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user-address');

        http.Response res = await http.get(
          Uri.parse('$uri/health_record/appointment_check_without/$code/$user'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );

        httpResponseHandle(
          response: res,
          context: context,
          onSuccess: () {
            isTrue = jsonDecode(res.body)["data"];
          },
        );

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return isTrue;
  }

  Future<List<ClinicInfo>> getClinicInfo({
    required BuildContext context,
  }) async {
    List<ClinicInfo> clinicList = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString('u-email');

      http.Response res = await http.get(
        Uri.parse('$uri/health_record/clinic/$email'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpResponseHandle(
        response: res,
        context: context,
        onSuccess: () {
          final temp = jsonDecode(res.body)["data"][0];
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
        },
      );

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return clinicList;
  }

  Future<List<User>> getUserInfo({
    required BuildContext context,
    required String? userWalletAddress
  }) async {
    List<User> userList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/health_record/user/$userWalletAddress'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpResponseHandle(
        response: res,
        context: context,
        onSuccess: () {
          final temp = jsonDecode(res.body)["data"][0];
          userList.add(
              User(
                  id: temp["_id"],
                  lname: temp["LNAME"],
                  fname: temp["FNAME"],
                  phoneNo: temp["PHONE_NO"],
                  email: temp["EMAIL"],
                  token: "",
                  hkid: temp["HKID_NO"],
                  address: temp["ADDRESS"],
                  walletAddress: temp["WALLET_ADDRESS"],
                  password: temp["PASSWORD"],
                  birthDate: temp["BIRTH_DATE"],
                  key: temp["KEY"],
                  pin: temp["PIN"]
              )
          );
        },
      );

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return userList;
  }

  Future<bool> insertHealthRecord({
    required BuildContext context,
    required String? appointmentId,
    required String? date,
    required String? time,
    required String? clinicWalletAddress,
    required String? userWalletAddress,
    required String doctor,
    required String services,
    required String diagnosis,
    required String treatment,
    required String medications,
    required String remarks
  }) async {
    bool isSuccess = false;
    try {
      // if no appointment Id

      http.Response res = await http.post(
        Uri.parse('$uri/health_record/insert'),
        body: jsonEncode({
          "appointmentId": appointmentId,
          "date": date,
          "time": time,
          "clinicWalletAddress": clinicWalletAddress,
          "userWalletAddress": userWalletAddress,
          "doctor": doctor,
          "services": services,
          "diagnosis": diagnosis,
          "treatment": treatment,
          "medications": medications,
          "remarks": remarks
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpResponseHandle(
        response: res,
        context: context,
        onSuccess: () {
          isSuccess = true;
          showSnackBar(context, "Insert successful");

        },
      );

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return isSuccess;
  }

  Future<List<HealthProvider>> getTrustHealthProviderUser(
      BuildContext context,
      ) async {
    List<HealthProvider> recordList = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user-address');

      http.Response homepageRes = await http.get(
        Uri.parse('$uri/health_record/trust_provider/$user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpResponseHandle(
        response: homepageRes,
        context: context,
        onSuccess: () {
          for (int i = 0; i <
              jsonDecode(homepageRes.body)["data"].length; i++) {
            final temp = jsonDecode(homepageRes.body)["data"][i];
            recordList.add(
                HealthProvider(
                  userAddress: temp["userAddress"],
                  clinicAddress: temp["clinicAddress"],
                  clinicName: temp["clinicName"],
                  date: temp["date"],
                  time: temp["time"],
                  clinicEmail: temp["clinicEmail"],
                  clinicArea: temp["clinicArea"],
                  clinicDistrict: temp["clinicDistrict"],
                  clinicLocationAddress: temp["clinicLocationAddress"],
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
    return recordList;
  }

  Future<bool> updateTrustHealthProviderStatusUser(
      BuildContext context,
      HealthProvider providerData,
      String status
      ) async {
    bool isSuccessful = false;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user-address');

      http.Response homepageRes = await http.post(
        Uri.parse('$uri/health_record/trust_provider/status'),
        body: jsonEncode({
          "userAddress": providerData.userAddress,
          "clinicAddress": providerData.clinicAddress,
          "status": status
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpResponseHandle(
        response: homepageRes,
        context: context,
        onSuccess: () {
          isSuccessful = true;
        },
      );

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return isSuccessful;
  }

}
