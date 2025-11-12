import 'package:flutter_riverpod/flutter_riverpod.dart';

final emptyStateProvider = StateProvider<bool>((ref) => false);
final loadingStateProvider = StateProvider<bool>((ref) => false);
final errorStateProvider = StateProvider<String?>((ref) => null);