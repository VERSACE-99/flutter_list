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
          title: Text('202116013_권성민_Test'),
        ),
        body: Column(children: [
          Image.asset('images/icon1.jpg'),
          Image.asset('images/icon2.jpg'),
          Image.asset('images/icon4.jpg'),
          Image.asset('images/sub/icon3.jpg'),
        ])),
    );
  }
}