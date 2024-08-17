import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/global_widgets/app_background_widget.dart';
import 'package:photoroomapp/presentation/views/global_widgets/search_textfield.dart';
import 'package:photoroomapp/presentation/views/home_section/home_screen/home_screen_widgets/art_style_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/home_screen/home_screen_widgets/trending_creations_widget.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

class HomeScreen extends ConsumerWidget {
  static const String routeName = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBackgroundWidget(
        widget: Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.spaceY,
            SearchTextfield(),
            15.spaceY,
            ArtStyleWidget(),
            15.spaceY,
            TrendingCreationsWidget()
          ],
        ),
      ),
    ));
  }
}
