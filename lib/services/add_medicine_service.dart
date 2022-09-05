import 'package:clone_flutter_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class AddMedicineService with ChangeNotifier {
  AddMedicineService(int updateMedicineId) {
    final isUpdate = updateMedicineId != -1;
    if (isUpdate) {
      final updateAlarms = medicineRepository.medicineBox.values
          .singleWhere((medicine) => medicine.id == updateMedicineId);

      _alarms.clear();
      _alarms.addAll(updateAlarms.alarms);
    }
  }

  final _alarms = <String>{"08:00", "13:00", "19:00"};

  Set<String> get alarms => _alarms;

  void addNowAlarm() {
    final DateTime now = DateTime.now();
    final nowTime = DateFormat('HH:mm').format(now);

    _alarms.add(nowTime);
    notifyListeners();
  }

  void removeAlarm(String time) {
    _alarms.remove(time);
    notifyListeners();
  }

  void setAlarm({required String prevTime, required DateTime setTime}) {
    final newTime = DateFormat('HH:mm').format(setTime);

    _alarms.remove(prevTime);
    _alarms.add(newTime);
    notifyListeners();
  }
}
