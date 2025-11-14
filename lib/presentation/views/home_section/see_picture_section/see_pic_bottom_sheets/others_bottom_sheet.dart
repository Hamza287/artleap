import 'bottom_sheet_widget.dart/common_button.dart';
import 'bottom_sheet_widget.dart/other_textfield.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class OthersBottomSheet extends ConsumerWidget {
  final String? imageId;
  final String? creatorId;

  const OthersBottomSheet({
    super.key,
    this.imageId,
    this.creatorId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final imageActions = ref.watch(imageActionsProvider);
    final text = ref.watch(imageActionsProvider.select((value) => value.othersTextController.text));
    final isEnabled = text.isNotEmpty && !imageActions.isReporting;

    void _closeSheet() {
      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
      }
    }

    void _handleReportCompletion() {
      if (imageActions.shouldCloseSheets) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _closeSheet();
        });
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleReportCompletion();
    });

    Future<void> _handleReport() async {
      await ref.read(imageActionsProvider).reportImage(
        imageId!,
        creatorId!,
      );
    }

    return SafeArea(
      child: Container(
        height: screenHeight * 0.7,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Additional Details",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (!imageActions.isReporting)
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: _closeSheet,
                        icon: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  if (imageActions.isReporting)
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            if (imageActions.isReporting)
              const LinearProgressIndicator(),

            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: imageActions.isReporting
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.description_rounded,
                                  color: theme.colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Please provide additional details about your report to help us understand the issue better",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Describe the issue",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Provide specific details about what you found inappropriate",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const OthersTextfield(),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Be specific and descriptive",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                              Consumer(
                                builder: (context, ref, child) {
                                  final text = ref.watch(imageActionsProvider.select((value) => value.othersTextController.text));
                                  return Text(
                                    "${text.length}/500",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: text.length > 450
                                          ? theme.colorScheme.error
                                          : theme.colorScheme.onSurface.withOpacity(0.5),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),

                  if (imageActions.isReporting)
                    Container(
                      color: theme.colorScheme.surface.withOpacity(0.7),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Submitting report...",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                  ),
                ),
              ),
              child: ReportCommonButton(
                title: "Submit Report",
                onpress: isEnabled ? _handleReport : null,
                backgroundColor: isEnabled
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
                textColor: isEnabled
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
                icon: Icons.flag_rounded,
                iconColor: isEnabled
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
                height: 50,
                showShadow: isEnabled,
                isLoading: imageActions.isReporting,
              ),
            ),
          ],
        ),
      ),
    );
  }
}