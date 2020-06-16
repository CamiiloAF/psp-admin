import 'package:psp_admin/src/models/modules_model.dart';
import 'package:psp_admin/src/repositories/modules_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class ModulesBloc {
  final _modulesProvider = ModulesRepository();

  final _modulesController = BehaviorSubject<Tuple2<int, List<ModuleModel>>>();

  Stream<Tuple2<int, List<ModuleModel>>> get modulesStream =>
      _modulesController.stream;

  Tuple2<int, List<ModuleModel>> get lastValueModulesController =>
      _modulesController.value;

  void getModules(bool isRefresing, String projectId) async {
    final modulesWithStatusCode =
        await _modulesProvider.getAllModules(isRefresing, projectId);
    _modulesController.sink.add(modulesWithStatusCode);
  }

  Future<int> insertModule(ModuleModel module) async {
    final result = await _modulesProvider.insertModule(module);
    final statusCode = result.item1;

    if (statusCode == 201) {
      final tempModules = lastValueModulesController.item2;
      tempModules.add(result.item2);
      _modulesController.sink.add(Tuple2(200, tempModules));
    }
    return statusCode;
  }

  Future<int> updateModule(ModuleModel module) async {
    final statusCode = await _modulesProvider.updateModule(module);

    if (statusCode == 204) {
      final tempModules = lastValueModulesController.item2;
      final indexOfOldModule =
          tempModules.indexWhere((element) => element.id == module.id);
      tempModules[indexOfOldModule] = module;
      _modulesController.sink.add(Tuple2(200, tempModules));
    }
    return statusCode;
  }

  void dispose() {
    _modulesController.sink.add(null);
  }
}
