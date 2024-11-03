import 'package:flutter/material.dart'; // Flutter material 디자인 라이브러리.
import 'package:http/http.dart' as http; // http 요청을 위한 라이브러리.
import 'dart:convert'; // JSON 변환을 위한 라이브러리.

// 앱 진입점
void main() {
  runApp(MyApp()); // MyApp 위젯 실행.
}

// MyApp클래스 : 어플의 루트 위젯 정의.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // materialApp을 사용하여 앱의 구조 설정.
    return const MaterialApp(
      home: HttpApp(), // HttpApp을 홈 위젯으로 설정.
    );
  }
}

//HttpApp클래스 = StatefulWidget, 상태 관리
class HttpApp extends StatefulWidget {
  const HttpApp({super.key});

  @override
  State<HttpApp> createState() => _HttpApp(); // 상태 객체 생성.
}

// _HttpApp클래스 = HttpApp의 상태를 정의
class _HttpApp extends State<HttpApp> {
  List<dynamic>? data; // API에서 가져온 데이터를 저장할 리스트.
  TextEditingController _editingController = TextEditingController(); // 검색어 입력을 위한 컨트롤러.ㅇ
  ScrollController _scrollController = ScrollController(); // 스트롤 이벤트를 처리하기 위한 컨트롤러.
  int page = 1; // 현재 페이지 번호.

  @override
  void initState() {
    super.initState();
    data = []; // 데이터 리스트 초기화.
    // 스크롤 리스너 추가 : 스크롤이 끝에 도달하면 다음 페이지 데이터 요청.
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        page++; // 페이지 번호 증가.
        getJSONData(); // 다음 페이지 데이터 요청.
      }});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //AppBar에 검색 입력 필드 추가.
        title: TextField(
          controller: _editingController, // 입력 컨트롤러 설정.
          style: const TextStyle(color: Colors.blueAccent), // 텍스트 색상 설정.
          decoration: const InputDecoration(hintText: "검색어를 입력하세요"), // 힌트 텍스트
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0), // 컨테이너에 패딩 추가.
        child: Center(
          child: data!.isEmpty // 데이터가 없을 경우
              ? const Text(
                  "데이터가 없습니다", // 데이터가 없을 때 표시할 텍스트
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )
              : ListView.builder(
                  itemCount: data!.length, // 데이터 개수 설정.
                  itemBuilder: (context, index) {
                    // ListView.builder를 사용하여 데이터 리스트 생성.
                    return Card(
                      child: Row(
                        children: <Widget>[
                          // 책의 썸네일 이미지를 표시.
                          Image.network(
                            data![index]['thumbnail'],
                            height: 100,
                            width: 100,
                            fit: BoxFit.contain,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // 책 제목
                                Text(data![index]['title'].toString(),
                                    textAlign: TextAlign.center),
                                // 저자, 가격, 판매 상태 표시.
                                Text(
                                    '저자 : ${data![index]['authors'].toString()}'),
                                Text(
                                    '판매가 : ${data![index]['sale_price'].toString()}'),
                                Text('정가 : ${data![index]['price'].toString()}'),
                                Text('판매중 : ${data![index]['status'].toString()}'),
                                Text('출판날짜 : ${data![index]['datetime'].toString()}'),
                              ],
                            ),)
                        ],),);
                  },
                  controller: _scrollController, // 스크롤 컨트롤러 설정.
                ),
        ),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //FAB 클릭 시 페이지 초기화 및 데이터 새로고침.
          page = 1; // 페이지 번호 초기화.
          data!.clear(); // 데이터 리스트 초기화.
          getJSONData(); // 새로운 데이터 요청.
        },
        child: const Icon(Icons.file_download), // 다운로드 아이콘 설정.
      ),);
  }

  Future<void> getJSONData() async {
    // kakao API에서 데이터 요청.
    var url =
        'http://dapi.kakao.com/v3/search/book?target=title&page='
        '$page&query=${Uri.encodeQueryComponent(_editingController.text)}';
    try {
      //http get 요청.
      var response = await http.get(Uri.parse(url), headers: {
        "Authorization": "KakaoAK b2b527c43a994ae411728106061e1fc1" // 카카오 API키 설정.
      });

      // 응답 상태 코드가 200일 경우
      if (response.statusCode == 200) {
        setState(() {
          var dataConvertedToJSON = json.decode(response.body); // JSON 데이터 디코딩.
          List<dynamic> result = dataConvertedToJSON['documents']; // documents 필드에서 데이터 추출.
          data!.addAll(result); // 데이터를 리스트에 추가.
        });
      } else {
        throw Exception('Failed to load data'); // 오류 처리.
      }
    } catch (e) {
      print('Error: $e'); // 오류 메시지 출력.
    }
  }
}
