import 'package:flutter/cupertino.dart'; // cupertino 위젯 패키지
import 'package:flutter/material.dart'; // material 위젯 패키지

void main() {
  runApp(MyApp()); // 앱의 시작점 (MyApp 위젯)
}

class MyApp extends StatelessWidget {
  static const String _title = '202116013_2A_권성민'; // 앱의 제목 정의

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title, // 앱의 제목 설정
      home: WidgetApp(), // 메인 화면으로 WidgetApp 클래스 호출.
    );
  }
}

class WidgetApp extends StatefulWidget {
  @override
  _WidgetExampleState createState() => _WidgetExampleState(); // State 생성.
}

class _WidgetExampleState extends State<WidgetApp> {
  String result = ''; // 계산 결과를 저장하는 변수.
  List<String> previousResults = []; // 이전 계산 결과 목록을 저장하는 리스트.
  TextEditingController value1 = TextEditingController(); // 첫 번째 숫자를 입력받기 위한 컨트롤러.
  TextEditingController value2 = TextEditingController(); // 두 번째 숫자를 입력받기 위한 컨트롤러.
  String operation = '+'; // 선택된 연산자 기본값을 '+'로 설정.

  void calculate() { // 계산을 수행하는 함수.
    double num1 = double.tryParse(value1.text) ?? 0; // 첫 번째 입력 값을 숫자로 변환. / 실패 시 0할당.
    double num2 = double.tryParse(value2.text) ?? 0; // 두 번째 입력 값을 숫자로 변환. / 실패 시 0할당.

    setState(() { // UI 업데이트 함수.
      switch (operation) {
        case '+':
          result = (num1 + num2).toString(); // 덧셈 계산 결과 저장.
          break;
        case '-':
          result = (num1 - num2).toString(); // 뺄셈 계산 결과 저장.
          break;
        case '*':
          result = (num1 * num2).toString(); // 곱셈 계산 결과 저장.
          break;
        case '/':
          if (num2 != 0) {
            result = (num1 / num2).toString(); // 나눗셈 계산 결과 저장.
          } else {
            result = '0으로 나눌 수 없음'; // 0으로 나눌 때 에러 메시지 출력.
          }
          break;
      }
      previousResults.add(result); // 계산 결과를 이전 결과 리스트에 추가.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 배경색을 검정색으로 설정
      appBar: AppBar(
        title: const Text('202116013_2A_권성민'), // App바 제목 설정.
        backgroundColor: Colors.orange, // AppBar 색상 : 주황색
      ),
      body: Center(
        // 중앙 정렬 Center 위젯.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 정보를 세로로 중앙 정렬
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(15), // 위젯에 15 여백 추가.
              child: Text(
                '플러터 계산기', // 텍스트 설정.
                style: TextStyle(fontSize: 24, color: Colors.white), // 텍스트 스타일 설정.
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20), // 양쪽에 20여백 추가.
              child: TextField(
                keyboardType: TextInputType.number, // 숫자 입력을 위한 키보드 설정.
                controller: value1, // 첫 번째 숫자를 입력받기 위한 컨트롤러 설정.
                decoration: const InputDecoration(
                  labelText: '첫 번째 숫자를 입력하세요', // 텍스트 필드 라벨.
                  labelStyle: TextStyle(color: Colors.white), // 텍스트 색상 설정.
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // 밑줄 색상 설정.
                  ),
                ),
                style: const TextStyle(color: Colors.white), // 입력 텍스트 색상 설정.
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10), // 상단에 10, 양쪽에 20 여백 추가.
              child: TextField(
                keyboardType: TextInputType.number,// 숫자를 입력 키보드 설정.
                controller: value2, // 두 번째 숫자를 입력받기 위한 컨드롤러 설정.
                decoration: const InputDecoration(
                  labelText: '두 번째 숫자를 입력하세요', // 텍스트 필드 라벨.
                  labelStyle: TextStyle(color: Colors.white), // 텍스트 색상 설정.
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // 활성화된 상태에서의 밑줄 색상 설정.
                  ),
                ),
                style: const TextStyle(color: Colors.white), // 입력 텍스트 색상 설정.
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15), // 상하로 15 여백 추가.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 버튼 배치.
                children: <Widget>[
                  buildOperationButton('+'), // 덧셈 버튼 생성.
                  buildOperationButton('-'), // 뺄셈 버튼 생성.
                  buildOperationButton('*'), // 곱셈 버튼 생성.
                  buildOperationButton('/'), // 나눗셈 버튼 생성.
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15), // 상하로 15 여백 추가.
              child: ElevatedButton(
                onPressed: calculate, // 버튼 클릭 시 계산 함수 호출.
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // 버튼 색상 주황색.
                ),
                child: const Text('계산하기'), // 버튼 텍스트 설정.
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15), // 전체 여백 15 추가.
              child: Text(
                '결과 : $result', // 계산 결과 출력.
                style: const TextStyle(fontSize: 20, color: Colors.white), // 결과 텍스트 스타일 설정.
              ),
            ),
            // 이전 계산 결과 표시
            Expanded(
              child: ListView( // 스크롤 가능한 목록 생성 위젯.
                children: previousResults // 리스트의 각 결과를 텍스트로 전환.
                    .map((res) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20), // 상하 여백 추가.
                  child: Text(
                    '이전 결과: $res', // 이전 계산 결과 출력.
                    style: const TextStyle(fontSize: 16, color: Colors.white70), // 텍스트 스타일 설정.
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
  Widget buildOperationButton(String op) { // 사칙연산 기호 클릭.
    return ElevatedButton( // 버튼을 눌렀을 때 호출되는 함수.
      onPressed: () {
        setState(() {
          operation = op; // 선택된 연산자로 변경
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor : Colors.orange, // 버튼 배경색 : 주황색
      ),
      child: Text(
        op,
        style: const TextStyle(fontSize: 35, color: Colors.white), // 버튼 텍스트 스타일.
      ),
    );
  }
}
