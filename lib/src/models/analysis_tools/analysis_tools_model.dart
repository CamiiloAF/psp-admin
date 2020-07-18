import 'dart:convert';

class ListOfAnalysisToolsModel {
  List<AnalysisToolsModel> analysisToolsModel = [];

  ListOfAnalysisToolsModel();

  ListOfAnalysisToolsModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final analysisToolsItem = AnalysisToolsModel.fromJson(item);
      analysisToolsModel.add(analysisToolsItem);
    }
  }
}

List<AnalysisToolsModel> graphicsModelFromJson(String str) =>
    List<AnalysisToolsModel>.from(
        json.decode(str).map((x) => AnalysisToolsModel.fromJson(x)));

String graphicsModelToJson(List<AnalysisToolsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AnalysisToolsModel {
  AnalysisToolsModel({
    this.programName,
    this.size,
    this.defects,
    this.time,
    this.defectsInjected,
    this.defectsRemoved,
  });

  String programName;
  num size;
  int defects;
  num time;
  List<DefectsModel> defectsInjected;
  List<DefectsModel> defectsRemoved;

  factory AnalysisToolsModel.fromJson(Map<String, dynamic> json) => AnalysisToolsModel(
        programName: json['program_name'],
        size: json['size'],
        defects: json['defects'],
        time: json['time'],
        defectsInjected: List<DefectsModel>.from(
            json['defects_injected'].map((x) => DefectsModel.fromJson(x))),
        defectsRemoved: List<DefectsModel>.from(
            json['defects_removed'].map((x) => DefectsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'program_name': programName,
        'size': size,
        'defects': defects,
        'time': time,
        'defects_injected':
            List<dynamic>.from(defectsInjected.map((x) => x.toJson())),
        'defects_removed':
            List<dynamic>.from(defectsRemoved.map((x) => x.toJson())),
      };
}

class DefectsModel {
  DefectsModel({
    this.phasesId,
    this.amount,
  });

  int phasesId;
  int amount;

  factory DefectsModel.fromJson(Map<String, dynamic> json) => DefectsModel(
        phasesId: json['phases_id'],
        amount: json['amount'],
      );

  Map<String, dynamic> toJson() => {
        'phases_id': phasesId,
        'amount': amount,
      };
}
