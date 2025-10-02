class CommentModel {
  final String id;
  final String image;
  final String user;
  final String userName;
  final String userAvatar;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  CommentModel({
    required this.id,
    required this.image,
    required this.user,
    required this.userName,
    required this.userAvatar,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] is Map ? json['user'] : {};
    return CommentModel(
      id: json['_id'] ?? json['id'] ?? '',
      image: json['image'] ?? '',
      user: json['user'] is String ? json['user'] : userData['_id'] ?? '',
      userName: userData['username'] ?? json['userName'] ?? '',
      userAvatar: userData['profilePic'] ?? json['userAvatar'] ?? '',
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'user': user,
      'comment': comment,
    };
  }
}