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

class AfterTakeTile extends StatelessWidget {
  const AfterTakeTile({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    return Row(
      children: [
        Stack(
          children: [
            _MedicineImageButton(medicineAlarm: medicineAlarm),
            CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green.withOpacity(0.8),
                child: const Icon(
                  CupertinoIcons.check_mark,
                  color: Colors.white,
                ))
          ],
        ),
        const SizedBox(width: smallSpace),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTileBody(textStyle, context),
          ),
        ),
        _MoreButton(medicineAlarm: medicineAlarm),
      ],
    );
  }

  List<Widget> _buildTileBody(TextStyle? textStyle, BuildContext context) {
    return [
      Text.rich(
        TextSpan(
          text: "${medicineAlarm.alarmTime} -",
          style: textStyle,
          children: [
            TextSpan(
                text: ' 20:20',
                style: textStyle?.copyWith(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
      const SizedBox(height: 6),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(medicineAlarm.name, style: textStyle),
          TileActionButton(
            title: "20시 20분에 ",
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
    ];
  }
}

class _MedicineImageButton extends StatelessWidget {
  const _MedicineImageButton({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
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
    );
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        medicineRepository.deleteMedicine(medicineAlarm.key);
      },
      child: const Icon(CupertinoIcons.ellipsis_vertical),
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
