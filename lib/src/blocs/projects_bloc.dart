import 'package:psp_admin/src/models/projects_model.dart';
import 'package:psp_admin/src/providers/db_provider.dart';
import 'package:psp_admin/src/providers/projects_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProjectsBloc {
  final _projectsProvider = new ProjectsProvider();

  final _projectsController = new BehaviorSubject<List<ProjectModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  Stream<List<ProjectModel>> get projectStream => _projectsController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;

  void searchProject(String query) async {
    final project = await DBProvider.db.searchProject(query);
    _projectsController.sink.add(project);
  }

  void insertProject(ProjectModel project) async {
    _changeLoadingStatus(true);
    await DBProvider.db.insertProject(project);
    _changeLoadingStatus(false);
  }

  void getProjects() async {
    _changeLoadingStatus(true);
    final projects = await _projectsProvider.getAllProjects();
    _projectsController.sink.add(projects);
    _changeLoadingStatus(false);
  }

  void _changeLoadingStatus(isLoading) => _loadingController.add(isLoading);

  dispose() {
    _projectsController?.close();
    _loadingController?.close();
  }
}
