import 'dart:convert';

class DefectLogsModel {
  List<DefectLogModel> defectLogs = [];

  DefectLogsModel();

  DefectLogsModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final defectLog = DefectLogModel.fromJson(item);
      defectLogs.add(defectLog);
    }
  }
}

DefectLogModel defectLogsModelFromJson(String str) =>
    DefectLogModel.fromJson(json.decode(str));

String defectLogsModelToJson(DefectLogModel data) => json.encode(data.toJson());

class DefectLogModel {
  DefectLogModel({
    this.id,
    this.defectLogChainedId,
    this.programsId,
    this.standardDefectsId,
    this.phaseAddedId,
    this.phaseRemovedId,
    this.description,
    this.solution,
    this.startDate,
    this.finishDate,
    this.timeForRepair,
  });

  int id;
  int defectLogChainedId;
  int programsId;
  int standardDefectsId;
  int phaseAddedId;
  int phaseRemovedId;
  String description;
  String solution;
  int startDate;
  int finishDate;
  int timeForRepair;

  factory DefectLogModel.fromJson(Map<String, dynamic> json) => DefectLogModel(
        id: json['id'],
        defectLogChainedId: json['defect_log_chained_id'],
        programsId: json['programs_id'],
        standardDefectsId: json['standard_defects_id'],
        phaseAddedId: json['phase_added_id'],
        phaseRemovedId: json['phase_removed_id'],
        description: json['description'],
        solution: json['solution'],
        startDate: int.parse(json['start_date']),
        finishDate: (json['finish_date'] != null)
            ? int.parse(json['finish_date'])
            : null,
        timeForRepair: json['time_for_repair'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'defect_log_chained_id': defectLogChainedId,
        'programs_id': programsId,
        'standard_defects_id': standardDefectsId,
        'phase_added_id': phaseAddedId,
        'phase_removed_id': phaseRemovedId,
        'description': description,
        'solution': solution,
        'start_date': startDate,
        'finish_date': finishDate,
        'time_for_repair': timeForRepair,
      };
}
