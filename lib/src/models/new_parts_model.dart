import 'dart:convert';

class NewPartsModel {
  List<NewPartModel> newParts = [];

  NewPartsModel();

  NewPartsModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final newPart = NewPartModel.fromJson(item);
      newParts.add(newPart);
    }
  }
}

NewPartModel newPartModelFromJson(String str) =>
    NewPartModel.fromJson(json.decode(str));

String newPartModelToJson(NewPartModel data) => json.encode(data.toJson());

class NewPartModel {
  NewPartModel({
    this.id,
    this.programsId,
    this.typesSizesId,
    this.name,
    this.plannedLines,
    this.numberMethodsPlanned,
    this.currentLines,
    this.numberMethodsCurrent,
  });

  int id;
  int programsId;
  int typesSizesId;
  String name;
  double plannedLines;
  int numberMethodsPlanned;
  int currentLines;
  int numberMethodsCurrent;

  factory NewPartModel.fromJson(Map<String, dynamic> json) => NewPartModel(
        id: json['id'],
        programsId: json['programs_id'],
        typesSizesId: json['types_sizes_id'],
        name: json['name'],
        plannedLines: json['planned_lines'],
        numberMethodsPlanned: json['number_methods_planned'],
        currentLines: json['current_lines'],
        numberMethodsCurrent: json['number_methods_current'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'programs_id': programsId,
        'types_sizes_id': typesSizesId,
        'name': name,
        'planned_lines': plannedLines,
        'number_methods_planned': numberMethodsPlanned,
        'current_lines': currentLines,
        'number_methods_current': numberMethodsCurrent,
      };
}
