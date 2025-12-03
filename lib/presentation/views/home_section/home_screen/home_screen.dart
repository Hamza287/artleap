import 'package:Artleap.ai/ads/banner_ads/banner_ad_widget.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider).updateUserCredits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider).userProfileData?.user;
    final shouldRefresh = ref.watch(refreshProvider);
    ref.watch(bottomNavBarProvider);
    final theme = Theme.of(context);

    if (shouldRefresh && UserData.ins.userId != null) {
      Future.microtask(() {
        ref.read(userProfileProvider).getUserProfileData(UserData.ins.userId!);
      });
    }
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      key: _scaffoldKey,
      drawer: ProfileDrawer(
        profileImage: userProfile?.profilePic ?? '',
        userName: userProfile?.username ?? 'Guest',
        userEmail: userProfile?.email ?? 'guest@example.com',
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeScreenTopBar(
              onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeScreenSearchBar(),
                    const SizedBox(height: 20),
                    const PortraitOptions(),
                    const SizedBox(height: 20),
                    AiFiltersGrid(),
                    const SizedBox(height: 24),
                    const TrendingStyles(),
                    const SizedBox(height: 24),
                    const PromptTemplates(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}