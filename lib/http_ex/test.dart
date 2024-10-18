import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http 패키지 추가.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HttpApp(), // 위젯의 홈 화면 설정.
    );
  }
}

class HttpApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HttpApp(); //_HttpApp클래스의 인스턴스 반환.
  }
}

class _HttpApp extends State<HttpApp> { // 상태관리 State
  String result = ' '; // 결과를 저장할 문자열 변수 result선언.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('202116013_권성민_Http Ex'),
      ),
      body: Container( // 화면의 내용을 담음.
        child: Center( // 텍스트를 화면에 중앙 배치.
          child: Text('$result'), // result 값을 화면에 텍스트로 출력.
        ),
      ),
      floatingActionButton: FloatingActionButton( //오른쪽 하단 버튼 추가.
        onPressed: () async { // 버튼을 눌렀을 때 실행되는 비동기 함수.
          var url = 'http://www.google.com'; // 요청을 보낼 Url
          var response = await http.get(Uri.parse(url)); // http.get 요청 보내기(비동기).
          setState(() {
            result = response.body; // 응답 결과를 result변수에 저장.
          });
        },
        child: Icon(Icons.file_download), // 다운로드 아이콘을 하단에 표시.
      ),
    );
  }
}
