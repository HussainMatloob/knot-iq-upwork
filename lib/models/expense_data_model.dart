// To parse this JSON data, do
//
//     final dashboardDataModel = dashboardDataModelFromJson(jsonString);

import 'dart:convert';

ExpenseDataModel dashboardDataModelFromJson(String str) =>
    ExpenseDataModel.fromJson(json.decode(str));

String dashboardDataModelToJson(ExpenseDataModel data) =>
    json.encode(data.toJson());

class ExpenseDataModel {
  String? id;
  CategoryId categoryId;
  Budget budget;
  String? title;
  num amount;
  String? note;
  List<Installment> installments;
  String? createdAt;
  String? updatedAt;

  ExpenseDataModel({
    this.id,
    required this.categoryId,
    required this.budget,
    this.title,
    required this.amount,
    this.note,
    required this.installments,
    this.createdAt,
    this.updatedAt,
  });

  factory ExpenseDataModel.fromJson(Map<String, dynamic> json) =>
      ExpenseDataModel(
        id: json["_id"],
        categoryId: CategoryId.fromJson(json["categoryId"]),
        budget: Budget.fromJson(json["budget"]),
        title: json["title"],
        amount: json["amount"],
        note: json["note"],
        installments: List<Installment>.from(
          json["installments"].map((x) => Installment.fromJson(x)),
        ),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "categoryId": categoryId.toJson(),
    "budget": budget.toJson(),
    "title": title,
    "amount": amount,
    "note": note,
    "installments": List<dynamic>.from(installments.map((x) => x.toJson())),
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}

class Budget {
  num? total;
  num? spent;
  num? remaining;
  num? percentage;

  Budget({
    required this.total,
    required this.spent,
    required this.remaining,
    required this.percentage,
  });

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
    total: json["total"],
    spent: json["spent"],
    remaining: json["remaining"],
    percentage: json["percentage"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "spent": spent,
    "remaining": remaining,
    "percentage": percentage,
  };
}

class CategoryId {
  String? id;
  String? name;
  String? icon;
  String? color;

  CategoryId({this.id, this.name, this.icon, this.color});

  factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
    id: json["_id"],
    name: json["name"],
    icon: json["icon"],
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "icon": icon,
    "color": color,
  };
}

class Installment {
  num? amount;
  String? startDate;
  bool isPaid;
  bool remindMe;
  String? note;

  Installment({
    required this.amount,
    this.startDate,
    required this.isPaid,
    required this.remindMe,
    this.note,
  });

  factory Installment.fromJson(Map<String, dynamic> json) => Installment(
    amount: json["amount"],
    startDate: json["startDate"],
    isPaid: json["isPaid"],
    remindMe: json["remindMe"],
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "startDate": startDate,
    "isPaid": isPaid,
    "remindMe": remindMe,
    "note": note,
  };
}
