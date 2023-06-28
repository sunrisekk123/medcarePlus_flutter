import 'dart:convert';

class User {
  final String id;
  final String walletAddress;
  final String fname;
  final String lname;
  final String email;
  final String password;
  final String hkid;
  final String phoneNo;
  final String birthDate;
  final String address;
  final String token;


  User({
    required this.id,
    required this.walletAddress,
    required this.fname,
    required this.lname,
    required this.email,
    required this.password,
    required this.hkid,
    required this.phoneNo,
    required this.birthDate,
    required this.address,
    required this.token
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'walletAddress': walletAddress,
      'fname': fname,
      'lname': lname,
      'email': email,
      'password': password,
      'hkid': hkid,
      'phoneNo': phoneNo,
      'birthDate': birthDate,
      'address': address,
      'token': token
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      walletAddress: map['walletAddress'] ?? '',
      fname: map['fname'] ?? '',
      lname: map['lname'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      hkid: map['hkid'] ?? '',
      phoneNo: map['phoneNo'] ?? '',
      birthDate: map['birthDate'] ?? '',
      address: map['address'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? id,
    String? walletAddress,
    String? fname,
    String? lname,
    String? email,
    String? password,
    String? hkid,
    String? phoneNo,
    String? birthDate,
    String? address,
    String? token
  }) {
    return User(
        id: id ?? this.id,
        walletAddress: walletAddress ?? this.walletAddress,
        fname: fname ?? this.fname,
        lname: lname ?? this.lname,
        email: email ?? this.email,
        password: password ?? this.password,
        hkid: hkid ?? this.hkid,
        phoneNo: phoneNo ?? this.phoneNo,
        birthDate: birthDate ?? this.birthDate,
        address: address ?? this.address,
        token: token ?? this.token
    );
  }
}