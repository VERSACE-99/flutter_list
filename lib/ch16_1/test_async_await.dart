import 'dart:async'; // 비동기 프로그래밍을 위한 라이브러리 임포트
import 'package:flutter/material.dart'; // Flutter의 Material Design 위젯을 사용하기 위한 라이브러리

void main() {
  runApp(MyApp()); // MyApp 위젯을 실행하여 어플 시작.
}

class MyApp extends StatelessWidget { // StatelessWidget을 상속받는 MyApp 클래스 정의.
  Future<int> funA() { // 정수형 Future 객체를 반환하는 funA 메서드 정의
    return Future.delayed(Duration(seconds: 3), () { // 3초 후에 실행될 Future 객체 생성.
      return 10; // 10을 반환.
    });
  }

  Future<int> funB(int arg) { // 정수형 Future 객체를 반환하는 funB 메서드 정의, arg는 입력값.
    return Future.delayed(Duration(seconds: 2), () { // 2초 후에 실행될 Future 객체 생성.
      return arg * arg; // 입력값 arg의 제곱을 반환.
    });
  }

  Future<int> calFun() async { // 정수형 Future 객체를 반환하는 비동기 calFun 메서드 정의.
    int aResult = await funA(); // funA를 호출하고 결과를 eResult에 저장, 비동기적으로 대기.
    int bResult = await funB(aResult); // aResult를 arg로 사용하여 funB를 호출하고 결과를 bR
    return bResult; // bResult반환
  }

  @override
  Widget build(BuildContext context) { // 위젯 빌드 메서드.
    return MaterialApp( // MaterialApp 위젯 반환.
      home: Scaffold( // Scaffold 위젯으로 기본화면 구조 제공.
        appBar: AppBar( // 앱바 생성.
          title: Text('202116013_권성민'), // 앱바 제목 설정.
        ),
        body: Center( // 중앙 내용 배치
          child: FutureBuilder( // FutureBuilder 위젯으로 비동기 작업의 결과를 처리.
              future: calFun(), // 비동기 작업으로 calFun 메서드 호출.
              builder: (context, snapshot) { // builder 메서드, 비동기 작업 상태에 따라 UI를 구성
                if (snapshot.hasData) { // 만약 snapshot에 데이터가 있는 경우
                  return Center( // 화면 중앙에 내용표시.
                      child: Text( // 결과 데이터 출력.
                    '${snapshot.data}', // 결과 데이터를 텍스트로 표시.
                    style: TextStyle(color: Colors.black, fontSize: 30), // 텍스트 스타일 설정.
                  ));
                }
                return const Center( // 데이터가 아직 없는 경우
                  child: Column( // 세로 방향으로 위젯 배치.
                    mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                    children: [
                      SizedBox( // 크기를 지정한 박스
                        width: 100, // 너비 100
                        height: 100, // 높이 100
                        child: CircularProgressIndicator(), // 로딩 인디케이터 표시
                      ),
                      Text(
                        'waiting...', // 텍스트 표시
                        style: TextStyle(color: Colors.black, fontSize: 20), // 텍스트 스타일 설정.
                      )
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
