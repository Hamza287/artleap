class SubscriptionModel {
  final String currentPlan;
  final String status;
  final DateTime nextBillingDate;
  final int remainingGenerations;
  final int totalGenerations;
  final List<String> features;

  SubscriptionModel({
    required this.currentPlan,
    required this.status,
    required this.nextBillingDate,
    required this.remainingGenerations,
    required this.totalGenerations,
    required this.features,
  });
}