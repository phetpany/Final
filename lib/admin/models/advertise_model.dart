import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AdvertiseModel {
  final String nameAdvertise;
  final String urlImage;
  AdvertiseModel({
    required this.nameAdvertise,
    required this.urlImage,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nameAdvertise': nameAdvertise,
      'urlImage': urlImage,
    };
  }

  factory AdvertiseModel.fromMap(Map<String, dynamic> map) {
    return AdvertiseModel(
      nameAdvertise: (map['nameAdvertise'] ?? '') as String,
      urlImage: (map['urlImage'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdvertiseModel.fromJson(String source) => AdvertiseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
