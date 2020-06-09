import 'dart:convert';

class ProjectsModel {
  List<ProjectModel> projects = new List();
  
  ProjectsModel();

  ProjectsModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final project = new ProjectModel.fromJson(item);
      projects.add(project);
    }
  }
}

ProjectModel projectModelFromJson(String str) =>
    ProjectModel.fromJson(json.decode(str));

String projectModelToJson(ProjectModel data) => json.encode(data.toJson());

// List<Pelicula> items = new List();

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
        id: json['id'],
        name: json['name'],
        description: json['description'],
        planningDate: int.parse(json['planning_date']),
        startDate: int.parse(json['start_date']),
        finishDate: int.parse(json['finish_date']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'planning_date': planningDate,
        'start_date': startDate,
        'finish_date': finishDate,
      };
}
