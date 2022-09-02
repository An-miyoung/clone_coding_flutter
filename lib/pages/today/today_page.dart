import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/medicine.dart';
import '../../component/dory_constants.dart';
import '../../main.dart';
import '../../models/medicine_alarm.dart';

import 'today_empty_widget.dart';
import 'today_take_tile.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({Key? key}) : super(key: key);

  // final service = AddMedicineService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "오늘 복용할 약은?",
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(height: regularSpace),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: medicineRepository.medicineBox.listenable(),
            builder: _builderMedicineListView,
          ),
        ),
      ],
    );
  }

  Widget _builderMedicineListView(context, Box<Medicine> box, _) {
    final medicines = box.values.toList();
    final medicineAlarms = <MedicineAlarm>[];

    if (medicines.isEmpty) {
      return const TodayEmpty();
    }

    for (var medicine in medicines) {
      for (var alarm in medicine.alarms) {
        medicineAlarms.add(MedicineAlarm(
          medicine.id,
          medicine.name,
          medicine.imagePath,
          alarm,
          medicine.key!,
        ));
      }
    }

    return Column(
      children: [
        const Divider(height: 1, thickness: 1.0),
        Expanded(
          child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: smallSpace),
              itemBuilder: ((context, index) =>
                  BeforeTakeTile(medicineAlarm: medicineAlarms[index])),
              separatorBuilder: ((context, index) {
                return const Divider(height: regularSpace);
              }),
              itemCount: medicineAlarms.length),
        ),
        const Divider(height: 1, thickness: 1.0),
      ],
    );
  }
}
