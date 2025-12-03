import 'package:Artleap.ai/shared/route_export.dart';

final remoteConfigProvider = Provider<RemoteConfigService>((ref) {
  return RemoteConfigService.instance;
});

final remoteConfigInitializationProvider = FutureProvider<void>((ref) async {
  final remoteConfig = ref.read(remoteConfigProvider);
  await remoteConfig.initialize();
});