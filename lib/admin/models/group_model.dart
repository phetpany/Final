import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class GroupModel {
  final String nameGroup;
  final String urlImage;
  GroupModel({
    required this.nameGroup,
    required this.urlImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nameGroup': nameGroup,
      'urlImage': urlImage,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      nameGroup: (map['nameGroup'] ?? '') as String,
      urlImage: (map['urlImage'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) => GroupModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
