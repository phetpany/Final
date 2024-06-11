import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PlacesModel {
  final String docIDGroup;
  final String name;
  final String description;
  final String urlGoogleMap;
  final List<String> urlImages;
  PlacesModel({
    required this.docIDGroup,
    required this.name,
    required this.description,
    required this.urlGoogleMap,
    required this.urlImages,
  });

  


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docIDGroup': docIDGroup,
      'name': name,
      'description': description,
      'urlGoogleMap': urlGoogleMap,
      'urlImages': urlImages,
    };
  }

  factory PlacesModel.fromMap(Map<String, dynamic> map) {
    return PlacesModel(
      docIDGroup: (map['docIDGroup'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      urlGoogleMap: (map['urlGoogleMap'] ?? '') as String,
      urlImages: List<String>.from(map['urlImages'] ?? []),    );
  }

  String toJson() => json.encode(toMap());

  factory PlacesModel.fromJson(String source) =>
      PlacesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
