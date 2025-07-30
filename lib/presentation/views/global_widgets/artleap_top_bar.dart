import 'package:Artleap.ai/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/user_profile_provider.dart';

class ArtLeapTopBar extends ConsumerWidget {
  final String title;
  ArtLeapTopBar({super.key,this.title = 'Creation Studio'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credits = ref.watch(userProfileProvider).userProfileData?.user.totalCredits ?? 0;

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
                  "$credits",
                  style: AppTextstyle.interMedium(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),

          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
            ),
          ),

          // Get Pro Button
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
              children: [
                Image.asset(
                  AppAssets.proBtn,
                  height: 30,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Get Pro",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
