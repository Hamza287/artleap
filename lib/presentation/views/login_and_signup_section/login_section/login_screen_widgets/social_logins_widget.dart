import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';

import '../../../../../providers/auth_provider.dart';
import '../../../../../shared/constants/app_colors.dart';

class SocialLoginsWidget extends ConsumerWidget {
  const SocialLoginsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 285,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ref.watch(authprovider).isLoading(LoginMethod.google)
              ? Container(
                  width: 85,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: AppColors.indigo,
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    ref.read(authprovider).signInWithGoogle();
                  },
                  child: SizedBox(
                    width: 85,
                    child: Image.asset(
                      AppAssets.googlelogin,
                      scale: 2.2,
                    ),
                  ),
                ),
          // ref.watch(authprovider).isLoading(LoginMethod.facebook)
          //     ? const SizedBox(
          //         width: 85,
          //         child: Center(
          //           child: CircularProgressIndicator(
          //             backgroundColor: AppColors.indigo,
          //           ),
          //         ),
          //       )
          //     : InkWell(
          //         onTap: () {
          //           ref.read(authprovider).signInWithFacebook();
          //         },
          //         child: Container(
          //           width: 85,
          //           child: Image.asset(
          //             AppAssets.facebooklogin,
          //             scale: 2.2,
          //           ),
          //         ),
          //       ),
          // Image.asset(
          //   AppAssets.applelogin,
          //   scale: 2.2,
          // ),
        ],
      ),
    );
  }
}
