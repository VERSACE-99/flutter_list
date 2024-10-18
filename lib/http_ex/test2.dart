import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http 패키지 추가

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HttpApp(), // 위젯의 홈 화면 표시.
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
      appBar: AppBar( // 상단 제목 표시.
        title: Text('202116013_권성민_Http Ex2'),
      ),
      body: Container( // 화면의 내용을 담음.
        padding: EdgeInsets.all(16.0), // 화면의 모든 방향에 16.0 여백 추가.
        child: Center( // 화면에 중앙 배치.
          child: SingleChildScrollView( // 긴 텍스트를 스크롤할 수 있도록 SingleChildScrollView 추가.
            child: Text('$result'), // result 값을 화면에 텍스트로 출력.
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton( //오른쪽 하단 버튼 추가.
        onPressed: () async { // 버튼을 눌렀을 때 실행되는 비동기 함수.
          var url = 'http://jsonplaceholder.typicode.com/posts/1'; // 요청을 보낼 url
          var response = await http.get(Uri.parse(url)); // http.get 요청 보내기(비동기).
          if (response.statusCode == 200) { // 요청 성공 시 (200 Ok)
            setState(() { // setState()를 호출해 상태 업데이트 후 화면에 출력.
              result = response.body; // result변수에 저장.
            });
          } else { // 응답 실패 시.
            setState(() { // setState()를 호출해 실패 메시지를 화면에 표시하도록 상태 업데이트.
              result = 'Failed to load data'; // 실패 메시지를 result변수에 저장.
            });
          }
        },
        child: Icon(Icons.file_download), // 다운로드 아이콘을 우측 하단에 표시.
      ),
    );
  }
}
