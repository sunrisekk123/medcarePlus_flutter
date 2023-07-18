import 'dart:convert';
import 'package:fyp/models/doctor.dart';

class HealthRecord {
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
  final String doctor;
  final String datetime;
  final String services;
  final String diagnosis;
  final String treatment;
  final String medications;
  final String remarks;

  HealthRecord({
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
    required this.doctor,
    required this.datetime,
    required this.services,
    required this.diagnosis,
    required this.treatment,
    required this.medications,
    required this.remarks
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
      'doctor': doctor,
      'datetime': datetime,
      'services': services,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'medications': medications,
      'remarks': remarks
    };
  }

  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
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
        doctor: map['doctor'] ?? '',
        datetime: map['datetime'] ?? '',
        services: map['services'] ?? '',
        diagnosis: map['diagnosis'] ?? '',
        treatment: map['treatment'] ?? '',
        medications: map['medications'] ?? '',
        remarks: map['remarks'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory HealthRecord.fromJson(String source) => HealthRecord.fromMap(json.decode(source));
}
