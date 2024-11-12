import 'dart:async'; // 비동기 프로그래밍을 위한 라이브러리 임포트
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp()); // MyApp 위젯을 실행하여 어플 시작.
}

class MyApp extends StatelessWidget {
  // StatelessWidget을 상속받는 MyApp 클래스 정의
  const MyApp({super.key}); // 생성자, super.key를 통해 키를 전달.

  Future<int> sum() {
    // 정수형 Future 객체를 반환하는 sum 메서드 정의
    return Future<int>(() {
      // Future 객체를 생성하고, 비동기 작업을 수행하는 함수 전달.
      var sum = 0; // 합계를 저장할 변수 초기화
      for (int i = 0; i < 500000000; i++) {
        // 0부터 499999999까지 반복
        sum += i; // 현재 i값을 sum에 더함.
      }
      return sum; // 최종 합계 반환
    });
  }

  @override
  Widget build(BuildContext context) {
    // 위젯 빌드 메서드
    return MaterialApp(
      //MaterialApp 위젯 변환
      home: Scaffold(
        // Scaffold 위젯으로 기본화면 구조 제공
        appBar: AppBar(
          title: const Text('202116013_권성민'),
        ), // 앱바의 제목 설정
        body: FutureBuilder(
          // FutureBuilder 위젯으로 비동기 작업의 결과를 처리
          future: sum(),
          builder: (context, snapshot) {
            // Builder 메서드, 비동기 작업으로 sum 메서드 호출
            if (snapshot.hasData) {
              // 만약 snapshot에 데이터가 있을 경우
              return Center(
                // 화면 중앙에 내용표시
                child: Text(
                  '${snapshot.data}', // sum 메서드의 결과 출력.
                  style: const TextStyle(color: Colors.black, fontSize: 30),
                ),
              );
            }
            return const Center(
              // 데이터가 아직 없는 경우
              child: Text(
                'waiting', // 'waiting' 메시지 출력
                style:
                    TextStyle(color: Colors.black, fontSize: 30), // 텍스트 스타일 성정.
              ),
            );
          },
        ),
      ),
    );
  }
}
