import 'package:Artleap.ai/shared/constants/app_assets.dart';

List<Map> onboardingImagesList = [
  {
    "image": AppAssets.Onboarding3,
    "text": "Unleash your Creativity with Image reference "
  },
  {
    "image": AppAssets.Onboarding2,
    "text": "Create Realistic High Quality Imagery "
  },
  {"image": AppAssets.Onboarding1, "text": "Bring your Ideas to Life with AI"},
];

List<Map> artsStyleImagesLIst = [
  {"image": "", "id": "0"},
  {"image": AppAssets.artstyle1, "id": "1"},
  {"image": AppAssets.artstyle2, "id": "2"},
  {"image": AppAssets.artstyle3, "id": "3"},
  {"image": AppAssets.artstyle4, "id": "4"},
  {"image": AppAssets.artstyle1, "id": "1"},
  {"image": AppAssets.artstyle2, "id": "1"},
];

List<Map> filterResult = [
  {"title": "Trending Creations", "icon": AppAssets.trendingicon},
  {"title": "Anime", "icon": AppAssets.animeicon},
  {"title": "Photography", "icon": AppAssets.photography},
  {"title": "Architecture", "icon": AppAssets.architectureicon},
  {"title": "TSci-fi", "icon": AppAssets.scifiicon},
  {"title": "Food", "icon": AppAssets.foodicon},
  {"title": "Character", "icon": AppAssets.charatericon},
  {"title": "Trending Artstyle", "icon": AppAssets.starticon},
];

List<Map<String, String>> freePikStyles = [
  {"title": "photo", "icon": AppAssets.photo},
  {"title": "cartoon", "icon": AppAssets.cartoon},
  {"title": "3d", "icon": AppAssets.threeD},
  {"title": "vector", "icon": AppAssets.vector},
  {"title": "vintage", "icon": AppAssets.vintage},
  {"title": "digital-art", "icon": AppAssets.digitalart},
  {"title": "pixel-art", "icon": AppAssets.pixelart},
  {"title": "70s-vibe", "icon": AppAssets.seventyVibe},
  {"title": "comic", "icon": AppAssets.comic},
  {"title": "painting", "icon": AppAssets.painting},
  {"title": "dark", "icon": AppAssets.dark},
  {"title": "art-nouveau", "icon": AppAssets.photo},
  {"title": "sketch", "icon": AppAssets.sketch},
  {"title": "mockup", "icon": AppAssets.mockup},
  {"title": "cyberpunk", "icon": AppAssets.cyberpunk},
  {"title": "anime", "icon": AppAssets.anime},
  {"title": "watercolor", "icon": AppAssets.watercolor},
  {"title": "origami", "icon": AppAssets.origami},
  {"title": "surreal", "icon": AppAssets.surreal},
  {"title": "fantasy", "icon": AppAssets.fantasy},
  {"title": "traditional-japan", "icon": AppAssets.traditionalJapan},
  {"title": "studio-shot", "icon": AppAssets.studio},
];

List<Map<String, String>> textToImageStyles = [
  {"title": "ANIME", "icon": AppAssets.leo_anime},
  {"title": "BOKEH", "icon": AppAssets.leo_bokeh},
  {"title": "CINEMATIC", "icon": AppAssets.leo_cinematic},
  {"title": "CINEMATIC_CLOSEUP", "icon": AppAssets.leo_cinematic_closure},
  {"title": "CREATIVE", "icon": AppAssets.leo_creative},
  {"title": "DYNAMIC", "icon": AppAssets.leo_dynamic},
  {"title": "ENVIRONMENT", "icon": AppAssets.leo_environment},
  {"title": "FASHION", "icon": AppAssets.leo_fashion},
  {"title": "FILM", "icon": AppAssets.leo_film},
  {"title": "FOOD", "icon": AppAssets.leo_food},
  {"title": "GENERAL", "icon": AppAssets.photo},
  {"title": "HDR", "icon": AppAssets.leo_hdr},
  {"title": "ILLUSTRATION", "icon": AppAssets.leo_illustration},
  // {"title": "LEONARDO", "icon": AppAssets.leo},
  // {"title": "LONG_EXPOSURE", "icon": AppAssets.photo},
  // {"title": "MACRO", "icon": AppAssets.photo},
  // {"title": "MINIMALISTIC", "icon": AppAssets.leo_mo},
  {"title": "MONOCHROME", "icon": AppAssets.leo_monochrome},
  {"title": "MOODY", "icon": AppAssets.leo_moody},
  // {"title": "NONE", "icon": AppAssets.vector},
  // {"title": "NEUTRAL", "icon": AppAssets.photo},
  // {"title": "PHOTOGRAPHY", "icon": AppAssets.photo},
  // {"title": "PORTRAIT", "icon": AppAssets.studio},
  // {"title": "RAYTRACED", "icon": AppAssets.threeD},
  // {"title": "RENDER_3D", "icon": AppAssets.threeD},
  // {"title": "RETRO", "icon": AppAssets.seventyVibe},
  {"title": "SKETCH_BW", "icon": AppAssets.leo_sketch},
  // {"title": "STOCK_PHOTO", "icon": AppAssets.photo},
  // {"title": "VIBRANT", "icon": AppAssets.vintage},
  // {"title": "UNPROCESSED", "icon": AppAssets.photo},
];

List<Map<String, String>> freePikAspectRatio = [
  {"title": "9:16", "icon": AppAssets.nine, "value": "social_story_9_16"},
  {"title": "5:4", "icon": AppAssets.five, "value": "social_5_4"},
  {"title": "4:3", "icon": AppAssets.four, "value": "classic_4_3"},
  {"title": "3:2", "icon": AppAssets.three, "value": "standard_3_2"},
  {"title": "1:1", "icon": AppAssets.one, "value": "square_1_1"},
  {"title": "2:3", "icon": AppAssets.two, "value": "portrait_2_3"},
  {"title": "16:9", "icon": AppAssets.sixteen, "value": "widescreen_16_9"},
];

List<Map<String, dynamic>> reportOptions = [
  {"id": "1", "title": "Inappropriate Content (e.g., nudity, violence)"},
  {"id": "2", "title": "Misleading or False Information"},
  {"id": "3", "title": "Copyright Violation"},
  {"id": "4", "title": "Low-Quality or Corrupted Image"},
  {"id": "5", "title": "Other ( Please Specify)"},
];

final List<String> sexualWordsList = [
  // Basic sexual words
  "sex", "sexual", "sexuality", "sexy",
  "xxx", "x x x",
  "nude", "nudes", "naked", "nekked",
  "porn", "p o r n", "pornhub", "porn hub",
  "xnxx", "xxxvideos", "xxx videos",
  "erotic", "erotica", "sensual", "provocative",

  // Body parts / slang
  "boobs", "boob", "b o o b s", "breasts", "nipples", "nipple",
  "penis", "p e n i s", "dick", "d i c k", "cock", "c o c k",
  "pussy", "p u s s y", "vagina", "vag", "v a g", "clit", "c l i t",
  "butt", "booty", "b u t t", "ass", "a s s", "arse", "anal", "anus",
  "bum", "bums", "thighs", "balls", "scrotum", "testicles",
  "tits", "tit", "hooter", "hooters", "privates", "genitals", "crotch",

  // Sexual acts / descriptions
  "masturbation", "masturbate", "fingering", "blowjob", "blow job", "bj",
  "handjob", "hand job", "hj", "cum", "c u m", "cumming", "ejaculate",
  "ejaculation", "orgasm", "deepthroat", "deep throat", "coitus",
  "penetration", "humping", "grinding", "squirting", "moaning",
  "kissing", "foreplay", "seduction", "sensuality", "tease", "lust",
  "aroused", "arousal", "hooking up", "hook up", "smash",
  "nut", "bust a nut", "grind", "moan", "squirt", "milking",
  "lustful", "desire", "horny", "wet",

  // Common slang / synonyms
  "fap", "fapping", "kink", "kinky", "bdsm", "bondage", "dominatrix",
  "dominant", "submissive", "sub", "dom", "roleplay", "role play",
  "fetish", "fetishes", "spanking", "tickling", "leather",
  "swinger", "swingers", "cuckold", "cuck",
  "dominance", "submission", "edge play", "discipline",
  "sex tape", "leaked video", "wet dream", "sugar mommy", "sugar mom",

  // Sexual services / references
  "escort", "camgirl", "cam girl", "cam-boy", "cam boy",
  "prostitute", "prostitution", "hooker", "stripper",
  "stripclub", "strip club", "sugarbaby", "sugar baby",
  "sugardaddy", "sugar daddy", "onlyfans", "only fans", "fansly",

  // Porn categories / related
  "nsfw", "hardcore", "hard core", "softcore", "soft core",
  "adult", "adultwork", "milf", "teen", "stepmom", "step mom",
  "stepsis", "step sis", "step sister", "step bro", "stepbro",
  "incest", "taboo", "interracial", "bbw", "creampie", "cream pie",
  "gangbang", "gang bang", "facial",

  // Fetish terms & BDSM-related
  "furry", "latex fetish", "foot fetish", "feet pics",
  "public sex", "exhibitionist", "choking", "whipping",
  "sub dom", "role-play", "leather gear",

  // Potential additional explicit slang
  "fleshlight", "dildo", "vibrator", "buttplug", "butt plug",
  "strapon", "strap-on", "oral", "oral sex", "doggystyle", "doggy style",
  "cowgirl", "reverse cowgirl", "missionary", "69", "sixtynine",
  "lingerie", "latex", "sex toys", "bondage gear",

  // Clothing & suggestive words
  "bikini", "panties", "penty", "thong", "g-string", "g string",
  "bra", "stockings", "heels", "fishnets", "strip",
  "hips", "hip"
];
