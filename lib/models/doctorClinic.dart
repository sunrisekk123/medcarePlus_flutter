import 'dart:convert';

class DoctorClinic{
  final String id;
  final String clinicId;
  final String name;
  final List<String> services;
  final List<String> qualifications;
  final String walletAddress;
  final String email;
  final String clinicName;
  final String password;
  final String area;
  final String district;
  final String address;
  final String phoneNo;
  final String openingHrs;
  final String active;
  final String verified;
  final String imagePath;

  DoctorClinic({
    required this.id,
    required this.clinicId,
    required this.name,
    required this.services,
    required this.qualifications,
    required this.walletAddress,
    required this.email,
    required this.clinicName,
    required this.password,
    required this.area,
    required this.district,
    required this.address,
    required this.phoneNo,
    required this.openingHrs,
    required this.active,
    required this.verified,
    required this.imagePath
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clinicID': clinicId,
      'name': name,
      'services': services,
      'qualifications': qualifications,
      'walletAddress': walletAddress,
      'email': email,
      'clinicName': clinicName,
      'password': password,
      'area': area,
      'district': district,
      'address': address,
      'phoneNo': phoneNo,
      'openingHrs': openingHrs,
      'active': active,
      'verified': verified,
      'imagePath': imagePath
    };
  }

  factory DoctorClinic.fromMap(Map<String, dynamic> map) {
    return DoctorClinic(
        id: map['_id'] ?? '',
        clinicId: map['CLINIC_ID'] ?? '',
        name: map['NAME'] ?? '',
        services: map['SERVICES'] ?? '',
        qualifications: map['QUALIFICATIONS'] ?? '',
        walletAddress: map['walletAddress'] ?? '',
        email: map['email'] ?? '',
        clinicName: map['clinicName'] ?? '',
        password: map['password'] ?? '',
        area: map['area'] ?? '',
        district: map['district'] ?? '',
        address: map['address'] ?? '',
        phoneNo: map['phoneNo'] ?? '',
        openingHrs: map['openingHrs'] ?? '',
        active: map['active'] ?? '',
        verified: map['verified'] ?? '',
        imagePath: map['IMAGE_PATH'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorClinic.fromJson(String data) => DoctorClinic.fromMap(json.decode(data));
}