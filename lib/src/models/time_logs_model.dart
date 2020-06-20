import 'dart:convert';

class TimeLogsModel {
  List<TimeLogModel> timeLogs = [];

  TimeLogsModel();

  TimeLogsModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final timeLog = TimeLogModel.fromJson(item);
      timeLogs.add(timeLog);
    }
  }
}

TimeLogModel timeLogModelFromJson(String str) =>
    TimeLogModel.fromJson(json.decode(str));

String timeLogModelToJson(TimeLogModel data) => json.encode(data.toJson());

class TimeLogModel {
  TimeLogModel({
    this.id,
    this.programsId,
    this.phasesId,
    this.startDate,
    this.deltaTime,
    this.finishDate,
    this.interruption,
    this.comments,
  });

  int id;
  int programsId;
  int phasesId;
  String startDate;
  double deltaTime;
  String finishDate;
  int interruption;
  String comments;

  factory TimeLogModel.fromJson(Map<String, dynamic> json) => TimeLogModel(
        id: json['id'],
        programsId: json['programs_id'],
        phasesId: json['phases_id'],
        startDate: json['start_date'],
        deltaTime: json['delta_time'].toDouble(),
        finishDate: json['finish_date'],
        interruption: json['interruption'],
        comments: json['comments'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'programs_id': programsId,
        'phases_id': phasesId,
        'start_date': startDate,
        'delta_time': deltaTime,
        'finish_date': finishDate,
        'interruption': interruption,
        'comments': comments,
      };
}
