import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class RowButtons extends ConsumerWidget {
  final VoidCallback? onSendPress;
  final VoidCallback? onCancelPress;
  const RowButtons({super.key, this.onSendPress, this.onCancelPress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onCancelPress,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: onSendPress == null
                    ? null
                    : LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                color: onSendPress == null
                    ? theme.colorScheme.surfaceVariant
                    : null,
                boxShadow: onSendPress == null
                    ? null
                    : [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onSendPress,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.flag_rounded,
                          size: 18,
                          color: onSendPress == null
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onPrimary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Report",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: onSendPress == null
                                ? theme.colorScheme.onSurfaceVariant
                                : theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}