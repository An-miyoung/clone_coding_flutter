import 'package:hive/hive.dart';

part "medicine_history.g.dart";

@HiveType(typeId: 2)
class MedicineHistory extends HiveObject {
  @HiveField(0)
  final int medicineId;

  @HiveField(1)
  final String alarmTime;

  @HiveField(2)
  final DateTime takeTime;

  @HiveField(3, defaultValue: -1)
  final int medicineKey;

  @HiveField(4, defaultValue: "")
  final String name;

  @HiveField(5)
  final String? imagePath;

  MedicineHistory({
    required this.name,
    required this.imagePath,
    required this.medicineId,
    required this.alarmTime,
    required this.takeTime,
    required this.medicineKey,
  });

  @override
  String toString() {
    return "{id: $medicineId, alarmTime: $alarmTime, takeTime: $takeTime, key: $medicineKey, name: $name, imagePath: $imagePath}";
  }
}
