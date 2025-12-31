// To parse this JSON data, do
//
//     final userDataModel = userDataModelFromJson(jsonString);

import 'dart:convert';

UserDataModel userDataModelFromJson(String str) =>
    UserDataModel.fromJson(json.decode(str));

String userDataModelToJson(UserDataModel data) => json.encode(data.toJson());

class UserDataModel {
  String? id;
  String? email;
  String? name;
  String? partnerName;
  String? weddingDate;
  String? weddingLocation;
  String? profileImage;
  String? role;
  int? onboardingStep;
  String? onboardingCompletedAt;
  String? createdAt;
  String? updatedAt;

  UserDataModel({
    this.id,
    this.email,
    this.name,
    this.partnerName,
    this.weddingDate,
    this.weddingLocation,
    this.profileImage,
    this.role,
    this.onboardingStep,
    this.onboardingCompletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
    id: json["id"],
    email: json["email"],
    name: json["name"],
    partnerName: json["partnerName"],
    weddingDate: json["weddingDate"],
    weddingLocation: json["weddingLocation"],
    profileImage: json["profileImage"],
    role: json["role"],
    onboardingStep: json["onboardingStep"],
    onboardingCompletedAt: json["onboardingCompletedAt"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "partnerName": partnerName,
    "weddingDate": weddingDate,
    "weddingLocation": weddingLocation,
    "profileImage": profileImage,
    "role": role,
    "onboardingStep": onboardingStep,
    "onboardingCompletedAt": onboardingCompletedAt,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}
