import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = '계산기 예제';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: WidgetApp(),
    );
  }
}

class WidgetApp extends StatefulWidget {
  @override
  _WidgetExampleState createState() => _WidgetExampleState();
}

class _WidgetExampleState extends State<WidgetApp> {
  String result = '';
  List<String> previousResults = [];
  TextEditingController value1 = TextEditingController();
  TextEditingController value2 = TextEditingController();
  String operation = '+';

  void calculate() {
    double num1 = double.tryParse(value1.text) ?? 0;
    double num2 = double.tryParse(value2.text) ?? 0;

    setState(() {
      switch (operation) {
        case '+':
          result = (num1 + num2).toString();
          break;
        case '-':
          result = (num1 - num2).toString();
          break;
        case '*':
          result = (num1 * num2).toString();
          break;
        case '/':
          if (num2 != 0) {
            result = (num1 / num2).toString();
          } else {
            result = '0으로 나눌 수 없음';
          }
          break;
      }
      previousResults.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 배경색을 검정색으로 설정
      appBar: AppBar(
        title: const Text('계산기 예제'),
        backgroundColor: Colors.orange, // AppBar 색상도 주황색으로
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                '플러터 계산기',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: value1,
                decoration: const InputDecoration(
                  labelText: '첫 번째 숫자를 입력하세요',
                  labelStyle: TextStyle(color: Colors.white), // 텍스트 필드의 라벨 색상 변경
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: value2,
                decoration: const InputDecoration(
                  labelText: '두 번째 숫자를 입력하세요',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buildOperationButton('+'),
                  buildOperationButton('-'),
                  buildOperationButton('*'),
                  buildOperationButton('/'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // 버튼 색상 주황색으로 설정
                ),
                child: const Text('계산하기'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                '결과 : $result',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            // 이전 계산 결과 표시
            Expanded(
              child: ListView(
                children: previousResults
                    .map((res) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Text(
                    '이전 결과: $res',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 사칙연산 버튼 빌드 함수
  Widget buildOperationButton(String op) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          operation = op;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor : Colors.orange,
      ),
      child: Text(
        op,
        style: const TextStyle(fontSize: 35, color: Colors.white),
      ),
    );
  }
}
