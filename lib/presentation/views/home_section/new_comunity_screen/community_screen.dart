import 'package:Artleap.ai/shared/route_export.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  static const String routeName = 'community_screen';
  const CommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final ScrollController _scrollController = ScrollController();
  final _throttleDuration = const Duration(milliseconds: 200);
  DateTime? _lastScrollTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favouriteProvider).getUserFav(UserData.ins.userId ?? "");
      ref.read(userProfileProvider.notifier).updateUserCredits();
      ref.read(homeScreenProvider).getUserInfo();
    });

    _scrollController.addListener(() {
      final now = DateTime.now();
      if (_lastScrollTime != null &&
          now.difference(_lastScrollTime!) < _throttleDuration) {
        return;
      }
      _lastScrollTime = now;

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300 &&
          !ref.read(homeScreenProvider).isLoadingMore) {
        ref.read(homeScreenProvider).loadMoreImages();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        bool shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            title: Text(
              'Confirm Exit',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            content: Text(
              'Are you sure you want to leave?',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                    'No',
                    style: AppTextstyle.interBold(color: theme.colorScheme.primary)
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                    'Yes',
                    style: AppTextstyle.interBold(color: theme.colorScheme.primary)
                ),
              ),
            ],
          ),
        ) ?? false;
        if (shouldExit) SystemNavigator.pop();
      },
      child: AppBackgroundWidget(
        widget: const CommunityFeedWidget(),
      ),
    );
  }
}