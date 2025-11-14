import 'package:Artleap.ai/shared/route_export.dart';

class ProfileInfoWidget extends ConsumerWidget {
  final String? profileName;
  final String? userId;
  const ProfileInfoWidget({super.key, this.profileName, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userProfile = ref.watch(userProfileProvider);
    final otherUser = userProfile.otherUserProfileData?.user;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildProfileAvatar(userProfile, theme),
              16.spaceX,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileName ?? "User Name",
                      style: AppTextstyle.interMedium(
                        color: theme.colorScheme.onSurface,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    6.spaceY,
                    Text(
                      "AI Artist",
                      style: AppTextstyle.interRegular(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          20.spaceY,
          _buildStatsRow(otherUser, theme),
          20.spaceY,
          _buildFollowButton(userProfile,ref, theme),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(dynamic userProfile, ThemeData theme) {
    final hasProfilePic = userProfile.otherUserProfileData?.user.profilePic.isNotEmpty ?? false;

    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3), width: 2),
      ),
      child: ClipOval(
        child: hasProfilePic
            ? Image.network(
          userProfile.otherUserProfileData!.user.profilePic,
          fit: BoxFit.cover,
        )
            : Container(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.person_rounded,
            color: theme.colorScheme.onSurface.withOpacity(0.4),
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(dynamic otherUser, ThemeData theme) {
    final creations = otherUser?.images.length ?? 0;
    final followers = otherUser?.followers.length ?? 0;
    final following = otherUser?.following.length ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("Creations", creations.toString(), theme),
          Container(height: 30, width: 1, color: theme.colorScheme.outline.withOpacity(0.3)),
          _buildStatItem("Followers", followers.toString(), theme),
          Container(height: 30, width: 1, color: theme.colorScheme.outline.withOpacity(0.3)),
          _buildStatItem("Following", following.toString(), theme),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, ThemeData theme) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextstyle.interMedium(
            fontSize: 16,
            color: theme.colorScheme.onSurface,
          ),
        ),
        4.spaceY,
        Text(
          label,
          style: AppTextstyle.interRegular(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildFollowButton(dynamic userProfile,WidgetRef ref, ThemeData theme) {
    final isFollowing = userProfile.userProfileData?.user.following.any((user) => user.id == userId) ?? false;
    final isLoading = userProfile.isLoading;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(userProfileProvider).followUnfollowUser(UserData.ins.userId!, userId!);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: isFollowing ? theme.colorScheme.surface : theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isFollowing ? theme.colorScheme.outline : theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            child: Center(
              child: isLoading
                  ? LoadingAnimationWidget.threeArchedCircle(
                color: isFollowing ? theme.colorScheme.primary : theme.colorScheme.onPrimary,
                size: 20,
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isFollowing ? Icons.check_rounded : Icons.add_rounded,
                    color: isFollowing ? theme.colorScheme.primary : theme.colorScheme.onPrimary,
                    size: 18,
                  ),
                  8.spaceX,
                  Text(
                    isFollowing ? "Following" : "Follow",
                    style: AppTextstyle.interMedium(
                      color: isFollowing ? theme.colorScheme.primary : theme.colorScheme.onPrimary,
                      fontSize: 15,
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