import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medminder/src/models/medicine_type.dart';
import 'package:medminder/src/ui/new_entry/new_entry.dart';

class Medicine {
  final List<dynamic> notificationIDs;
  final String medicineName;
  final int dosage;
  final MedicineTypeModel medicineType;
  final int interval;
  final String startTime;

  Medicine({
    this.notificationIDs,
    this.medicineName,
    this.dosage,
    this.medicineType,
    this.startTime,
    this.interval,
  });

  String get getName => medicineName;
  int get getDosage => dosage;
  MedicineTypeModel get getType => medicineType;
  int get getInterval => interval;
  String get getStartTime => startTime;
  List<dynamic> get getIDs => notificationIDs;

  Map<String, dynamic> toJson() {
    return {
      "ids": this.notificationIDs,
      "name": this.medicineName,
      "dosage": this.dosage,
      "type": MedicineTypeModel().toJson(this.medicineType),
      "interval": this.interval,
      "start": this.startTime,
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> parsedJson) {
    return Medicine(
      notificationIDs: parsedJson['ids'],
      medicineName: parsedJson['name'],
      dosage: parsedJson['dosage'],
      medicineType: MedicineTypeModel.fromJson(parsedJson['type']),
      interval: parsedJson['interval'],
      startTime: parsedJson['start'],
    );
  }
}

class MedicineTypeModel {
  MedicineType type;
  String name;
  IconData icon;
  bool isSelected;

  MedicineTypeModel({this.type, this.name, this.icon, this.isSelected});
  factory MedicineTypeModel.fromJson(Map<String, dynamic> parsedJson) {
    return MedicineTypeModel(
        type: parsedJson["type"],
        name: parsedJson["name"],
        icon: parsedJson["icon"],
        isSelected: parsedJson["isSelected"]);
  }
  Map<String, dynamic> toJson(MedicineTypeModel type) {
    return {
      "type": type.type,
      "name": type.name,
      "icon": type.icon,
      "isSelected": type.isSelected,
    };
  }
}

class Medicines {
  List<Medicine> medicines = [];

  Medicines({this.medicines});
  String toJson(List<Medicine> rawList) {
    Medicine medicine = new Medicine();
    String medicines = "";
    medicines =
        rawList.map((medicine) => json.encode(medicine.toJson())).toString();

    return medicines;
  }

  factory Medicines.fromJson(List<dynamic> jsonList) {
    List<Medicine> medicines = new List<Medicine>();
    medicines =
        jsonList.map((medicine) => Medicine.fromJson(medicine)).toList();

    return Medicines(medicines: medicines);
  }

  int addMedicine({Medicine medicine}) {
    medicines.add(medicine);

    return medicines.length;
  }
}
