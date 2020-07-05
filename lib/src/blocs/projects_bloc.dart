import 'package:psp_admin/src/models/projects_model.dart';
import 'package:psp_admin/src/repositories/projects_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class ProjectsBloc {
  final _projectsRepository = ProjectsRepository();

  final _projectsController =
      BehaviorSubject<Tuple2<int, List<ProjectModel>>>();

  Stream<Tuple2<int, List<ProjectModel>>> get projectStream =>
      _projectsController.stream;

  Tuple2<int, List<ProjectModel>> get lastValueProjectsController =>
      _projectsController.value;

  void getProjects(bool isRefreshing) async {
    final projectsWithStatusCode =
        await _projectsRepository.getAllProjects(isRefreshing);
    _projectsController.sink.add(projectsWithStatusCode);
  }

  Future<int> insertProject(ProjectModel projectModel) async {
    final result = await _projectsRepository.insertProject(projectModel);
    final statusCode = result.item1;

    if (statusCode == 201) {
      final tempProjects = lastValueProjectsController.item2;
      tempProjects.add(result.item2);
      _projectsController.sink.add(Tuple2(200, tempProjects));
    }
    return statusCode;
  }

  Future<int> updateProject(ProjectModel projectModel) async {
    final statusCode = await _projectsRepository.updateProject(projectModel);

    if (statusCode == 204) {
      final tempProjects = lastValueProjectsController.item2;
      final indexOfOldProject =
          tempProjects.indexWhere((element) => element.id == projectModel.id);
      tempProjects[indexOfOldProject] = projectModel;
      _projectsController.sink.add(Tuple2(200, tempProjects));
    }
    return statusCode;
  }

  void dispose() => _projectsController?.sink?.add(null);
}
