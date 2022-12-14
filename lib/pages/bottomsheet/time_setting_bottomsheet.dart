import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../component/dory_constants.dart';
import '../../component/dory_widgts.dart';
import '../../component/dory_colors.dart';

class TimeSettingBottomSheet extends StatelessWidget {
  const TimeSettingBottomSheet({
    Key? key,
    required this.initialTime,
    this.submitTitle = "선택",
    this.bottomWidget,
  }) : super(key: key);

  final String initialTime;
  final String submitTitle;
  final Widget? bottomWidget;

  @override
  Widget build(BuildContext context) {
    final initialTimeData = DateFormat('HH:mm').parse(initialTime);
    final now = DateTime.now();
    final DateTime initialDateTime = DateTime(now.year, now.month, now.day,
        initialTimeData.hour, initialTimeData.minute);
    DateTime setDateTime = initialDateTime;

    return BottomSheetBody(
      children: [
        SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            onDateTimeChanged: (dateTime) {
              setDateTime = dateTime;
            },
            mode: CupertinoDatePickerMode.time,
            initialDateTime: initialDateTime,
          ),
        ),
        const SizedBox(height: smallSpace),
        if (bottomWidget != null) bottomWidget!,
        const SizedBox(height: smallSpace),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.subtitle1,
                      primary: Colors.white,
                      onPrimary: DoryColors.primaryColor,
                    ),
                    onPressed: () => Navigator.pop(context),
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
                    onPressed: () => Navigator.pop(context, setDateTime),
                    child: Text(submitTitle)),
              ),
            ),
          ],
        )
      ],
    );
  }
}
