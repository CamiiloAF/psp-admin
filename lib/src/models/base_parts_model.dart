import 'dart:convert';

class BasePartsModel {
  List<BasePartModel> baseParts = [];

  BasePartsModel();

  BasePartsModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final basePart = BasePartModel.fromJson(item);
      baseParts.add(basePart);
    }
  }
}

BasePartModel basePartModelFromJson(String str) =>
    BasePartModel.fromJson(json.decode(str));

String basePartModelToJson(BasePartModel data) => json.encode(data.toJson());

class BasePartModel {
  BasePartModel({
    this.id,
    this.programsId,
    this.programsBaseId,
    this.plannedLinesBase,
    this.plannedLinesDeleted,
    this.plannedLinesEdits,
    this.plannedLinesAdded,
    this.currentLinesBase,
    this.currentLinesDeleted,
    this.currentLinesEdits,
    this.currentLinesAdded,
  });

  int id;
  int programsId;
  int programsBaseId;
  int plannedLinesBase;
  int plannedLinesDeleted;
  int plannedLinesEdits;
  int plannedLinesAdded;
  int currentLinesBase;
  int currentLinesDeleted;
  int currentLinesEdits;
  int currentLinesAdded;

  factory BasePartModel.fromJson(Map<String, dynamic> json) => BasePartModel(
        id: json['id'],
        programsId: json['programs_id'],
        programsBaseId: json['programs_base_id'],
        plannedLinesBase: json['planned_lines_base'],
        plannedLinesDeleted: json['planned_lines_deleted'],
        plannedLinesEdits: json['planned_lines_edits'],
        plannedLinesAdded: json['planned_lines_added'],
        currentLinesBase: json['current_lines_base'],
        currentLinesDeleted: json['current_lines_deleted'],
        currentLinesEdits: json['current_lines_edits'],
        currentLinesAdded: json['current_lines_added'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'programs_id': programsId,
        'programs_base_id': programsBaseId,
        'planned_lines_base': plannedLinesBase,
        'planned_lines_deleted': plannedLinesDeleted,
        'planned_lines_edits': plannedLinesEdits,
        'planned_lines_added': plannedLinesAdded,
        'current_lines_base': currentLinesBase,
        'current_lines_deleted': currentLinesDeleted,
        'current_lines_edits': currentLinesEdits,
        'current_lines_added': currentLinesAdded,
      };
}
