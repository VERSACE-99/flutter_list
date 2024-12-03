import 'package:flutter_lab_202116013/project4/component/custom_youtube_player.dart'; // CustomYoutubePlayer 위젯 임포트
import 'package:flutter_lab_202116013/project4/model/video_model.dart'; // Video_model 임포트
import 'package:flutter/material.dart';

// HomeScreen 클래스 : 앱의 홈 화면을 구성하는 StatelessWidget
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // 생성사 : 키를 받아 초기화

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 기본 구조인 Scaffold 위젯 반환
      backgroundColor: Colors.black, // 배경색 : 검정
      body: CustomYoutubePlayer(
        // CustomYoutubePlayer 위젯 사용
        videoModel: VideoModel(
            // VideoModel 인스턴스 생성
            id: '7e80Il_7Z70', // 동영상 ID 설정
            title: '다트언어 기본기 1시간 정복' // 동영상 제목 설정
            ),
      ),
    );
  }
}
