import 'package:flutter/material.dart';

class LoadingOverlayRedesign extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> fadeAnimation;

  const LoadingOverlayRedesign({
    super.key,
    required this.animationController,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnimation.value, // Fixed: changed _fadeAnimation to fadeAnimation
          child: Container(
            color: Colors.black.withOpacity(0.85),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated AI Icon
                  _buildAnimatedAIIcon(theme),
                  const SizedBox(height: 32),

                  // Loading Text
                  _buildLoadingText(theme),
                  const SizedBox(height: 16),

                  // Progress Indicator
                  _buildProgressIndicator(theme),
                  const SizedBox(height: 24),

                  // Tips
                  _buildLoadingTips(theme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedAIIcon(ThemeData theme) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Icon(
        Icons.auto_awesome_rounded,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Widget _buildLoadingText(ThemeData theme) {
    return Column(
      children: [
        Text(
          "Creating Your Art",
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "AI is working its magic...",
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return SizedBox(
      width: 200,
      child: LinearProgressIndicator(
        backgroundColor: theme.colorScheme.surface.withOpacity(0.3),
        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(10),
        minHeight: 8,
      ),
    );
  }

  Widget _buildLoadingTips(ThemeData theme) {
    final tips = [
      "Pro tip: The more detailed your prompt, the better the results!",
      "Experiment with different art styles for unique creations",
      "Try using reference images for more accurate outputs",
    ];

    final currentTip = tips[DateTime.now().second % tips.length];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: theme.colorScheme.primary,
            size: 16,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              currentTip,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
                fontSize: 12,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}