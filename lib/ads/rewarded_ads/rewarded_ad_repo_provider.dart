import 'package:Artleap.ai/ads/rewarded_ads/rewarded_ad_repo.dart';
import 'package:Artleap.ai/ads/rewarded_ads/rewarded_ad_repo_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rewardedAdRepoProvider = Provider<RewardedAdRepo>((ref) {
  return RewardedAdRepoImpl();
});