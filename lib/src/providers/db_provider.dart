import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:psp_admin/src/models/modules_model.dart';
import 'package:psp_admin/src/models/projects_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._internal();

  final _ProjectsDBHandler _projectsDBHandler = _ProjectsDBHandler();
  final _ModulesDBHandler _modulesDBHandler = _ModulesDBHandler();

  static const _PROJECTS_TABLE_NAME = 'projects';
  static const _MODULES_TABLE_NAME = 'modules';

  DBProvider._internal();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'psp_admin.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE $_PROJECTS_TABLE_NAME('
          'id INT (11) PRIMARY KEY NOT NULL,'
          'name VARCHAR (50) NOT NULL,'
          'description TEXT NOT NULL,'
          'planning_date VARCHAR NOT NULL,'
          'start_date VARCHAR NULL,'
          'finish_date VARCHAR NULL'
          ')');
      await db.execute('CREATE TABLE $_MODULES_TABLE_NAME('
          'id INT (11) PRIMARY KEY NOT NULL,'
          'projects_id INT (11) NOT NULL,'
          'name VARCHAR (50) NOT NULL,'
          'description TEXT NOT NULL,'
          'planning_date VARCHAR NOT NULL,'
          'start_date VARCHAR NULL,'
          'finish_date VARCHAR NULL)');
    });
  }

  void insertProject(ProjectModel project) async =>
      _projectsDBHandler.insertProject(project);
  void insertProjects(List<ProjectModel> projects) async =>
      _projectsDBHandler.insertProjects(projects);
  void updateProject(ProjectModel project) async =>
      _projectsDBHandler.updateProject(project);
  Future<List<ProjectModel>> getAllProjects() async =>
      _projectsDBHandler.getAllProjects();
  void deleteAllProjects() async => _projectsDBHandler.deleteAllProjects();

  void insertModule(ModuleModel module) async =>
      _modulesDBHandler.insertModule(module);
  void insertModules(List<ModuleModel> modules) async =>
      _modulesDBHandler.insertModules(modules);
  void updateModule(ModuleModel module) async =>
      _modulesDBHandler.updateModule(module);
  Future<List<ModuleModel>> getAllModulesByProjectId(String projectId) async =>
      _modulesDBHandler.getAllModulesByProjectId(projectId);
  void deleteAllModules(String projectId) async =>
      _modulesDBHandler.deleteModulesByProjectId(projectId);
}

class _ProjectsDBHandler {
  static const _PROJECTS_TABLE_NAME = 'projects';

  void insertProject(ProjectModel project) async {
    final db = await DBProvider.db.database;
    await db.insert(_PROJECTS_TABLE_NAME, project.toJson());
  }

  void insertProjects(List<ProjectModel> projects) async {
    final db = await DBProvider.db.database;
    for (var project in projects) {
      await db.insert(_PROJECTS_TABLE_NAME, project.toJson());
    }
  }

  void updateProject(ProjectModel project) async {
    final db = await DBProvider.db.database;
    await db.update(_PROJECTS_TABLE_NAME, project.toJson(),
        where: 'id = ?', whereArgs: [project.id]);
  }

  Future<List<ProjectModel>> getAllProjects() async {
    final db = await DBProvider.db.database;
    final res = await db.query(_PROJECTS_TABLE_NAME);

    var projects = _getProjectsFromJson(res);

    return projects;
  }

  void deleteAllProjects() async {
    final db = await DBProvider.db.database;
    await db.rawDelete('DELETE FROM $_PROJECTS_TABLE_NAME');
  }

  List<ProjectModel> _getProjectsFromJson(List<Map<String, dynamic>> res) {
    return res.isNotEmpty
        ? res
            .map((projectModel) => ProjectModel.fromJson(projectModel))
            .toList()
        : [];
  }
}

class _ModulesDBHandler {
  static const _MODULES_TABLE_NAME = 'modules';

  void insertModule(ModuleModel module) async {
    final db = await DBProvider.db.database;
    await db.insert(_MODULES_TABLE_NAME, module.toJson());
  }

  void insertModules(List<ModuleModel> modules) async {
    final db = await DBProvider.db.database;
    for (var module in modules) {
      await db.insert(_MODULES_TABLE_NAME, module.toJson());
    }
  }

  void updateModule(ModuleModel module) async {
    final db = await DBProvider.db.database;
    await db.update(_MODULES_TABLE_NAME, module.toJson(),
        where: 'id = ?', whereArgs: [module.id]);
  }

  Future<List<ModuleModel>> getAllModulesByProjectId(projectId) async {
    final db = await DBProvider.db.database;
    final res = await db.query(_MODULES_TABLE_NAME,
        where: 'projects_id = ?', whereArgs: [projectId]);

    var modules = _getModulesFromJson(res);

    return modules;
  }

  void deleteModulesByProjectId(String projectId) async {
    final db = await DBProvider.db.database;

    await db.rawDelete(
        'DELETE FROM $_MODULES_TABLE_NAME WHERE projects_id = $projectId');
  }

  List<ModuleModel> _getModulesFromJson(List<Map<String, dynamic>> res) {
    return res.isNotEmpty
        ? res.map((module) => ModuleModel.fromJson(module)).toList()
        : [];
  }
}
