import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../component/dory_constants.dart';
import '../../component/dory_page_route.dart';
import '../../main.dart';
import '../../models/medicine_alarm.dart';
import '../../models/medicine_history.dart';
import '../bottomsheet/time_setting_bottomsheet.dart';
import 'image_detail_page.dart';

class BeforeTakeTile extends StatelessWidget {
  const BeforeTakeTile({
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