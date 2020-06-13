import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:psp_admin/src/blocs/provider.dart';
import 'package:psp_admin/src/models/projects_model.dart';
import 'package:psp_admin/src/providers/db_provider.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/network_bound_resources/insert_and_update_bound_resource.dart';
import 'package:psp_admin/src/utils/network_bound_resources/network_bound_resource.dart';
import 'package:psp_admin/src/utils/rate_limiter.dart';
import 'package:tuple/tuple.dart';

class ProjectsProvider {
  final preferences = Preferences();

  Future<Tuple2<int, List<ProjectModel>>> getAllProjects() async {
    final networkBoundResource = _ProjectsNetworkBoundResource(RateLimiter());
    final response = await networkBoundResource.execute();

    if (response.item2 == null) {
      return Tuple2(response.item1, []);
    } else {
      return response;
    }
  }

  Future<int> insertProject(ProjectModel projectModel) async {
    final url = '${Constants.baseUrl}/projects';

    return await _ProjectsInsertBoundResource()
        .executeInsert(projectModelToJson(projectModel), url);
  }

  Future<int> updateProject(ProjectModel projectModel) async {
    final url = '${Constants.baseUrl}/projects/${projectModel.id}';
    return await _ProjectsUpdateBoundResource()
        .executeUpdate(projectModelToJson(projectModel), projectModel, url);
  }
}

class _ProjectsNetworkBoundResource
    extends NetworkBoundResource<List<ProjectModel>> {
  final preferences = Preferences();

  final RateLimiter rateLimiter;

  final _allProjects = 'allProjects';

  _ProjectsNetworkBoundResource(this.rateLimiter);

  @override
  Future<http.Response> createCall() async {
    final userId = json.decode(preferences.curentUser)['id'];
    final url = '${Constants.baseUrl}/projects/by-user/$userId';

    return await http.get(url, headers: Constants.getHeaders());
  }

  @override
  Future saveCallResult(List<ProjectModel> item) async {
    await DBProvider.db.deleteAllProjects();

    if (item != null && item.isNotEmpty) {
      await DBProvider.db.insertProjects(item);
    }
  }

  @override
  bool shouldFetch(List<ProjectModel> data) =>
      data.isEmpty ||
      data == null ||
      rateLimiter.shouldFetch(_allProjects, Duration(minutes: 10));

  @override
  Future<List<ProjectModel>> loadFromDb() async =>
      await DBProvider.db.getAllProjects();

  @override
  void onFetchFailed() {
    rateLimiter.reset(_allProjects);
  }

  @override
  List<ProjectModel> decodeData(List<dynamic> payload) =>
      ProjectsModel.fromJsonList(payload).projects;
}

class _ProjectsInsertBoundResource
    extends InsertAndUpdateBoundResource<ProjectModel> {
  @override
  ProjectModel buildNewModel(payload) => ProjectModel.fromJson(payload);

  @override
  void doOperationInDb(ProjectModel model) async =>
      await DBProvider.db.insertProject(model);
}

class _ProjectsUpdateBoundResource
    extends InsertAndUpdateBoundResource<ProjectModel> {
  @override
  ProjectModel buildNewModel(payload) => null;

  @override
  void doOperationInDb(ProjectModel model) async =>
      await DBProvider.db.updateProject(model);
}
