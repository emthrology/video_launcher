import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //자주쓰는 설정을 위에 끌어놓기
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontWeight: FontWeight.w300
    );
    return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          // color: Colors.black,
          decoration: getBoxDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Logo(),
              SizedBox(height: 30.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'VIDEO',
                    style: textStyle
                  ),
                  Text(
                    'PLAYER',
                    style: textStyle.copyWith(
                      fontWeight: FontWeight.w700
                    )
                  )
                ],
              )
            ],
          ),
        )
    );
  }

  BoxDecoration getBoxDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
        Color(0xff2A3A7C),
        Color(0xff000118)
        ]
      )
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
        'asset/image/logo.png'
    );
  }
}
