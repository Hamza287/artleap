import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/global_widgets/app_background_widget.dart';
import 'package:photoroomapp/presentation/views/global_widgets/search_textfield.dart';
import 'package:photoroomapp/presentation/views/home_section/home_screen/home_screen_widgets/art_style_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/home_screen/home_screen_widgets/trending_creations_widget.dart';
import 'package:photoroomapp/providers/generate_image_provider.dart';
import 'package:photoroomapp/providers/home_screen_provider.dart';
import 'package:photoroomapp/providers/models_list_provider.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_static_data.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';
import 'package:photoroomapp/shared/navigation/navigator_key.dart';

import '../../../../providers/favrourite_provider.dart';
import '../../../../providers/user_profile_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String routeName = 'home_screen';

  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeScreenProvider).requestPermission();
      ref.read(modelsListProvider).getModelsListData();
      ref.read(homeScreenProvider).getUserCreations();
      ref.read(userProfileProvider).getUserProfiledata();
      ref.read(favouriteProvider).fetchUserFavourites();
      ref.read(generateImageProvider).clearVarData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundWidget(
        widget: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: RefreshIndicator(
        backgroundColor: AppColors.darkBlue,
        onRefresh: () {
          return ref.read(homeScreenProvider).getUserCreations();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [10.spaceY, 15.spaceY, TrendingCreationsWidget()],
          ),
        ),
      ),
    ));
  }
}
