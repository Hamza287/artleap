class GenerateImageModel {
  GenerateImageModel({
    required this.status,
    required this.tip,
    required this.generationTime,
    required this.id,
    required this.output,
    required this.proxyLinks,
    required this.nsfwContentDetected,
    required this.meta,
  });
  late final String status;
  late final String tip;
  late final double generationTime;
  late final int id;
  late final List<String> output;
  late final List<String> proxyLinks;
  late final String nsfwContentDetected;
  late final Meta meta;

  GenerateImageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    tip = json['tip'];
    generationTime = json['generationTime'];
    id = json['id'];
    output = List.castFrom<dynamic, String>(json['output']);
    proxyLinks = List.castFrom<dynamic, String>(json['proxy_links']);
    nsfwContentDetected = json['nsfw_content_detected'];
    meta = Meta.fromJson(json['meta']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['tip'] = tip; 
    _data['generationTime'] = generationTime;
    _data['id'] = id;
    _data['output'] = output;
    _data['proxy_links'] = proxyLinks;
    _data['nsfw_content_detected'] = nsfwContentDetected;
    _data['meta'] = meta.toJson();
    return _data;
  }
}

class Meta {
  Meta({
    required this.base64,
    required this.enhancePrompt,
    required this.enhanceStyle,
    required this.filePrefix,
    required this.guidanceScale,
    required this.height,
    required this.instantResponse,
    required this.nSamples,
    required this.negativePrompt,
    required this.opacity,
    required this.outdir,
    required this.paddingDown,
    required this.paddingRight,
    required this.pagScale,
    required this.prompt,
    required this.rescale,
    required this.safetyChecker,
    required this.safetyCheckerType,
    required this.scaleDown,
    required this.seed,
    required this.temp,
    required this.watermark,
    required this.width,
  });
  late final String base64;
  late final String enhancePrompt;
  late final String enhanceStyle;
  late final String filePrefix;
  late final int guidanceScale;
  late final int height;
  late final String instantResponse;
  late final int nSamples;
  late final String negativePrompt;
  late final double opacity;
  late final String outdir;
  late final int paddingDown;
  late final int paddingRight;
  late final double pagScale;
  late final String prompt;
  late final String rescale;
  late final String safetyChecker;
  late final String safetyCheckerType;
  late final int scaleDown;
  late final int seed;
  late final String temp;
  late final String watermark;
  late final int width;

  Meta.fromJson(Map<String, dynamic> json) {
    base64 = json['base64'] ?? "";
    enhancePrompt = json['enhance_prompt'] ?? "";
    enhanceStyle = json["enhance_style"] ?? "";
    filePrefix = json['file_prefix'] ?? "";
    guidanceScale = json['guidance_scale'];
    height = json['height'];
    instantResponse = json['instant_response'];
    nSamples = json['n_samples'];
    negativePrompt = json['negative_prompt'];
    opacity = json['opacity'];
    outdir = json['outdir'];
    paddingDown = json['padding_down'];
    paddingRight = json['padding_right'];
    pagScale = json['pag_scale'];
    prompt = json['prompt'];
    rescale = json['rescale'];
    safetyChecker = json['safety_checker'];
    safetyCheckerType = json['safety_checker_type'];
    scaleDown = json['scale_down'];
    seed = json['seed'];
    temp = json['temp'];
    watermark = json['watermark'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['base64'] = base64;
    _data['enhance_prompt'] = enhancePrompt;
    _data['enhance_style'] = enhanceStyle;
    _data['file_prefix'] = filePrefix;
    _data['guidance_scale'] = guidanceScale;
    _data['height'] = height;
    _data['instant_response'] = instantResponse;
    _data['n_samples'] = nSamples;
    _data['negative_prompt'] = negativePrompt;
    _data['opacity'] = opacity;
    _data['outdir'] = outdir;
    _data['padding_down'] = paddingDown;
    _data['padding_right'] = paddingRight;
    _data['pag_scale'] = pagScale;
    _data['prompt'] = prompt;
    _data['rescale'] = rescale;
    _data['safety_checker'] = safetyChecker;
    _data['safety_checker_type'] = safetyCheckerType;
    _data['scale_down'] = scaleDown;
    _data['seed'] = seed;
    _data['temp'] = temp;
    _data['watermark'] = watermark;
    _data['width'] = width;
    return _data;
  }
}
