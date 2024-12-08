import 'dart:async'; // 비동기 프로그래밍을 위한 패키지 임포트
import 'package:flutter/material.dart'; // Flutter의 기본 UI 라이브러리

void main() {
  runApp(MyApp()); // MyApp 위젯을 실행하여 앱 시작
}

class MyApp extends StatelessWidget {
  // 정수 x를 받아서 x의 제곱을 반환하는 함수
  int calFun(int x) {
    return x * x; // x를 제곱하여 반환
  }

  // 3초마다 호출되는 Stream을 생성하는 함수
  Stream<int> test() {
    Duration duration = Duration(seconds: 3); // 3초 간격 설정.
    // 주기적으로 calFun 함수를 호출하여 Stream<int> 생성
    Stream<int> stream = Stream<int>.periodic(duration, calFun);
    // 처음 6개의 값만 가져옴
    return stream.take(6);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('202116013_권성민_Stream Test'), // 앱바 제목 설정.
        ),
        body: Center(
          child: StreamBuilder(
              stream: test(), // test()함수로부터 생성된 Stream을 구독.
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                //Stream의 현재 상태에 따라 위젯 빌드
                if (snapshot.connectionState == ConnectionState.done) {
                  // Stream이 완료되었을 때
                  return const Center(
                    child: Text(
                      'Completed', // 완료 메시지 표시
                      style: TextStyle(
                        fontSize: 30.0, // 글자 크기 설정
                      ),
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  // Stream이 아직 데이터를 기다리고 있을 때
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100, // 원형 프로그레스 인디케이터의 넓이
                          height: 100, // 원형 프로그레스 인디케이터의 높이
                          child: CircularProgressIndicator(),
                        ),
                        Text(
                          'waiting...', // 대기 중 메시지 표시.
                          style: TextStyle(fontSize: 20), // 글자 크기 설정
                        )
                      ],
                    ),
                  );
                }
                // 데이터가 정상적으로 수신되었을 때
                return Center(
                  child: Text(
                    'data : ${snapshot.data}', // 수신된 데이터 표시
                    style: const TextStyle(
                        fontSize: 30.0 // 글자 크기 설정.
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
