import 'dart:io';
import 'package:clone_flutter_app/pages/add_medicine/add_medicine_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../bottomsheet/more_action_bottomsheet.dart';
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
        MedicineImageButton(imagePath: medicineAlarm.imagePath),
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
      Text('🕑 ${medicineAlarm.alarmTime}', style: textStyle),
      const SizedBox(height: 6),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('${medicineAlarm.name},', style: textStyle),
          TileActionButton(
            onTap: () {
              historyRepository.addHistory(
                MedicineHistory(
                    medicineId: medicineAlarm.id,
                    alarmTime: medicineAlarm.alarmTime,
                    takeTime: DateTime.now(),
                    medicineKey: medicineAlarm.key,
                    name: medicineAlarm.name,
                    imagePath: medicineAlarm.imagePath),
              );
            },
            title: '지금',
          ),
          Text('|', style: textStyle),
          TileActionButton(
            onTap: () => _onPreviousTake(context),
            title: '아까',
          ),
          Text('먹었어요!', style: textStyle),
        ],
      )
    ];
  }

  void _onPreviousTake(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          TimeSettingBottomSheet(initialTime: medicineAlarm.alarmTime),
    ).then((takeDateTime) {
      if (takeDateTime == null || takeDateTime is! DateTime) {
        return;
      }
      historyRepository.addHistory(MedicineHistory(
          medicineId: medicineAlarm.id,
          alarmTime: medicineAlarm.alarmTime,
          takeTime: takeDateTime,
          medicineKey: medicineAlarm.key,
          name: medicineAlarm.name,
          imagePath: medicineAlarm.imagePath));
    });
  }
}

class AfterTakeTile extends StatelessWidget {
  const AfterTakeTile({
    Key? key,
    required this.medicineAlarm,
    required this.medicineHistory,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;
  final MedicineHistory medicineHistory;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    return Row(
      children: [
        Stack(
          children: [
            MedicineImageButton(imagePath: medicineAlarm.imagePath),
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
          text: "✅  ${medicineAlarm.alarmTime} -",
          style: textStyle,
          children: [
            TextSpan(
                text: takeTimeStr,
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
            title:
                "${DateFormat('HH시 mm분').format(medicineHistory.takeTime)}에 ",
            onTap: () => _onTab(context),
          ),
          Text(
            "먹었어요.",
            style: textStyle,
          )
        ],
      )
    ];
  }

  String get takeTimeStr =>
      DateFormat('HH:mm').format(medicineHistory.takeTime);

  void _onTab(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => TimeSettingBottomSheet(
        initialTime: takeTimeStr,
        submitTitle: "수정",
        bottomWidget: TextButton(
          onPressed: () {
            historyRepository.deleteHistory(medicineAlarm.key);
            Navigator.pop(context);
          },
          child: Text(
            "복약시간을 지우고 싶어요.",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ),
    ).then((takeDateTime) {
      if (takeDateTime == null || takeDateTime is! DateTime) {
        return;
      }
      historyRepository.updateHistory(
          key: medicineHistory.key,
          history: MedicineHistory(
              medicineId: medicineAlarm.id,
              alarmTime: medicineAlarm.alarmTime,
              takeTime: takeDateTime,
              medicineKey: medicineAlarm.key,
              name: medicineAlarm.name,
              imagePath: medicineAlarm.imagePath));
    });
  }
}

class MedicineImageButton extends StatelessWidget {
  const MedicineImageButton({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: imagePath == null
          ? null
          : () {
              Navigator.push(
                context,
                FadePageRoute(
                  page: ImageDetailPage(imagePath: imagePath!),
                ),
              );
            },
      child: CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 40,
          foregroundImage:
              imagePath == null ? null : FileImage(File(imagePath!)),
          child:
              imagePath == null ? const Icon(CupertinoIcons.alarm_fill) : null),
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
        showModalBottomSheet(
            context: context,
            builder: (context) => MoreActionBottomSheet(
                  onPressedModify: () {
                    Navigator.push(
                        context,
                        FadePageRoute(
                            page: AddMedicinePage(
                          updateMedicineId: medicineAlarm.id,
                        ))).then((_) => Navigator.maybePop(context));
                  },
                  onPressedDeleteOnlyMedicine: () {
                    // 1.알람삭제
                    notification.deleteMultipleAlarm(alarmIds);
                    // 2.hive 데이터 삭제
                    medicineRepository.deleteMedicine(medicineAlarm.key);
                    Navigator.pop(context);
                  },
                  onPressedDeleteAll: () {
                    // 1.알람삭제
                    notification.deleteMultipleAlarm(alarmIds);
                    // 2.hive 데이터 삭제
                    historyRepository.deleteAllHistory(keys);
                    medicineRepository.deleteMedicine(medicineAlarm.key);

                    Navigator.pop(context);
                  },
                ));
      },
      child: const Icon(CupertinoIcons.ellipsis_vertical),
    );
  }

  List<String> get alarmIds {
    final medicine = medicineRepository.medicineBox.values
        .singleWhere((element) => element.id == medicineAlarm.id);
    final alarmIds = medicine.alarms
        .map((alarmStr) => notification.alarmId(medicine.id, alarmStr))
        .toList();
    return alarmIds;
  }

  Iterable<int> get keys {
    final histories = historyRepository.historyBox.values.where((history) =>
        history.medicineId == medicineAlarm.id &&
        history.medicineKey == medicineAlarm.key);
    final keys = histories.map((e) => e.key as int);
    return keys;
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
