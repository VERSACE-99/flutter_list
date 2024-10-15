import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  onPressed() {
    print('icon button click...');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('202116013_권성민_Icon Test'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.alarm, size: 100, color: Colors.red),
                  FaIcon(
                    FontAwesomeIcons.bell,
                    size: 100,
                  ),
                  IconButton(
                      onPressed: onPressed,
                      icon: Icon(
                        Icons.alarm,
                        size: 100,
                      ))
                ]))));
  }
}
