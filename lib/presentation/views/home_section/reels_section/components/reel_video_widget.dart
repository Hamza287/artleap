import 'package:Artleap.ai/domain/reels/reel_model.dart';
import 'package:Artleap.ai/domain/reels/reel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class ReelVideoWidget extends ConsumerStatefulWidget {
  final ReelModel reel;
  final bool isCurrentReel;

  const ReelVideoWidget({
    super.key,
    required this.reel,
    required this.isCurrentReel,
  });

  @override
  ConsumerState<ReelVideoWidget> createState() => _ReelVideoWidgetState();
}

class _ReelVideoWidgetState extends ConsumerState<ReelVideoWidget> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    _controller = VideoPlayerController.network(widget.reel.videoUrl);

    try {
      await _controller.initialize();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }

      if (widget.isCurrentReel) {
        _controller.play();
        _controller.setLooping(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isVideoInitialized = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(ReelVideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isCurrentReel && _isVideoInitialized) {
      _controller.play();
    } else if (_isVideoInitialized) {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMuted = ref.watch(reelProvider.select((state) => state.isMuted));

    if (!_isVideoInitialized) {
      return _buildVideoPlaceholder(theme);
    }

    _controller.setVolume(isMuted ? 0.0 : 1.0);

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),

          if (!_controller.value.isPlaying)
            Container(
              color: Colors.black38,
              child: Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 64,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ),

          if (isMuted)
            Positioned(
              top: 40,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.volume_off_rounded,
                  color: theme.colorScheme.onSurface,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoPlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_rounded,
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading video...',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}