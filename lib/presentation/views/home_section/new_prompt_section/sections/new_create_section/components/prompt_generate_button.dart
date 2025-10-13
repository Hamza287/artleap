import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';

class PromptScreenButtonRedesign extends ConsumerWidget {
  final String? title;
  final String? imageIcon;
  final VoidCallback? onpress;
  final bool isLoading;
  final double? height;
  final double? width;
  final double? imageIconSize;
  final bool? suffixRow;
  final String credits;

  const PromptScreenButtonRedesign({
    super.key,
    this.title,
    this.imageIcon,
    this.onpress,
    required this.isLoading,
    this.height,
    this.width,
    this.imageIconSize,
    this.suffixRow,
    this.credits = '2'
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: height ?? 56,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: _getButtonGradient(theme),
        boxShadow: _getButtonShadows(theme),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onpress,
          borderRadius: BorderRadius.circular(16),
          splashColor: theme.colorScheme.onPrimary.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side - Icon and Text
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLoading)
                        LoadingAnimationWidget.threeRotatingDots(
                          color: theme.colorScheme.onPrimary,
                          size: 24,
                        )
                      else
                        _buildContent(theme),
                    ],
                  ),
                ),
                if (suffixRow == true && !isLoading)
                  _buildCreditsSection(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon with background
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            imageIcon!,
            width: imageIconSize ?? 20,
            height: imageIconSize ?? 20,
            color: theme.colorScheme.onPrimary,
          ),
        ),

        if (title != null) 12.spaceX,

        if (title != null)
          Flexible(
            child: Text(
              title!,
              style: AppTextstyle.interMedium(
                color: theme.colorScheme.onPrimary,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _buildCreditsSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onPrimary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Coin Icon
          Image.asset(
            AppAssets.stackofcoins,
            width: 16,
            height: 16,
            color: theme.colorScheme.onPrimary,
          ),
          6.spaceX,

          // Credits Text
          Text(
            credits,
            style: AppTextstyle.interMedium(
              color: theme.colorScheme.onPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getButtonGradient(ThemeData theme) {
    if (isLoading) {
      return LinearGradient(
        colors: [
          theme.colorScheme.primary.withOpacity(0.7),
          theme.colorScheme.primary.withOpacity(0.5),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }

    return LinearGradient(
      colors: [
        theme.colorScheme.primary,
        theme.colorScheme.primary.withOpacity(0.9),
        theme.colorScheme.primary.withOpacity(0.8),
      ],
      stops: const [0.0, 0.5, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  List<BoxShadow> _getButtonShadows(ThemeData theme) {
    if (isLoading) {
      return [
        BoxShadow(
          color: theme.colorScheme.primary.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    }

    return [
      BoxShadow(
        color: theme.colorScheme.primary.withOpacity(0.4),
        blurRadius: 15,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: theme.colorScheme.primary.withOpacity(0.2),
        blurRadius: 30,
        offset: const Offset(0, 8),
        spreadRadius: 2,
      ),
    ];
  }
}