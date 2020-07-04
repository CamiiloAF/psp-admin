import 'package:psp_admin/src/models/languages_model.dart';
import 'package:psp_admin/src/repositories/languages_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class LanguagesBloc {
  final _languagesRepository = LanguagesRepository();

  final _languagesController =
      BehaviorSubject<Tuple2<int, List<LanguageModel>>>();

  Stream<Tuple2<int, List<LanguageModel>>> get languageStream =>
      _languagesController.stream;

  Tuple2<int, List<LanguageModel>> get lastValueLanguagesController =>
      _languagesController.value;

  void getLanguages(bool isRefreshing) async {
    final languagesWithStatusCode =
        await _languagesRepository.getAllLanguages(isRefreshing);
    _languagesController.sink.add(languagesWithStatusCode);
  }

  Future<int> insertLanguage(LanguageModel languageModel) async {
    final result = await _languagesRepository.insertLanguage(languageModel);
    final statusCode = result.item1;

    if (statusCode == 201) {
      final tempLanguages = lastValueLanguagesController.item2;
      tempLanguages.add(result.item2);
      _languagesController.sink.add(Tuple2(200, tempLanguages));
    }
    return statusCode;
  }

  Future<int> updateLanguage(LanguageModel languageModel) async {
    final statusCode = await _languagesRepository.updateLanguage(languageModel);

    if (statusCode == 204) {
      final tempLanguages = lastValueLanguagesController.item2;
      final indexOfOldLanguage =
          tempLanguages.indexWhere((element) => element.id == languageModel.id);
      tempLanguages[indexOfOldLanguage] = languageModel;
      _languagesController.sink.add(Tuple2(200, tempLanguages));
    }
    return statusCode;
  }

  void dispose() => _languagesController.sink.add(null);
}
