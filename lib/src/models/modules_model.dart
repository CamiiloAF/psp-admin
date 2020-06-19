import 'dart:convert';

class ModulesModel {
  List<ModuleModel> modules = [];

  ModulesModel();

  ModulesModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final module = ModuleModel.fromJson(item);
      modules.add(module);
    }
  }
}

ModuleModel moduleModelFromJson(String str) =>
    ModuleModel.fromJson(json.decode(str));

String moduleModelToJson(ModuleModel data) => json.encode(data.toJson());

class ModuleModel {
  ModuleModel({
    this.id,
    this.projectsId,
    this.name,
    this.description,
    this.planningDate,
    this.startDate,
    this.finishDate,
  });

  int id;
  int projectsId;
  String name;
  String description;
  int planningDate;
  int startDate;
  int finishDate;

  factory ModuleModel.fromJson(Map<String, dynamic> json) => ModuleModel(
        id: json['id'],
        projectsId: json['projects_id'],
        name: json['name'],
        description: json['description'],
        planningDate: int.parse(json['planning_date']),
        startDate:
            (json['start_date'] != null) ? int.parse(json['start_date']) : null,
        finishDate: (json['finish_date'] != null)
            ? int.parse(json['finish_date'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'projects_id': projectsId,
        'name': name,
        'description': description,
        'planning_date': planningDate,
        'start_date': startDate,
        'finish_date': finishDate,
      };
}
