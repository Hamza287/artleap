class Images {
  final String id;
  final String imageUrl;
  final String prompt;
  final String presetStyle;
  final String createdAt;
  final String? privacy;

  // Optional fields for different use cases
  final String? userId;
  final String? creatorEmail;
  final String? username;
  final String? modelName;
  final String? generationId;
  final int? v;

  Images({
    required this.id,
    required this.imageUrl,
    required this.prompt,
    required this.presetStyle,
    required this.createdAt,
    this.privacy = 'public',
    this.userId,
    this.creatorEmail,
    this.username,
    this.modelName,
    this.generationId,
    this.v,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      id: json['_id'] ?? json['id'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
      prompt: json['prompt'] ?? "",
      presetStyle: json['presetStyle'] ?? "",
      createdAt: json['createdAt'] ?? "",
      privacy: json['privacy'] ?? 'public',
      userId: json['userId'],
      creatorEmail: json['creatorEmail'],
      username: json['username'],
      modelName: json['modelName'],
      generationId: json['generationId'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['imageUrl'] = imageUrl;
    data['prompt'] = prompt;
    data['presetStyle'] = presetStyle;
    data['createdAt'] = createdAt;
    data['privacy'] = privacy;

    // Add optional fields only if they exist
    if (userId != null) data['userId'] = userId;
    if (creatorEmail != null) data['creatorEmail'] = creatorEmail;
    if (username != null) data['username'] = username;
    if (modelName != null) data['modelName'] = modelName;
    if (generationId != null) data['generationId'] = generationId;
    if (v != null) data['__v'] = v;

    return data;
  }

  Images copyWith({
    String? id,
    String? imageUrl,
    String? prompt,
    String? presetStyle,
    String? createdAt,
    String? privacy,
    String? userId,
    String? creatorEmail,
    String? username,
    String? modelName,
    String? generationId,
    int? v,
  }) {
    return Images(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      prompt: prompt ?? this.prompt,
      presetStyle: presetStyle ?? this.presetStyle,
      createdAt: createdAt ?? this.createdAt,
      privacy: privacy ?? this.privacy,
      userId: userId ?? this.userId,
      creatorEmail: creatorEmail ?? this.creatorEmail,
      username: username ?? this.username,
      modelName: modelName ?? this.modelName,
      generationId: generationId ?? this.generationId,
      v: v ?? this.v,
    );
  }
}