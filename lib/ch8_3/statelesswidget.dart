import 'package:flutter/material.dart';
import 'package:flutter_lab_202116013/ch2/test_50.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool enabled = false;
  String stateText = "disable";

  void changeChek() {
    if (enabled) {
      stateText = "disable";
      enabled = false;
    } else {
      stateText = "enable";
      enabled = true;
    }
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Stateless Test'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: (enabled ? Icon(Icons.check_box, size: 20,) :
                      Icon(Icons.check_box_outline_blank, size: 20,)),
                color: Colors.red,
                onPressed: changeChek,
              ),
              Container(
                padding: EdgeInsets.only(left: 16),
                child: Text('$stateText', style: TextStyle(fontSize: 30,
                        fontWeight: FontWeight.bold),),

              ),
            ],
          ),
        )
      )
    );
  }
}

