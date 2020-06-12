import 'package:flutter/material.dart';
import 'package:psp_admin/src/models/projects_model.dart';
import 'package:psp_admin/src/providers/projects_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class ProjectsBloc {
  final _projectsProvider = ProjectsProvider();

  final _projectsController =
      BehaviorSubject<Tuple2<int, List<ProjectModel>>>();

  Stream<Tuple2<int, List<ProjectModel>>> get projectStream =>
      _projectsController.stream;

  Tuple2<int, List<ProjectModel>> get lastValueProjectsController =>
      _projectsController.value;

  void getProjects(BuildContext context) async {
    final projectsWithStatusCode =
        await _projectsProvider.getAllProjects(context);
    _projectsController.sink.add(projectsWithStatusCode);
  }

  Future<int> insertProject(ProjectModel projectModel) async {
    final statusCode = await _projectsProvider.insertProject(projectModel);

    if (statusCode == 201) {
      final tempProjects = lastValueProjectsController.item2;
      tempProjects.add(projectModel);
      _projectsController.sink.add(Tuple2(200, tempProjects));
    }
    return statusCode;
  }

  void dispose() {
    _projectsController?.close();
  }
}
