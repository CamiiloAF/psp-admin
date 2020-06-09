import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:psp_admin/src/models/projects_model.dart';
import 'package:psp_admin/src/providers/db_provider.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';

class ProjectsProvider {
  final preferences = new Preferences();

  Future<List<ProjectModel>> getAllProjects() async {
    final userId = json.decode(preferences.curentUser)['id'];

    final url = '${Constants.baseUrl}/projects/by-user/$userId';

    final response = await http.get(url, headers: Constants.getHeaders());

    final Map<String, dynamic> decodedData = json.decode(response.body);
    List<ProjectModel> projects = [];

    if (decodedData == null) return [];

    if (decodedData['status'] != 200) return [];

    projects = ProjectsModel.fromJsonList(decodedData['payload']).projects;

    if (!kIsWeb) {
      return await _changesProjectsDataInDb(projects);
    } else {
      return projects;
    }
  }

  Future<List<ProjectModel>> _changesProjectsDataInDb(List<ProjectModel> projects) async {
    await DBProvider.db.deleteAllProjects();

    projects.forEach((project) async {
      await DBProvider.db.insertProject(project);
    });

    return await DBProvider.db.getAllProjects();
  }
}
