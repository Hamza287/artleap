import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/navigation/screen_params.dart';

class FullImageViewerScreen extends ConsumerWidget {
  static const String routeName = "full_image_screen";
  final FullImageScreenParams? params;
  const FullImageViewerScreen({super.key, this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkBlue,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InteractiveViewer(
            // Set the desired transformation properties
            boundaryMargin: EdgeInsets.all(double.infinity),
            minScale: 0.1,
            maxScale: 5.0,
            child: params!.uint8list != null
                ? Container( 
                    height: double.infinity,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.memory(
                        params!.uint8list!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        params!.Image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
