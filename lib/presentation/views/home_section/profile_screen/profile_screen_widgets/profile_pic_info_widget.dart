import 'package:Artleap.ai/shared/route_export.dart';

class ProfilePicAndInfoWidget extends ConsumerWidget {
  const ProfilePicAndInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userProfile = ref.watch(userProfileProvider);
    final user = userProfile.value!.userProfile?.user;
    final profilePic = user?.profilePic;
    final userName = user?.username ?? 'Guest';

    if (user == null) {
      return const CircularProgressIndicator();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surface,
            image: profilePic != null && profilePic.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(profilePic),
                    fit: BoxFit.cover,
                  )
                : const DecorationImage(
                    image: AssetImage(AppAssets.artstyle1),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        10.spaceY,
        Text(
          userName,
          style: AppTextstyle.interMedium(
            color: theme.colorScheme.onPrimary,
            fontSize: 14,
          ),
        ),
        20.spaceY,
      ],
    );
  }
}
