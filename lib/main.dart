import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  /* 프레임워크 실행할 준비가 되어있는지 확인하는 절차
  * runApp()실행 하기 전 다른 함수를 실행하고 싶다면 이 함수를 실행해줘야 한다. */
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting(); /// 날짜 포맷 초기화

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: HomeScreen(),
    ),
  );
}

/// intl 패키지 이용하여 한글 적용