import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore 사용
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_lab_202116013/firebase_options.dart';


// Open-Meteo API Base URL
const String openMeteoApiUrl = 'https://api.open-meteo.com/v1/forecast';

void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWidget(),
    );
  }
}

class AuthWidget extends StatefulWidget {
  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final _formkey = GlobalKey<FormState>();
  late String email;
  late String password;
  bool isInput = true;
  bool isSignIn = true;

  signIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user!.emailVerified) {
          setState(() {
            isInput = false;
          });
        } else {
          showToast('이메일 인증이 필요합니다.');
        }
        return value;
      });
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        showToast('사용자를 찾을 수 없습니다.');
      } else if (e.code == 'wrong-password') {
        showToast('비밀번호가 잘못되었습니다.');
      } else {
        print(e.code);
      }
    }
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      isInput = true;
    });
  }

  signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user!.email != null) {
          FirebaseAuth.instance.currentUser?.sendEmailVerification();
          setState(() {
            isInput = false;
          });
        }
        return value;
      });
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        showToast('비밀번호가 너무 약합니다.');
      } else if (e.code == 'email-already-in-use') {
        showToast('이미 등록된 이메일입니다.');
      } else {
        showToast('알 수 없는 오류가 발생했습니다.');
        print(e.code);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  List<Widget> getInputWidget() {
    return [
      Text(
        isSignIn ? "로그인" : "회원가입",
        style: TextStyle(
          color: Colors.indigo,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: '이메일'),
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return '이메일을 입력하세요';
                }
                return null;
              },
              onSaved: (String? value) {
                email = value ?? "";
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: '비밀번호',
              ),
              obscureText: true,
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return '비밀번호를 입력하세요';
                }
                return null;
              },
              onSaved: (String? value) {
                password = value ?? "";
              },
            ),
          ],
        ),
      ),
      ElevatedButton(
        onPressed: () {
          if (_formkey.currentState?.validate() ?? false) {
            _formkey.currentState?.save();
            if (isSignIn) {
              signIn();
            } else {
              signUp();
            }
          }
        },
        child: Text(isSignIn ? "로그인" : "회원가입"),
      ),
      RichText(
        textAlign: TextAlign.right,
        text: TextSpan(
          style: Theme
              .of(context)
              .textTheme
              .bodyLarge,
          children: [
            TextSpan(
                text: isSignIn ? "회원가입" : "로그인",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      isSignIn = !isSignIn;
                    });
                  }),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return isInput
        ? Scaffold(
      appBar: AppBar(
        title: Text("로그인"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getInputWidget(),
          ),
        ),
      ),
    )
        : WeatherHomeScreen(signOut: signOut);
  }
}

class WeatherHomeScreen extends StatefulWidget {
  final VoidCallback signOut;

  WeatherHomeScreen({required this.signOut});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  List<String> favoriteCities = [];
  final List<Map<String, dynamic>> provinces = [
    {'name': '서울', 'lat': 37.5665, 'lon': 126.9780},
    {'name': '부산', 'lat': 35.1796, 'lon': 129.0756},
    {'name': '대구', 'lat': 35.8714, 'lon': 128.6014},
    {'name': '인천', 'lat': 37.4563, 'lon': 126.7052},
    {'name': '광주', 'lat': 35.1595, 'lon': 126.8526},
    {'name': '대전', 'lat': 36.3504, 'lon': 127.3845},
    {'name': '울산', 'lat': 35.5384, 'lon': 129.3114},
    {'name': '세종', 'lat': 36.4800, 'lon': 127.2890},
  ];

  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    final url = Uri.parse(
        '$openMeteoApiUrl?latitude=$lat&longitude=$lon&current_weather=true');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('날씨 정보를 가져올 수 없습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('날씨 조회'),
        actions: [
          IconButton(onPressed: widget.signOut, icon: Icon(Icons.logout))
        ],
      ),
      body: ListView.builder(
        itemCount: provinces.length,
        itemBuilder: (context, index) {
          final province = provinces[index];
          return ListTile(
            title: Text(province['name']),
            trailing: IconButton(
              icon: Icon(
                favoriteCities.contains(province['name'])
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: favoriteCities.contains(province['name'])
                    ? Colors.red
                    : null,
              ),
              onPressed: () {
                setState(() {
                  if (favoriteCities.contains(province['name'])) {
                    favoriteCities.remove(province['name']);
                  } else {
                    favoriteCities.add(province['name']);
                  }
                });
              },
            ),
            onTap: () async {
              final weatherData = await fetchWeather(
                  province['lat'], province['lon']);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('${province['name']} 날씨'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            '온도: ${weatherData['current_weather']['temperature']}°C'),
                        Text(
                            '풍속: ${weatherData['current_weather']['windspeed']} km/h'),
                        Text(
                            '날씨 상태: ${weatherData['current_weather']['weathercode']}'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('닫기'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
