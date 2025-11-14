import 'package:Artleap.ai/shared/constants/app_static_data.dart';
import 'bottom_sheet_widget.dart/row_buttons.dart';
import 'others_bottom_sheet.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class ReportImageBottomSheet extends ConsumerWidget {
  final String? imageId;
  final String? creatorId;

  const ReportImageBottomSheet({super.key, this.imageId, this.creatorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final imageActions = ref.watch(imageActionsProvider);

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

    void _openOthersSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return OthersBottomSheet(
            imageId: imageId,
            creatorId: creatorId,
          );
        },
      );
    }

    void _selectOption(Map<String, dynamic> option) {
      ref.read(imageActionsProvider).reportReason = option["title"];
      ref.read(imageActionsProvider).reportReasonId = option["id"];

      if (option["id"] == "5") {
        Future.delayed(const Duration(milliseconds: 200), () {
          _openOthersSheet();
        });
      }
    }

    return SafeArea(
      child: Container(
        height: screenHeight * 0.75,
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
                    "Report Content",
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
                        color: theme.colorScheme.surfaceContainerHighest,
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
                                  Icons.info_outline_rounded,
                                  color: theme.colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Help us keep the community safe by reporting inappropriate content",
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
                            "Select a reason",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...reportOptions.map((option) {
                            return _buildReportOption(
                              option,
                              theme,
                              ref,
                              _selectOption,
                            );
                          }).toList(),
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
            if (!imageActions.isReporting)
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
                child: RowButtons(
                  onSendPress: imageActions.reportReason == null
                      ? null
                      : imageActions.reportReasonId == "5"
                      ? _openOthersSheet
                      : _handleReport,
                  onCancelPress: _closeSheet,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportOption(
      Map<String, dynamic> option,
      ThemeData theme,
      WidgetRef ref,
      Function(Map<String, dynamic>) onSelect,
      ) {
    final imageActions = ref.watch(imageActionsProvider);
    final isSelected = imageActions.reportReason == option["title"];
    final isOthersOption = option["id"] == "5";

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: imageActions.isReporting
              ? null
              : () => onSelect(option),
          borderRadius: BorderRadius.circular(12),
          child: Opacity(
            opacity: imageActions.isReporting ? 0.6 : 1.0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withOpacity(0.3),
                        width: 2,
                      ),
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: theme.colorScheme.onPrimary,
                    )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      option["title"],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isOthersOption)
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}