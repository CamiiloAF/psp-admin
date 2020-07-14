import 'dart:convert';

import 'package:psp_admin/src/blocs/validators/validators.dart';
import 'package:psp_admin/src/models/experience_model.dart';
import 'package:psp_admin/src/repositories/experiences_repository.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class ExperiencesBloc with Validators {
  final _experienceRepository = ExperienceRepository();

  final _experienceController = BehaviorSubject<Tuple2<int, ExperienceModel>>();

  Stream<Tuple2<int, ExperienceModel>> get experienceStream =>
      _experienceController.stream;

  Tuple2<int, ExperienceModel> get lastValueTestReportsController =>
      _experienceController.value;

  void getExperience(bool isRefresing, int userId) async {
    final experienceWithStatusCode =
        await _experienceRepository.getExperience(isRefresing, userId);
    _experienceController.sink.add(experienceWithStatusCode);
  }

  Future<int> insertExperience(ExperienceModel experience) async {
    final result = await _experienceRepository.insertExperience(experience);
    final statusCode = result.item1;

    if (statusCode == 201) {
      _experienceController.sink.add(Tuple2(200, result.item2));
    }
    return statusCode;
  }

  Future<int> updateExperience(ExperienceModel experience) async {
    final statusCode = await _experienceRepository.updateExperience(experience);

    if (statusCode == 204) {
      _experienceController.sink.add(Tuple2(200, experience));
    }
    return statusCode;
  }

  Future<bool> haveExperience() async {
    bool haveExperiences;
    final currentUserId = json.decode(Preferences().currentUser)['id'];

    final experienceWithStatusCode =
        await _experienceRepository.getExperience(true, currentUserId);

    if (experienceWithStatusCode.item1 == 404) {
      haveExperiences = false;
    } else if (experienceWithStatusCode.item1 == 200) {
      haveExperiences = true;
    }

    return haveExperiences;
  }

  void dispose() => _experienceController.sink.add(null);
}
