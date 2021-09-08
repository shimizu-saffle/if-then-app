import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavigationProvider =
    ChangeNotifierProvider<BottomNavigationController>(
  (ref) => BottomNavigationController(),
);

class BottomNavigationController extends ChangeNotifier {
  int _currentIndex = 0;

  // getterとsetterを指定しています
  // setのときにnotifyListeners()を呼ぶとアイコンタップと同時に画面を更新しています。
  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners(); // View側に変更を通知
  }

  void pageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // void bottomTapped(int index) {
  //   _currentIndex = index;
  //   pageController.animateToPage(index,
  //       duration: Duration(milliseconds: 500), curve: Curves.ease);
  //   notifyListeners();
  // }
}