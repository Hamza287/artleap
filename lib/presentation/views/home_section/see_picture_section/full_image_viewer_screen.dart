import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/navigation/screen_params.dart';
import 'package:Artleap.ai/providers/watermark_provider.dart';
import '../../../../providers/full_image_state_provider.dart';
import '../../../firebase_analyitcs_singleton/firebase_analtics_singleton.dart';

class FullImageViewerScreen extends ConsumerStatefulWidget {
  static const String routeName = "full_image_screen";
  final FullImageScreenParams? params;

  const FullImageViewerScreen({super.key, this.params});

  @override
  ConsumerState<FullImageViewerScreen> createState() => _FullImageViewerScreenState();
}

class _FullImageViewerScreenState extends ConsumerState<FullImageViewerScreen>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController = TransformationController();
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  final double _minScale = 1.0;
  final double _maxScale = 5.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.addListener(() {
      if (_animation != null) {
        _transformationController.value = _animation!.value;
      }
    });

    AnalyticsService.instance.logScreenView(screenName: 'full image screen');

    // Delay the image loading until after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadImage();
    });
  }

  Future<void> _loadImage() async {
    final imageUrl = widget.params?.Image;
    if (imageUrl == null || imageUrl.isEmpty) return;

    await ref.read(fullImageProvider.notifier).loadOriginalImage(imageUrl);

    // Apply watermark after image is loaded
    final imageBytes = ref.read(fullImageProvider).originalImageBytes;
    if (imageBytes != null && mounted) {
      ref.read(watermarkProvider.notifier).applyWatermark(imageBytes);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformationController.dispose();
    // ref.read(fullImageProvider.notifier).reset();
    super.dispose();
  }

  void _handleDoubleTap(BuildContext context) {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();

    if (currentScale > _minScale) {
      _animateTransformation(Matrix4.identity());
    } else {
      final newScale = _maxScale / 2;
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final screenSize = renderBox.size;
      final screenCenter = Offset(screenSize.width / 2, screenSize.height / 2);

      final targetMatrix = Matrix4.identity()
        ..translate(
            screenCenter.dx * (1 - newScale), screenCenter.dy * (1 - newScale))
        ..scale(newScale);

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

  Widget _buildImageContent() {
    final fullImageState = ref.watch(fullImageProvider);
    final watermarkState = ref.watch(watermarkProvider);
    final imageUrl = widget.params?.Image;

    if (fullImageState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (fullImageState.error != null) {
      return Center(
        child: Text(
          fullImageState.error!,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    if (watermarkState.isLoading) {
      return imageUrl != null
          ? CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        errorWidget: (context, url, error) => const Icon(Icons.error),
      )
          : const Center(child: Icon(Icons.error));
    }

    if (watermarkState.watermarkedImage != null) {
      return Image.memory(
        watermarkState.watermarkedImage!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      );
    }

    return imageUrl != null
        ? CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      errorWidget: (context, url, error) => const Icon(Icons.error),
    )
        : const Center(child: Icon(Icons.error));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:  const Color(0xFFFFFFFF),
        appBar: AppBar(
          backgroundColor:  const Color(0xFFFFFFFF),
          iconTheme: const IconThemeData(color: AppColors.darkBlue),
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
                  child: _buildImageContent(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}