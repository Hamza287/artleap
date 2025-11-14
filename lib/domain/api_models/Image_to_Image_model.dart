import 'image_model.dart';

class ImageToImageModel {
  ImageToImageModel({
    required this.generationId,
    required this.prompt,
    required this.presetStyle,
    required this.images,
  });
  late final String generationId;
  late final String prompt;
  late final String presetStyle;
  late final List<Images> images;

  ImageToImageModel.fromJson(Map<String, dynamic> json) {
    generationId = json['generationId'];
    prompt = json['prompt'];
    presetStyle = json['presetStyle'];
    images = List.from(json['images']).map((e) => Images.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['generationId'] = generationId;
    data['prompt'] = prompt;
    data['presetStyle'] = presetStyle;
    data['images'] = images.map((e) => e.toJson()).toList();
    return data;
  }
}

