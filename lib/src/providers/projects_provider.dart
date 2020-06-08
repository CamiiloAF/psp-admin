import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:psp_admin/src/models/ProjectsModel.dart';
import 'package:psp_admin/src/providers/db_provider.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';

class ProjectsProvider {
  final preferences = new Preferences();

  Future<List<ProjectModel>> getAllProjects() async {
    //TODO: Cargar esto de las shared prefs cuando funcione el login
    final userId = 1;

    final url = '${Constants.baseUrl}/projects/by-user/$userId';

    // final response = await http.get(url, headers: Constants.headers);

    // final Map<String, dynamic> decodedData = json.decode(response.body);
    // final List<ProjectModel> projects = new List();

    // if (decodedData == null) return [];

//TODO: reemplazar si el código es != de 200 o 201
    // if (decodedData['error'] != null) return [];

    // _changesProjectsDataInDb(projects);

    return await DBProvider.db.getAllProjects();
  }

  void _changesProjectsDataInDb(List<ProjectModel> projects) {
    DBProvider.db..deleteAllProjects();
    projects.forEach((project) {
      DBProvider.db.insertProject(project);
    });
  }
}
