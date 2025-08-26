import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String id;
  String title;
  String description;
  DateTime date;
  bool isDone;

  TaskModel({
    this.id = '',
    required this.title,
    required this.description,
    required this.date,
    this.isDone = false,
  });

  TaskModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        isDone: json['isDone'],
        date: (json['date'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'isDone': isDone,
    'date': Timestamp.fromDate(date),
    'id': id,
  };
}
