import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../component/dory_constants.dart';
import '../../main.dart';
import '../../models/medicine.dart';
import '../../models/medicine_history.dart';
import '../today/today_take_tile.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '잘 복용 했어요 👏🏻',
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(
          height: regularSpace,
        ),
        const Divider(
          height: 1,
          thickness: 1.0,
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: historyRepository.historyBox.listenable(),
            builder: _buildListView,
          ),
        ),
      ],
    );
  }

  Widget _buildListView(context, Box<MedicineHistory> historyBox, _) {
    final medicineHistories = historyBox.values.toList().reversed.toList();
    return ListView.builder(
      itemBuilder: (context, index) {
        final medicineHistory = medicineHistories[index];
        return _TimeTile(medicineHistory: medicineHistory);
      },
      itemCount: medicineHistories.length,
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    Key? key,
    required this.medicineHistory,
  }) : super(key: key);

  final MedicineHistory medicineHistory;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            DateFormat('yyyy\nMM.dd E', 'ko_KR')
                .format(medicineHistory.takeTime),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                height: 1.6, leadingDistribution: TextLeadingDistribution.even),
          ),
        ),
        const SizedBox(width: smallSpace),
        Stack(
          alignment: const Alignment(0.0, -0.3),
          children: const [
            SizedBox(
              height: 130,
              child: VerticalDivider(
                width: 1,
                thickness: 1,
              ),
            ),
            // 검은 원형위에 하얀 원형을 겹쳐서 라인만 있는 원으로 만듬
            CircleAvatar(
              radius: 4,
              child: CircleAvatar(
                radius: 3,
                backgroundColor: Colors.white,
              ),
            )
          ],
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: medicine.imagePath != null,
                child: MedicineImageButton(imagePath: medicine.imagePath),
              ),
              const SizedBox(width: smallSpace),
              Text(
                  '${DateFormat("a hh:mm", 'ko_KR').format(medicineHistory.takeTime)}\n${medicine.name}',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        height: 1.6,
                        leadingDistribution: TextLeadingDistribution.even,
                      ))
            ],
          ),
        ),
      ],
    );
  }

  Medicine get medicine {
    return medicineRepository.medicineBox.values.singleWhere(
      (element) =>
          element.id == medicineHistory.medicineId &&
          element.key == medicineHistory.medicineKey,
      orElse: () => Medicine(
          alarms: [],
          id: -1,
          name:
              medicineHistory.name.isEmpty ? "삭제된 약입니다." : medicineHistory.name,
          imagePath: medicineHistory.imagePath),
    );
  }
}
