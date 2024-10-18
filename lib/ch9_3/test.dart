import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              // 상단 제목 표시.
              title: const Text('202116013_권성민_asset_Test'),
            ),
            body: Column(children: [ // 여러 위젯을 세로로 배치하는 Column 위젯 사용.
              Image( // Image위젯을 사용하여 이미지 표시.
                // NetwokrImage함수로  url의 이미지를 불러온다.
                image: NetworkImage('https://flutter.github.io/assets-for-api-'
                    'docs/assets/widgets/owl.jpg'),
              ),
              Container( // Container함수에 레이아웃 구성.
                color: Colors.red, // 배경색 red.
                child: Image.asset( // 프로젝트 내 파일의 이미지 불러오기.
                  'images/big.jpeg', // 애셋 이미지 경로 지정.
                  width: 200, // 이미지의 너비 200.
                  height: 100, // 이미지의 높이 100.
                  fit: BoxFit.fill, // 이미지를 컨테이너의 크기에 맞춰 채움.
                ),
              )
            ])));
  }
}
