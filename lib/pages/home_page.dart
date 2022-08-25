import 'package:clone_flutter_app/component/dory_colors.dart';
import 'package:clone_flutter_app/pages/add_medicine/add_medicine_page.dart';
import 'package:clone_flutter_app/pages/history/history_page.dart';
import 'package:clone_flutter_app/pages/today/today_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _pages = [const TodayPage(), const HistoryPage()];

  @override
  Widget build(BuildContext context) {
    return Container(
      // 3. bottomNavigationBar 의 색과 scaffold 하단의 색을 맞추기 위해
      // scaffold 는 theme 색상을 기본으로 갖고 이 앱은 검정이 기본색이다.
      color: Colors.yellow,
      // 1.하단과 bottomNavigationBar 사이 공간을 없애주기 위해 SafeArea 로 감싼다.
      child: SafeArea(
        // 4. 맨 위 AppBar밖의 색상이 3번 작업으로 노란색이 되서 top을 사용하지 않는 설정
        top: false,
        child: Scaffold(
          appBar: AppBar(),
          body: _pages[_currentIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: _onAddMedicine,
            child: const Icon(CupertinoIcons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _buildBottomAppBar(),
        ),
      ),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
        // 2.SafeArea 로 감싼 후 아래공간과 bottomNavigationBar 를 구분하는 선을 없애기 위해
        // elevation 을 0으로 준다.
        elevation: 0,
        child: Container(
          height: kBottomNavigationBarHeight,
          color: Colors.yellow,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            CupertinoButton(
                onPressed: () => _onCurrentPage(0),
                child: Icon(
                  CupertinoIcons.check_mark,
                  color: (_currentIndex == 0
                      ? DoryColors.primaryColor
                      : Colors.grey[350]),
                )),
            CupertinoButton(
                onPressed: () => _onCurrentPage(1),
                child: Icon(
                  CupertinoIcons.text_badge_checkmark,
                  color: _currentIndex == 1
                      ? DoryColors.primaryColor
                      : Colors.grey[350],
                ))
          ]),
        ));
  }

  void _onCurrentPage(int pageIndex) {
    setState(() {
      _currentIndex = pageIndex;
    });
  }

  void _onAddMedicine() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddMedicinePage(),
        ));
  }
}
