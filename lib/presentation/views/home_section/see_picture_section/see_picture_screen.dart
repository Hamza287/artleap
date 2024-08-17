import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/global_widgets/app_background_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/see_picture_section/see_picture_widgets/picture_container.dart';
import 'package:photoroomapp/presentation/views/home_section/see_picture_section/see_picture_widgets/picture_info_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/see_picture_section/see_picture_widgets/prompt_text_widget.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';
import 'package:photoroomapp/shared/navigation/screen_params.dart';

class SeePictureScreen extends ConsumerStatefulWidget {
  static const routeName = "see_picture_screen";
  final SeePictureParams? params;
  const SeePictureScreen({super.key, this.params});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SeePictureScreenState();
}

class _SeePictureScreenState extends ConsumerState<SeePictureScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBackgroundWidget(
      widget: Column(
        children: [
          20.spaceY,
          PictureInfoWidget(),
          20.spaceY,
          PictureWidget(
            image: widget.params!.image,
          ),
          20.spaceY,
          PromptTextWidget()
        ],
      ),
    );
  }
}
