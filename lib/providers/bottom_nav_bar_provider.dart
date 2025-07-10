import 'package:Artleap.ai/presentation/views/home_section/home_screen/home_screen.dart';
import 'package:Artleap.ai/presentation/views/home_section/new_prompt_section/new_prompt_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/views/home_section/community_screen/community_screen.dart';
import '../presentation/views/home_section/profile_screen/profile_screen.dart';

final bottomNavBarProvider = ChangeNotifierProvider<BottomNavBarProvider>(
    (ref) => BottomNavBarProvider());

class BottomNavBarProvider extends ChangeNotifier {
  List<Widget> widgets = [
    HomeScreen(),
    PromptScreen(),
    CommunityScreen(),
    ProfileScreen()
  ];

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }
}
