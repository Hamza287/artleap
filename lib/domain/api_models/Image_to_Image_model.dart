class ImageToImageModel {
  ImageToImageModel({
    required this.image,
    required this.finishReason,
    required this.seed,
  });
  late final String image;
  late final String finishReason;
  late final int seed;

  ImageToImageModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    finishReason = json['finish_reason'];
    seed = json['seed'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['image'] = image;
    _data['finish_reason'] = finishReason;
    _data['seed'] = seed;
    return _data;
  }
}
