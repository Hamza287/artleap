class FreePikAIGenModel {
  FreePikAIGenModel({
    required this.data,
    required this.meta,
  });
  late final List<Data> data;
  late final Meta meta;

  FreePikAIGenModel.fromJson(Map<String, dynamic> json) {
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
    meta = Meta.fromJson(json['meta']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['meta'] = meta.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.base64,
    required this.hasNsfw,
  });
  late final String base64;
  late final bool hasNsfw;

  Data.fromJson(Map<String, dynamic> json) {
    base64 = json['base64'];
    hasNsfw = json['has_nsfw'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['base64'] = base64;
    _data['has_nsfw'] = hasNsfw;
    return _data;
  }
}

class Meta {
  Meta({
    required this.prompt,
    required this.seed,
    required this.image,
    required this.numInferenceSteps,
    required this.guidanceScale,
  });
  late final String prompt;
  late final int seed;
  late final Image image;
  late final int numInferenceSteps;
  late final int guidanceScale;

  Meta.fromJson(Map<String, dynamic> json) {
    prompt = json['prompt'];
    seed = json['seed'];
    image = Image.fromJson(json['image']);
    numInferenceSteps = json['num_inference_steps'];
    guidanceScale = json['guidance_scale'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['prompt'] = prompt;
    _data['seed'] = seed;
    _data['image'] = image.toJson();
    _data['num_inference_steps'] = numInferenceSteps;
    _data['guidance_scale'] = guidanceScale;
    return _data;
  }
}

class Image {
  Image({
    required this.size,
    required this.width,
    required this.height,
  });
  late final String size;
  late final int width;
  late final int height;

  Image.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['size'] = size;
    _data['width'] = width;
    _data['height'] = height;
    return _data;
  }
}
