import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:epubview/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2),() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EpubView())));
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Color(0xFF86b918),
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.lightGreen,
            statusBarBrightness: Brightness.light ,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              // Image.asset('assets/images/epub_splash_logo.png',width: 50.0,height: 50.0,),
              Text(
                'E Pub View',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  // color: Color(0xFF86b918),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
