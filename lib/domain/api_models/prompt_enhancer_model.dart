class PromptEnhancerModel {
  final bool success;
  final String enhanced;
  final String? message;

  PromptEnhancerModel({
    required this.success,
    required this.enhanced,
    this.message,
  });

  factory PromptEnhancerModel.fromJson(Map<String, dynamic> json) {
    return PromptEnhancerModel(
      success: json['success'] ?? false,
      enhanced: json['enhanced'] ?? '',
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'enhanced': enhanced,
      'message': message,
    };
  }
}