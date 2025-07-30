class UserProfileModel {
  final bool success;
  final String message;
  final User user;

  UserProfileModel({
    required this.success,
    required this.message,
    required this.user,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user.toJson(),
    };
  }
}

class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final List<String> favorites;
  final String profilePic;
  final int dailyCredits;
  final bool isSubscribed;
  final List<Images> images;
  final List<dynamic> followers;
  final List<Following> following;
  final String createdAt;
  final int V;
  // New fields from old model
  final DateTime? lastCreditReset;
  final List<String> hiddenNotifications;
  final String? currentSubscription;
  final String subscriptionStatus;
  final String planName;
  final String planType;
  final int totalCredits;
  final int usedImageCredits;
  final int usedPromptCredits;
  final int imageGenerationCredits;
  final int promptGenerationCredits;
  final bool hasActiveTrial;
  final List<dynamic> paymentMethods;
  final bool watermarkEnabled;
  final int? v;

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
    // New fields initialization
    this.lastCreditReset,
    required this.hiddenNotifications,
    this.currentSubscription,
    required this.subscriptionStatus,
    required this.planName,
    required this.planType,
    required this.totalCredits,
    required this.usedImageCredits,
    required this.usedPromptCredits,
    required this.imageGenerationCredits,
    required this.promptGenerationCredits,
    required this.hasActiveTrial,
    required this.paymentMethods,
    required this.watermarkEnabled,
    this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? "",
      username: json['username'] is String ? json['username'] as String : "",
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      favorites: List.castFrom<dynamic, String>(json['favorites'] ?? []),
      profilePic: json['profilePic'] ?? "",
      dailyCredits: json['dailyCredits'] ?? 10,
      isSubscribed: json['isSubscribed'] ?? false,
      images: List.from(json['images'] ?? []).map((e) => Images.fromJson(e ?? {})).toList(),
      followers: List.castFrom<dynamic, dynamic>(json['followers'] ?? []),
      following: List.from(json['following'] ?? []).map((e) => Following.fromJson(e ?? {})).toList(),
      createdAt: json['createdAt'] ?? "",
      V: json['__v'] ?? 0,
      // New fields from old model
      lastCreditReset: json['lastCreditReset'] != null ? DateTime.parse(json['lastCreditReset']) : null,
      hiddenNotifications: List.castFrom<dynamic, String>(json['hiddenNotifications'] ?? []),
      currentSubscription: json['currentSubscription']?.toString(),
      subscriptionStatus: json['subscriptionStatus'] ?? 'none',
      planName: json['planName'] ?? 'Free',
      planType: json['planType'] ?? 'free',
      totalCredits: json['totalCredits'] ?? 10,
      usedImageCredits: json['usedImageCredits'] ?? 0,
      usedPromptCredits: json['usedPromptCredits'] ?? 0,
      imageGenerationCredits: json['imageGenerationCredits'] ?? 0,
      promptGenerationCredits: json['promptGenerationCredits'] ?? 0,
      hasActiveTrial: json['hasActiveTrial'] ?? false,
      paymentMethods: List.castFrom<dynamic, dynamic>(json['paymentMethods'] ?? []),
      watermarkEnabled: json['watermarkEnabled'] ?? true,
      v: json['__v'],
    );
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
    // New fields toJson
    if (lastCreditReset != null) {
      data['lastCreditReset'] = lastCreditReset!.toIso8601String();
    }
    data['hiddenNotifications'] = hiddenNotifications;
    if (currentSubscription != null) {
      data['currentSubscription'] = currentSubscription;
    }
    data['subscriptionStatus'] = subscriptionStatus;
    data['planName'] = planName;
    data['planType'] = planType;
    data['totalCredits'] = totalCredits;
    data['usedImageCredits'] = usedImageCredits;
    data['usedPromptCredits'] = usedPromptCredits;
    data['imageGenerationCredits'] = imageGenerationCredits;
    data['promptGenerationCredits'] = promptGenerationCredits;
    data['hasActiveTrial'] = hasActiveTrial;
    data['paymentMethods'] = paymentMethods;
    data['watermarkEnabled'] = watermarkEnabled;
    if (v != null) {
      data['__v'] = v;
    }
    return data;
  }
}

class Images {
  final String id;
  final String userId;
  final String username;
  final String creatorEmail;
  final String imageUrl;
  final String createdAt;
  final String modelName;
  final String prompt;
  final int V;

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

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      id: json['_id'] ?? "",
      userId: json['userId'] ?? "",
      username: json['username'] is String ? json['username'] as String : "",
      creatorEmail: json['creatorEmail'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
      createdAt: json['createdAt'] ?? "",
      modelName: json['modelName'] ?? "",
      prompt: json['prompt'] ?? "",
      V: json['__v'] ?? 0,
    );
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
  final String id;
  final String username;
  final String email;
  final String password;
  final List<String> favorites;
  final String profilePic;
  final int dailyCredits;
  final bool isSubscribed;
  final List<String> images;
  final List<String> followers;
  final List<dynamic> following;
  final String createdAt;
  final int V;

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

  factory Following.fromJson(Map<String, dynamic> json) {
    return Following(
      id: json['_id'] ?? "",
      username: json['username'] is String ? json['username'] as String : "",
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      favorites: List.castFrom<dynamic, String>(json['favorites'] ?? []),
      profilePic: json['profilePic'] ?? "",
      dailyCredits: json['dailyCredits'] ?? 0,
      isSubscribed: json['isSubscribed'] ?? false,
      images: List.castFrom<dynamic, String>(json['images'] ?? []),
      followers: List.castFrom<dynamic, String>(json['followers'] ?? []),
      following: List.castFrom<dynamic, dynamic>(json['following'] ?? []),
      createdAt: json['createdAt'] ?? "",
      V: json['__v'] ?? 0,
    );
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