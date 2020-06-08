import 'dart:convert';

ProjectModel projectModelFromJson(String str) =>
    ProjectModel.fromJson(json.decode(str));

String projectModelToJson(ProjectModel data) => json.encode(data.toJson());

class ProjectModel {
  ProjectModel({
    this.id,
    this.name,
    this.description,
    this.planningDate,
    this.startDate,
    this.finishDate,
  });

  int id;
  String name;
  String description;
  int planningDate;
  int startDate;
  int finishDate;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        planningDate: json["planning_date"],
        startDate: json["start_date"],
        finishDate: json["finish_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "planning_date": planningDate,
        "start_date": startDate,
        "finish_date": finishDate,
      };
}
