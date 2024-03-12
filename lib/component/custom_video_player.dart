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

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (vc == null) {
      return CircularProgressIndicator();
    }
    return VideoPlayer(
      vc!,
    );
  }
}
