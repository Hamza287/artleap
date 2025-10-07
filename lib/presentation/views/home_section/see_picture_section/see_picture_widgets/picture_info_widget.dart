import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/shared.dart';

class PictureInfoWidget extends ConsumerWidget {
  final String? styleName;
  final String? createdAt;
  const PictureInfoWidget({super.key, this.styleName, this.createdAt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFf8f9ff), Color(0xFFf0f2ff)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline_rounded,
                  color: AppColors.darkBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                "Artwork Information",
                style: AppTextstyle.interMedium(
                  color: AppColors.darkBlue,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Information Cards
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.brush_rounded,
                  title: "Art Style",
                  info: styleName ?? "Unknown",
                  color: Colors.purple,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.calendar_today_rounded,
                  title: "Created On",
                  info: createdAt ?? "Unknown",
                  color: Colors.blue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Additional Action Buttons (commented but preserved)
          _primaryActionButton(
            icon: Icons.auto_awesome_rounded,
            label: "Generate Prompt",
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          _primaryActionButton(
            icon: Icons.open_in_full_rounded,
            label: "Upscale",
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          _primaryActionButton(
            icon: Icons.brush_rounded,
            label: "Add/Remove Object",
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String info,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextstyle.interMedium(
              fontSize: 12,
              color: Colors.grey[600]!,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            info,
            style: AppTextstyle.interMedium(
              fontSize: 14,
              color: AppColors.darkBlue,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _primaryActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9B59FF).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9B59FF), Color(0xFF8E44AD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppTextstyle.interMedium(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoText extends ConsumerWidget {
  final String? title;
  final String? info;
  const InfoText({super.key, this.title, this.info});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title!,
            style: AppTextstyle.interMedium(
              fontSize: 14,
              color: Colors.grey[600]!,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            info!,
            style: AppTextstyle.interMedium(
              fontSize: 16,
              color: AppColors.darkBlue,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
