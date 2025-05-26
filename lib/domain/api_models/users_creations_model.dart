class UsersCreations {
  UsersCreations({
    required this.success,
    required this.message,
    required this.currentPage,
    required this.totalPages,
    required this.totalImages,
    required this.images,
  });
  late final bool success;
  late final String message;
  late final int currentPage;
  late final int totalPages;
  late final int totalImages;
  late final List<Images> images;

  UsersCreations.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalImages = json['totalImages'];
    images = List.from(json['images']).map((e) => Images.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['totalImages'] = totalImages;
    data['images'] = images.map((e) => e.toJson()).toList();
    return data;
  }
}

class Images {
  Images({
    required this.id,
    required this.userId,
    required this.username,
    required this.imageUrl,
    required this.createdAt,
    required this.modelName,
    required this.userEmail,
    required this.prompt,
    required this.V,
  });
  late final String id;
  late final String userId;
  late final String username;
  late final String imageUrl;
  late final String createdAt;
  late final String modelName;
  late final String userEmail;
  late final String prompt;
  late final int V;

  Images.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    username = json['username'];
    imageUrl = json['imageUrl'];
    createdAt = json['createdAt'];
    modelName = json['modelName'] ?? "";
    userEmail = json["creatorEmail"] ?? "";
    prompt = json['prompt'];
    V = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['userId'] = userId;
    data['username'] = username;
    data['imageUrl'] = imageUrl;
    data['createdAt'] = createdAt;
    data['modelName'] = modelName;
    data['prompt'] = prompt;
    data['__v'] = V;
    return data;
  }
}
