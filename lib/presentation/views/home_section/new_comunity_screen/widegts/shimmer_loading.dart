import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shimmer user info
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: theme.colorScheme.surfaceContainerHighest,
                      highlightColor: theme.colorScheme.surface,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: theme.colorScheme.surfaceContainerHighest,
                            highlightColor: theme.colorScheme.surface,
                            child: Container(
                              height: 16,
                              width: 120,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Shimmer.fromColors(
                            baseColor: theme.colorScheme.surfaceContainerHighest,
                            highlightColor: theme.colorScheme.surface,
                            child: Container(
                              height: 12,
                              width: 80,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Shimmer image
              Shimmer.fromColors(
                baseColor: theme.colorScheme.surfaceContainerHighest,
                highlightColor: theme.colorScheme.surface,
                child: Container(
                  height: 400,
                  width: double.infinity,
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
              ),

              // Shimmer buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: Shimmer.fromColors(
                  baseColor: theme.colorScheme.surfaceContainerHighest,
                  highlightColor: theme.colorScheme.surface,
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}