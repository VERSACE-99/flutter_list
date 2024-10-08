import 'package:flutter/material.dart';
import 'package:flutter_lab_202116013/ch2/test_50.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget { // 정적 StatelessWidget을 상속받는 클래스 정의
  bool enabled = false; // 체크박스의 활성화 상태를 관리하는 변수, 기본값 false.
  String stateText = "disable"; // 상태에 따라 화면에 표시되는 텍스트 기본값 disable.

  void changeChek() { // 체크박스 상태를 변경하는 함수.
    if (enabled) { // enabled가 활성화 상태일 때.
      stateText = "disable"; // 텍스트를 disable로 변경.
      enabled = false; // 체크박스 비활성화.
    } else { // enabled 비활성화.
      stateText = "enable"; // 텍스트를 enable로 변경.
      enabled = true; // 체크박스 활성화.
    }
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold( // 레이아웃 제공.
        appBar: AppBar( // 제목 표시줄.
          title: Text('Stateless Test'),
        ),
        body: Center( // 화면 중앙에 위젯 배치.
          child: Row( // 수평 위젯 나열.
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton( // 클릭할 수 있는 아이콘 버튼 생성.
                icon: (enabled ? Icon(Icons.check_box, size: 20,) : // true : 체크박스 아이콘 표시.
                      Icon(Icons.check_box_outline_blank, size: 20,)), // false : 빈 체크박스 아이콘 표시.
                color: Colors.red, // 색 설정.
                onPressed: changeChek, // changecheck함수 호출 -> 상태 변경.
              ),
              Container( // 텍스트 표시 컨테이너
                padding: EdgeInsets.only(left: 16),
                child: Text('$stateText', style: TextStyle(fontSize: 30, // 택스트 표시.
                        fontWeight: FontWeight.bold),),

              ),
            ],
          ),
        )
      )
    );
  }
}

