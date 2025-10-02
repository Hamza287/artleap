class SaveModel {
  final String id;
  final String image;
  final String user;
  final DateTime createdAt;
  final Map<String, dynamic>? imageData;

  SaveModel({
    required this.id,
    required this.image,
    required this.user,
    required this.createdAt,
    this.imageData,
  });

  factory SaveModel.fromJson(Map<String, dynamic> json) {
    return SaveModel(
      id: json['_id'] ?? json['id'] ?? '',
      image: json['image'] is String ? json['image'] : json['image']?['_id'] ?? '',
      user: json['user'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      imageData: json['image'] is Map ? json['image'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'user': user,
    };
  }
}