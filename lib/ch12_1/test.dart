import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class User {
  String name;
  String phone;
  String email;
  User(this.name, this.phone, this.email);
}

class MyApp extends StatelessWidget{
  MyApp({super.key});

  List<User> users = [
    User('인덕대1', '010101', 'abc@induk.ac.kr'), User('정통2', '010102', 'abc@induk.ac,kr'),
    User('인덕대3', '010103', 'abc@induk.ac.kr'), User('정통4', '010104', 'abc@induk.ac,kr'),
    User('인덕대5', '010105', 'abc@induk.ac.kr'), User('정통6', '010106', 'abc@induk.ac,kr'),
    User('인덕대7', '010107', 'abc@induk.ac.kr'), User('정통8', '010108', 'abc@induk.ac,kr'),
    User('인덕대9', '010109', 'abc@induk.ac.kr'), User('정통10', '0101010', 'abc@induk.ac,kr'),
    User('인덕대11', '0101011', 'abc@induk.ac.kr'), User('정통12', '0101012', 'abc@induk.ac,kr'),
    User('인덕대13', '0101013', 'abc@induk.ac.kr'), User('정통14', '0101014', 'abc@induk.ac,kr'),
    User('인덕대15', '0101015', 'abc@induk.ac.kr'), User('정통16', '0101016', 'abc@induk.ac,kr'),
  ];

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home : Scaffold(
        appBar: AppBar(title: Text('202116013_2A_권성민'),),
        body: ListView.separated(
            itemBuilder:(context, index){
              return ListTile(
                leading : const CircleAvatar(
                  radius : 25,
                  backgroundImage: AssetImage('images/induk.png'),
                ),
                title : Text(users[index].name),
                subtitle : Text(users[index].phone),
                trailing : Icon(Icons.more_vert),
                onTap:(){
                  print(users[index].name);
                },
              );
            },
        separatorBuilder: (context, index){
              return const Divider(height: 2, color: Colors.black,);
        },
        itemCount: users.length
        ),
      ),
    );
  }
}