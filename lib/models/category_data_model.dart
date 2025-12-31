// To parse this JSON data, do
//
//     final categoriesDataModel = categoriesDataModelFromJson(jsonString);

import 'dart:convert';

CategoriesDataModel categoriesDataModelFromJson(String str) =>
    CategoriesDataModel.fromJson(json.decode(str));

String categoriesDataModelToJson(CategoriesDataModel data) =>
    json.encode(data.toJson());

class CategoriesDataModel {
  String? id;
  String? name;
  String? icon;
  String? color;
  String? supplierName;
  Stats? stats;
  String? createdAt;
  String? updatedAt;
  String? categoryId;

  CategoriesDataModel({
    this.id,
    this.name,
    this.icon,
    this.color,
    this.supplierName,
    this.stats,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
  });

  factory CategoriesDataModel.fromJson(Map<String, dynamic> json) =>
      CategoriesDataModel(
        id: json["_id"],
        name: json["name"],
        icon: json["icon"],
        color: json["color"],
        supplierName: json["supplierName"],
        stats: Stats.fromJson(json["stats"]),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        categoryId: json["categoryId"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "icon": icon,
    "color": color,
    "supplierName": supplierName,
    "stats": stats?.toJson(),
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "categoryId": categoryId,
  };
}

class Stats {
  dynamic totalVendors;
  dynamic totalBudget;

  Stats({this.totalVendors, this.totalBudget});

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    totalVendors: json["totalVendors"],
    totalBudget: json["totalBudget"],
  );

  Map<String, dynamic> toJson() => {
    "totalVendors": totalVendors,
    "totalBudget": totalBudget,
  };
}
