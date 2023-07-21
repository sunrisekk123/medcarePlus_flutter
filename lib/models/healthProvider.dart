
import 'dart:convert';

class HealthProvider{
  final String userAddress;
  final String clinicAddress;
  final String clinicName;
  final String clinicEmail;
  final String clinicArea;
  final String clinicDistrict;
  final String clinicLocationAddress;
  final String date;
  final String time;
  final String status;

  HealthProvider({
    required this.userAddress,
    required this.clinicAddress,
    required this.clinicName,
    required this.clinicEmail,
    required this.clinicArea,
    required this.clinicDistrict,
    required this.clinicLocationAddress,
    required this.date,
    required this.time,
    required this.status
  });

  Map<String, dynamic> toMap() {
    return {
      'userAddress': userAddress,
      'clinicAddress': clinicAddress,
      'clinicName': clinicName,
      'clinicEmail': clinicEmail,
      'clinicArea': clinicArea,
      'clinicDistrict': clinicDistrict,
      'clinicLocationAddress': clinicLocationAddress,
      'date': date,
      'time': time,
      'status': status
    };
  }

  factory HealthProvider.fromMap(Map<String, dynamic> map) {
    return HealthProvider(
        userAddress: map['userAddress'] ?? '',
        clinicAddress: map['clinicAddress'] ?? '',
        clinicName: map['clinicName'] ?? '',
        clinicEmail: map['clinicEmail'] ?? '',
        clinicArea: map['clinicArea'] ?? '',
        clinicDistrict: map['clinicDistrict'] ?? '',
        clinicLocationAddress: map['clinicLocationAddress'] ?? '',
        date: map['date'] ?? '',
        time: map['time'] ?? '',
        status: map['status'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory HealthProvider.fromJson(String data) => HealthProvider.fromMap(json.decode(data));
}