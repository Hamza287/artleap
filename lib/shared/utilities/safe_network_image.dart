import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../providers/image_load_provider.dart';

class SafeNetworkImage extends ConsumerWidget {
  final String imageUrl;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final int maxRetryAttempts;
  final Duration retryDelay;

  const SafeNetworkImage({
    super.key,
    required this.imageUrl,
    this.placeholder,
    this.errorWidget,
    this.maxRetryAttempts = 2,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imageLoadStateProvider(imageUrl));
    final notifier = ref.read(imageLoadStateProvider(imageUrl).notifier);

    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: placeholder ?? (_, __) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) {
        if (error is DioException &&
            error.error.toString().contains('Connection closed while receiving data')) {
          return _ConnectionRetryWidget(
            imageUrl: url,
            state: state,
            onRetry: notifier.retryLoad,
            maxRetryAttempts: maxRetryAttempts,
          );
        }
        return errorWidget?.call(context, url, error) ??
            const Icon(Icons.error_outline, color: Colors.red);
      },
      httpHeaders: const {
        'Accept': 'image/*',
        'Cache-Control': 'max-age=604800',
      },
    );
  }
}

class _ConnectionRetryWidget extends StatelessWidget {
  final String imageUrl;
  final ImageLoadState state;
  final VoidCallback onRetry;
  final int maxRetryAttempts;

  const _ConnectionRetryWidget({
    required this.imageUrl,
    required this.state,
    required this.onRetry,
    required this.maxRetryAttempts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.signal_wifi_off, color: Colors.orange),
        const SizedBox(height: 8),
        Text(
          'Connection interrupted',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (state.attemptCount < maxRetryAttempts) ...[
          const SizedBox(height: 8),
          state.isLoading
              ? const CircularProgressIndicator(strokeWidth: 2)
              : TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ],
    );
  }
}