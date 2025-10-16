import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/image_actions_provider.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class OthersTextfield extends ConsumerStatefulWidget {
  const OthersTextfield({super.key});

  @override
  ConsumerState<OthersTextfield> createState() => _OthersTextfieldState();
}

class _OthersTextfieldState extends ConsumerState<OthersTextfield> {
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textController = ref.watch(imageActionsProvider).othersTextController;
    final textLength = textController.text.length;
    final isNearLimit = textLength > 450;
    final isAtLimit = textLength >= 500;

    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _hasFocus
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withOpacity(0.2),
          width: _hasFocus ? 2 : 1.5,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              focusNode: _focusNode,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              maxLength: 500,
              style: AppTextstyle.interMedium(
                color: theme.colorScheme.onSurface,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16),
                border: InputBorder.none,
                hintText: "Describe the specific issue you encountered...",
                hintStyle: AppTextstyle.interMedium(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                  fontSize: 16,
                ),
                counterText: "",
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: textLength / 500,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isNearLimit
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Be specific and descriptive",
                      style: AppTextstyle.interMedium(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "$textLength/500",
                      style: AppTextstyle.interMedium(
                        color: isAtLimit
                            ? theme.colorScheme.error
                            : isNearLimit
                            ? theme.colorScheme.error.withOpacity(0.8)
                            : theme.colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: isNearLimit ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}