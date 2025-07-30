class AppApiPaths {
  // Authentication paths
  static const String login = "login";
  static const String signup = "signup";
  static const String googleLogin = "googleLogin";
  static const String appleLogin = "appleLogin";
  static const String deleteAccount = "delete/";

  // User paths
  static const getUsers = "getUsers";
  static const String getUserProData = "user/";
  static const String toggleFollow = "toggle-follow";
  static const String getUserFav = "favorites/";
  static const String togglefavourite = "toggle-favorite";
  static const String userCredits = "user/credits";
  static const String deductCredits = "user/deductCredits";

  // Image generation paths
  static const String generateImage = "freepikTxtToImg";
  static const String img2imgPath = "leonardoImgToImg";
  static const String txt2imgPath = "leonardoTxtToImg";
  static const String getUsersCreations = "all-images?page=";
  static const String deleteImage = "images/delete/";
  static const String reportImage = "images/";

  // Subscription paths
  static const String subscriptionsBasePath = "subscriptions/";
  static const String getSubscriptionPlans = "${subscriptionsBasePath}plans";
  static const String subscribe = "${subscriptionsBasePath}subscribe";
  static const String startTrial = "${subscriptionsBasePath}trial";
  static const String  cancelSubscription = "${subscriptionsBasePath}cancel";
  static const String getCurrentSubscription = "${subscriptionsBasePath}current";
  static const String checkGenerationLimits = "${subscriptionsBasePath}limits/";

  // Other paths (from your example)
  static const passengers = "/api/v1/employees";
  static const getReqResUsers = "/users?page=2";
}