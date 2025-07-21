class UserProfileModel {
  UserProfileModel({
    required this.success,
    required this.message,
    required this.user,
  });
  late final bool success;
  late final String message;
  late final User user;

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message'] ?? '';
    user = User.fromJson(json['user'] ?? {});
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['user'] = user.toJson();
    return data;
  }
}

class User {
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.favorites,
    required this.profilePic,
    required this.dailyCredits,
    required this.isSubscribed,
    required this.images,
    required this.followers,
    required this.following,
    required this.createdAt,
    required this.V,
  });
  late final String id;
  late final String username;
  late final String email;
  late final String password;
  late final List<String> favorites;
  late final String profilePic;
  late final int dailyCredits;
  late final bool isSubscribed;
  late final List<Images> images;
  late final List<dynamic> followers;
  late final List<Following> following;
  late final String createdAt;
  late final int V;

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? "";
    username = json['username'] is String ? json['username'] as String : "";
    email = json['email'] ?? "";
    password = json['password'] ?? "";
    favorites = List.castFrom<dynamic, String>(json['favorites'] ?? []);
    profilePic = json['profilePic'] ?? "";
    dailyCredits = json['dailyCredits'] ?? 150;
    isSubscribed = json['isSubscribed'] ?? false;
    images = List.from(json['images'] ?? []).map((e) => Images.fromJson(e ?? {})).toList();
    followers = List.castFrom<dynamic, dynamic>(json['followers'] ?? []);
    following = List.from(json['following'] ?? []).map((e) => Following.fromJson(e ?? {})).toList();
    createdAt = json['createdAt'] ?? "";
    V = json['__v'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['favorites'] = favorites;
    data['profilePic'] = profilePic;
    data['dailyCredits'] = dailyCredits;
    data['isSubscribed'] = isSubscribed;
    data['images'] = images.map((e) => e.toJson()).toList();
    data['followers'] = followers;
    data['following'] = following.map((e) => e.toJson()).toList();
    data['createdAt'] = createdAt;
    data['__v'] = V;
    return data;
  }
}

class Images {
  Images({
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

  Images.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? "";
    userId = json['userId'] ?? "";
    username = json['username'] is String ? json['username'] as String : "";
    creatorEmail = json['creatorEmail'] ?? "";
    imageUrl = json['imageUrl'] ?? "";
    createdAt = json['createdAt'] ?? "";
    modelName = json['modelName'] ?? "";
    prompt = json['prompt'] ?? "";
    V = json['__v'] ?? 0;
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

class Following {
  Following({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.favorites,
    required this.profilePic,
    required this.dailyCredits,
    required this.isSubscribed,
    required this.images,
    required this.followers,
    required this.following,
    required this.createdAt,
    required this.V,
  });
  late final String id;
  late final String username;
  late final String email;
  late final String password;
  late final List<String> favorites;
  late final String profilePic;
  late final int dailyCredits;
  late final bool isSubscribed;
  late final List<String> images;
  late final List<String> followers;
  late final List<dynamic> following;
  late final String createdAt;
  late final int V;

  Following.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? "";
    username = json['username'] is String ? json['username'] as String : "";
    email = json['email'] ?? "";
    password = json['password'] ?? "";
    favorites = List.castFrom<dynamic, String>(json['favorites'] ?? []);
    profilePic = json['profilePic'] ?? "";
    dailyCredits = json['dailyCredits'] ?? 0;
    isSubscribed = json['isSubscribed'] ?? false;
    images = List.castFrom<dynamic, String>(json['images'] ?? []);
    followers = List.castFrom<dynamic, String>(json['followers'] ?? []);
    following = List.castFrom<dynamic, dynamic>(json['following'] ?? []);
    createdAt = json['createdAt'] ?? "";
    V = json['__v'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['favorites'] = favorites;
    data['profilePic'] = profilePic;
    data['dailyCredits'] = dailyCredits;
    data['isSubscribed'] = isSubscribed;
    data['images'] = images;
    data['followers'] = followers;
    data['following'] = following;
    data['createdAt'] = createdAt;
    data['__v'] = V;
    return data;
  }
}