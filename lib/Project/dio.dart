import 'package:dio/dio.dart';

void main() async {
  // BaseOptions 설정
  final options = BaseOptions(
    baseUrl: 'http://reqres.in/api/',
    connectTimeout: Duration(seconds: 5), // 연결 타임아웃 설정(5초).
    receiveTimeout: Duration(seconds: 3), // 응답 수신 타임아웃 설정(3초).
  );

  //Dio 인스턴스 설정
  final dio = Dio(options);

  try {
    //Get 요청을 통해 사용자 목록 가져오기
    final response = await dio.get('users?page = 1');

    //응답 데이터 출력
    if (response.statusCode == 200) {
      print('응답 데이터 : ${response.data}');
    } else {
      print('오류 발생 : ${response.statusCode}');
    }
  } on DioError catch (e) {
    //DioError 처리
    if (e.response != null) {
      print('서버오류 발생 : ${e.response?.statusCode} - ${e.response?.data}');
    } else {
      print('요청 중 오류발생 : $e');
    }
  } catch (e) {
    //일반 예외 처리
    print('예상치 못한 오류 발생 : $e');
  }
}
