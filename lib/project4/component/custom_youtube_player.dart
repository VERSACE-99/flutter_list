import 'package:flutter/material.dart';
import 'package:flutter_lab_202116013/project4/model/video_model.dart';

// 유튜브 플레이어를 사용하기 위해 패키지 불러오기
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// 유튜브 동영상 플레이어가 될 위젯 클래스
class CustomYoutubePlayer extends StatefulWidget {
  // 상위 위젯에서 입력받을 동영상 정보
  final VideoModel videoModel; // 동영상 모델을 저장할 변수

const CustomYoutubePlayer({
    required this.videoModel, // 필수 매개변수로 동영상 모델 받기
  super.key, // 기본키 매개변수 사용
});

@override
  State<CustomYoutubePlayer> createState() => _CustomYoutubePlayerState(); // 상태 클래스 생성
}

class _CustomYoutubePlayerState extends State<CustomYoutubePlayer> {
  YoutubePlayerController? controller; // 유튜브 플레이어 컨트롤러 변수

  @override
  void initState() {
    super.initState(); // 부모 클래스의 initState호출

    // 유튜브 플레이어 컨트롤러 초기화
    controller = YoutubePlayerController(
        initialVideoId: widget.videoModel.id, // 처음 실행할 동영상의 ID설정
      flags: const YoutubePlayerFlags(
        autoPlay: false, // 자동실행 x
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯을 부모 위젯의 너비에 맞춤
      children: [
        // 유튜브 플레이어 위젯
        YoutubePlayer(
          controller: controller!, // 설정한 컨트롤러 사용
          showVideoProgressIndicator: true, // 동영상 진행 표시기 표시
        ),
        const SizedBox(height: 16.0,), // 위젯 간 간격 설정
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0), // 좌우 패딩 설정
          child: Text(
            widget.videoModel.title, //동영상 제목 표시
            style: const TextStyle(
              color: Colors.white, // 텍스트 생상 : 흰색
              fontSize: 16.0, // 텍스트 크기 설정
              fontWeight: FontWeight.w700, //텍스트 굵기 설정
            ),
          ),
        )
      ],
    );
  }
}