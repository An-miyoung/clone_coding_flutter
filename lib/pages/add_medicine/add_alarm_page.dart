// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../component/dory_constants.dart';
import '../../component/dory_widgts.dart';
import '../../main.dart';
import '../../models/medicine.dart';
import '../../services/add_medicine_service.dart';
import '../../services/dory_file_service.dart';
import '../bottomsheet/time_setting_bottomsheet.dart';
import 'components/add_page_widget.dart';

class AddAlarmPage extends StatelessWidget {
  AddAlarmPage(
      {Key? key,
      required this.medicineImage,
      required this.medicineText,
      required this.updateMedicineId})
      : super(key: key) {
    service = AddMedicineService(updateMedicineId);
  }

  final int updateMedicineId;
  final File? medicineImage;
  final String medicineText;

  late AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AddPageBody(
        children: [
          Text(
            "매일 복약 잊지 말아요!",
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(
            height: largeSpace,
          ),
          Expanded(
              child: AnimatedBuilder(
            animation: service,
            builder: (context, _) {
              return ListView(
                children: alarmWidget,
              );
            },
          )),
        ],
      ),
      bottomNavigationBar: BottomSubmitButton(
        onPressed: () async {
          final isUpdate = updateMedicineId != -1;
          isUpdate
              ? await _onUpdateMedicine(context)
              : await _onAddMedicine(context);
        },
        text: "완료",
      ),
    );
  }

  List<Widget> get alarmWidget {
    final children = <Widget>[];

    children.addAll(
      service.alarms.map(
        (alarm) => AlarmBox(
          service: service,
          text: alarm,
        ),
      ),
    );
    children.add(AddAlarmButton(
      service: service,
    ));

    return children;
  }

  Future<void> _onAddMedicine(BuildContext context) async {
    // 1.add alarm
    bool result = false;
    for (var alarm in service.alarms) {
      result = await notification.addNotifcication(
        medicineId: medicineRepository.newId,
        alarmTimeStr: alarm,
        body: '$alarm 약 먹을 시간이예요!',
        title: '$medicineText 복약했다고 알려주세요',
      );
    }
    if (!result) {
      // ignore: use_build_context_synchronously
      return showPermissonDenied(context, permission: "알람 접근");
    }
    // 2. save Image
    String? imageFilePath;
    if (medicineImage != null) {
      imageFilePath = await saveImageToLocalDirectory(medicineImage!);
    }
    // 3. add medicine model
    final medicine = Medicine(
        id: medicineRepository.newId,
        name: medicineText,
        imagePath: imageFilePath,
        alarms: service.alarms.toList());
    medicineRepository.addMedicine(medicine);

    // ignore: use_build_context_synchronously
    Navigator.popUntil(context, ((route) => route.isFirst));
  }

  Future<void> _onUpdateMedicine(BuildContext context) async {
    // 1-1.delete previous alarm
    final alarmIds = _updateMedicine.alarms
        .map((alarmTime) => notification.alarmId(updateMedicineId, alarmTime));
    await notification.deleteMultipleAlarm(alarmIds);

    // 1-2.add alarm
    bool result = false;
    for (var alarm in service.alarms) {
      result = await notification.addNotifcication(
        medicineId: updateMedicineId,
        alarmTimeStr: alarm,
        body: '$alarm 약 먹을 시간이예요!',
        title: '$medicineText 복약했다고 알려주세요',
      );
    }
    if (!result) {
      // ignore: use_build_context_synchronously
      return showPermissonDenied(context, permission: "알람 접근");
    }

    String? imageFilePath = _updateMedicine.imagePath;

    if (imageFilePath != medicineImage?.path) {
      // 2-1. delete previous image
      if (_updateMedicine.imagePath != null) {
        deleteImage(_updateMedicine.imagePath!);
      }

      // 2-2. save Image
      if (medicineImage != null) {
        imageFilePath = await saveImageToLocalDirectory(medicineImage!);
      }
    }
    // 3. update medicine model
    final medicine = Medicine(
        id: updateMedicineId,
        name: medicineText,
        imagePath: imageFilePath,
        alarms: service.alarms.toList());
    medicineRepository.updateMedicine(
        key: _updateMedicine.key, medicine: medicine);

    // ignore: use_build_context_synchronously
    Navigator.popUntil(context, ((route) => route.isFirst));
  }

  Medicine get _updateMedicine {
    return medicineRepository.medicineBox.values
        .singleWhere((medicine) => medicine.id == updateMedicineId);
  }
}

class AlarmBox extends StatelessWidget {
  const AlarmBox({
    Key? key,
    required this.text,
    required this.service,
  }) : super(key: key);

  final String text;
  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () {
              service.removeAlarm(text);
            },
            icon: const Icon(CupertinoIcons.minus_circle),
          ),
        ),
        Expanded(
          flex: 5,
          child: TextButton(
            style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.subtitle2),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return TimeSettingBottomSheet(
                    initialTime: text,
                  );
                },
              ).then((value) {
                if (value == null || value is! DateTime) return;
                service.setAlarm(
                  prevTime: text,
                  setTime: value,
                );
              });
            },
            child: Text(text),
          ),
        ),
      ],
    );
  }
}

class AddAlarmButton extends StatelessWidget {
  const AddAlarmButton({
    Key? key,
    required this.service,
  }) : super(key: key);

  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        textStyle: Theme.of(context).textTheme.subtitle1,
      ),
      onPressed: service.addNowAlarm,
      child: Row(
        children: [
          const Expanded(
              flex: 1, child: Icon(CupertinoIcons.add_circled_solid)),
          Expanded(
            flex: 5,
            child: Center(
                child: Text("복용시간 추가",
                    style: Theme.of(context).textTheme.subtitle1)),
          ),
        ],
      ),
    );
  }
}
