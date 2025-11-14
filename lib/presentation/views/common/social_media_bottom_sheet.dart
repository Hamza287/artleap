import 'package:url_launcher/url_launcher.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class SocialMediaBottomSheet extends StatelessWidget {
  const SocialMediaBottomSheet({super.key});

  final List<Map<String, dynamic>> socialMedia = const [
    {
      'name': 'Instagram',
      'icon': Icons.photo_camera_rounded,
      'url': 'https://www.instagram.com/artleap.ai',
      'color': Color(0xFFE1306C),
      'gradient': [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCAF45)],
      'description': 'Visual Stories & Behind the Scenes',
    },
    {
      'name': 'TikTok',
      'icon': Icons.music_video_rounded,
      'url': 'https://www.tiktok.com/@artleap.ai',
      'color': Color(0xFF000000),
      'gradient': [Color(0xFF000000), Color(0xFF333333), Color(0xFF666666)],
      'description': 'Short Creative Videos & Trends',
    },
    {
      'name': 'YouTube',
      'icon': Icons.play_circle_filled_rounded,
      'url': 'https://www.youtube.com/@artleapai',
      'color': Color(0xFFFF0000),
      'gradient': [Color(0xFFFF0000), Color(0xFFFF4747), Color(0xFFFF6B6B)],
      'description': 'Tutorials & Full Process Videos',
    },
    {
      'name': 'Facebook',
      'icon': Icons.thumb_up_rounded,
      'url': 'https://www.facebook.com/artleapai/',
      'color': Color(0xFF1877F2),
      'gradient': [Color(0xFF1877F2), Color(0xFF4E93F3), Color(0xFF7BAFF7)],
      'description': 'Community & Updates',
    },
  ];

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 400;
    final iconSize = isSmallScreen ? 28.0 : 32.0;
    final fontSize = isSmallScreen ? 12.0 : 14.0;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.3),
              blurRadius: 32,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(theme,context),
            const SizedBox(height: 8),
            _buildSubtitle(theme),
            const SizedBox(height: 32),
            _buildSocialMediaGrid(theme, iconSize, fontSize),
            const SizedBox(height: 32),
            _buildFooter(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme,BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'Join Our Community',
            style: AppTextstyle.interBold(
              fontSize: 22,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        // Close button
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Follow us for daily inspiration, tutorials, and exclusive content from the world of AI art',
        style: AppTextstyle.interRegular(
          fontSize: 14,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSocialMediaGrid(ThemeData theme, double iconSize, double fontSize) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.6,
      ),
      itemCount: socialMedia.length,
      itemBuilder: (context, index) {
        final platform = socialMedia[index];
        return _buildPlatformCard(platform, theme, iconSize, fontSize);
      },
    );
  }

  Widget _buildPlatformCard(
      Map<String, dynamic> platform, ThemeData theme, double iconSize, double fontSize) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchUrl(platform['url']),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: List<Color>.from(platform['gradient']),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (platform['color'] as Color).withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              _buildBackgroundPattern(platform['color'] as Color),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        platform['icon'],
                        color: Colors.white,
                        size: iconSize,
                      ),
                    ),
                    Text(
                      platform['name'],
                      style: AppTextstyle.interBold(
                        fontSize: fontSize + 2,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Hover Overlay
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _launchUrl(platform['url']),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundPattern(Color color) {
    return Positioned(
      right: -20,
      bottom: -20,
      child: Opacity(
        opacity: 0.1,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Column(
      children: [
        Container(
          height: 1,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.outline.withOpacity(0.1),
                theme.colorScheme.outline.withOpacity(0.3),
                theme.colorScheme.outline.withOpacity(0.1),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_rounded,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Be part of our creative journey!',
              style: AppTextstyle.interMedium(
                fontSize: 14,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'New content every day • Exclusive tutorials • Community challenges',
          style: AppTextstyle.interRegular(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}