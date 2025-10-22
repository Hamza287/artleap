class ReelModel {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String creatorName;
  final String creatorAvatar;
  final String caption;
  final int likes;
  final int comments;
  final int shares;
  final String musicName;
  final Duration duration;
  final bool isLiked;

  const ReelModel({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.creatorName,
    required this.creatorAvatar,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.musicName,
    required this.duration,
    this.isLiked = false,
  });

  ReelModel copyWith({
    String? id,
    String? videoUrl,
    String? thumbnailUrl,
    String? creatorName,
    String? creatorAvatar,
    String? caption,
    int? likes,
    int? comments,
    int? shares,
    String? musicName,
    Duration? duration,
    bool? isLiked,
  }) {
    return ReelModel(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      creatorName: creatorName ?? this.creatorName,
      creatorAvatar: creatorAvatar ?? this.creatorAvatar,
      caption: caption ?? this.caption,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      musicName: musicName ?? this.musicName,
      duration: duration ?? this.duration,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}