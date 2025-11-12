import 'package:Artleap.ai/shared/utilities/privacy_settings_content.dart';
import 'package:flutter/material.dart';
import '../../providers/image_privacy_provider.dart';
import 'base_dialog.dart';

enum DialogType {
  confirmDelete,
  cancelSubscription,
  success,
  warning,
  info,
  premium,
  privacy,
  logout,
  custom
}

class DialogService {
  static Future<T?> showAppDialog<T>({
    required BuildContext context,
    required DialogType type,
    String title = '',
    String message = '',
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon,
    Color? iconColor,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Widget? customContent,
    Map<String, dynamic>? extraData,
  }) {
    final theme = Theme.of(context);

    return showDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (context) => BaseDialog(
        type: type,
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        icon: icon,
        iconColor: iconColor,
        onConfirm: onConfirm,
        onCancel: onCancel,
        customContent: customContent,
        extraData: extraData,
      ),
    );
  }

  static Future<bool?> confirmDelete({
    required BuildContext context,
    required String itemName,
    VoidCallback? onDelete,
  }) {
    return showAppDialog<bool>(
      context: context,
      type: DialogType.confirmDelete,
      title: 'Delete $itemName?',
      message: 'This action cannot be undone.',
      confirmText: 'Delete',
      onConfirm: onDelete,
      icon: Icons.delete_outline,
      iconColor: Theme.of(context).colorScheme.error,
    );
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
    String title = 'Success!',
  }) {
    showAppDialog(
      context: context,
      type: DialogType.success,
      title: title,
      message: message,
      confirmText: 'OK',
      icon: Icons.check_circle,
      iconColor: Colors.green,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    String title = 'Warning',
  }) {
    showAppDialog(
      context: context,
      type: DialogType.warning,
      title: title,
      message: message,
      confirmText: 'OK',
      icon: Icons.warning,
      iconColor: Colors.orange,
    );
  }

  static void showPremiumUpgrade({
    required BuildContext context,
    String? featureName,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    showAppDialog(
      context: context,
      type: DialogType.premium,
      title: 'Premium Feature',
      message: featureName ?? 'Upgrade to unlock this feature',
      confirmText: 'Upgrade',
      cancelText: 'Not Now',
      icon: Icons.workspace_premium,
      iconColor: Colors.amber,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  static Future<ImagePrivacy?> showPrivacyDialog({
    required BuildContext context,
    required String imageId,
    required String userId,
    required ImagePrivacy initialPrivacy,
  }) {
    return showAppDialog<ImagePrivacy>(
      context: context,
      type: DialogType.privacy,
      title: 'Privacy Settings',
      customContent: PrivacySettingsContent(
        imageId: imageId,
        userId: userId,
        initialPrivacy: initialPrivacy,
      ),
    );
  }
}