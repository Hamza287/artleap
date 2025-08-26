import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaBottomSheet extends StatelessWidget {
  const SocialMediaBottomSheet({super.key});

  // Social media data
  final List<Map<String, dynamic>> socialMedia = const [
    {
      'name': 'Instagram',
      'icon': Icons.camera_alt,
      'url': 'https://www.instagram.com/artleap.ai',
      'color': Color(0xFFE1306C),
      'gradient': [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCAF45)],
    },
    {
      'name': 'TikTok',
      'icon': Icons.music_note,
      'url': 'https://www.tiktok.com/@artleap.ai',
      'color': Color(0xFF000000),
      'gradient': [Color(0xFF000000), Color(0xFF000000)],
    },
    {
      'name': 'YouTube',
      'icon': Icons.play_circle_fill,
      'url': 'https://www.youtube.com/@artleapai',
      'color': Color(0xFFFF0000),
      'gradient': [Color(0xFFFF0000), Color(0xFFFF4747)],
    },
    {
      'name': 'Facebook',
      'icon': Icons.facebook,
      'url': 'https://www.facebook.com/artleapai/',
      'color': Color(0xFF1877F2),
      'gradient': [Color(0xFF1877F2), Color(0xFF4E93F3)],
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
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 400;
    final iconSize = isSmallScreen ? 28.0 : 32.0;
    final fontSize = isSmallScreen ? 12.0 : 14.0;

    return Container(
      padding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, -6),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with title and close button
          Stack(
            alignment: Alignment.center,
            children: [
              // Title
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Follow Us',
                  style: AppTextstyle.interRegular(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // Close button (top right)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Subtitle
          Text(
            'Stay updated with our latest creations',
            style: AppTextstyle.interRegular(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          // Social media icons in one row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: socialMedia.map((platform) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () => _launchUrl(platform['url']),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: platform['gradient'],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: platform['color'].withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          platform['icon'],
                          color: Colors.white,
                          size: iconSize,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    platform['name'],
                    style: AppTextstyle.interRegular(
                      fontSize: fontSize,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          // Call to action text
          Text(
            'Join our creative community!',
            style: AppTextstyle.interRegular(
              fontSize: 16,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}