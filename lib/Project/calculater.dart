import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

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
  _WidgetExampleState createState() {
    return _WidgetExampleState();
  }
}

class _WidgetExampleState extends State<WidgetApp> {
  String result = '';
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
    });
  }

  @override
  Widget build(BuildContext conetext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계산기 예제'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text('플러터 인덕대학교'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: value1,
                decoration: const InputDecoration(
                  labelText: '첫 번째 숫자를 입력하세요',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: value2,
                decoration: const InputDecoration(
                  labelText: '두 번째 숫자를 입력하세요',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DropdownButton<String>(
                  value: operation,
                  items: <String>['+', '-', '*', '/']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      operation = newValue!;
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('계산하기'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                '결과 : $result',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
