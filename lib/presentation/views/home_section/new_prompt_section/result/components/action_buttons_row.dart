import 'package:Artleap.ai/presentation/views/common/dialog_box/delete_alert_dialog.dart';
import 'package:Artleap.ai/presentation/views/common/dialog_box/set_privacy_dialog.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart'
    hide ImagePrivacy;
import 'package:Artleap.ai/providers/add_image_to_fav_provider.dart';
import 'package:Artleap.ai/providers/favrourite_provider.dart';
import 'package:Artleap.ai/providers/image_actions_provider.dart';
import 'package:Artleap.ai/presentation/firebase_analyitcs_singleton/firebase_analtics_singleton.dart';
import 'package:Artleap.ai/providers/image_privacy_provider.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:share_plus/share_plus.dart';

class ActionButtonsRow extends ConsumerWidget {
  final WidgetRef ref;
  const ActionButtonsRow({super.key, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final generatedImages = ref.watch(generateImageProvider).generatedImage;
    final generatedTextToImageData =
        ref.watch(generateImageProvider).generatedTextToImageData;
    final isLoading = ref.watch(generateImageProvider).isGenerateImageLoading;

    final currentImageData =
        _getCurrentImageData(generatedImages, generatedTextToImageData);

    if (isLoading || currentImageData == null) {
      return _buildLoadingButtons(theme);
    }

    return _buildActionButtons(context, ref, currentImageData, theme);
  }

  dynamic _getCurrentImageData(
      List<dynamic> generatedImages, List<dynamic> generatedTextToImageData) {
    if (generatedTextToImageData.isNotEmpty) {
      return generatedTextToImageData.first;
    } else if (generatedImages.isNotEmpty) {
      return generatedImages.first;
    }
    return null;
  }

  Widget _buildLoadingButtons(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) => _buildLoadingButton(theme)),
      ),
    );
  }

  Widget _buildLoadingButton(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 40,
          height: 8,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
      BuildContext context, WidgetRef ref, dynamic imageData, ThemeData theme) {
    final isCurrentUser = _isCurrentUserImage(imageData);
    final imageId = imageData.id ?? '';
    final imageUrl = imageData.imageUrl ?? '';
    final privacy = imageData.privacy ?? 'public';

    final List<Widget> buttons = [
      _buildFavoriteButton(context, ref, imageId, theme),
      _buildDownloadButton(context, ref, imageUrl, theme),
      _buildShareButton(context, ref, imageUrl, theme),
    ];

    if (isCurrentUser) {
      buttons.addAll([
        // _buildPrivacyButton(context, ref, imageId, privacy, theme),
        _buildDeleteButton(context, ref, imageId, theme),
      ]);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: buttons,
      ),
    );
  }

  bool _isCurrentUserImage(dynamic imageData) {
    return true;
  }

  Widget _buildFavoriteButton(
      BuildContext context, WidgetRef ref, String imageId, ThemeData theme) {
    final isLiked = ref.watch(favouriteProvider).usersFavourites != null
        ? ref
            .watch(favouriteProvider)
            .usersFavourites!
            .favorites
            .any((img) => img.id == imageId)
        : false;

    return _buildActionButton(
      icon: Icons.favorite_rounded,
      label: 'Favorite',
      color: Colors.red,
      theme: theme,
      isLikeButton: true,
      isLiked: isLiked,
      onTap: () async {
        AnalyticsService.instance
            .logButtonClick(buttonName: 'Favorite button event');
        try {
          final currentUserId = UserData.ins.userId ?? '';
          if (currentUserId.isNotEmpty && imageId.isNotEmpty) {
            await ref
                .read(favouriteProvider)
                .addToFavourite(currentUserId, imageId);
          }
        } catch (e) {
          // Handle error
        }
      },
    );
  }

  Widget _buildDownloadButton(
      BuildContext context, WidgetRef ref, String imageUrl, ThemeData theme) {
    final isLoading = ref.watch(favProvider).isDownloading == true;

    return _buildActionButton(
      icon: Icons.download_rounded,
      label: 'Download',
      color: Colors.green,
      theme: theme,
      isLoading: isLoading,
      onTap: () {
        AnalyticsService.instance
            .logButtonClick(buttonName: 'download button event');
        ref.read(favProvider).downloadImage(imageUrl);
      },
    );
  }

  Widget _buildShareButton(
      BuildContext context, WidgetRef ref, String imageUrl, ThemeData theme) {
    return _buildActionButton(
      icon: Icons.share_rounded,
      label: 'Share',
      color: Colors.blue,
      theme: theme,
      onTap: () async {
        AnalyticsService.instance
            .logButtonClick(buttonName: 'share button event');
        await Share.shareUri(Uri.parse(imageUrl));
      },
    );
  }

  Widget _buildPrivacyButton(BuildContext context, WidgetRef ref,
      String imageId, String privacy, ThemeData theme) {
    return _buildActionButton(
      icon: Icons.lock_rounded,
      label: 'Privacy',
      color: Colors.purple,
      theme: theme,
      onTap: () async {
        AnalyticsService.instance
            .logButtonClick(buttonName: 'privacy button event');
        final currentUserId = UserData.ins.userId ?? '';
        if (currentUserId.isNotEmpty) {
          await showDialog<ImagePrivacy>(
            context: context,
            builder: (context) => SetPrivacyDialog(
              imageId: imageId,
              userId: currentUserId,
              initialPrivacyString: privacy,
            ),
          );
        }
      },
    );
  }

  Widget _buildDeleteButton(
      BuildContext context, WidgetRef ref, String imageId, ThemeData theme) {
    final isLoading = ref.watch(imageActionsProvider).isDeleting;

    return _buildActionButton(
      icon: Icons.delete_rounded,
      label: 'Delete',
      color: Colors.red,
      theme: theme,
      isLoading: isLoading,
      onTap: () {
        AnalyticsService.instance
            .logButtonClick(buttonName: 'delete button event');
        showDialog(
          context: context,
          builder: (context) => DeleteAlertDialog(imageId: imageId),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required ThemeData theme,
    bool isLoading = false,
    bool isLiked = false,
    bool isLikeButton = false,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: label,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(25),
                child: isLoading
                    ? Center(
                        child: LoadingAnimationWidget.threeArchedCircle(
                          color: color,
                          size: 24,
                        ),
                      )
                    : isLikeButton
                        ? Center(
                            child: LikeButton(
                              size: 24,
                              isLiked: isLiked,
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  isLiked
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color:
                                      isLiked ? color : color.withOpacity(0.6),
                                  size: 24,
                                );
                              },
                              bubblesColor: BubblesColor(
                                dotPrimaryColor: color,
                                dotSecondaryColor: color,
                              ),
                              onTap: (isLiked) async {
                                onTap();
                                return !isLiked;
                              },
                            ),
                          )
                        : Center(
                            child: Icon(
                              icon,
                              color: color,
                              size: 24,
                            ),
                          ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
