import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //rootBundle을 이용해 애셋 파일을 읽어 반환하는 함수
  // Future는 비동기 데이터를 의미.
  Future<String> useRootBundle() async {
    // 파일을 문자열로 읽어들임.
    return await rootBundle.loadString('assets/text/my_text.txt');
  }

  // DefaultAssetBundle을 이용해 애셋 파일을 읽어 반환하는 함수.
  Future<String> useDefaultAsserBundle(BuildContext context) async {
    // 파일을 context를 통해 읽어들임.
    return await DefaultAssetBundle.of(context)
        .loadString('assets/text/my_text.txt');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            // 상단 제목 표시
            title: Text('202116013_권성민_assets Test'),
          ),
          body: Column(
            children: [
              // 이미지 파일을 애셋경로에서 불러와 표시.
              Image.asset('images/icon.jpg'),
              Image.asset('images/icon/user.png'),
              //FutureBuilder는 비동기 데이터를 이용해 화면을 구성하는 위젯.
              FutureBuilder(
                  future: useRootBundle(), //useRootBundle() 함수 호출.
                  builder: (context, snapshot) {
                    //useRootBundle() 함수의 결괏값 전달.
                    //결괏값이 snapshot으로 전달, 이 값으로 화면 구성.
                    return Text('rootBundle : ${snapshot.data}');
                  }),
              FutureBuilder(
                  future: useDefaultAsserBundle(context), // 함수 호출
                  builder: (context, snapshot) {
                    return Text('DefaultAsserBundle : ${snapshot.data}');
                  })
            ],
          )),
    );
  }
}
