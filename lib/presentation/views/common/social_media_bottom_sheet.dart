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
      'url': 'https://www.instagram.com/360mimar?igsh=MXNrbDI0dGh0aWdsOQ==',
      'color': Color(0xFFE1306C),
    },
    // {
    //   'name': 'Twitter',
    //   'icon': Icons.alternate_email,
    //   'url': 'https://x.com/your_account',
    //   'color': Color(0xFF1DA1F2),
    // },
    {
      'name': 'Facebook',
      'icon': Icons.facebook,
      'url': 'https://www.facebook.com/share/1EN7VL75MG/',
      'color': Color(0xFF1877F2),
    },
    {
      'name': 'LinkedIn',
      'icon': Icons.business,
      'url': 'https://www.linkedin.com/company/360mimar/',
      'color': Color(0xFF0A66C2),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle for dragging
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Text(
            'Follow Us on Social Media',
            style: AppTextstyle.interRegular(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          // Social media icons in one row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: socialMedia.map((platform) {
              return GestureDetector(
                onTap: () => _launchUrl(platform['url']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [

                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        platform['icon'],
                        color: platform['color'],
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        platform['name'],
                        style: AppTextstyle.interRegular(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Close button
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            child: Text(
              'Close',
              style: AppTextstyle.interRegular(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}