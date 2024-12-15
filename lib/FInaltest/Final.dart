import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_lab_202116013/firebase_options.dart';

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
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          showToast('사용자를 찾을 수 없습니다.');
          break;
        case 'wrong-password':
          showToast('비밀번호가 잘못되었습니다.');
          break;
        default:
          showToast('알 수 없는 오류가 발생했습니다.');
      }
    }
  }

  signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        value.user?.sendEmailVerification(); // Simplified null check
        setState(() {
          isInput = true; // Changed to true to allow user to verify email
        });
        showToast('이메일 인증 링크를 확인하세요.');
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          showToast('비밀번호가 너무 약합니다.');
          break;
        case 'email-already-in-use':
          showToast('이미 등록된 이메일입니다.');
          break;
        default:
          showToast('알 수 없는 오류가 발생했습니다.');
      }
    }
  }

  List<Widget> getInputWidget() {
    return [
      Text(
        isSignIn ? "로그인" : "회원가입",
        style: TextStyle(
          color: Colors.indigo,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 20),
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 8.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: '이메일'),
                  validator: (value) => value?.isEmpty == true ? '이메일을 입력하세요' : null,
                  onSaved: (value) => email = value ?? "",
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: '비밀번호'),
                  obscureText: true,
                  validator: (value) => value?.isEmpty == true ? '비밀번호를 입력하세요' : null,
                  onSaved: (value) => password = value ?? "",
                ),
              ],
            ),
          ),
        ),
      ),
      SizedBox(height: 20),
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
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
        ),
      ),
      SizedBox(height: 10),
      RichText(
        textAlign: TextAlign.right,
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyLarge,
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
                },
            ),
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
        : WeatherHomeScreen(); // Removed signOut parameter
  }
}

class WeatherHomeScreen extends StatefulWidget {

  @override
  _WeatherHomeScreenState createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  final List<Map<String, dynamic>> provinces = [
    {'name': '서울', 'lat': 37.5665, 'lon': 126.9780},
    {'name': '부산', 'lat': 35.1796, 'lon': 129.0756},
    {'name': '대구', 'lat': 35.8714, 'lon': 128.6014},
    {'name': '인천', 'lat': 37.4563, 'lon': 126.7052},
    {'name': '광주', 'lat': 35.1595, 'lon': 126.8526},
    {'name': '대전', 'lat': 36.3504, 'lon': 127.3845},
    {'name': '울산', 'lat': 35.5384, 'lon': 129.3114},
    {'name': '세종', 'lat': 36.4800, 'lon': 127.2890},
    {'name': '제주', 'lat': 33.4996, 'lon': 126.5312},
    {'name': '독도', 'lat': 37.239, 'lon': 131.865},
  ];


  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    final url = Uri.parse(
        '$openMeteoApiUrl?latitude=$lat&longitude=$lon&current_weather=true&daily=temperature_2m_max,temperature_2m_min&hourly=apparent_temperature&timezone=auto');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('날씨 정보를 가져올 수 없습니다.');
    }
  }

  IconData mapWeatherCodeToIcon(int code) {
    if (code == 0) return Icons.wb_sunny; // 맑음
    if (code <= 3) return Icons.cloud; // 구름
    if (code <= 48) return Icons.foggy; // 안개
    if (code <= 57) return Icons.grain; // 이슬비
    if (code <= 67) return Icons.umbrella; // 비
    if (code <= 77) return Icons.ac_unit; // 눈
    return Icons.help_outline; // 알 수 없음
  }

  void showWeatherDialog(
      BuildContext context, String cityName, Map<String, dynamic> weatherData) {
    final currentWeather = weatherData['current_weather'] ?? {};
    final dailyWeather = weatherData['daily'] ?? {};
    final hourlyWeather = weatherData['hourly'] ?? {};

    final temperature = currentWeather['temperature']?.toString() ?? "N/A";
    final windSpeed = currentWeather['windspeed']?.toString() ?? "N/A";
    final tempMax = dailyWeather['temperature_2m_max']?[0]?.toString() ?? "N/A";
    final tempMin = dailyWeather['temperature_2m_min']?[0]?.toString() ?? "N/A";
    final feelsLike = hourlyWeather['apparent_temperature']?[0]?.toString() ?? "N/A";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$cityName 날씨 정보'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(mapWeatherCodeToIcon(currentWeather['weathercode'] ?? -1), size: 48),
              SizedBox(height: 8),
              Text('현재 온도: $temperature°C', style: TextStyle(fontSize: 16)),
              Text('최고 온도: $tempMax°C', style: TextStyle(fontSize: 16)),
              Text('최저 온도: $tempMin°C', style: TextStyle(fontSize: 16)),
              Text('체감온도: $feelsLike°C', style: TextStyle(fontSize: 16)),
              Text('풍속: $windSpeed km/h', style: TextStyle(fontSize: 16)),
            ],
          ),
          actions: [
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('날씨 정보')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 3 / 2,
          ),
          itemCount: provinces.length,
          itemBuilder: (context, index) {
            final province = provinces[index];
            return FutureBuilder<Map<String, dynamic>>(
              future: fetchWeather(province['lat'], province['lon']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4.0,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4.0,
                    child: Center(child: Text("${province['name']}\n오류 발생")),
                  );
                } else {
                  final weatherData = snapshot.data!;
                  final currentWeather = weatherData['current_weather'] ?? {};
                  return GestureDetector(
                    onTap: () {
                      showWeatherDialog(context, province['name'], weatherData);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              mapWeatherCodeToIcon(currentWeather['weathercode'] ?? -1),
                              size: 36,
                            ),
                            SizedBox(height: 8),
                            Text(
                              province['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${currentWeather['temperature']?.toString() ?? "N/A"}°C',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
