
import 'dart:convert';

class Doctor{
  final String id;
  final String clinicId;
  final String name;
  final List<String> services;
  final List<String> qualifications;
  final String imagePath;

  Doctor({
    required this.id,
    required this.clinicId,
    required this.name,
    required this.services,
    required this.qualifications,
    required this.imagePath
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clinicID': clinicId,
      'name': name,
      'services': services,
      'qualifications': qualifications,
      'imagePath': imagePath
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
        id: map['_id'] ?? '',
        clinicId: map['CLINIC_ID'] ?? '',
        name: map['NAME'] ?? '',
        services: map['SERVICES'] ?? '',
        qualifications: map['QUALIFICATIONS'] ?? '',
        imagePath: map['IMAGE_PATH'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory Doctor.fromJson(String data) => Doctor.fromMap(json.decode(data));
}