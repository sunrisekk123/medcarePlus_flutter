import 'dart:convert';
import 'package:fyp/models/doctor.dart';

class ClinicInfo {
  final String id;
  final String walletAddress;
  final String email;
  final String name;
  final String password;
  final String area;
  final String district;
  final String address;
  final String phoneNo;
  final String openingHrs;
  final String active;
  final String verified;
  final String imagePath;
  final String token;
  final List<Doctor> doctorInfo;

  ClinicInfo({
    required this.id,
    required this.walletAddress,
    required this.email,
    required this.name,
    required this.password,
    required this.area,
    required this.district,
    required this.address,
    required this.phoneNo,
    required this.openingHrs,
    required this.active,
    required this.verified,
    required this.imagePath,
    required this.token,
    required this.doctorInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'walletAddress': walletAddress,
      'email': email,
      'name': name,
      'password': password,
      'area': area,
      'district': district,
      'address': address,
      'phoneNo': phoneNo,
      'openingHrs': openingHrs,
      'active': active,
      'verified': verified,
      'imagePath': imagePath,
      'token': token,
      'doctorInfo': doctorInfo.map((x) => x.toMap()).toList()
    };
  }

  factory ClinicInfo.fromMap(Map<String, dynamic> map) {
    return ClinicInfo(
        id: map['_id'] ?? '',
        walletAddress: map['WALLET_ADDRESS'] ?? '',
        email: map['EMAIL'] ?? '',
        name: map['NAME'] ?? '',
        password: map['PASSWORD'] ?? '',
        area: map['AREA'] ?? '',
        district: map['DISTRICT'] ?? '',
        address: map['ADDRESS'] ?? '',
        phoneNo: map['PHONE_NO'] ?? '',
        openingHrs: map['OPENING_HRS'] ?? '',
        active: map['ACTIVE'] ?? '',
        verified: map['VERIFIED'] ?? '',
        imagePath: map['IMAGE_PATH'] ?? '',
        token: map['TOKEN'] ?? '',
        doctorInfo: List<Doctor>.from(
            map['DOCTOR_INFO']?.map((x) => Doctor.fromMap(x['DOCTOR_INFO']))
        )
    );
  }

  String toJson() => json.encode(toMap());

  factory ClinicInfo.fromJson(String source) => ClinicInfo.fromMap(json.decode(source));
}
