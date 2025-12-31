// To parse this JSON data, do
//
//     final tasksDataModel = tasksDataModelFromJson(jsonString);

import 'dart:convert';

TasksDataModel tasksDataModelFromJson(String str) =>
    TasksDataModel.fromJson(json.decode(str));

String tasksDataModelToJson(TasksDataModel data) => json.encode(data.toJson());

class TasksDataModel {
  String? id;
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  bool isCompleted;
  bool remindMe;
  List<Assignee> assignees;
  String? createdAt;
  String? updatedAt;

  TasksDataModel({
    this.id,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    required this.isCompleted,
    required this.remindMe,
    required this.assignees,
    this.createdAt,
    this.updatedAt,
  });

  factory TasksDataModel.fromJson(Map<String, dynamic> json) => TasksDataModel(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    isCompleted: json["isCompleted"],
    remindMe: json["remindMe"],
    assignees: List<Assignee>.from(
      json["assignees"].map((x) => Assignee.fromJson(x)),
    ),
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "startDate": startDate,
    "endDate": endDate,
    "isCompleted": isCompleted,
    "remindMe": remindMe,
    "assignees": List<dynamic>.from(assignees.map((x) => x.toJson())),
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}

class Assignee {
  String? id;
  String? firstName;
  String? lastName;
  String? email;

  Assignee({this.id, this.firstName, this.lastName, this.email});

  factory Assignee.fromJson(Map<String, dynamic> json) => Assignee(
    id: json["_id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
  };
}
