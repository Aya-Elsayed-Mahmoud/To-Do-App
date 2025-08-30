import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  String id;

  UserModel({required this.name, required this.email, required this.id});

  UserModel.fromJson(Map<String, dynamic> json)
    : this(name: json['name'], email: json['email'], id: json['id']);

  Map<String, dynamic> toJson() => {'name': name, 'email': email, 'id': id};
}
