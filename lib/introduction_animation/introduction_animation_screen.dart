import 'package:mapx_pass/introduction_animation/components/care_view.dart';
import 'package:mapx_pass/introduction_animation/components/center_next_button.dart';
import 'package:mapx_pass/introduction_animation/components/mood_diary_vew.dart';
import 'package:mapx_pass/introduction_animation/components/relax_view.dart';
import 'package:mapx_pass/introduction_animation/components/splash_view.dart';
import 'package:mapx_pass/introduction_animation/components/top_back_skip_view.dart';
import 'package:mapx_pass/introduction_animation/components/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:mapx_pass/navigation_home_screen.dart';
import 'package:mapx_pass/login_screen.dart';
import 'package:mapx_pass/services/read_write.dart';
import 'dart:convert';
import 'package:mapx_pass/services/strapi.dart' as Strapi;

class IntroductionAnimationScreen extends StatefulWidget {
  const IntroductionAnimationScreen({Key? key}) : super(key: key);
  @override
  _IntroductionAnimationScreenState createState() =>
      _IntroductionAnimationScreenState();
}

class _IntroductionAnimationScreenState
    extends State<IntroductionAnimationScreen> with TickerProviderStateMixin {
  AnimationController? _animationController;
  CounterStorage storage = CounterStorage();
  String? _data;
  Future<String>? userData;
  String? _tempUser;
  String? _tempPass;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 8));
    _animationController?.animateTo(0.0);

    opener();
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_data != null) {
      bypassLogIn();
    }
    print(_animationController?.value);
    return Scaffold(
      backgroundColor: Color(0xffF7EBE1),
      body: ClipRect(
        child: Stack(
          children: [
            SplashView(
              animationController: _animationController!,
            ),
            RelaxView(
              animationController: _animationController!,
            ),
            CareView(
              animationController: _animationController!,
            ),
            MoodDiaryVew(
              animationController: _animationController!,
            ),
            WelcomeView(
              animationController: _animationController!,
            ),
            TopBackSkipView(
              onBackClick: _onBackClick,
              onSkipClick: _onSkipClick,
              animationController: _animationController!,
            ),
            CenterNextButton(
              animationController: _animationController!,
              onNextClick: _onNextClick,
            ),
            CenterNextButton(
              animationController: _animationController!,
              onNextClick: _onNextClick,
            ),
          ],
        ),
      ),
    );
  }

  void _onSkipClick() {
    _animationController?.animateTo(0.8,
        duration: Duration(milliseconds: 1200));
  }

  void _onBackClick() {
    if (_animationController!.value >= 0 &&
        _animationController!.value <= 0.2) {
      _animationController?.animateTo(0.0);
    } else if (_animationController!.value > 0.2 &&
        _animationController!.value <= 0.4) {
      _animationController?.animateTo(0.2);
    } else if (_animationController!.value > 0.4 &&
        _animationController!.value <= 0.6) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value > 0.6 &&
        _animationController!.value <= 0.8) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.8 &&
        _animationController!.value <= 1.0) {
      _animationController?.animateTo(0.8);
    }
  }

  void _onNextClick() {
    if (_animationController!.value >= 0 &&
        _animationController!.value <= 0.2) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value > 0.2 &&
        _animationController!.value <= 0.4) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.4 &&
        _animationController!.value <= 0.6) {
      _animationController?.animateTo(0.8);
    } else if (_animationController!.value > 0.6 &&
        _animationController!.value <= 0.8) {
      _signUpClick();
    }
  }

  void _signUpClick() {
    // Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LoginScreen(
              animationController: _animationController!,
              onNextClick: _loginClick)),
    );

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
    // );
  }

  void _loginClick() {
    // Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
    );
  }

  void bypassLogIn() {
    try {
      var user = jsonDecode(_data.toString())[0];
      this._tempUser = user['id_number'];
      if (_tempUser != null) {
        Future.delayed(Duration.zero, () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationHomeScreen(),
              ),
              (route) => false);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future opener() async {
    try {
      await storage.readCounter().then((context) {
        if (context != null) {
          setState(() {
            _data = context;
            // print(_data);
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
