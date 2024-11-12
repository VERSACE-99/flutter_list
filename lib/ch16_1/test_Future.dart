import 'dart:async'; // 비동기 프로그래밍을 위한 라이브러리 임포트
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // StatelessWidget을 상속받는 MyApp 클래스 정의
  const MyApp({super.key}); // 생성자, super.key를 통해 키를 전달.

  Future<int> sum() {
    return Future<int>(() {
      var sum = 0;
      for (int i = 0; i < 500000000; i++) {
        sum += i;
      }
      return sum;
    });
  }
}
