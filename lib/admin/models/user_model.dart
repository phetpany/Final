import 'dart:convert';

class UserModel {
  final String name;
  final String email;
  final String password;
  final String typeUser;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.typeUser,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'typeUser': typeUser,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      typeUser: map['typeUser'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
