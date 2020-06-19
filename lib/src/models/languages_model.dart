import 'dart:convert';

class LanguagesModel {
  List<LanguageModel> languages = [];

  LanguagesModel();

  LanguagesModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final language = LanguageModel.fromJson(item);
      languages.add(language);
    }
  }
}

LanguageModel languageModelFromJson(String str) =>
    LanguageModel.fromJson(json.decode(str));

String languageModelToJson(LanguageModel data) => json.encode(data.toJson());

class LanguageModel {
  LanguageModel({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
