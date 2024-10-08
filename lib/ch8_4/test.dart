import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget { // statelessWidget(정적) UI상속.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold( // 레이아웃 설정.
        appBar: AppBar( // 제목 표시줄.
          title: Text('202116013_권성민 StatefulWidget test'), // 상단에 제목 표시.
        ),
        body: MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatefulWidget { // StatefulWidget을 상속하여 상태를 가질 수 있는 위젯.
  @override
  State<StatefulWidget> createState() { // build함수가 없으므로 State를 상속받은 클래스 반환.
    return _MyWidgetState();
  }
}

class _MyWidgetState extends State<MyWidget> {
  bool enabled = false; // 체크박스 상태 관리 변수, 기본값은 비활성.
  String stateText = "disable"; // 화면에 표시될 텍스트.

  void changeCheck() { // 체크박스 상태 변경 함수.
    setState(() { // 상태변경을 Flutter terminal에 보여줌.
      if (enabled) { // 체크박스 활성화.
        stateText = "disable"; // 텍스트 disable출력.
        enabled = false; // 체크박스 비활성화.
      } else { // 체크박스 비활성화.
        stateText = "enable"; // 텍스트 enble 출력.
        enabled = true; // 체크박스 활성화.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center( // 화면에 중앙 배치.
      child: Row( // 위젯 수평 나열.
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: (enabled // enabled상태에 따라 다른 아이콘 표시.
                ? Icon( // 체크박스 아이콘 표시.
                    Icons.check_box,
                    size: 20, // 아이콘 크기 설정.
                  )
                : Icon(
                    Icons.check_box_outline_blank, // 빈 체크박스 아이콘 표시.
                    size: 20,
                  )),
            color: Colors.red, // 색 설정.
            onPressed: changeCheck, // 아이콘 클릭 시 changecheck 함수 호출.
          ),
          Container( // 텍스트를 포함할 컨테이너 함수.
            padding: EdgeInsets.only(left: 16),
            child: Text(
              '$stateText', // 현재 상태에 따라 표시되는 텍스트
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), // 텍스트 스타일.
            ),
          ),
        ],
      ),
    );
  }
}
