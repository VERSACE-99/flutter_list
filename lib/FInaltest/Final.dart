import 'package:firebase_auth/firebase_auth.dart'; // Firebase 인증 라이브러리
import 'package:flutter/gestures.dart'; // TextSpan의 클릭 이벤트 처리를 위한 패키지
import 'package:flutter/material.dart'; // Flutter의 UI 관련 위젯 라이브러리
import 'package:firebase_core/firebase_core.dart'; // Firebase 초기화를 위한 라이브러리
import 'package:fluttertoast/fluttertoast.dart'; // Toast 메시지를 출력하기 위한 패키지
import 'package:http/http.dart' as http; // HTTP 통신을 위한 라이브러리
import 'dart:convert'; // JSON 데이터를 다루기 위한 라이브러리
import 'package:flutter_lab_202116013/firebase_options.dart'; // Firebase 프로젝트 옵션 설정 파일

const String openMeteoApiUrl = 'https://api.open-meteo.com/v1/forecast'; // Open-Meteo 날씨 API URL 상수로 정의

void showToast(String msg) { // 사용자에게 Toast 메시지를 보여주는 함수
  Fluttertoast.showToast(
      msg: msg, // 출력할 메시지 내용
      toastLength: Toast.LENGTH_SHORT, // Toast 지속 시간
      gravity: ToastGravity.CENTER, // Toast 위치 설정 (화면 중앙)
      backgroundColor: Colors.red, // 배경색
      textColor: Colors.white, // 텍스트 색상
      fontSize: 16.0); // 글자 크기
}

void main() async { // 앱의 진입점 (main 함수), Firebase 초기화 필요
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진과 앱 바인딩 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase 설정 옵션 로드
  );
  runApp(MyApp()); // MyApp 위젯 실행
}

class MyApp extends StatelessWidget { // 앱의 최상위 위젯
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App', // 앱의 제목 설정
      theme: ThemeData(
        primarySwatch: Colors.blue, // 앱 테마 색상 설정
      ),
      home: AuthWidget(), // 초기 화면으로 AuthWidget을 설정 (로그인 화면)
    );
  }
}

class AuthWidget extends StatefulWidget { // 로그인 및 회원가입 화면을 위한 StatefulWidget
  @override
  State<AuthWidget> createState() => _AuthWidgetState(); // 상태 클래스 생성
}

class _AuthWidgetState extends State<AuthWidget> {
  final _formkey = GlobalKey<FormState>(); // 폼 상태 관리를 위한 GlobalKey
  late String email; // 사용자 입력 이메일 저장 변수
  late String password; // 사용자 입력 비밀번호 저장 변수
  bool isInput = true; // 입력 상태 여부 확인
  bool isSignIn = true; // 현재 화면이 로그인인지 회원가입인지 여부 확인

  signIn() async { // 로그인 함수
    try {
      await FirebaseAuth.instance // Firebase 인증으로 로그인 처리
          .signInWithEmailAndPassword(email: email, password: password) // 이메일과 비밀번호 입력
          .then((value) {
        if (value.user!.emailVerified) { // 이메일 인증 여부 확인
          setState(() {
            isInput = false; // 인증되면 날씨 화면으로 전환
          });
        } else {
          showToast('이메일 인증이 필요합니다.'); // 이메일 인증이 필요하다고 알림
        }
      });
    } on FirebaseAuthException catch (e) { // Firebase 인증 에러 처리
      switch (e.code) {
        case 'user-not-found':
          showToast('사용자를 찾을 수 없습니다.'); // 사용자가 존재하지 않는 경우
          break;
        case 'wrong-password':
          showToast('비밀번호가 잘못되었습니다.'); // 비밀번호 오류
          break;
        default:
          showToast('알 수 없는 오류가 발생했습니다.'); // 그 외의 에러 처리
      }
    }
  }

  signUp() async { // 회원가입 함수
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password) // 이메일과 비밀번호로 회원가입 처리
          .then((value) {
        value.user?.sendEmailVerification(); // 이메일 인증 링크 전송
        setState(() {
          isInput = true; // 회원가입 후 이메일 인증 대기 상태 유지
        });
        showToast('이메일 인증 링크를 확인하세요.'); // 인증 링크 확인 안내
      });
    } on FirebaseAuthException catch (e) { // Firebase 인증 에러 처리
      switch (e.code) {
        case 'weak-password':
          showToast('비밀번호가 너무 약합니다.'); // 비밀번호 강도 부족
          break;
        case 'email-already-in-use':
          showToast('이미 등록된 이메일입니다.'); // 이메일이 이미 사용 중인 경우
          break;
        default:
          showToast('알 수 없는 오류가 발생했습니다.'); // 그 외 에러 처리
      }
    }
  }

  List<Widget> getInputWidget() { // 로그인 또는 회원가입 화면에 보여줄 입력 위젯 리스트
    return [
      Text( // 화면 제목
        isSignIn ? "로그인" : "회원가입",
        style: TextStyle(
          color: Colors.indigo, // 텍스트 색상
          fontWeight: FontWeight.bold, // 글자 굵기
          fontSize: 24, // 글자 크기
        ),
        textAlign: TextAlign.center, // 텍스트 중앙 정렬
      ),
      SizedBox(height: 20), // 여백 추가
      Card( // 입력 폼을 Card 위젯으로 감싸 디자인 적용
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // Card 테두리 둥글게 설정
        ),
        elevation: 8.0, // 그림자 효과 추가
        child: Padding(
          padding: const EdgeInsets.all(16.0), // 내부 여백 설정
          child: Form( // Form 위젯 사용
            key: _formkey, // Form 상태 키 연결
            child: Column(
              children: [
                TextFormField( // 이메일 입력 필드
                  decoration: InputDecoration(labelText: '이메일'), // 입력 필드 레이블 설정
                  validator: (value) => value?.isEmpty == true ? '이메일을 입력하세요' : null, // 유효성 검사
                  onSaved: (value) => email = value ?? "", // 입력된 값을 email 변수에 저장
                ),
                SizedBox(height: 16), // 여백 추가
                TextFormField( // 비밀번호 입력 필드
                  decoration: InputDecoration(labelText: '비밀번호'), // 입력 필드 레이블 설정
                  obscureText: true, // 비밀번호 숨김 처리
                  validator: (value) => value?.isEmpty == true ? '비밀번호를 입력하세요' : null, // 유효성 검사
                  onSaved: (value) => password = value ?? "", // 입력된 값을 password 변수에 저장
                ),
              ],
            ),
          ),
        ),
      ),
      SizedBox(height: 20), // 여백 추가
      ElevatedButton( // 로그인 또는 회원가입 버튼
        onPressed: () {
          if (_formkey.currentState?.validate() ?? false) { // 입력값 검증
            _formkey.currentState?.save(); // 입력값 저장
            if (isSignIn) {
              signIn(); // 로그인 처리 함수 호출
            } else {
              signUp(); // 회원가입 처리 함수 호출
            }
          }
        },
        child: Text(isSignIn ? "로그인" : "회원가입"), // 버튼 텍스트 동적 설정
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32), // 버튼 여백 설정
        ),
      ),
      SizedBox(height: 10), // 여백 추가
      RichText( // 회원가입/로그인 화면 전환 링크
        textAlign: TextAlign.right, // 텍스트 오른쪽 정렬
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyLarge, // 기본 텍스트 스타일 적용
          children: [
            TextSpan(
              text: isSignIn ? "회원가입" : "로그인", // 텍스트 변경
              style: TextStyle(
                color: Colors.blue, // 텍스트 색상 설정
                fontWeight: FontWeight.bold, // 글자 굵기
                decoration: TextDecoration.underline, // 밑줄 추가
              ),
              recognizer: TapGestureRecognizer() // 텍스트 클릭 이벤트 처리
                ..onTap = () {
                  setState(() {
                    isSignIn = !isSignIn; // 로그인/회원가입 화면 전환
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
        ? Scaffold( // 입력 화면 UI 구성
      appBar: AppBar(
        title: Text("로그인"),
      ),
      body: SingleChildScrollView( // 스크롤 가능 화면 설정
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // 열 정렬 설정
            children: getInputWidget(), // 입력 위젯 불러오기
          ),
        ),
      ),
    )
        : WeatherHomeScreen(); // 로그인 후 날씨 화면으로 전환
  }
}

class WeatherHomeScreen extends StatefulWidget { // WeatherHomeScreen 위젯 정의
  @override
  _WeatherHomeScreenState createState() => _WeatherHomeScreenState(); // 상태 객체 생성
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> { // WeatherHomeScreen의 상태 관리
  final List<Map<String, dynamic>> provinces = [ // 각 지역에 대한 정보 리스트 (위도, 경도)
    {'name': '서울', 'lat': 37.5665, 'lon': 126.9780}, // 서울
    {'name': '부산', 'lat': 35.1796, 'lon': 129.0756}, // 부산
    {'name': '대구', 'lat': 35.8714, 'lon': 128.6014}, // 대구
    {'name': '인천', 'lat': 37.4563, 'lon': 126.7052}, // 인천
    {'name': '광주', 'lat': 35.1595, 'lon': 126.8526}, // 광주
    {'name': '대전', 'lat': 36.3504, 'lon': 127.3845}, // 대전
    {'name': '울산', 'lat': 35.5384, 'lon': 129.3114}, // 울산
    {'name': '세종', 'lat': 36.4800, 'lon': 127.2890}, // 세종
    {'name': '제주', 'lat': 33.4996, 'lon': 126.5312}, // 제주
    {'name': '독도', 'lat': 37.239, 'lon': 131.865}, // 독도
  ];

  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async { // 날씨 데이터를 가져오는 비동기 함수
    final url = Uri.parse(
        '$openMeteoApiUrl?latitude=$lat&longitude=$lon&current_weather=true&daily=temperature_2m_max,temperature_2m_min&hourly=apparent_temperature&timezone=auto'); // API URL 구성
    final response = await http.get(url); // API 호출

    if (response.statusCode == 200) { // 응답 성공
      return json.decode(response.body); // JSON 응답 파싱
    } else { // 실패한 경우
      throw Exception('날씨 정보를 가져올 수 없습니다.'); // 예외 처리
    }
  }

  Color mapWeatherCodeToColor(int code) { // 날씨 코드에 따른 배경 색상 반환
    if (code == 0) return Colors.yellowAccent[100]!; // 맑음 : 노란색
    if (code <= 3) return Colors.grey[300]!; // 구름 : 회색
    if (code <= 48) return Colors.lightBlueAccent[500]!; // 안개 : 하늘색 강조
    if (code <= 57) return Colors.blueGrey[200]!; // 이슬비 : 청회색
    if (code <= 67) return Colors.blue[400]!; // 비 : 파란색
    if (code <= 77) return Colors.lightBlue[200]!; // 눈 : 하늘색
    return Colors.grey[200]!; // 알 수 없음
  }

  IconData mapWeatherCodeToIcon(int code) { // 날씨 코드에 따른 아이콘 반환
    if (code == 0) return Icons.wb_sunny; // 맑음 아이콘
    if (code <= 3) return Icons.cloud; // 구름 아이콘
    if (code <= 48) return Icons.foggy; // 안개 아이콘
    if (code <= 57) return Icons.grain; // 이슬비 아이콘
    if (code <= 67) return Icons.umbrella; // 비 아이콘
    if (code <= 77) return Icons.ac_unit; // 눈 아이콘
    return Icons.help_outline; // 알 수 없음
  }

  void showWeatherDialog(
      BuildContext context, String cityName, Map<String, dynamic> weatherData) {
    // 현재 날씨 데이터를 가져옵니다. (current_weather가 없으면 빈 값 사용)
    final currentWeather = weatherData['current_weather'] ?? {};
    // 일별 날씨 데이터를 가져옵니다. (daily가 없으면 빈 값 사용)
    final dailyWeather = weatherData['daily'] ?? {};

    // 현재 날씨 정보
    final temperature = currentWeather['temperature']?.toString() ?? "N/A"; // 현재 온도 가져오기
    final windSpeed = currentWeather['windspeed']?.toString() ?? "N/A"; // 현재 풍속 가져오기

    // 오늘의 최고 온도와 최저 온도 가져오기
    final todayTempMax = dailyWeather['temperature_2m_max']?[0]?.toString() ?? "N/A";
    final todayTempMin = dailyWeather['temperature_2m_min']?[0]?.toString() ?? "N/A";

    // 내일의 최고 온도와 최저 온도 가져오기
    final tomorrowTempMax = dailyWeather['temperature_2m_max']?[1]?.toString() ?? "N/A";
    final tomorrowTempMin = dailyWeather['temperature_2m_min']?[1]?.toString() ?? "N/A";

    // 다이얼로그(팝업창)화면
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$cityName 날씨 정보'), // 팝업창 제목에 도시 이름을 표시
          content: Column(
            mainAxisSize: MainAxisSize.min, // 팝업창 내용이 너무 길지 않도록 최소 크기로 설정
            crossAxisAlignment: CrossAxisAlignment.start, // 내용을 왼쪽 정렬로 배치
            children: [
              // 현재 온도와 풍속을 표시합니다.
              Text('현재 온도: $temperature°C', style: TextStyle(fontSize: 16)),
              Text('풍속: $windSpeed km/h', style: TextStyle(fontSize: 16)),
              Divider(), // 구분선 추가

              // 오늘의 최고 온도와 최저 온도를 표시
              Text('오늘 최고 온도: $todayTempMax°C', style: TextStyle(fontSize: 16)),
              Text('오늘 최저 온도: $todayTempMin°C', style: TextStyle(fontSize: 16)),
              Divider(), // 구분선 추가

              // 내일의 최고 온도와 최저 온도를 강조해서 표시
              Text('내일 최고 온도: $tomorrowTempMax°C',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('내일 최저 온도: $tomorrowTempMin°C',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            // 팝업창 닫기 버튼
            TextButton(
              child: Text('닫기'), // 버튼 이름: '닫기'
              onPressed: () {
                Navigator.of(context).pop(); // 버튼을 누르면 팝업창을 닫음
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> signOut() async { // 로그아웃 처리 함수
    await FirebaseAuth.instance.signOut(); // Firebase 로그아웃
    Navigator.of(context).pushReplacement( // 로그인 화면으로 이동
      MaterialPageRoute(builder: (context) => AuthWidget()),
    );
  }

  @override
  Widget build(BuildContext context) { // 위젯 빌드 함수
    return Scaffold(
      appBar: AppBar(
        title: Text('날씨 정보'), // 앱바 제목
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // 로그아웃 아이콘
            onPressed: signOut, // 로그아웃 처리
            tooltip: "로그아웃", // 툴팁
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // 본문 여백 설정
        child: GridView.builder( // 그리드 뷰로 날씨 카드 표시
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 그리드의 열 수
            crossAxisSpacing: 8, // 열 간격
            mainAxisSpacing: 8, // 행 간격
            childAspectRatio: 3 / 2, // 자식 위젯의 비율 설정
          ),
          itemCount: provinces.length, // 아이템 개수
          itemBuilder: (context, index) { // 그리드 아이템 빌드
            final province = provinces[index]; // 각 지역 정보
            return FutureBuilder<Map<String, dynamic>>( // 날씨 데이터를 비동기적으로 가져오는 FutureBuilder
              future: fetchWeather(province['lat'], province['lon']), // 날씨 데이터 요청
              builder: (context, snapshot) { // 빌더 함수
                if (snapshot.connectionState == ConnectionState.waiting) { // 로딩 상태일 때
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // 카드 모서리 둥글게
                    ),
                    elevation: 4.0, // 카드 그림자
                    child: Center(child: CircularProgressIndicator()), // 로딩 인디케이터
                  );
                } else if (snapshot.hasError) { // 오류 발생 시
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // 카드 모서리 둥글게
                    ),
                    elevation: 4.0, // 카드 그림자
                    child: Center(child: Text("${province['name']}\n오류 발생")), // 오류 메시지
                  );
                } else { // 데이터가 정상적으로 로드된 경우
                  final weatherData = snapshot.data!; // 날씨 데이터
                  final currentWeather = weatherData['current_weather'] ?? {}; // 현재 날씨 정보
                  final weatherCode = currentWeather['weathercode'] ?? -1; // 날씨 코드
                  final bgColor = mapWeatherCodeToColor(weatherCode); // 날씨 코드에 따른 배경 색상

                  return GestureDetector( // 카드 클릭 시 상세 정보 표시
                    onTap: () {
                      showWeatherDialog(context, province['name'], weatherData); // 다이얼로그 호출
                    },
                    child: Card(
                      color: bgColor, // 배경 색상 설정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // 카드 모서리 둥글게
                      ),
                      elevation: 4.0, // 카드 그림자
                      child: Padding(
                        padding: const EdgeInsets.all(8.0), // 카드 내 여백 설정
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // 내용 중앙 정렬
                          children: [
                            Icon(
                              mapWeatherCodeToIcon(weatherCode), // 날씨 코드에 맞는 아이콘 표시
                              size: 36.0,
                              color: Colors.black54, // 아이콘 색상 설정
                            ),
                            SizedBox(height: 8), // 간격
                            Text(
                              province['name'], // 지역 이름 표시
                              style: TextStyle(
                                fontWeight: FontWeight.bold, // 굵은 글씨
                                fontSize: 16, // 글씨 크기 설정
                              ),
                            ),
                            SizedBox(height: 8), // 간격
                            Text(
                              '${currentWeather['temperature']?.toString() ?? "N/A"}°C', // 온도 표시
                              style: TextStyle(fontSize: 14), // 글씨 크기 설정
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

