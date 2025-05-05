class ImageToImageModel {
  ImageToImageModel({
    required this.generationId,
    required this.prompt,
    required this.presetStyle,
    required this.images,
  });
  late final String generationId;
  late final String prompt;
  late final String presetStyle;
  late final List<Images> images;

  ImageToImageModel.fromJson(Map<String, dynamic> json) {
    generationId = json['generationId'];
    prompt = json['prompt'];
    presetStyle = json['presetStyle'];
    images = List.from(json['images']).map((e) => Images.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['generationId'] = generationId;
    data['prompt'] = prompt;
    data['presetStyle'] = presetStyle;
    data['images'] = images.map((e) => e.toJson()).toList();
    return data;
  }
}

class Images {
  Images({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.creatorEmail,
    required this.username,
    required this.presetStyle,
    required this.prompt,
    required this.createdAt,
  });
  late final String id;
  late final String userId;
  late final String imageUrl;
  late final String creatorEmail;
  late final String username;
  late final String presetStyle;
  late final String prompt;
  late final String createdAt;

  Images.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    imageUrl = json['imageUrl'];
    creatorEmail = json['creatorEmail'];
    username = json['username'];
    presetStyle = json['presetStyle'];
    prompt = json['prompt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['userId'] = userId;
    data['imageUrl'] = imageUrl;
    data['creatorEmail'] = creatorEmail;
    data['username'] = username;
    data['presetStyle'] = presetStyle;
    data['prompt'] = prompt;
    data['createdAt'] = createdAt;
    return data;
  }
}
