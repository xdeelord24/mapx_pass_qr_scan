import 'package:mapx_pass/design_course/home_design_course.dart';
import 'package:mapx_pass/fitness_app/fitness_app_home_screen.dart';
import 'package:mapx_pass/hotel_booking/hotel_home_screen.dart';
import 'package:mapx_pass/qr/quick_response.dart';
import 'package:mapx_pass/scanner_qr/scanner_qr.dart';
import 'package:mapx_pass/introduction_animation/introduction_animation_screen.dart';
import 'package:flutter/widgets.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
    this.avail=false,
  });

  Widget? navigateScreen;
  String imagePath;
  bool avail;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/quick_response/qr_code.png',
      navigateScreen: QuickResponse(),
      avail: true,
    ),
    HomeList(
      imagePath: 'assets/hotel/hotel_booking.png',
      navigateScreen: ScannerQr(),
      avail: true,
    ),
    HomeList(
      imagePath: 'assets/hotel/hotel_booking.png',
      navigateScreen: HotelHomeScreen(),
      avail: true,
    ),
    HomeList(
      imagePath: 'assets/fitness_app/fitness_app.png',
      navigateScreen: FitnessAppHomeScreen(),
    ),
    HomeList(
      imagePath: 'assets/design_course/design_course.png',
      navigateScreen: DesignCourseHomeScreen(),
    ),
  ];
}
