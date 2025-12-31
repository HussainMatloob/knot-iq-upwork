import 'dart:convert';

DashboardDataModel dashboardDataModelFromJson(String str) =>
    DashboardDataModel.fromJson(json.decode(str));

String dashboardDataModelToJson(DashboardDataModel data) =>
    json.encode(data.toJson());

class DashboardDataModel {
  Guests guests;
  Vendors vendors;
  Budget budget;
  Tasks tasks;
  List<UpcomingReminder>? upcomingReminders;

  DashboardDataModel({
    required this.guests,
    required this.vendors,
    required this.budget,
    required this.tasks,
    this.upcomingReminders = const [],
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) =>
      DashboardDataModel(
        guests: Guests.fromJson(json["guests"]),
        vendors: Vendors.fromJson(json["vendors"]),
        budget: Budget.fromJson(json["budget"]),
        tasks: Tasks.fromJson(json["tasks"]),
        upcomingReminders: List<UpcomingReminder>.from(
          json["upcomingReminders"].map((x) => UpcomingReminder.fromJson(x)) ??
              [],
        ),
      );

  Map<String, dynamic> toJson() => {
    "guests": guests.toJson(),
    "vendors": vendors.toJson(),
    "budget": budget.toJson(),
    "tasks": tasks.toJson(),
    "upcomingReminders": List<dynamic>.from(
      upcomingReminders?.map((x) => x.toJson()) ?? [],
    ),
  };
}

class Budget {
  num? spent;
  num? planned;

  Budget({this.spent, this.planned});

  factory Budget.fromJson(Map<String, dynamic> json) =>
      Budget(spent: json["spent"], planned: json["planned"]);

  Map<String, dynamic> toJson() => {"spent": spent, "planned": planned};
}

class Guests {
  num? attending;
  num? total;

  Guests({this.attending, this.total});

  factory Guests.fromJson(Map<String, dynamic> json) =>
      Guests(attending: json["attending"], total: json["total"]);

  Map<String, dynamic> toJson() => {"attending": attending, "total": total};
}

class Tasks {
  num? completed;
  num? total;

  Tasks({this.completed, this.total});

  factory Tasks.fromJson(Map<String, dynamic> json) =>
      Tasks(completed: json["completed"], total: json["total"]);

  Map<String, dynamic> toJson() => {"completed": completed, "total": total};
}

class UpcomingReminder {
  String? id;
  String? type;
  String? title;
  String? message;
  String? dueDate;
  bool? isRead;
  num? amount;
  String? vendorName;

  UpcomingReminder({
    this.id,
    this.type,
    this.title,
    this.message,
    this.dueDate,
    this.isRead,
    this.amount,
    this.vendorName,
  });

  factory UpcomingReminder.fromJson(Map<String, dynamic> json) =>
      UpcomingReminder(
        id: json["_id"],
        type: json["type"],
        title: json["title"],
        message: json["message"],
        dueDate: json["dueDate"],
        isRead: json["isRead"],
        amount: json["amount"],
        vendorName: json["vendorName"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "title": title,
    "message": message,
    "dueDate": dueDate,
    "isRead": isRead,
    "amount": amount,
    "vendorName": vendorName,
  };
}

class Vendors {
  num? current;
  num? target;

  Vendors({this.current, this.target});

  factory Vendors.fromJson(Map<String, dynamic> json) =>
      Vendors(current: json["current"], target: json["target"]);

  Map<String, dynamic> toJson() => {"current": current, "target": target};
}
