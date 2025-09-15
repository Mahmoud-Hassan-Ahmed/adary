import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../view/screen/instructors/instructor.dart';
import '../view/screen/laps/laps.dart';
import '../view/screen/profile/profile.dart';
import '../view/screen/waiting/waiting.dart';

class DashBoardController extends GetxController implements GetxService {
  int _pageIndex = 0;

  final pageController = PageController();
  int currentIndex = 0.obs();

  int get pageIndex => _pageIndex;
  set pageIndex(int index) => _pageIndex == index;

  final List<Widget> _children = [
    Instructor(),
    Laps(),
    // Waiting(),
    // Profile(),
  ];
  List<Widget> get children => _children;
  void onPageChanged(int index) {
    _pageIndex = index;
    currentIndex = index;
    update();
  }

  void onTapPager(int index) {
    pageController.jumpToPage(index);
    _pageIndex = index;
    update();
  }
}
