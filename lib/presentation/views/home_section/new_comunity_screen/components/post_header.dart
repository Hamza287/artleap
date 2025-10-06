import 'dart:typed_data';
import 'package:Artleap.ai/providers/favrourite_provider.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:Artleap.ai/shared/navigation/screen_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../../profile_screen/other_user_profile_screen.dart';
import '../../see_picture_section/see_pic_bottom_sheets/report_pic_bottom_sheet.dart';

class PostHeader extends ConsumerStatefulWidget {
  final dynamic image;
  final String? imageId;
  final String? profilePic;
  final String? imageUrl;
  final Uint8List? uint8ListImage;
  final String? currentUserId;
  final String? otherUserId;

  const PostHeader({
    super.key,
    required this.image,
    this.imageId,
    this.imageUrl,
    this.uint8ListImage,
    this.currentUserId,
    this.otherUserId,
    required this.profilePic,
  });

  @override
  ConsumerState<PostHeader> createState() => _PostHeaderState();
}

class _PostHeaderState extends ConsumerState<PostHeader> {
  late dynamic _filteredImage;
  late String? _filteredImageUrl;
  late String? _filteredImageId;
  late String? _filteredOtherUserId;

  @override
  void initState() {
    super.initState();
    _filterImageData();
  }

  @override
  void didUpdateWidget(PostHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image ||
        oldWidget.imageUrl != widget.imageUrl ||
        oldWidget.imageId != widget.imageId ||
        oldWidget.otherUserId != widget.otherUserId) {
      _filterImageData();
    }
  }

  void _filterImageData() {
    _filteredImage = widget.image;
    _filteredImageUrl =
        widget.imageUrl ?? widget.image?.imageUrl ?? widget.image?.url;
    _filteredImageId =
        widget.imageId ?? widget.image?.id ?? widget.image?.imageId;
    _filteredOtherUserId =
        widget.otherUserId ?? widget.image?.userId ?? widget.image?.creatorId;
  }

  String _getUserInitials(dynamic image) {
    final processedImage = image ?? _filteredImage;
    if (processedImage.username != null &&
        processedImage.username!.isNotEmpty) {
      final names = processedImage.username!.split(' ');
      if (names.length > 1) {
        return '${names[0][0]}${names[1][0]}'.toUpperCase();
      }
      return processedImage.username!.substring(0, 1).toUpperCase();
    }
    if (processedImage.userEmail != null &&
        processedImage.userEmail!.isNotEmpty) {
      return processedImage.userEmail!.substring(0, 1).toUpperCase();
    }
    return 'A';
  }

  String _getDisplayName(dynamic image) {
    final processedImage = image ?? _filteredImage;
    if (processedImage.username != null &&
        processedImage.username!.isNotEmpty) {
      return processedImage.username!;
    }
    if (processedImage.userEmail != null &&
        processedImage.userEmail!.isNotEmpty) {
      return processedImage.userEmail!.split('@')[0];
    }
    return 'Anonymous Artist';
  }

  String _getTimeAgo(dynamic image) {
    final processedImage = image ?? _filteredImage;

    if (processedImage.createdAt == null) return 'Recently';

    // parse the string to DateTime
    final createdAt = DateTime.parse(processedImage.createdAt).toLocal();
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago';
    } else {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    }
  }

  void _handleDownload(BuildContext context) {
    final downloadUrl = _filteredImageUrl;
    final downloadUint8List = widget.uint8ListImage;
    ref
        .read(favProvider)
        .downloadImage(downloadUrl!, uint8ListObject: downloadUint8List);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Downloading image...'),
        backgroundColor: AppColors.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleShare(BuildContext context) async {
    final shareUrl = _filteredImageUrl;

    if (shareUrl != null) {
      await Share.shareUri(Uri.parse(shareUrl));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Unable to share image'),
          backgroundColor: AppColors.errorColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _handleReport(BuildContext context) {
    final reportImageId = _filteredImageId;
    final reportCreatorId = _filteredOtherUserId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReportImageBottomSheet(
        imageId: reportImageId,
        creatorId: reportCreatorId,
      ),
    );
  }

  void _handleMoreOptions(String value, BuildContext context) {
    switch (value) {
      case 'download':
        _handleDownload(context);
        break;
      case 'share':
        _handleShare(context);
        break;
      case 'report':
        _handleReport(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          InkWell(
            onTap: _filteredOtherUserId != null
                ? () {
                    Navigation.pushNamed(
                      OtherUserProfileScreen.routeName,
                      arguments: OtherUserProfileParams(
                        userId: _filteredOtherUserId!,
                        profileName: _getDisplayName(_filteredImage),
                      ),
                    );
                  }
                : null,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.darkBlue, AppColors.pinkColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: widget.profilePic != null
                    ? Image.network(
                        widget.profilePic!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Text(
                            _getUserInitials(_filteredImage),
                            style: AppTextstyle.interBold(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          _getUserInitials(_filteredImage),
                          style: AppTextstyle.interBold(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: _filteredOtherUserId != null
                      ? () {
                          Navigation.pushNamed(
                            OtherUserProfileScreen.routeName,
                            arguments: OtherUserProfileParams(
                              userId: _filteredOtherUserId!,
                              profileName: _getDisplayName(_filteredImage),
                            ),
                          );
                        }
                      : null,
                  child: Text(
                    _getDisplayName(_filteredImage),
                    style: AppTextstyle.interBold(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'AI Art Creator • ${_getTimeAgo(_filteredImage)}',
                  style: AppTextstyle.interRegular(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.more_horiz,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ),
            onSelected: (value) => _handleMoreOptions(value, context),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(
                      Icons.download_outlined,
                      size: 20,
                      color: AppColors.darkBlue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Download',
                      style: AppTextstyle.interMedium(
                        color: AppColors.darkBlue,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(
                      Icons.share_outlined,
                      size: 20,
                      color: AppColors.darkBlue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Share',
                      style: AppTextstyle.interMedium(
                        color: AppColors.darkBlue,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      size: 20,
                      color: AppColors.redColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Report',
                      style: AppTextstyle.interMedium(
                        color: AppColors.redColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
