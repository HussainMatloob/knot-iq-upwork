// To parse this JSON data, do
//
//     final budgetDataModel = budgetDataModelFromJson(jsonString);

import 'dart:convert';

BudgetDataModel budgetDataModelFromJson(String str) =>
    BudgetDataModel.fromJson(json.decode(str));

String budgetDataModelToJson(BudgetDataModel data) =>
    json.encode(data.toJson());

class BudgetDataModel {
  Summary summary;
  List<Category> categories;

  BudgetDataModel({required this.summary, required this.categories});

  factory BudgetDataModel.fromJson(Map<String, dynamic> json) =>
      BudgetDataModel(
        summary: Summary.fromJson(json["summary"]),
        categories: List<Category>.from(
          json["categories"].map((x) => Category.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "summary": summary.toJson(),
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class Category {
  String? id;
  String? name;
  String? icon;
  String? color;
  Summary budget;
  String? createdAt;
  String? updatedAt;

  Category({
    this.id,
    this.name,
    this.icon,
    this.color,
    required this.budget,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["_id"],
    name: json["name"],
    icon: json["icon"],
    color: json["color"],
    budget: Summary.fromJson(json["budget"]),
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "icon": icon,
    "color": color,
    "budget": budget.toJson(),
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}

class Summary {
  num? planned;
  num? spent;
  num? remaining;
  num? percentage;

  Summary({this.planned, this.spent, this.remaining, this.percentage});

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    planned: json["planned"],
    spent: json["spent"],
    remaining: json["remaining"],
    percentage: json["percentage"],
  );

  Map<String, dynamic> toJson() => {
    "planned": planned,
    "spent": spent,
    "remaining": remaining,
    "percentage": percentage,
  };
}
