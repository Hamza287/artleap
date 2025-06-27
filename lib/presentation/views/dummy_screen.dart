import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../shared/console.dart';
import '../../shared/extensions/build_context.dart';
import '../../domain/api_services/api_services.dart';
import '../../shared/navigation/screen_params.dart';
import '../../providers/localization_provider.dart';
import '../../providers/theme_provider.dart';
import '../../shared/localization/language_constrants.dart';

class DummyScreen extends ConsumerStatefulWidget {
  static const String routeName = "home_screen";
  final DummyScreenArgs? params;
  const DummyScreen({super.key, this.params});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DummyScreenState();
}

class _DummyScreenState extends ConsumerState<DummyScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizationPro = ref.read(localizationProvider.notifier);
    final themePro = ref.read(themeProvider.notifier);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            getTranslated('lang', context),
            style: TextStyle(color: context.theme.textTheme.labelSmall!.color!),
          ),
          actions: [
            IconButton(
                onPressed: () => themePro.toggle(),
                icon: Icon(
                  Icons.dark_mode,
                  color: context.theme.iconTheme.color,
                )),
            IconButton(
                onPressed: () => localizationPro
                    .setLanguage(localizationPro.languageIndex == 0 ? 1 : 0),
                icon:
                    Icon(Icons.language, color: context.theme.iconTheme.color)),
            IconButton(
                onPressed: () async {
                  String d = (await getDownloadsDirectory())?.path ?? '';
                  await ApiServices(
                          baseUrl:
                              "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")
                      .download(
                    'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                    "${d}sample.pdf",
                  );
                },
                icon:
                    Icon(Icons.download, color: context.theme.iconTheme.color)),
          ]),
      body: Column(
        children: [
          Expanded(
              child: Column(
            children: [
              Text('${context.height}'),
              Text('${context.width}'),
              Text('${context.isKeyboardVisible}'),
              const TextField()
            ],
          )),
        ],
      ),
    );
  }
}
