// To parse this JSON data, do
//
//     final vendorExpensesModel = vendorExpensesModelFromJson(jsonString);

import 'dart:convert';

VendorExpensesModel vendorExpensesModelFromJson(String str) =>
    VendorExpensesModel.fromJson(json.decode(str));

String vendorExpensesModelToJson(VendorExpensesModel data) =>
    json.encode(data.toJson());

class VendorExpensesModel {
  String? id;
  String? categoryId;
  String? name;
  num? totalBudget;
  String? paymentType;
  Budget budget;
  List<Installment> installments;
  String? contactName;
  String? contactNumber;
  String? note;
  List<Document> documents;
  String? createdAt;
  String? updatedAt;

  VendorExpensesModel({
    this.id,
    this.categoryId,
    this.name,
    this.totalBudget,
    this.paymentType,
    required this.budget,
    required this.installments,
    this.contactName,
    this.contactNumber,
    this.note,
    required this.documents,
    this.createdAt,
    this.updatedAt,
  });

  factory VendorExpensesModel.fromJson(Map<String, dynamic> json) =>
      VendorExpensesModel(
        id: json["_id"],
        categoryId: json["categoryId"],
        name: json["name"],
        totalBudget: json["totalBudget"],
        paymentType: json["paymentType"],
        budget: Budget.fromJson(json["budget"]),
        installments: List<Installment>.from(
          json["installments"].map((x) => Installment.fromJson(x)),
        ),
        contactName: json["contactName"],
        contactNumber: json["contactNumber"],
        note: json["note"],
        documents: List<Document>.from(
          json["documents"].map((x) => Document.fromJson(x)),
        ),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "categoryId": categoryId,
    "name": name,
    "totalBudget": totalBudget,
    "paymentType": paymentType,
    "budget": budget.toJson(),
    "installments": List<dynamic>.from(installments.map((x) => x.toJson())),
    "contactName": contactName,
    "contactNumber": contactNumber,
    "note": note,
    "documents": List<dynamic>.from(documents.map((x) => x.toJson())),
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

class Document {
  String? name;
  String? url;
  String? size;

  Document({this.name, this.url, this.size});

  factory Document.fromJson(Map<String, dynamic> json) =>
      Document(name: json["name"], url: json["url"], size: json["size"]);

  Map<String, dynamic> toJson() => {"name": name, "url": url, "size": size};
}

class Installment {
  num? amount;
  String? startDate;
  String? dueDate;
  bool isPaid;
  bool remindMe;
  String? note;

  Installment({
    this.amount,
    this.startDate,
    this.dueDate,
    required this.isPaid,
    required this.remindMe,
    this.note,
  });

  factory Installment.fromJson(Map<String, dynamic> json) => Installment(
    amount: json["amount"],
    startDate: json["startDate"],
    dueDate: json["dueDate"],
    isPaid: json["isPaid"],
    remindMe: json["remindMe"],
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "startDate": startDate,
    "dueDate": dueDate,
    "isPaid": isPaid,
    "remindMe": remindMe,
    "note": note,
  };
}
