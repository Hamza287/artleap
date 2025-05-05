import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/navigation/screen_params.dart';

import '../../../firebase_analyitcs_singleton/firebase_analtics_singleton.dart';

class FullImageViewerScreen extends StatefulWidget {
  static const String routeName = "full_image_screen";
  final FullImageScreenParams? params;

  const FullImageViewerScreen({super.key, this.params});

  @override
  _FullImageViewerScreenState createState() => _FullImageViewerScreenState();
}

class _FullImageViewerScreenState extends State<FullImageViewerScreen>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();

  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  final double _minScale = 1.0; // Your specified minScale
  final double _maxScale = 5.0; // Your specified maxScale

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.addListener(() {
      _transformationController.value = _animation!.value;
    });
    AnalyticsService.instance.logScreenView(screenName: 'full image screen');
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap(BuildContext context) {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();

    if (currentScale > _minScale) {
      // Animate back to the original scale
      _animateTransformation(Matrix4.identity());
    } else {
      // Center zoom logic
      final newScale = _maxScale / 2; // Example zoom level
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final Size screenSize = renderBox.size;

      // Calculate the center point to zoom in on
      final Offset screenCenter =
          Offset(screenSize.width / 2, screenSize.height / 2);

      // Create the target transformation matrix
      final targetMatrix = Matrix4.identity()
        ..translate(
            screenCenter.dx * (1 - newScale), screenCenter.dy * (1 - newScale))
        ..scale(newScale);

      // Animate to the target matrix
      _animateTransformation(targetMatrix);
    }
  }

  void _animateTransformation(Matrix4 targetMatrix) {
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: targetMatrix,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkBlue,
        appBar: AppBar(
          backgroundColor: AppColors.darkBlue,
          iconTheme: const IconThemeData(color: AppColors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onDoubleTap: () => _handleDoubleTap(context),
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: _minScale,
              maxScale: _maxScale,
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: widget.params!.Image!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
