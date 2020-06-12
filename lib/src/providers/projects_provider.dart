import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:psp_admin/src/blocs/provider.dart';
import 'package:psp_admin/src/models/projects_model.dart';
import 'package:psp_admin/src/providers/db_provider.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/NetworkBoundResource.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/rate_limiter.dart';
import 'package:tuple/tuple.dart';

class ProjectsProvider {
  final preferences = Preferences();

  Future<Tuple2<int, List<ProjectModel>>> getAllProjects(
      BuildContext context) async {
    final networkBoundResource =
        _ProjectsNetworkBoundResource(Provider.rateLimiter(context));
    final response = await networkBoundResource.execute();

    if (response.item2 == null) {
      return Tuple2(response.item1, []);
    } else {
      return response;
    }
  }

  Future<int> insertProject(ProjectModel projectModel) async {
    try {
      final url = '${Constants.baseUrl}/projects';

      final resp = await http.post(url,
          headers: Constants.getHeaders(),
          body: projectModelToJson(projectModel));

      final decodedData = json.decode(resp.body);

      final int statusCode = decodedData['status'];
      final newProjectModel = ProjectModel.fromJson(decodedData['payload']);

      if (statusCode == 201 && !kIsWeb) {
        await DBProvider.db.insertProject(newProjectModel);
      }

      return statusCode;
    } on SocketException catch (e) {
      return e.osError.errorCode;
    } on http.ClientException catch (_) {
      return 7;
    } catch (e) {
      return -1;
    }
  }

  Future<int> updateProject(ProjectModel projectModel) async {
    try {
      final url = '${Constants.baseUrl}/projects/${projectModel.id}';

      final resp = await http.put(url,
          headers: Constants.getHeaders(),
          body: projectModelToJson(projectModel));

      if (resp.statusCode == 204 && !kIsWeb) {
        await DBProvider.db.updateProject(projectModel);
      }

      return resp.statusCode;
    } on SocketException catch (e) {
      return e.osError.errorCode;
    } on http.ClientException catch (_) {
      return 7;
    } catch (e) {
      return -1;
    }
  }
}

class _ProjectsNetworkBoundResource
    extends NetworkBoundResource<List<ProjectModel>> {
  final preferences = Preferences();

  final RateLimiter rateLimiter;

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
  bool shouldFetch(List<ProjectModel> data) => true;

  @override
  Future<List<ProjectModel>> loadFromDb() async =>
      await DBProvider.db.getAllProjects();

  @override
  void onFetchFailed() {
    rateLimiter.reset('allProjects');
  }

  @override
  List<ProjectModel> decodeData(List<dynamic> payload) =>
      ProjectsModel.fromJsonList(payload).projects;
}
