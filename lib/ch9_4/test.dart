import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // fontawesomeicon을 사용하기 위해 패키지 추가

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  onPressed() {
    print('icon button click...'); // 버튼 클릭 시 출력되는 문자열.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar( // 앱바 상단의 제목
              title: Text('202116013_권성민_Icon Test'),
            ),
            body: Center( // 화면 중앙에 위젯 배치
              child: Column( // 세로로 위젯을 나열하는 위젯
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // 세로 방향으로 위젯 사이의 공간을 균일하게 배분함.
                children: [
                  Icon(Icons.alarm, size: 100, color: Colors.red), // 알람 아이콘, 크기 100, red
                  FaIcon(
                    FontAwesomeIcons.bell, // 벨 아이콘, 크기 100
                    size: 100,
                  ),
                  IconButton( // 클릭 가능한 아이콘 버튼
                      onPressed: onPressed, // 아이콘 버튼이 눌리면 opPressed함수 호출.
                      icon: Icon(
                        Icons.alarm,
                        size: 100,
                      ))
                ]))));
  }
}
