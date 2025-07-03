class AppConstants {
  static const String textToImageUrl =
      "https://modelslab.com/api/v6/images/text2img";
  static const String imgToimgUrl =
      "https://api.stability.ai/v2beta/stable-image/generate/sd3";

  static const String generateHighQualityImage =
      "https://modelslab.com/api/v6/realtime/text2img";
  static const String otherBaseUrl = "https://jsonplaceholder1.typicode.com";
  static const String reqresBaseUrl = "https://reqres.in/api/";
  static const String getModelsList =
      "https://modelslab.com/api/v4/dreambooth/model_list";

  static const String freePikImageUrl =
      "https://api.freepik.com/v1/ai/text-to-image";
  static const Environment environment = Environment.development;
  static const ResponseMode responseMode = ResponseMode.real;
  static const String stableDefKey =
      "q888ISOb2v6zvmbLTb7tbSyiMrVfzZ3A8lQrp2yNaI55m5OYujQqPmlOGfuf";

  // static const String artleapBaseUrl = "http://192.168.11.204:8000/api/";
  static const String artleapBaseUrl = "http://43.205.54.198:8000/api/";

  // notification related apis
  static const String notificationsBasePath = "notifications/";
  static const String getUserNotificationsPath = "${notificationsBasePath}user/";
  static const String markAsReadPath = "${notificationsBasePath}";
  static const String deleteNotificationPath = "${notificationsBasePath}";
  static const String createNotificationPath = "${notificationsBasePath}";
  static const String markAllAsReadPath = "${notificationsBasePath}mark-all-read";
  // Notification types
  static const String generalNotificationType = "general";
  static const String userNotificationType = "user";
}

enum Environment { development, staging, production }

enum ResponseMode { mock, real }

String localDataStorageEnabled = "localDataStorageEnabled";
