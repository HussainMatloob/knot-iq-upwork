// To parse this JSON data, do
//
//     final guestsDataModel = guestsDataModelFromJson(jsonString);

import 'dart:convert';

GuestsDataModel guestsDataModelFromJson(String str) =>
    GuestsDataModel.fromJson(json.decode(str));

String guestsDataModelToJson(GuestsDataModel data) =>
    json.encode(data.toJson());

class GuestsDataModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? note;
  int? plusOnes;
  String? rsvpStatus;
  bool? isVip;
  String? invitationStatus;
  String? invitationSentAt;
  String? createdAt;
  String? updatedAt;

  GuestsDataModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.note,
    this.plusOnes,
    this.rsvpStatus,
    this.isVip,
    this.invitationStatus,
    this.invitationSentAt,
    this.createdAt,
    this.updatedAt,
  });

  factory GuestsDataModel.fromJson(Map<String, dynamic> json) =>
      GuestsDataModel(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        note: json["note"],
        plusOnes: json["plusOnes"],
        rsvpStatus: json["rsvpStatus"],
        isVip: json["isVip"],
        invitationStatus: json["invitationStatus"],
        invitationSentAt: json["invitationSentAt"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "note": note,
    "plusOnes": plusOnes,
    "rsvpStatus": rsvpStatus,
    "isVip": isVip,
    "invitationStatus": invitationStatus,
    "invitationSentAt": invitationSentAt,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}
