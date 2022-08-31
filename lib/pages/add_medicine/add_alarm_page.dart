import 'dart:io';
import 'package:clone_flutter_app/component/dory_colors.dart';
import 'package:clone_flutter_app/component/dory_constants.dart';
import 'package:clone_flutter_app/component/dory_widgts.dart';
import 'package:clone_flutter_app/main.dart';
import 'package:clone_flutter_app/models/medicine.dart';
import 'package:clone_flutter_app/services/add_medicine_service.dart';
import 'package:clone_flutter_app/services/dory_file_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';

import 'components/add_page_widget.dart';

class AddAlarmPage extends StatelessWidget {
  AddAlarmPage(
      {Key? key, required this.medicineImage, required this.medicineText})
      : super(key: key);

  final File? medicineImage;
  final String medicineText;
  final service = AddMedicineService();

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
          // 1.add alarm
          bool result = false;
          for (var alarm in service.alarms) {
            result = await notification.addNotifcication(
              medicineId: 0,
              alarmTimeStr: alarm,
              body: '$alarm 약 먹을 시간이예요!',
              title: '$medicineText 복약했다고 알려주세요',
            );
          }
          if (!result) {
            // ignore: use_build_context_synchronously
            showPermissonDenied(context, permission: "알람 접근");
          }
          // 2. save Image
          String? imageFilePath;
          if (medicineImage != null) {
            imageFilePath = await saveImageToLocalDirectory(medicineImage!);
          }
          // 3. add medicine model
          final medicine = Medicine(
              id: 0,
              name: medicineText,
              imagePath: imageFilePath,
              alarms: service.alarms);
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
                  return TimePickerBottomSheet(
                    initialTime: text,
                    service: service,
                  );
                },
              );
            },
            child: Text(text),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class TimePickerBottomSheet extends StatelessWidget {
  TimePickerBottomSheet({
    Key? key,
    required this.initialTime,
    required this.service,
  }) : super(key: key);

  final String initialTime;
  final AddMedicineService service;

  DateTime? _setDateTime;

  @override
  Widget build(BuildContext context) {
    final initialDateTime = DateFormat('HH:mm').parse(initialTime);

    return BottomSheetBody(
      children: [
        SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            onDateTimeChanged: (dateTime) {
              _setDateTime = dateTime;
            },
            mode: CupertinoDatePickerMode.time,
            initialDateTime: initialDateTime,
          ),
        ),
        const SizedBox(height: regularSpace),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.subtitle1,
                      primary: Colors.white,
                      onPrimary: DoryColors.primaryColor,
                    ),
                    child: const Text("취소")),
              ),
            ),
            const SizedBox(
              width: smallSpace,
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.subtitle1,
                    ),
                    onPressed: () {
                      service.setAlarm(
                        prevTime: initialTime,
                        setTime: _setDateTime ?? initialDateTime,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text("선택")),
              ),
            ),
          ],
        )
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
