class ModelsListModel {
  final String modelId;
  final String status;
  final DateTime? createdAt;
  final String? instancePrompt;
  final String apiCalls;
  final String modelCategory;
  final String? modelName;
  final String? isNsfw;
  final String featured;
  final String description;
  final String screenshots;

  ModelsListModel({
    required this.modelId,
    required this.status,
    this.createdAt,
    this.instancePrompt,
    required this.apiCalls,
    required this.modelCategory,
    this.modelName,
    this.isNsfw,
    required this.featured,
    required this.description,
    required this.screenshots,
  });

  factory ModelsListModel.fromJson(Map<String, dynamic> json) {
    return ModelsListModel(
      modelId: json['model_id'] ?? "",
      status: json['status'] ?? "",
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      instancePrompt: json['instance_prompt'] ?? "",
      apiCalls: json['api_calls'] ?? "",
      modelCategory: json['model_category'] ?? "",
      modelName: json['model_name'] ?? "",
      isNsfw: json['is_nsfw'] ?? "",
      featured: json['featured'] ?? "",
      description: json['description'] ?? "",
      screenshots: json['screenshots'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model_id': modelId,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'instance_prompt': instancePrompt,
      'api_calls': apiCalls,
      'model_category': modelCategory,
      'model_name': modelName,
      'is_nsfw': isNsfw,
      'featured': featured,
      'description': description,
      'screenshots': screenshots,
    };
  }
}
