import 'dart:convert';

class TextValue {
  late String text;
  late String value;

  TextValue(
      this.text,
      this.value,
  );
  TextValue.fromJson(Map <String, dynamic> map){
      text = map['text'];
      value = map['value'];
    }
}

class District {
  final String id;
  final String district;
  final String area;

  District({
    required this.id,
    required this.area,
    required this.district,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'area': area,
      'district': district
    };
  }

  factory District.fromMap(Map<String, dynamic> map) {
    return District(
        id: map['_id'] ?? '',
        area: map['AREA'] ?? '',
        district: map['DISTRICT'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory District.fromJson(String source) => District.fromMap(json.decode(source));
}