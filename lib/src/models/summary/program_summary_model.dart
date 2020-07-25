import 'dart:convert';

import 'package:psp_admin/src/models/summary/summary.dart';

ProgramSummaryModel programSummaryModelFromJson(String str) =>
    ProgramSummaryModel.fromJson(json.decode(str));

String programSummaryModelToJson(ProgramSummaryModel data) =>
    json.encode(data.toJson());

class ProgramSummaryModel {
  ProgramSummaryModel({
    this.language,
    this.programLines,
    this.timePhase,
    this.defectsInjected,
    this.defectsRemoved,
  });

  String language;
  Map<String, double> programLines;
  List<SummaryTimePhase> timePhase;
  List<SummaryDefects> defectsInjected;
  List<SummaryDefects> defectsRemoved;

  factory ProgramSummaryModel.fromJson(Map<String, dynamic> json) =>
      ProgramSummaryModel(
        language: json['language'],
        programLines: Map.from(json['program_lines'])
            .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
        timePhase: List<SummaryTimePhase>.from(
            json['time_phase'].map((x) => SummaryTimePhase.fromJson(x))),
        defectsInjected: List<SummaryDefects>.from(
            json['defects_injected'].map((x) => SummaryDefects.fromJson(x))),
        defectsRemoved: List<SummaryDefects>.from(
            json['defects_removed'].map((x) => SummaryDefects.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        'language': language,
        'program_lines': Map.from(programLines)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        'time_phase': List<dynamic>.from(timePhase.map((x) => x.toJson())),
        'defects_injected':
        List<dynamic>.from(defectsInjected.map((x) => x.toJson())),
        'defects_removed':
        List<dynamic>.from(defectsRemoved.map((x) => x.toJson())),
      };
}

class SummaryDefects implements Summary {
  SummaryDefects({
    this.phaseId,
    this.planning,
    this.current,
    this.toDate,
    this.percent,
  });

  @override
  int phaseId;
  @override
  int planning;
  @override
  int current;
  @override
  int toDate;
  @override
  double percent;

  factory SummaryDefects.fromJson(Map<String, dynamic> json) =>
      SummaryDefects(
        phaseId: json['phase_id'],
        planning: json['planning_defects'],
        current: json['current_defects'],
        toDate: json['to_date_defects'],
        percent: json['percent'].toDouble(),
      );

  Map<String, dynamic> toJson() =>
      {
        'phase_id': phaseId,
        'planning_defects': planning,
        'current_defects': current,
        'to_date_defects': toDate,
        'percent': percent,
      };
}

class SummaryTimePhase implements Summary {
  SummaryTimePhase({
    this.phaseId,
    this.planning,
    this.current,
    this.toDate,
    this.percent,
  });

  @override
  int phaseId;
  @override
  int planning;
  @override
  int current;
  @override
  int toDate;
  @override
  double percent;

  factory SummaryTimePhase.fromJson(Map<String, dynamic> json) =>
      SummaryTimePhase(
        phaseId: json['phase_id'],
        planning: json['planning_time'],
        current: json['current_time'],
        toDate: json['to_date_time'],
        percent: json['percent'].toDouble(),
      );

  Map<String, dynamic> toJson() =>
      {
        'phase_id': phaseId,
        'planning_time': planning,
        'current_time': current,
        'to_date_time': toDate,
        'percent': percent,
      };
}
