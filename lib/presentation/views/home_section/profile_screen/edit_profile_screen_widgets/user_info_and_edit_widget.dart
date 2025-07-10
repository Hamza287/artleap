import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/edit_profile_screen_widgets/edit_profile_widget.dart';
import 'package:Artleap.ai/shared/navigation/screen_params.dart';

class UserInfoAndEditWidget extends ConsumerWidget {
  final EditProfileSreenParams? params;

  const UserInfoAndEditWidget({super.key, this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.only(top: 70),
      decoration: BoxDecoration(
        color: Colors.transparent, // Slightly transparent
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Mirror effect background
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x22F3F2F2),
                        Color(0x22F3F2F2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                EditProfileWidget(
                  params: params,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}