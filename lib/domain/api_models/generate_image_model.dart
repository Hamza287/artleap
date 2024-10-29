class GenerateImageModel {
  GenerateImageModel({
    required this.status,
    required this.generationTime,
    required this.id,
    required this.output,
    required this.proxyLinks,
    required this.nsfwContentDetected,
    required this.webhookStatus,
    required this.meta,
    required this.tip,
  });
  late final String status;
  late final double generationTime;
  late final int id;
  late final List<String> output;
  late final List<String> proxyLinks;
  late final bool nsfwContentDetected;
  late final String webhookStatus;
  late final Meta meta;
  late final String tip;

  GenerateImageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    generationTime = json['generationTime'] ?? 0.0;
    id = json['id'];
    output = List.castFrom<dynamic, String>(json['output']);
    proxyLinks = List.castFrom<dynamic, String>(json['proxy_links'] ?? []);
    nsfwContentDetected = json['nsfw_content_detected'] ?? false;
    webhookStatus = json['webhook_status'] ?? "";
    meta = Meta.fromJson(json['meta']);
    tip = json['tip'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['generationTime'] = generationTime;
    _data['id'] = id;
    _data['output'] = output;
    _data['proxy_links'] = proxyLinks;
    _data['nsfw_content_detected'] = nsfwContentDetected;
    _data['webhook_status'] = webhookStatus;
    _data['meta'] = meta.toJson();
    _data['tip'] = tip;
    return _data;
  }
}

class Meta {
  Meta({
    required this.prompt,
    required this.modelId,
    required this.negativePrompt,
    required this.scheduler,
    required this.safetyChecker,
    required this.W,
    required this.H,
    required this.guidanceScale,
    required this.seed,
    required this.steps,
    required this.nSamples,
    required this.fullUrl,
    required this.instantResponse,
    required this.tomesd,
    required this.ipAdapterId,
    required this.enhancePrompt,
    required this.enhanceStyle,
    required this.ipAdapterScale,
    required this.ipAdapterImage,
    required this.freeU,
    required this.upscale,
    required this.multiLingual,
    required this.panorama,
    required this.selfAttention,
    required this.useKarrasSigmas,
    required this.algorithmType,
    required this.safetyCheckerType,
    required this.embeddings,
    required this.vae,
    required this.lora,
    required this.loraStrength,
    required this.clipSkip,
    required this.watermark,
    required this.temp,
    required this.base64,
    required this.filePrefix,
  });
  late final String prompt;
  late final String modelId;
  late final String negativePrompt;
  late final String scheduler;
  late final String safetyChecker;
  late final int W;
  late final int H;
  late final int guidanceScale;
  late final int seed;
  late final int steps;
  late final int nSamples;
  late final String fullUrl;
  late final String instantResponse;
  late final String tomesd;
  late final String ipAdapterId;
  late final String enhancePrompt;
  late final String enhanceStyle;
  late final double ipAdapterScale;
  late final String ipAdapterImage;
  late final String freeU;
  late final String upscale;
  late final String multiLingual;
  late final String panorama;
  late final String selfAttention;
  late final String useKarrasSigmas;
  late final String algorithmType;
  late final String safetyCheckerType;
  late final String embeddings;
  late final String vae;
  late final String lora;
  late final int loraStrength;
  late final int clipSkip;
  late final String watermark;
  late final String temp;
  late final String base64;
  late final String filePrefix;

  Meta.fromJson(Map<String, dynamic> json) {
    prompt = json['prompt'];
    modelId = json['model_id'] ?? "";
    negativePrompt = json['negative_prompt'];
    scheduler = json['scheduler'] ?? "";
    safetyChecker = json['safety_checker'] ?? "";
    W = json['W'];
    H = json['H'];
    guidanceScale = json['guidance_scale'];
    seed = json['seed'] ?? "";
    steps = json['steps'];
    nSamples = json['n_samples'];
    fullUrl = json['full_url'];
    instantResponse = json['instant_response'];
    tomesd = json['tomesd'];
    ipAdapterId = json["ip_adapter_id"] ?? "";
    enhancePrompt = json['enhance_prompt'];
    enhanceStyle = json["enhance_style"] ?? "";
    ipAdapterScale = json['ip_adapter_scale'];
    ipAdapterImage = json["ip_adapter_image"] ?? "";
    freeU = json['free_u'];
    upscale = json['upscale'];
    multiLingual = json['multi_lingual'];
    panorama = json['panorama'];
    selfAttention = json['self_attention'];
    useKarrasSigmas = json['use_karras_sigmas'];
    algorithmType = json['algorithm_type'];
    safetyCheckerType = json['safety_checker_type'];
    embeddings = json["embeddings"] ?? "";
    vae = json["vae"] ?? "";
    lora = json["lora"] ?? "";
    loraStrength = json['lora_strength'];
    clipSkip = json['clip_skip'];
    watermark = json['watermark'];
    temp = json['temp'];
    base64 = json['base64'];
    filePrefix = json['file_prefix'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['prompt'] = prompt;
    _data['model_id'] = modelId;
    _data['negative_prompt'] = negativePrompt;
    _data['scheduler'] = scheduler;
    _data['safety_checker'] = safetyChecker;
    _data['W'] = W;
    _data['H'] = H;
    _data['guidance_scale'] = guidanceScale;
    _data['seed'] = seed;
    _data['steps'] = steps;
    _data['n_samples'] = nSamples;
    _data['full_url'] = fullUrl;
    _data['instant_response'] = instantResponse;
    _data['tomesd'] = tomesd;
    _data['ip_adapter_id'] = ipAdapterId;
    _data['enhance_prompt'] = enhancePrompt;
    _data['enhance_style'] = enhanceStyle;
    _data['ip_adapter_scale'] = ipAdapterScale;
    _data['ip_adapter_image'] = ipAdapterImage;
    _data['free_u'] = freeU;
    _data['upscale'] = upscale;
    _data['multi_lingual'] = multiLingual;
    _data['panorama'] = panorama;
    _data['self_attention'] = selfAttention;
    _data['use_karras_sigmas'] = useKarrasSigmas;
    _data['algorithm_type'] = algorithmType;
    _data['safety_checker_type'] = safetyCheckerType;
    _data['embeddings'] = embeddings;
    _data['vae'] = vae;
    _data['lora'] = lora;
    _data['lora_strength'] = loraStrength;
    _data['clip_skip'] = clipSkip;
    _data['watermark'] = watermark;
    _data['temp'] = temp;
    _data['base64'] = base64;
    _data['file_prefix'] = filePrefix;
    return _data;
  }
}
