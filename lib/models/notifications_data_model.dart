// To parse this JSON data, do
//
//     final notificationDataModel = notificationDataModelFromJson(jsonString);

import 'dart:convert';

NotificationDataModel notificationDataModelFromJson(String str) =>
    NotificationDataModel.fromJson(json.decode(str));

String notificationDataModelToJson(NotificationDataModel data) =>
    json.encode(data.toJson());

class NotificationDataModel {
  String? id;
  String? userId;
  String? type;
  String? title;
  String? message;
  String? dueDate;
  bool isRead;
  String? relatedId;
  String? relatedType;
  num? amount;
  String? vendorName;
  String? createdAt;
  String? updatedAt;

  NotificationDataModel({
    this.id,
    this.userId,
    this.type,
    this.title,
    this.message,
    this.dueDate,
    required this.isRead,
    this.relatedId,
    this.relatedType,
    this.amount,
    this.vendorName,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) =>
      NotificationDataModel(
        id: json["_id"],
        userId: json["userId"],
        type: json["type"],
        title: json["title"],
        message: json["message"],
        dueDate: json["dueDate"],
        isRead: json["isRead"],
        relatedId: json["relatedId"],
        relatedType: json["relatedType"],
        amount: json["amount"],
        vendorName: json["vendorName"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "type": type,
    "title": title,
    "message": message,
    "dueDate": dueDate,
    "isRead": isRead,
    "relatedId": relatedId,
    "relatedType": relatedType,
    "amount": amount,
    "vendorName": vendorName,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}
