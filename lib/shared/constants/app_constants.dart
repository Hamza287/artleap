class AppConstants {
  static const String textToImageUrl = "https://modelslab.com/api/v3/text2img";
  static const String imgToimgUrl =
      "https://modelslab.com/api/v6/realtime/img2img";
  static const String otherBaseUrl = "https://jsonplaceholder1.typicode.com";
  static const String reqresBaseUrl = "https://reqres.in/api/";
  static const Environment environment = Environment.development;
  static const ResponseMode responseMode = ResponseMode.real;
  static const String stableDefKey =
      "q888ISOb2v6zvmbLTb7tbSyiMrVfzZ3A8lQrp2yNaI55m5OYujQqPmlOGfuf";
}

enum Environment { development, staging, production }

enum ResponseMode { mock, real }

String localDataStorageEnabled = "localDataStorageEnabled";
