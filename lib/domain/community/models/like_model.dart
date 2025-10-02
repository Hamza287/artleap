class LikeModel {
  final String id;
  final String image;
  final String user;
  final DateTime createdAt;
  final String? userName;
  final String? userAvatar;

  LikeModel({
    required this.id,
    required this.image,
    required this.user,
    required this.createdAt,
    this.userName,
    this.userAvatar,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] is Map ? json['user'] : {};

    return LikeModel(
      id: json['_id'] ?? json['id'] ?? '',
      image: json['image'] ?? '',
      user: json['user'] is String ? json['user'] : userData['_id'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      userName: userData['username'] ?? json['userName'] ?? '',
      userAvatar: userData['profilePic'] ?? json['userAvatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'user': user,
    };
  }
}