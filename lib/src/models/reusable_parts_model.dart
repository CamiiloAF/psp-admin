import 'dart:convert';

class ReusablePartsModel {
  List<ReusablePartModel> reusableParts = [];

  ReusablePartsModel();

  ReusablePartsModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final reusablePart = ReusablePartModel.fromJson(item);
      reusableParts.add(reusablePart);
    }
  }
}

ReusablePartModel reusablePartModelFromJson(String str) =>
    ReusablePartModel.fromJson(json.decode(str));

String reusablePartModelToJson(ReusablePartModel data) =>
    json.encode(data.toJson());

class ReusablePartModel {
  ReusablePartModel({
    this.id,
    this.programsId,
    this.programsReusablesId,
    this.plannedLines,
    this.currentLines,
  });

  int id;
  int programsId;
  int programsReusablesId;
  int plannedLines;
  int currentLines;

  factory ReusablePartModel.fromJson(Map<String, dynamic> json) =>
      ReusablePartModel(
        id: json['id'],
        programsId: json['programs_id'],
        programsReusablesId: json['programs_reusables_id'],
        plannedLines: json['planned_lines'],
        currentLines: json['current_lines'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'programs_id': programsId,
        'programs_reusables_id': programsReusablesId,
        'planned_lines': plannedLines,
        'current_lines': currentLines,
      };
}
