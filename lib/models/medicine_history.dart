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

  MedicineHistory(
      {required this.medicineId,
      required this.alarmTime,
      required this.takeTime});

  @override
  String toString() {
    return "{id: $medicineId, alarmTime: $alarmTime, takeTime: $takeTime}";
  }
}
