import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'sections/account_actions_card.dart';
import 'sections/credits_card.dart';
import 'sections/profile_header.dart';
import 'sections/stats_card.dart';
import 'sections/subscription_card.dart';

class PersonalInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = "personal_info_screen";

  const PersonalInformationScreen({super.key});

  @override
  ConsumerState<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends ConsumerState<PersonalInformationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider).getUserProfileData(UserData.ins.userId ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = ref.watch(userProfileProvider);
    final user = profileProvider.userProfileData?.user;
    final isLoading = profileProvider.isLoading;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                foregroundColor: Colors.white,
                expandedHeight: 280,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    background: user != null
                        ? ProfileHeader(
                            profilePic: user.profilePic,
                            username: user.username,
                            email: user.email,
                          )
                        : Container(color: Colors.grey[200])),
                actions: [
                  // IconButton(
                  //   icon: const Icon(Icons.edit, color: Colors.white),
                  //   onPressed: null,
                  //   tooltip: "Edit Profile",
                  // ),
                ],
              ),
            ];
          },
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (isLoading) _buildLoadingState(),
                if (!isLoading && user != null) ...[
                  StatsCard(
                    followers: user.followers.length,
                    following: user.following.length,
                    images: user.images.length,
                  ),
                  const SizedBox(height: 20),
                  SubscriptionCard(
                    status: user.subscriptionStatus,
                    planName: user.planName,
                    planType: user.planName,
                    currentSubscription: user.planName,
                    isSubscribed: user.isSubscribed,
                  ),
                  const SizedBox(height: 20),
                  CreditsCard(
                    dailyCredits: user.totalCredits,
                    totalCredits: user.totalCredits,
                    usedImageCredits: user.usedImageCredits,
                    imageGenerationCredits: user.totalCredits,
                    usedPromptCredits: user.usedPromptCredits,
                    promptGenerationCredits: user.totalCredits,
                  ),
                  const SizedBox(height: 20),
                  // const AccountActionsCard(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: List.generate(
        4,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
