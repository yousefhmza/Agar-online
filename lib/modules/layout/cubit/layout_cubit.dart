import '../../advertisements/view/screens/add_advertisement_screen.dart';
import '../../chat/view/screens/chats_screen.dart';
import '../../home/view/screens/home_screen.dart';
import '../../more/view/screens/more_screen.dart';
import '../../profile/view/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout_states.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitState());

  int currentIndex = 0;
  final List<Widget> bottomTabsScreens = [
    const HomeScreen(),
    const ProfileScreen(),
    const AddAdvertisementScreen(),
    const ChatsScreen(),
    const MoreScreen(),
  ];

  void setCurrentIndex(int index) {
    currentIndex = index;
    emit(LayoutSetIndexState());
  }
}
