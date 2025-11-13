import 'package:Artleap.ai/providers/auth_provider.dart';
import 'package:Artleap.ai/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';

class SocialLoginsWidget extends ConsumerWidget {
  const SocialLoginsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 285,
      child: Row(
        mainAxisAlignment: Platform.isIOS
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          ref.watch(authprovider).isLoading(LoginMethod.google)
              ? Container(
                  width: 100,
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
                  child: Container(
                    height: 45,
                    width: 139,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      AppAssets.googlelogin,
                      scale: 2.1,
                    ),
                  ),
                ),
          if (Platform.isIOS)
            Container(
              height: 45,
              width: 139,
              child: SignInWithAppleButton(
                style: SignInWithAppleButtonStyle.white,
                text: "",
                onPressed: () async {
                  ref.read(authprovider).signInWithApple();
                },
              ),
            )
        ],
      ),
    );
  }
}
