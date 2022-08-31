import 'package:hive/hive.dart';

part "medicine.g.dart";

@HiveType(typeId: 1)
class Medicine {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? imagePath;

  @HiveField(3)
  final Set<String> alarms;

  Medicine(
      {required this.id,
      required this.name,
      required this.imagePath,
      required this.alarms});
}
