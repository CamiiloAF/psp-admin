import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:psp_admin/src/models/users_model.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._internal();

  static const _DB_NAME = 'psp_admin.db';

  DBProvider._internal();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    return await openDatabase(await getDbPath(), version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(Constants.SQL_CREATE_TABLE_PROJECTS);
      await db.execute(Constants.SQL_CREATE_TABLE_MODULES);

      await db.execute(Constants.SQL_CREATE_TABLE_USERS);
      await db.execute(Constants.SQL_CREATE_TABLE_PROJECTS_USERS);

      await db.execute(Constants.SQL_CREATE_TABLE_EXPERIENCES);

      await db.execute(Constants.SQL_CREATE_TABLE_PROGRAMS);
      await db.execute(Constants.SQL_CREATE_TABLE_LANGUAGES);

      await db.execute(Constants.SQL_CREATE_TABLE_BASE_PARTS);
      await db.execute(Constants.SQL_CREATE_TABLE_NEW_PARTS);
      await db.execute(Constants.SQL_CREATE_TABLE_REUSABLE_PARTS);

      await db.execute(Constants.SQL_CREATE_TABLE_DEFECT_LOGS);
      await db.execute(Constants.SQL_CREATE_TABLE_TIME_LOGS);

      await db.execute(Constants.SQL_CREATE_TABLE_TEST_REPORTS);
    });
  }

  Future<String> getDbPath() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, _DB_NAME);
  }

  // ? General
  Future<List<Map<String, dynamic>>> getAllModels(String tableName) async {
    final db = await DBProvider.db.database;
    return await db.query(tableName);
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

  void deleteDb() async {
    await deleteDatabase(await getDbPath());
    _database = null;
  }

  // ? Users
  void insertUser(
      UserModel model, int projectId, bool isByOrganizationId) async {
    final db = await DBProvider.db.database;
    await db.insert(Constants.USERS_TABLE_NAME, model.toJson());
    if (!isByOrganizationId) {
      await insertUserProject(projectId, model.id);
    }
  }

  void insertUserProject(int projectId, int userId) async {
    final db = await DBProvider.db.database;
    await db.insert(Constants.PROJECTS_USERS_TABLE_NAME, {
      'id_project': projectId,
      'id_user': userId,
    });
  }

  void deleteUserProject(int projectId, int userId) async {
    final db = await DBProvider.db.database;
    await db.delete(Constants.PROJECTS_USERS_TABLE_NAME,
        where: 'id_project = ? AND id_user = ?',
        whereArgs: [projectId, userId]);
  }

  void insertUsers(
      List<dynamic> models, int projectId, bool isByOrganizationId) async {
    for (var model in models) {
      await insertUser(model, projectId, isByOrganizationId);
    }
  }

  Future<List<Map<String, dynamic>>> getAllByOrganizationId(
      int organizationId, String tableName) async {
    final db = await DBProvider.db.database;
    final res = await db.query(tableName,
        where: 'organizations_id = ?', whereArgs: [organizationId]);

    return res;
  }

  void deleteAllUsers(bool isByOrganizationId) async {
    if (!isByOrganizationId) {
      await deleteAll(Constants.PROJECTS_USERS_TABLE_NAME);
    }
    await deleteAll(Constants.USERS_TABLE_NAME);
  }

  Future<List<Map<String, dynamic>>> getAllUsersByProjectId(
      int projectId) async {
    final db = await DBProvider.db.database;
    final res =
        await db.rawQuery('SELECT * FROM ${Constants.USERS_TABLE_NAME} as u '
            'INNER JOIN ${Constants.PROJECTS_USERS_TABLE_NAME} AS pu '
            'ON pu.id_user = u.id WHERE pu.id_project = $projectId');

    return res;
  }

  // ? Programs
  Future<List<Map<String, dynamic>>> getAllProgramsByModuleId(
      String moduleId) async {
    final db = await DBProvider.db.database;
    return await db.query(Constants.PROGRAMS_TABLE_NAME,
        where: 'modules_id = ?', whereArgs: [moduleId]);
  }

  void deleteAllByModuleId(String moduleId, String tableName) async {
    final db = await DBProvider.db.database;
    await db.rawDelete('DELETE FROM $tableName WHERE modules_id = $moduleId');
  }

  Future<List<Map<String, dynamic>>> getAllModelsByProgramId(
      String tableName, int programId) async {
    final db = await DBProvider.db.database;
    return await db
        .query(tableName, where: 'programs_id = ?', whereArgs: [programId]);
  }
}
