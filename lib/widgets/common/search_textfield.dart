import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/home_screen_provider.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class SearchTextfield extends ConsumerWidget {
  const SearchTextfield({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: TextField(
          style: AppTextstyle.interRegular(
            fontSize: 16,
            color: Colors.black,
          ),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: "Search AI Creations",
            hintStyle: AppTextstyle.interRegular(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 12, right: 8),
              child: Icon(
                Icons.search,
                color: Colors.black,
                size: 30, // Set appropriate icon size
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
          onChanged: (value) {
            FirebaseCrashlytics.instance.log('User typing in search textfield');
            ref.read(homeScreenProvider).filteredListFtn(value);
          },
        ),
      ),
    );
  }
}