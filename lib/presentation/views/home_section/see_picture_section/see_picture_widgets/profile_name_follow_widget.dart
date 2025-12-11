import 'package:Artleap.ai/shared/route_export.dart';

class ProfileNameFollowWidget extends ConsumerWidget {
  final String? profileName;
  final String? userId;
  const ProfileNameFollowWidget({super.key, this.profileName, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userProfile = ref.watch(userProfileProvider);
    final currentUserId = UserData.ins.userId;

    final isFollowing = userProfile.value!.userProfile?.user.following
            .any((user) => user.id == userId) ??
        false;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: userId != null
                ? () {
                    Navigation.pushNamed(
                      OtherUserProfileScreen.routeName,
                      arguments: OtherUserProfileParams(
                        userId: userId,
                        profileName: profileName,
                      ),
                    );
                  }
                : null,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.onPrimary,
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: theme.colorScheme.primary,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                12.spaceX,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Created by",
                      style: AppTextstyle.interRegular(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (profileName?.length ?? 0) > 12
                          ? '${profileName!.substring(0, 12)}...'
                          : (profileName ?? "Jack Bolt"),
                      style: AppTextstyle.interMedium(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    )
                  ],
                ),
              ],
            ),
          ),

          // Follow Button
          if (userId != null && currentUserId != null)
            _buildFollowButton(
                ref, userProfile, isFollowing, currentUserId, theme),
        ],
      ),
    );
  }

  Widget _buildFollowButton(WidgetRef ref, dynamic userProfile,
      bool isFollowing, String currentUserId, ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (isFollowing)
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          else
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref
                .read(userProfileProvider.notifier)
                .followUnfollowUser(currentUserId, userId!);
          },
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 40,
            width: isFollowing ? 100 : 90,
            decoration: BoxDecoration(
              gradient: isFollowing
                  ? const LinearGradient(
                      colors: [Colors.white, Colors.white],
                    )
                  : LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primaryContainer
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isFollowing
                    ? theme.colorScheme.outline
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Center(
              child: userProfile.isLoading
                  ? LoadingAnimationWidget.threeArchedCircle(
                      color: isFollowing
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onPrimary,
                      size: 20,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isFollowing ? Icons.check_rounded : Icons.add_rounded,
                          color: isFollowing
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onPrimary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isFollowing ? "Following" : "Follow",
                          style: AppTextstyle.interMedium(
                            color: isFollowing
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onPrimary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
