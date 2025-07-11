import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenTopBar extends ConsumerWidget {
  final VoidCallback? onMenuTap;
  const HomeScreenTopBar({super.key, this.onMenuTap});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onMenuTap,
                child: const Icon(Icons.menu, size: 28, color: Colors.black),
              ),
              Container(
                height: 36,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.2,
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.stackofcoins,
                      height: 18,
                      color: Colors.amber[700],
                    ),
                    3.spaceX,
                    Text(
                      "${ref.watch(userProfileProvider).userProfileData?.user.dailyCredits ?? 0}",
                      style: AppTextstyle.interMedium(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              const Text(
                "Art leap",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Add Get Pro logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF923CFF),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "✨ Get Pro",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
