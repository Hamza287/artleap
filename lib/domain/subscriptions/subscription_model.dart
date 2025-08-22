import 'dart:io';

class SubscriptionPlanModel {
  final String id;
  final String googleProductId;
  final String appleProductId;
  final String basePlanId;
  final String name;
  final String type;
  final String description;
  final double price;
  final int totalCredits;
  final int imageGenerationCredits;
  final int promptGenerationCredits;
  final List<String> features;
  final bool isActive;
  final int version;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SubscriptionPlanModel({
    required this.id,
    required this.googleProductId,
    required this.appleProductId,
    required this.basePlanId,
    required this.name,
    required this.type,
    required this.description,
    required this.price,
    required this.totalCredits,
    required this.imageGenerationCredits,
    required this.promptGenerationCredits,
    required this.features,
    required this.isActive,
    required this.version,
    required this.createdAt,
    this.updatedAt,
  });

  /// Platform-specific product ID
  String get platformProductId {
    if (Platform.isIOS) {
      return appleProductId;
    } else if (Platform.isAndroid) {
      return googleProductId;
    }
    return ''; // or throw an error if needed
  }

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['_id'] ?? '',
      googleProductId: json['googleProductId'] ?? '',
      appleProductId: json['appleProductId'] ?? '',
      basePlanId: json['basePlanId'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      totalCredits: json['totalCredits'] ?? 0,
      imageGenerationCredits: json['imageGenerationCredits'] ?? 0,
      promptGenerationCredits: json['promptGenerationCredits'] ?? 0,
      features: List<String>.from(json['features'] ?? []),
      isActive: json['isActive'] ?? true,
      version: json['version'] ?? 1,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'googleProductId': googleProductId,
      'appleProductId': appleProductId,
      'basePlanId': basePlanId,
      'name': name,
      'type': type,
      'description': description,
      'price': price,
      'totalCredits': totalCredits,
      'imageGenerationCredits': imageGenerationCredits,
      'promptGenerationCredits': promptGenerationCredits,
      'features': features,
      'isActive': isActive,
      'version': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}


class UserSubscriptionModel {
  final String id;
  final String userId;
  final String planId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isTrial;
  final bool isActive;
  final String? paymentMethod;
  final bool autoRenew;
  final DateTime? cancelledAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final SubscriptionPlanModel? planSnapshot;
  final int usedImageCredits;
  final int usedPromptCredits;

  UserSubscriptionModel({
    required this.id,
    required this.userId,
    required this.planId,
    required this.startDate,
    required this.endDate,
    required this.isTrial,
    required this.isActive,
    this.paymentMethod,
    required this.autoRenew,
    this.cancelledAt,
    required this.createdAt,
    this.updatedAt,
    this.planSnapshot,
    this.usedImageCredits = 0,
    this.usedPromptCredits = 0,
  });

  factory UserSubscriptionModel.fromJson(Map<String, dynamic> json) {
    final planId = json['planId'] is String
        ? json['planId']
        : json['planId']?['_id'] ?? '';

    final endDate = json['endDate'] != null
        ? DateTime.parse(json['endDate'])
        : DateTime.now().add(const Duration(days: 365 * 10));

    return UserSubscriptionModel(
      id: json['_id'] ?? '',
      userId: json['userId'] is String ? json['userId'] : json['userId']?['_id'] ?? '',
      planId: planId,
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: endDate,
      isTrial: json['isTrial'] ?? false,
      isActive: json['isActive'] ?? true,
      paymentMethod: json['paymentMethod'],
      autoRenew: json['autoRenew'] ?? true,
      cancelledAt: json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt']) : null,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      planSnapshot: json['planSnapshot'] != null ? SubscriptionPlanModel.fromJson(json['planSnapshot']) : null,
      usedImageCredits: json['usedImageCredits'] ?? 0,
      usedPromptCredits: json['usedPromptCredits'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'planId': planId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isTrial': isTrial,
      'isActive': isActive,
      'paymentMethod': paymentMethod,
      'autoRenew': autoRenew,
      'cancelledAt': cancelledAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'planSnapshot': planSnapshot?.toJson(),
      'usedImageCredits': usedImageCredits,
      'usedPromptCredits': usedPromptCredits,
    };
  }
}

class GenerationLimitsModel {
  final bool allowed;
  final int creditsUsed;
  final int remaining;

  GenerationLimitsModel({
    required this.allowed,
    required this.creditsUsed,
    required this.remaining,
  });

  factory GenerationLimitsModel.fromJson(Map<String, dynamic> json) {
    return GenerationLimitsModel(
      allowed: json['allowed'] ?? false,
      creditsUsed: json['creditsUsed'] ?? 0,
      remaining: json['remaining'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowed': allowed,
      'creditsUsed': creditsUsed,
      'remaining': remaining,
    };
  }
}