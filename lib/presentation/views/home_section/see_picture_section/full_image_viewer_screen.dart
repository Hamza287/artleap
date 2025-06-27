import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/navigation/screen_params.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../../../providers/watermark_provider.dart';
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
  final TransformationController _transformationController =
  TransformationController();

  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  final double _minScale = 1.0;
  final double _maxScale = 5.0;

  Uint8List? _originalImageBytes;
  bool _isLoadingImage = true;

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
    _loadOriginalImage();
  }

  Future<void> _loadOriginalImage() async {
    try {
      final response = await http.get(Uri.parse(widget.params!.Image!));
      if (response.statusCode == 200) {
        setState(() {
          _originalImageBytes = response.bodyBytes;
          _isLoadingImage = false;
        });
        if (_originalImageBytes != null) {
          ref.read(watermarkProvider.notifier).applyWatermark(_originalImageBytes!);
        }
      } else {
        setState(() {
          _isLoadingImage = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingImage = false;
      });
    }
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
      _animateTransformation(Matrix4.identity());
    } else {
      final newScale = _maxScale / 2;
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final Size screenSize = renderBox.size;
      final Offset screenCenter =
      Offset(screenSize.width / 2, screenSize.height / 2);

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

  @override
  Widget build(BuildContext context) {
    final watermarkState = ref.watch(watermarkProvider);

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
                  child: _isLoadingImage
                      ? const Center(child: CircularProgressIndicator())
                      : watermarkState.isLoading
                      ? CachedNetworkImage(
                    imageUrl: widget.params!.Image!,
                    fit: BoxFit.contain,
                  )
                      : watermarkState.watermarkedImage != null
                      ? Image.memory(
                    watermarkState.watermarkedImage!,
                    fit: BoxFit.contain,
                  )
                      : CachedNetworkImage(
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