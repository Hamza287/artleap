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
          padding: const EdgeInsets.only(top: 20, left: 20, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Row(
               children: [
                 GestureDetector(
                   onTap: onMenuTap,
                   child: SizedBox(
                     height: 28,
                     width: 28,
                     child: Center(
                       child: Transform.scale(
                         scale: 1.3,
                         child: Image.asset(
                           AppAssets.sidebar,
                           color: Colors.black,
                           height: 40, // actual image size
                           width: 40,
                           fit: BoxFit.contain,
                         ),
                       ),
                     ),
                   ),
                 ),
                 10.spaceX,
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
                         "${ref.watch(userProfileProvider).userProfileData?.user.totalCredits ?? 0}",
                         style: AppTextstyle.interMedium(
                           color: Colors.black,
                           fontSize: 12,
                           fontWeight: FontWeight.bold,
                         ),
                       )
                     ],
                   ),
                 ),
               ],
             ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("choose_plan_screen");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF923CFF),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(86),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      AppAssets.proBtn,
                      height: 30,
                    ),

                    const Text(
                      "Get Pro",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
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
