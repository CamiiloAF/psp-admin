import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/providers/models/system_language_model.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/expansion_list_card.dart';

class SettingsPage extends StatelessWidget {
  static const ROUTE_NAME = 'settings';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: S.of(context).optionSettings),
        body: LanguageCard());
  }
}

class LanguageCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final systemLanguageModel = Provider.of<SystemLanguageModel>(context);

    return Container(
      width: double.infinity,
      child: ExpansionListCard<Locale>(
        title: S.of(context).labelLanguage,
        subTitle: _localizeLocale(context, systemLanguageModel.locale),
        leading: Icon(Icons.language, size: 48),
        items: [
          null,
          ...S.delegate.supportedLocales,
        ],
        itemBuilder: (locale) {
          return ExpansionCardItem(
            text: _localizeLocale(context, locale),
            onTap: () =>
                Provider.of<SystemLanguageModel>(context, listen: false)
                    .locale = locale,
          );
        },
      ),
    );
  }

  String _localizeLocale(BuildContext context, Locale locale) {
    if (locale == null) {
      return S.of(context).labelSystemLanguage;
    } else {
      final localeString = LocaleNames.of(context).nameOf(locale.toString());
      return localeString[0].toUpperCase() + localeString.substring(1);
    }
  }
}
