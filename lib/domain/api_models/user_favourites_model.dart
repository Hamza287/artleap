class UserFavouritesModel {
  UserFavouritesModel({
    required this.success,
    required this.favorites,
  });
  late final bool success;
  late final List<Favorites> favorites;

  UserFavouritesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    favorites =
        List.from(json['favorites']).map((e) => Favorites.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['favorites'] = favorites.map((e) => e.toJson()).toList();
    return data;
  }
}

class Favorites {
  Favorites({
    required this.id,
    required this.userId,
    required this.username,
    required this.creatorEmail,
    required this.imageUrl,
    required this.createdAt,
    required this.modelName,
    required this.prompt,
    required this.V,
  });
  late final String id;
  late final String userId;
  late final String username;
  late final String creatorEmail;
  late final String imageUrl;
  late final String createdAt;
  late final String modelName;
  late final String prompt;
  late final int V;

  Favorites.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    username = json['username'];
    creatorEmail = json['creatorEmail'];
    imageUrl = json['imageUrl'];
    createdAt = json['createdAt'];
    modelName = json['modelName'];
    prompt = json['prompt'];
    V = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['userId'] = userId;
    data['username'] = username;
    data['creatorEmail'] = creatorEmail;
    data['imageUrl'] = imageUrl;
    data['createdAt'] = createdAt;
    data['modelName'] = modelName;
    data['prompt'] = prompt;
    data['__v'] = V;
    return data;
  }
}
