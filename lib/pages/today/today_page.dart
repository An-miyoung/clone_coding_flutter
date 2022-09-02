import 'dart:io';

import 'package:clone_flutter_app/models/medicine_history.dart';
import 'package:clone_flutter_app/pages/bottomsheet/time_setting_bottomsheet.dart';
import 'package:clone_flutter_app/pages/today/today_empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/medicine.dart';
import '../../component/dory_constants.dart';
import '../../component/dory_page_route.dart';
import '../../main.dart';
import '../../models/medicine_alarm.dart';

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
                  MedicineListTile(medicineAlarm: medicineAlarms[index])),
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

class MedicineListTile extends StatelessWidget {
  const MedicineListTile({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    return Row(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: medicineAlarm.imagePath == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    FadePageRoute(
                      page: ImageDetailPage(medicineAlarm: medicineAlarm),
                    ),
                  );
                },
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 40,
            foregroundImage: medicineAlarm.imagePath == null
                ? null
                : FileImage(File(medicineAlarm.imagePath!)),
          ),
        ),
        const SizedBox(width: smallSpace),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(medicineAlarm.alarmTime, style: textStyle),
              const SizedBox(height: 6),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(medicineAlarm.name, style: textStyle),
                  TileActionButton(
                    title: "지금",
                    onTap: () {},
                  ),
                  Text(
                    "|",
                    style: textStyle,
                  ),
                  TileActionButton(
                    title: "아까",
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => TimeSettingBottomSheet(
                            initialTime: medicineAlarm.alarmTime),
                      ).then((takeDateTime) {
                        if (takeDateTime == null || takeDateTime is! DateTime) {
                          return;
                        }
                        historyRepository.addHistory(MedicineHistory(
                            medicineId: medicineAlarm.id,
                            alarmTime: medicineAlarm.alarmTime,
                            takeTime: takeDateTime));
                      });
                    },
                  ),
                  Text(
                    "먹었어요.",
                    style: textStyle,
                  )
                ],
              )
            ],
          ),
        ),
        CupertinoButton(
          onPressed: () {
            medicineRepository.deleteMedicine(medicineAlarm.key);
          },
          child: const Icon(CupertinoIcons.ellipsis_vertical),
        ),
      ],
    );
  }
}

class ImageDetailPage extends StatelessWidget {
  const ImageDetailPage({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: Center(
        child: medicineAlarm.imagePath == null
            ? null
            : Image.file(File(medicineAlarm.imagePath!)),
      ),
    );
  }
}

class TileActionButton extends StatelessWidget {
  const TileActionButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = Theme.of(context)
        .textTheme
        .bodyText2
        ?.copyWith(fontWeight: FontWeight.w500);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: buttonTextStyle,
        ),
      ),
    );
  }
}
