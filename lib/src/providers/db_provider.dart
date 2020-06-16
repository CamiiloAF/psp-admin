import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:psp_admin/src/models/users_model.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._internal();

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
      await db.execute('CREATE TABLE ${Constants.PROJECTS_TABLE_NAME}('
          'id INT (11) PRIMARY KEY NOT NULL,'
          'name VARCHAR (50) NOT NULL,'
          'description TEXT NOT NULL,'
          'planning_date VARCHAR NOT NULL,'
          'start_date VARCHAR NULL,'
          'finish_date VARCHAR NULL'
          ')');
      await db.execute('CREATE TABLE ${Constants.MODULES_TABLE_NAME}('
          'id INT (11) PRIMARY KEY NOT NULL,'
          'projects_id INT (11) NOT NULL,'
          'name VARCHAR (50) NOT NULL,'
          'description TEXT NOT NULL,'
          'planning_date VARCHAR NOT NULL,'
          'start_date VARCHAR NULL,'
          'finish_date VARCHAR NULL)');

      await db.execute('CREATE TABLE ${Constants.USERS_TABLE_NAME}('
          'id INT (11) PRIMARY KEY NOT NULL,'
          'organizations_id INT (11) NOT NULL,'
          'first_name VARCHAR (50) NOT NULL,'
          'last_name VARCHAR (50) NOT NULL,'
          'email VARCHAR (80) NOT NULL,'
          'phone VARCHAR(20) NOT NULL,'
          'rol VARCHAR (50) NOT NULL)');

      await db.execute('CREATE TABLE ${Constants.PROJECTS_USERS_TABLE_NAME}('
          'id_project INT (11) NOT NULL,'
          'id_user INT (11) NOT NULL,'
          'CONSTRAINT PK_PROYECTOS_USUARIOS PRIMARY KEY (id_user, id_project),'
          'CONSTRAINT FK_PROYECTOS_USUARIOS_PROYECTOS FOREIGN KEY (id_project) REFERENCES ${Constants.PROJECTS_TABLE_NAME}(id),'
          'CONSTRAINT FK_PROYECTOS_USUARIOS_USUARIOS FOREIGN KEY (id_user) REFERENCES ${Constants.USERS_TABLE_NAME}(id))');
    });
  }

  Future<List<Map<String, dynamic>>> getAllModels() async {
    final db = await DBProvider.db.database;
    return await db.query(Constants.PROJECTS_TABLE_NAME);
  }

  void deleteAll(String tableName) async {
    final db = await DBProvider.db.database;
    await db.rawDelete('DELETE FROM $tableName');
  }

  void insert(dynamic model, String tableName) async {
    final db = await DBProvider.db.database;
    await db.insert(tableName, model.toJson());
  }

  void insertList(List<dynamic> models, String tableName) async {
    final db = await DBProvider.db.database;
    for (var model in models) {
      await db.insert(tableName, model.toJson());
    }
  }

  void update(dynamic model, String tableName) async {
    final db = await DBProvider.db.database;
    await db.update(tableName, model.toJson(),
        where: 'id = ?', whereArgs: [model.id]);
  }

  Future<List<Map<String, dynamic>>> getAllByProjectId(
      projectId, String tableName) async {
    final db = await DBProvider.db.database;
    final res = await db
        .query(tableName, where: 'projects_id = ?', whereArgs: [projectId]);

    return res;
  }

  void deleteAllByProjectId(String projectId, String tableName) async {
    final db = await DBProvider.db.database;
    await db.rawDelete('DELETE FROM $tableName WHERE projects_id = $projectId');
  }

  void insertUser(UserModel model, int projectId) async {
    final db = await DBProvider.db.database;
    final id = await db.insert(Constants.USERS_TABLE_NAME, model.toJson());
    await db.insert(Constants.PROJECTS_USERS_TABLE_NAME, {
      'id_project': projectId,
      'id_user': id,
    });
  }

// Users
  void insertUsers(List<dynamic> models, int projectId) async {
    for (var model in models) {
      await insertUser(model, projectId);
    }
  }

  Future<List<Map<String, dynamic>>> getAllByOrganizationId(
      int organizationId, String tableName) async {
    final db = await DBProvider.db.database;
    final res = await db.query(tableName,
        where: 'organizations_id = ?', whereArgs: [organizationId]);

    return res;
  }

  void deleteAllUsers() async {
    await deleteAll(Constants.USERS_TABLE_NAME);
    await deleteAll(Constants.PROJECTS_USERS_TABLE_NAME);
  }

  Future<List<Map<String, dynamic>>> getAllUsertByProjectId(
      int projectId) async {
    final db = await DBProvider.db.database;
    return await db.rawQuery('SELECT * FROM ${Constants.USERS_TABLE_NAME} as u '
        'INNER JOIN ${Constants.PROJECTS_USERS_TABLE_NAME} AS pu '
        'ON pu.id_user = u.id WHERE pu.id_project = $projectId');
  }
}
