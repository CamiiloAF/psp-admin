import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:psp_admin/src/models/projects_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._internal();

  static const _PROJECTS_TABLE_NAME = 'projects';

  DBProvider._internal();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

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
    });
  }

  insertProject(ProjectModel project) async {
    final db = await database;
    final res = await db.insert(_PROJECTS_TABLE_NAME, project.toJson());
    return res;
  }

  Future<List<ProjectModel>> getAllProjects() async {
    final db = await database;
    final res = await db.query(_PROJECTS_TABLE_NAME);

    List<ProjectModel> projects = _getProjectsFromJson(res);

    return projects;
  }

  Future<List<ProjectModel>> searchProject(String query) async {
    final db = await database;
    final res = await db.rawQuery(
        "SELECT * FROM $_PROJECTS_TABLE_NAME WHERE name LIKE '%$query%' OR description LIKE '%$query%' ");

    List<ProjectModel> projects = _getProjectsFromJson(res);
    return projects;
  }

  List<ProjectModel> _getProjectsFromJson(List<Map<String, dynamic>> res) {
    return res.isNotEmpty
        ? res
            .map((projectModel) => ProjectModel.fromJson(projectModel))
            .toList()
        : [];
  }

  Future<int> deleteAllProjects() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM $_PROJECTS_TABLE_NAME');
    return res;
  }
}
