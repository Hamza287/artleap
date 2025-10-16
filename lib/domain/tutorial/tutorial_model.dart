class TutorialScreenModel {
  final String imageAsset;
  final String title;
  final String description;

  TutorialScreenModel({
    required this.imageAsset,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'imageAsset': imageAsset,
      'title': title,
      'description': description,
    };
  }

  factory TutorialScreenModel.fromMap(Map<String, dynamic> map) {
    return TutorialScreenModel(
      imageAsset: map['imageAsset'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }
}