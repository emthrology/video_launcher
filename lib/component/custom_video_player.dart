import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CsutomVideoPlayer extends StatefulWidget {
  final XFile video;

  const CsutomVideoPlayer({required this.video, super.key});

  @override
  State<CsutomVideoPlayer> createState() => _CsutomVideoPlayerState();
}

class _CsutomVideoPlayerState extends State<CsutomVideoPlayer> {
  VideoPlayerController? vc;
  Duration currentPosition = Duration();

  @override
  void initState() {
    super.initState();

    initializeController();
  }

  // initState는 async 못해서 따로 뺌
  initializeController() async {
    vc = VideoPlayerController.file(
        File(widget.video.path) //XFile 형식을 dart.io.file 형식으로 convert
        );

    await vc!.initialize();

    vc!.addListener(() {
      final currentPosition = vc!.value.position;
      setState(() {
        this.currentPosition = currentPosition;
      });
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (vc == null) {
      return CircularProgressIndicator();
    }
    return AspectRatio(
      aspectRatio: vc!.value.aspectRatio,
      child: Stack(children: [
        VideoPlayer(
          vc!,
        ),
        _Controls(
          onPlayPressed: onPlayPressed,
          onRewindPressed: onRewindPressed,
          onFFPressed: onFFPressed,
          isPlaying: vc!.value.isPlaying,
        ),
        _NewVideo(
          onPressed: onNewVideoPressed,
        ),
        _SliderBottom(
          currentPosition: currentPosition,
          maxPosition: vc!.value.duration,
          onSliderChanged: onSliderChanaged,
        ),
      ]),
    );
  }

  void onSliderChanaged(double val) {
    vc!.seekTo(
      Duration(
        seconds: val.toInt()
      )
    );
  }


  void onNewVideoPressed() {}

  void onPlayPressed() {
    //toggle play state
    setState(() {
      //like watching
      if (vc!.value.isPlaying) {
        vc!.pause();
      } else {
        vc!.play();
      }
    });
  }

  void onRewindPressed() {
    final jump = Duration(milliseconds: 3000);
    final currentPosition = vc!.value.position;
    final minPosition = Duration.zero;
    Duration position;
    if (currentPosition < jump) {
      position = minPosition;
    } else {
      position = currentPosition - jump;
    }
    vc!.seekTo(position);
  }

  void onFFPressed() {
    final jump = Duration(milliseconds: 3000);
    final currentPosition = vc!.value.position;
    final maxPosition = vc!.value.duration;
    final timeLeft = maxPosition - currentPosition;
    Duration position;
    if (timeLeft < jump) {
      position = maxPosition;
    } else {
      position = currentPosition + jump;
    }
    vc!.seekTo(position);
  }
}

class _Controls extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onRewindPressed;
  final VoidCallback onFFPressed;
  final bool isPlaying;

  const _Controls({
    required this.onPlayPressed,
    required this.onRewindPressed,
    required this.onFFPressed,
    required this.isPlaying,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5), //비디오 컨트롤 버튼 잘보이게
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          renderIconButton(
            onPressed: onRewindPressed,
            iconData: Icons.rotate_left,
          ),
          renderIconButton(
            onPressed: onPlayPressed,
            iconData: isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          renderIconButton(
            onPressed: onFFPressed,
            iconData: Icons.rotate_right,
          ),
        ],
      ),
    );
  }

  Widget renderIconButton(
      {required VoidCallback onPressed, required IconData iconData}) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 30.0,
      color: Colors.white,
      icon: Icon(iconData),
    );
  }
}

class _NewVideo extends StatelessWidget {
  final VoidCallback onPressed;

  const _NewVideo({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      //absolute-like
      right: 0,
      child: IconButton(
          onPressed: onPressed,
          color: Colors.white,
          iconSize: 30.0,
          icon: Icon(
            Icons.photo_camera_back,
          )),
    );
  }
}

class _SliderBottom extends StatelessWidget {
  final Duration currentPosition;
  final Duration maxPosition;
  final ValueChanged<double> onSliderChanged;

  const _SliderBottom({
    required this.currentPosition,
    required this.maxPosition,
    required this.onSliderChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Text(
              '${(currentPosition.inMinutes % 60).toString().padLeft(2, '0')}:${(currentPosition.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Slider(
                value: currentPosition.inSeconds.toDouble(),
                onChanged: onSliderChanged,
                max: maxPosition.inSeconds.toDouble(),
                min: 0,
              ),
            ),
            Text(
              '${(maxPosition.inMinutes % 60).toString().padLeft(2, '0')}:${(maxPosition.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
