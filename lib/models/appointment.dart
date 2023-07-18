import 'dart:convert';
import 'package:fyp/models/doctor.dart';

class AppointmentInfo {
  final String appointmentId;
  final String userAddress;
  final String userFName;
  final String userLName;
  final String userEmail;
  final String userHKID;
  final String userPhone;
  final String userHomeAddress;
  final String userBirthDate;
  final String clinicAddress;
  final String clinicName;
  final String clinicLocation;
  final String clinicDistrict;
  final String clinicArea;
  final String clinicImage;
  final String index;
  final String doctor;
  final String date;
  final String time;
  final String status;

  AppointmentInfo({
    required this.appointmentId,
    required this.userAddress,
    required this.userFName,
    required this.userLName,
    required this.userEmail,
    required this.userHKID,
    required this.userPhone,
    required this.userHomeAddress,
    required this.userBirthDate,
    required this.clinicAddress,
    required this.clinicName,
    required this.clinicLocation,
    required this.clinicDistrict,
    required this.clinicArea,
    required this.clinicImage,
    required this.index,
    required this.doctor,
    required this.date,
    required this.time,
    required this.status
  });

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'userAddress': userAddress,
      'userFName': userFName,
      'userLName': userLName,
      'userEmail': userEmail,
      'userHKID': userHKID,
      'userPhone': userPhone,
      'userHomeAddress': userHomeAddress,
      'userBirthDate': userBirthDate,
      'clinicAddress': clinicAddress,
      'clinicName': clinicName,
      'clinicLocation': clinicLocation,
      'clinicDistrict': clinicDistrict,
      'clinicArea': clinicArea,
      'clinicImage': clinicImage,
      'index': index,
      'doctor': doctor,
      'date': date,
      'time': time,
      'status': status
    };
  }

  factory AppointmentInfo.fromMap(Map<String, dynamic> map) {
    return AppointmentInfo(
        appointmentId: map['appointmentId'] ?? '',
        userAddress: map['userAddress'] ?? '',
        userFName: map['userFName'] ?? '',
        userLName: map['userLName'] ?? '',
        userEmail: map['userEmail'] ?? '',
        userHKID: map['userHKID'] ?? '',
        userPhone: map['userPhone'] ?? '',
        userHomeAddress: map['userHomeAddress'] ?? '',
        userBirthDate: map['userBirthDate'] ?? '',
        clinicAddress: map['clinicAddress'] ?? '',
        clinicName: map['clinicName'] ?? '',
        clinicLocation: map['clinicLocation'] ?? '',
        clinicDistrict: map['clinicDistrict'] ?? '',
        clinicArea: map['clinicArea'] ?? '',
        clinicImage: map['clinicImage'] ?? '',
        index: map['index'] ?? '',
        doctor: map['doctor'] ?? '',
        date: map['date'] ?? '',
        time: map['time'] ?? '',
        status: map['status'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory AppointmentInfo.fromJson(String source) => AppointmentInfo.fromMap(json.decode(source));
}
